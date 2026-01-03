import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart' hide AppDatabase;
import '../database/app_database.dart' as local;
import '../services/connectivity_service.dart';
import '../services/sync_manager.dart';

/// Repository for managing forms with offline support
class OfflineFormRepository {
  final local.AppDatabase _database;
  final ConnectivityService _connectivityService;
  final SyncManager _syncManager;
  final FormRepository _apiRepository;
  
  OfflineFormRepository(
    this._database,
    this._connectivityService,
    this._syncManager,
    this._apiRepository,
  );
  
  /// Get all forms (from cache if offline, from API if online)
  Future<List<FormModel>> getForms() async {
    if (_connectivityService.isOnline) {
      try {
        // Fetch from API
        final forms = await _apiRepository.getForms();
        
        // Update local cache
        for (final form in forms) {
          await _cacheForm(form);
        }
        
        return forms;
      } catch (e) {
        // Fall back to cache if API fails
        return _getFormsFromCache();
      }
    } else {
      // Use cache when offline
      return _getFormsFromCache();
    }
  }
  
  /// Get a single form by ID
  Future<FormModel?> getFormById(String id) async {
    if (_connectivityService.isOnline) {
      try {
        final form = await _apiRepository.getFormById(id);
        if (form != null) {
          await _cacheForm(form);
        }
        return form;
      } catch (e) {
        // Fall back to cache
        return _getFormFromCache(id);
      }
    } else {
      return _getFormFromCache(id);
    }
  }
  
  Future<List<FormModel>> _getFormsFromCache() async {
    final cachedForms = await _database.getAllForms();
    return cachedForms.map((f) => _formFromCache(f)).toList();
  }
  
  Future<FormModel?> _getFormFromCache(String id) async {
    final cached = await _database.getFormById(id);
    if (cached == null) return null;
    return _formFromCache(cached);
  }
  
  Future<void> _cacheForm(FormModel form) async {
    final existing = await _database.getFormById(form.id);
    
    final companion = local.FormsCompanion(
      id: drift.Value(form.id),
      title: drift.Value(form.title),
      description: drift.Value(form.description),
      status: drift.Value(form.status.toString().split('.').last),
      scheduleType: drift.Value(form.scheduleType.toString().split('.').last),
      tags: drift.Value(jsonEncode(form.tags)),
      requiresGeofence: const drift.Value(false), // Default value
      estimatedDuration: const drift.Value(null),
      createdAt: drift.Value(form.createdAt),
      updatedAt: drift.Value(form.updatedAt),
      lastSyncedAt: drift.Value(DateTime.now()),
    );
    
    if (existing != null) {
      await _database.updateForm(companion);
    } else {
      await _database.insertForm(companion);
    }
  }
  
  FormModel _formFromCache(local.Form cached) {
    return FormModel(
      id: cached.id,
      title: cached.title,
      description: cached.description,
      status: FormStatus.values.firstWhere(
        (e) => e.toString().split('.').last == cached.status,
      ),
      scheduleType: FormScheduleType.values.firstWhere(
        (e) => e.toString().split('.').last == cached.scheduleType,
      ),
      tags: List<String>.from(jsonDecode(cached.tags)),
      createdAt: cached.createdAt,
      updatedAt: cached.updatedAt,
      createdBy: 'cached', // Placeholder
    );
  }
}

/// Repository for managing submissions with offline support
class OfflineSubmissionRepository {
  final local.AppDatabase _database;
  final ConnectivityService _connectivityService;
  final SyncManager _syncManager;
  final SubmissionRepository _apiRepository;
  
  OfflineSubmissionRepository(
    this._database,
    this._connectivityService,
    this._syncManager,
    this._apiRepository,
  );
  
  /// Create a new submission
  Future<Submission> createSubmission(Submission submission) async {
    // Always save to local database first
    await _saveToCache(submission, isDirty: true);
    
    if (_connectivityService.isOnline) {
      try {
        // Try to sync immediately
        final created = await _apiRepository.createSubmission(submission);
        
        // Update cache with server-confirmed data
        await _saveToCache(created, isDirty: false);
        
        return created;
      } catch (e) {
        // Queue for sync if API fails
        await _queueForSync(submission, 'create');
        return submission;
      }
    } else {
      // Queue for sync when offline
      await _queueForSync(submission, 'create');
      return submission;
    }
  }
  
  /// Update an existing submission
  Future<Submission> updateSubmission(Submission submission) async {
    // Save to local database
    await _saveToCache(submission, isDirty: true);
    
    if (_connectivityService.isOnline) {
      try {
        // Try to sync immediately
        final updated = await _apiRepository.updateSubmission(submission);
        
        // Update cache with server-confirmed data
        await _saveToCache(updated, isDirty: false);
        
        return updated;
      } catch (e) {
        // Queue for sync if API fails
        await _queueForSync(submission, 'update');
        return submission;
      }
    } else {
      // Queue for sync when offline
      await _queueForSync(submission, 'update');
      return submission;
    }
  }
  
  /// Get submissions for a form
  Future<List<Submission>> getSubmissionsByFormId(String formId) async {
    if (_connectivityService.isOnline) {
      try {
        final submissions = await _apiRepository.getFormSubmissions(formId);
        
        // Update cache
        for (final submission in submissions) {
          await _saveToCache(submission, isDirty: false);
        }
        
        return submissions;
      } catch (e) {
        // Fall back to cache
        return _getSubmissionsFromCache(formId);
      }
    } else {
      return _getSubmissionsFromCache(formId);
    }
  }
  
  /// Get all submissions
  Future<List<Submission>> getAllSubmissions() async {
    // For now, just return cached submissions
    // TODO: Add API method to get all submissions for current user
    return _getAllSubmissionsFromCache();
  }
  
  Future<void> _saveToCache(Submission submission, {required bool isDirty}) async {
    final existing = await _database.getSubmissionById(submission.id);
    
    final companion = local.SubmissionsCompanion(
      id: drift.Value(submission.id),
      formId: drift.Value(submission.formId),
      userId: drift.Value(submission.submittedBy),
      status: drift.Value(submission.status.toString().split('.').last),
      responses: drift.Value(jsonEncode({})), // Placeholder for responses
      submittedAt: drift.Value(submission.submissionDate),
      completedAt: drift.Value(submission.status == SubmissionStatus.completed ? submission.updatedAt : null),
      createdAt: drift.Value(submission.createdAt),
      updatedAt: drift.Value(submission.updatedAt),
      lastSyncedAt: drift.Value(isDirty ? null : DateTime.now()),
      isDirty: drift.Value(isDirty),
    );
    
    if (existing != null) {
      await _database.updateSubmission(companion);
    } else {
      await _database.insertSubmission(companion);
    }
  }
  
  Future<void> _queueForSync(Submission submission, String operation) async {
    await _syncManager.queueSync(
      operationType: operation,
      entityType: 'submission',
      entityId: submission.id,
      data: {
        'form_id': submission.formId,
        'submitted_by': submission.submittedBy,
        'submission_date': submission.submissionDate.toIso8601String(),
        'submission_time': submission.submissionTime.toIso8601String(),
        'status': submission.status.toString().split('.').last,
        'completion_percentage': submission.completionPercentage,
        'is_auto_submitted': submission.isAutoSubmitted,
        'created_at': submission.createdAt.toIso8601String(),
        'updated_at': submission.updatedAt.toIso8601String(),
      },
    );
  }
  
  Future<List<Submission>> _getSubmissionsFromCache(String formId) async {
    final cached = await _database.getSubmissionsByFormId(formId);
    return cached.map((s) => _submissionFromCache(s)).toList();
  }
  
  Future<List<Submission>> _getAllSubmissionsFromCache() async {
    final cached = await _database.getAllSubmissions();
    return cached.map((s) => _submissionFromCache(s)).toList();
  }
  
  Submission _submissionFromCache(local.Submission cached) {
    return Submission(
      id: cached.id,
      formId: cached.formId,
      submittedBy: cached.userId,
      submissionDate: cached.submittedAt ?? cached.createdAt,
      submissionTime: cached.submittedAt ?? cached.createdAt,
      status: SubmissionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == cached.status,
        orElse: () => SubmissionStatus.inProgress,
      ),
      completionPercentage: 0.0,
      isAutoSubmitted: false,
      createdAt: cached.createdAt,
      updatedAt: cached.updatedAt,
    );
  }
}

/// Provider for offline form repository
final offlineFormRepositoryProvider = Provider<OfflineFormRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final syncManager = ref.watch(syncManagerProvider);
  // TODO: Get actual API repository from insight_core
  final apiRepository = FormRepository(); // Placeholder
  
  return OfflineFormRepository(
    database,
    connectivity,
    syncManager,
    apiRepository,
  );
});

/// Provider for offline submission repository
final offlineSubmissionRepositoryProvider = Provider<OfflineSubmissionRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final syncManager = ref.watch(syncManagerProvider);
  // TODO: Get actual API repository from insight_core
  final apiRepository = SubmissionRepository(); // Placeholder
  
  return OfflineSubmissionRepository(
    database,
    connectivity,
    syncManager,
    apiRepository,
  );
});
