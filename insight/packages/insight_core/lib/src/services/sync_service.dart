import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:drift/drift.dart';

import '../models/sync.dart';
import '../database/database.dart';
import 'api_client.dart';

/// Sync service for bidirectional data synchronization
class SyncService {
  SyncService({
    required this.database,
    this.autoSyncInterval = const Duration(minutes: 5),
  });

  final AppDatabase database;
  final Duration autoSyncInterval;
  Timer? _syncTimer;
  bool _isSyncing = false;
  String? _deviceId;

  /// Tables to sync (can be customized per app)
  static const List<String> allTables = [
    'forms',
    'form_sections',
    'fields',
    'dropdown_options',
    'submissions',
    'submission_answers',
    'team',
    'goals',
    'kpi_data',
    'business_calendar',
  ];

  /// Initialize the sync service and get device ID
  Future<void> initialize() async {
    _deviceId = await _getDeviceId();
  }

  /// Start automatic syncing at configured interval
  void startAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(autoSyncInterval, (_) => performSync());
  }

  /// Stop automatic syncing
  void stopAutoSync() {
    _syncTimer?.cancel();
  }

  /// Perform a full sync cycle (pull then push)
  Future<SyncStatus> performSync() async {
    if (_isSyncing) {
      return SyncStatus.alreadySyncing();
    }

    _isSyncing = true;
    try {
      await initialize();

      // Pull changes from server first
      final pullResult = await pullFromServer();
      final pullIsSuccess = pullResult.map(
        idle: (_) => false,
        syncing: (_) => false,
        success: (_) => true,
        error: (_) => false,
        alreadySyncing: (_) => false,
      );
      if (!pullIsSuccess) {
        return pullResult;
      }

      // Push local changes to server
      final pushResult = await pushToServer();
      final pushIsSuccess = pushResult.map(
        idle: (_) => false,
        syncing: (_) => false,
        success: (_) => true,
        error: (_) => false,
        alreadySyncing: (_) => false,
      );
      if (!pushIsSuccess) {
        return pushResult;
      }

      return SyncStatus.success();
    } catch (e) {
      return SyncStatus.error([]);
    } finally {
      _isSyncing = false;
    }
  }

  /// Pull changes from server and apply to local database
  Future<SyncStatus> pullFromServer({List<String>? tables}) async {
    final syncTables = tables ?? allTables;
    final metadata = await database.getSyncMetadata(syncTables);

    try {
      final request = SyncPullRequest(
        deviceId: _deviceId!,
        lastSyncTimestamps: metadata,
        tables: syncTables,
      );

      final response = await ApiClient.post(
        '/sync/pull',
        data: request.toJson(),
      );

      final syncResponse = SyncResponse.fromJson(response.data as Map<String, dynamic>);

      if (syncResponse.conflicts != null && syncResponse.conflicts!.isNotEmpty) {
        // Handle conflicts through resolution strategy
        final resolvedConflicts = await resolveConflicts(syncResponse.conflicts!);
        if (resolvedConflicts.isNotEmpty) {
          return SyncStatus.error(resolvedConflicts);
        }
      }

      // Apply server changes to local database
      await _applyChangesToLocal(syncResponse.changes);

      return SyncStatus.success();
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final conflicts = (e.response?.data['conflicts'] as List)
            .map((c) => SyncConflict.fromJson(c as Map<String, dynamic>))
            .toList();
        return SyncStatus.error(conflicts);
      }
      rethrow;
    }
  }

  /// Push local changes to server
  Future<SyncStatus> pushToServer({List<String>? tables}) async {
    final syncTables = tables ?? allTables;
    final pendingChanges = await _getPendingChanges();

    if (pendingChanges.isEmpty) {
      return SyncStatus.success();
    }

    try {
      final request = SyncPushRequest(
        deviceId: _deviceId!,
        changes: pendingChanges,
      );

      final response = await ApiClient.post(
        '/sync/push',
        data: request.toJson(),
      );

      final syncResponse = SyncResponse.fromJson(response.data as Map<String, dynamic>);

      if (syncResponse.conflicts != null && syncResponse.conflicts!.isNotEmpty) {
        final resolvedConflicts = await resolveConflicts(syncResponse.conflicts!);
        if (resolvedConflicts.isNotEmpty) {
          return SyncStatus.error(resolvedConflicts);
        }
      }

      // Mark local changes as synced
      await _markChangesSynced(pendingChanges);

      return SyncStatus.success();
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final conflicts = (e.response?.data['conflicts'] as List)
            .map((c) => SyncConflict.fromJson(c as Map<String, dynamic>))
            .toList();
        return SyncStatus.error(conflicts);
      }
      rethrow;
    }
  }

  /// Resolve conflicts between local and server data
  /// Default strategy: Server wins
  Future<List<SyncConflict>> resolveConflicts(
    List<SyncConflict> conflicts,
  ) async {
    final unresolved = <SyncConflict>[];

    for (final conflict in conflicts) {
      try {
        // Default strategy: Accept server version
        await _acceptServerVersion(conflict);
      } catch (e) {
        // If resolution fails, add to unresolved list
        unresolved.add(conflict);
      }
    }

    return unresolved;
  }

  // ===== Private helper methods =====

  Future<void> _applyChangesToLocal(
    Map<String, List<Map<String, dynamic>>> changes,
  ) async {
    for (final entry in changes.entries) {
      final tableName = entry.key;
      final records = entry.value;

      for (final record in records) {
        switch (tableName) {
          case 'forms':
            await database.insertOrUpdateForm(
              FormsTableCompanion.insert(
                id: record['id'] as String,
                title: record['title'] as String,
                description: Value(record['description'] as String?),
                tags: Value(jsonEncode(record['tags'] ?? [])),
                isTemplate: Value(record['is_template'] as bool? ?? false),
                scheduleType: Value(record['schedule_type'] as String? ?? 'tag_based'),
                createdBy: record['created_by'] as String,
                createdAt: DateTime.parse(record['created_at'] as String),
                updatedAt: DateTime.parse(record['updated_at'] as String),
              ),
            );
            break;

          case 'submissions':
            await database.insertOrUpdateSubmission(
              SubmissionsTableCompanion.insert(
                id: record['id'] as String,
                formId: record['form_id'] as String,
                submittedBy: record['submitted_by'] as String,
                submissionDate: DateTime.parse(record['submission_date'] as String),
                submissionTime: DateTime.parse(record['submission_time'] as String),
                status: Value(record['status'] as String? ?? 'in_progress'),
                completionPercentage: Value((record['completion_percentage'] as num? ?? 0.0).toDouble()),
                isAutoSubmitted: Value(record['is_auto_submitted'] as bool? ?? false),
                createdAt: DateTime.parse(record['created_at'] as String),
                updatedAt: DateTime.parse(record['updated_at'] as String),
              ),
            );
            break;

          case 'team':
            await database.insertOrUpdateTeamMember(
              TeamTableCompanion.insert(
                id: record['id'] as String,
                name: record['name'] as String,
                role: Value(record['role'] as String? ?? 'employee'),
                createdAt: DateTime.parse(record['created_at'] as String),
              ),
            );
            break;

          case 'kpi_data':
            await database.insertOrUpdateKPIData(
              KPIDataTableCompanion.insert(
                id: record['id'] as String,
                dataDate: DateTime.parse(record['data_date'] as String),
                gemScore: Value((record['gem_score'] as num?)?.toDouble()),
                hoursScheduled: Value((record['hours_scheduled'] as num?)?.toDouble()),
                hoursRecommended: Value((record['hours_recommended'] as num?)?.toDouble()),
                laborUsedPercentage: Value((record['labor_used_percentage'] as num?)?.toDouble()),
                salesActual: Value((record['sales_actual'] as num?)?.toDouble()),
                createdAt: DateTime.parse(record['created_at'] as String),
                updatedAt: DateTime.parse(record['updated_at'] as String),
              ),
            );
            break;

          case 'business_calendar':
            await database.insertOrUpdateCalendar(
              BusinessCalendarTableCompanion.insert(
                id: record['id'] as String,
                startDate: DateTime.parse(record['start_date'] as String),
                currentWeek: record['current_week'] as int,
                currentPeriod: record['current_period'] as int,
                currentQuarter: record['current_quarter'] as int,
                updatedAt: DateTime.parse(record['updated_at'] as String),
              ),
            );
            break;
        }
      }

      // Update sync metadata
      await database.updateSyncMetadata(tableName, DateTime.now());
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> _getPendingChanges() async {
    final pending = await database.getPendingChanges(syncedOnly: false);

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final change in pending) {
      if (!grouped.containsKey(change.table)) {
        grouped[change.table] = [];
      }

      final data = jsonDecode(change.data) as Map<String, dynamic>;
      grouped[change.table]!.add(data);
    }

    return grouped;
  }

  Future<void> _markChangesSynced(
    Map<String, List<Map<String, dynamic>>> changes,
  ) async {
    final pending = await database.getPendingChanges(syncedOnly: false);

    for (final change in pending) {
      await database.markChangeSynced(change.id);
    }

    // Periodically clean up old synced changes
    await database.clearSyncedChanges();
  }

  Future<void> _retryPushConflict(SyncConflict conflict) async {
    // Re-add to pending changes for next sync
    await database.addPendingChange(
      tableName: conflict.table,
      recordId: conflict.recordId,
      operation: 'UPDATE',
      data: jsonEncode(conflict.clientData),
    );
  }

  Future<void> _acceptServerVersion(SyncConflict conflict) async {
    // Apply server version to local database
    await _applyChangesToLocal({
      conflict.table: [conflict.serverData]
    });
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        return info.id;
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        return info.identifierForVendor ?? 'unknown-ios';
      } else if (Platform.isMacOS) {
        final info = await deviceInfo.macOsInfo;
        return info.systemGUID ?? 'unknown-macos';
      }
    } catch (e) {
      return 'unknown-device';
    }

    return 'unknown-device';
  }

  void dispose() {
    stopAutoSync();
  }
}
