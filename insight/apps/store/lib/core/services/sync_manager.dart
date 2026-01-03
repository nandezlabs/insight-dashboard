import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'connectivity_service.dart';

/// Sync status for an entity
enum SyncStatus {
  synced,
  pending,
  syncing,
  error,
}

/// Conflict resolution strategy
enum ConflictResolutionStrategy {
  useLocal,
  useServer,
  manual,
}

/// Sync conflict details
class SyncConflict {
  final String entityId;
  final String entityType;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final DateTime localUpdatedAt;
  final DateTime serverUpdatedAt;

  SyncConflict({
    required this.entityId,
    required this.entityType,
    required this.localData,
    required this.serverData,
    required this.localUpdatedAt,
    required this.serverUpdatedAt,
  });
}

/// Service for managing offline data synchronization
class SyncManager {
  final AppDatabase _database;
  final ConnectivityService _connectivityService;
  
  Timer? _syncTimer;
  bool _isSyncing = false;
  
  final StreamController<SyncStatus> _syncStatusController = 
      StreamController<SyncStatus>.broadcast();
  
  final StreamController<int> _pendingCountController = 
      StreamController<int>.broadcast();
  
  final StreamController<SyncConflict> _conflictController = 
      StreamController<SyncConflict>.broadcast();
  
  SyncManager(this._database, this._connectivityService) {
    _initialize();
  }
  
  /// Stream of sync status changes
  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;
  
  /// Stream of pending sync count
  Stream<int> get pendingCount => _pendingCountController.stream;
  
  /// Stream of sync conflicts
  Stream<SyncConflict> get conflicts => _conflictController.stream;
  
  void _initialize() {
    // Start periodic sync when online
    _connectivityService.connectionStatus.listen((isOnline) {
      if (isOnline) {
        _startPeriodicSync();
      } else {
        _stopPeriodicSync();
      }
    });
    
    // Initial sync if online
    if (_connectivityService.isOnline) {
      _startPeriodicSync();
    }
    
    // Update pending count on startup
    _updatePendingCount();
  }
  
  void _startPeriodicSync() {
    _syncTimer?.cancel();
    
    // Sync immediately on connection
    syncPendingChanges();
    
    // Then sync every 30 seconds
    _syncTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => syncPendingChanges(),
    );
  }
  
  void _stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
  
  /// Add an item to the sync queue
  Future<void> queueSync({
    required String operationType,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> data,
  }) async {
    await _database.addToSyncQueue(
      SyncQueueCompanion(
        operationType: drift.Value(operationType),
        entityType: drift.Value(entityType),
        entityId: drift.Value(entityId),
        data: drift.Value(jsonEncode(data)),
        createdAt: drift.Value(DateTime.now()),
      ),
    );
    
    await _updatePendingCount();
    
    // Trigger sync if online
    if (_connectivityService.isOnline) {
      syncPendingChanges();
    }
  }
  
  /// Sync all pending changes
  Future<void> syncPendingChanges() async {
    if (_isSyncing || !_connectivityService.isOnline) {
      return;
    }
    
    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);
    
    try {
      final pendingItems = await _database.getPendingSyncItems();
      
      for (final item in pendingItems) {
        try {
          await _processSyncItem(item);
          
          // Remove from queue after successful sync
          await _database.removeSyncQueueItem(item.id);
        } catch (e) {
          // Update retry count and error message
          await _database.updateSyncQueueItem(
            SyncQueueCompanion(
              id: drift.Value(item.id),
              retryCount: drift.Value(item.retryCount + 1),
              lastAttemptAt: drift.Value(DateTime.now()),
              errorMessage: drift.Value(e.toString()),
            ),
          );
          
          // If too many retries, check for conflicts
          if (item.retryCount >= 3) {
            await _checkForConflict(item);
          }
        }
      }
      
      await _updatePendingCount();
      _syncStatusController.add(SyncStatus.synced);
    } catch (e) {
      _syncStatusController.add(SyncStatus.error);
    } finally {
      _isSyncing = false;
    }
  }
  
  Future<void> _processSyncItem(SyncQueueData item) async {
    final data = jsonDecode(item.data) as Map<String, dynamic>;
    
    // TODO: Implement actual API calls here
    // For now, simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    switch (item.entityType) {
      case 'submission':
        await _syncSubmission(item.operationType, item.entityId, data);
        break;
      case 'form':
        await _syncForm(item.operationType, item.entityId, data);
        break;
      default:
        throw Exception('Unknown entity type: ${item.entityType}');
    }
  }
  
  Future<void> _syncSubmission(
    String operationType,
    String entityId,
    Map<String, dynamic> data,
  ) async {
    // TODO: Call actual API endpoints
    // Example: POST /api/v1/submissions or PUT /api/v1/submissions/{id}
    
    // Update local database to mark as synced
    final submission = await _database.getSubmissionById(entityId);
    if (submission != null) {
      await _database.updateSubmission(
        SubmissionsCompanion(
          id: drift.Value(entityId),
          isDirty: const drift.Value(false),
          lastSyncedAt: drift.Value(DateTime.now()),
        ),
      );
    }
  }
  
  Future<void> _syncForm(
    String operationType,
    String entityId,
    Map<String, dynamic> data,
  ) async {
    // TODO: Call actual API endpoints
    // Update local database to mark as synced
    final form = await _database.getFormById(entityId);
    if (form != null) {
      await _database.updateForm(
        FormsCompanion(
          id: drift.Value(entityId),
          lastSyncedAt: drift.Value(DateTime.now()),
        ),
      );
    }
  }
  
  Future<void> _checkForConflict(SyncQueueData item) async {
    // TODO: Fetch latest version from server and compare
    // For now, create a mock conflict for demonstration
    
    final localData = jsonDecode(item.data) as Map<String, dynamic>;
    
    // Simulate server data (in real implementation, fetch from API)
    final serverData = Map<String, dynamic>.from(localData);
    serverData['updated_at'] = DateTime.now().toIso8601String();
    
    final conflict = SyncConflict(
      entityId: item.entityId,
      entityType: item.entityType,
      localData: localData,
      serverData: serverData,
      localUpdatedAt: DateTime.parse(localData['updated_at'] as String),
      serverUpdatedAt: DateTime.now(),
    );
    
    _conflictController.add(conflict);
  }
  
  /// Resolve a sync conflict
  Future<void> resolveConflict(
    SyncConflict conflict,
    ConflictResolutionStrategy strategy,
  ) async {
    Map<String, dynamic> dataToUse;
    
    switch (strategy) {
      case ConflictResolutionStrategy.useLocal:
        dataToUse = conflict.localData;
        break;
      case ConflictResolutionStrategy.useServer:
        dataToUse = conflict.serverData;
        // Update local database with server data
        await _updateLocalEntity(conflict.entityType, conflict.entityId, dataToUse);
        break;
      case ConflictResolutionStrategy.manual:
        // Manual resolution will be handled by UI
        return;
    }
    
    // Re-queue the sync with resolved data
    await queueSync(
      operationType: 'update',
      entityType: conflict.entityType,
      entityId: conflict.entityId,
      data: dataToUse,
    );
  }
  
  Future<void> _updateLocalEntity(
    String entityType,
    String entityId,
    Map<String, dynamic> data,
  ) async {
    switch (entityType) {
      case 'submission':
        await _database.updateSubmission(
          SubmissionsCompanion(
            id: drift.Value(entityId),
            responses: drift.Value(jsonEncode(data['responses'])),
            updatedAt: drift.Value(DateTime.parse(data['updated_at'] as String)),
          ),
        );
        break;
      case 'form':
        // Update form data
        break;
    }
  }
  
  Future<void> _updatePendingCount() async {
    final items = await _database.getPendingSyncItems();
    _pendingCountController.add(items.length);
  }
  
  /// Force sync now (manually triggered)
  Future<void> forceSyncNow() async {
    if (!_connectivityService.isOnline) {
      throw Exception('Cannot sync while offline');
    }
    
    await syncPendingChanges();
  }
  
  /// Clear all sync queue items (use with caution)
  Future<void> clearSyncQueue() async {
    await _database.clearCompletedSyncItems();
    await _updatePendingCount();
  }
  
  void dispose() {
    _syncTimer?.cancel();
    _syncStatusController.close();
    _pendingCountController.close();
    _conflictController.close();
  }
}

/// Provider for sync manager
final syncManagerProvider = Provider<SyncManager>((ref) {
  final database = ref.watch(databaseProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final manager = SyncManager(database, connectivity);
  ref.onDispose(() => manager.dispose());
  return manager;
});

/// Provider for sync status
final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final manager = ref.watch(syncManagerProvider);
  return manager.syncStatus;
});

/// Provider for pending sync count
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final manager = ref.watch(syncManagerProvider);
  return manager.pendingCount;
});

/// Provider for sync conflicts
final syncConflictsProvider = StreamProvider<SyncConflict>((ref) {
  final manager = ref.watch(syncManagerProvider);
  return manager.conflicts;
});

/// Provider for database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});
