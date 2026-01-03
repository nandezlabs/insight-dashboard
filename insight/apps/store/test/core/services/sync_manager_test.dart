import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:store/core/services/sync_manager.dart';
import 'package:store/core/services/connectivity_service.dart';
import 'package:store/core/database/app_database.dart';

void main() {
  group('SyncManager', () {
    late AppDatabase database;
    late ConnectivityService connectivity;
    late SyncManager syncManager;

    setUp(() {
      // Create in-memory database for testing
      database = AppDatabase.forTesting(NativeDatabase.memory());
      connectivity = ConnectivityService();
      syncManager = SyncManager(database, connectivity);
    });

    tearDown(() async {
      syncManager.dispose();
      connectivity.dispose();
      await database.close();
    });

    test('should queue sync item', () async {
      await syncManager.queueSync(
        operationType: 'create',
        entityType: 'submission',
        entityId: 'test-id',
        data: {'test': 'data'},
      );

      // Give the queue time to process
      await Future.delayed(const Duration(milliseconds: 100));

      final pendingItems = await database.getPendingSyncItems();
      expect(pendingItems.length, equals(1));
      expect(pendingItems.first.entityId, equals('test-id'));
    });

    test('should track pending count', () async {
      await syncManager.queueSync(
        operationType: 'create',
        entityType: 'submission',
        entityId: 'test-id-1',
        data: {'test': 'data1'},
      );

      await syncManager.queueSync(
        operationType: 'create',
        entityType: 'submission',
        entityId: 'test-id-2',
        data: {'test': 'data2'},
      );

      // Give streams time to update
      await Future.delayed(const Duration(milliseconds: 100));

      final items = await database.getPendingSyncItems();
      expect(items.length, equals(2));
    });

    test('should emit sync status', () async {
      // Add an item to sync first
      await syncManager.queueSync(
        operationType: 'create',
        entityType: 'submission',
        entityId: 'test-id',
        data: {'test': 'data'},
      );

      // Trigger sync and wait
      await syncManager.syncPendingChanges();
      
      // Verify stream exists
      expect(syncManager.syncStatus, isA<Stream<SyncStatus>>());
    });

    test('should clear sync queue', () async {
      await syncManager.queueSync(
        operationType: 'create',
        entityType: 'submission',
        entityId: 'test-id',
        data: {'test': 'data'},
      );

      await syncManager.clearSyncQueue();

      final pendingItems = await database.getPendingSyncItems();
      expect(pendingItems.length, equals(0));
    });
  });
}
