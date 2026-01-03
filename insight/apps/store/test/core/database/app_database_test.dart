import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:store/core/database/app_database.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  group('AppDatabase', () {
    late AppDatabase database;

    setUp(() {
      // Create in-memory database for testing
      database = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    group('Forms', () {
      test('should insert and retrieve form', () async {
        final form = FormsCompanion(
          id: const Value('test-form-id'),
          title: const Value('Test Form'),
          description: const Value('Test Description'),
          status: const Value('active'),
          scheduleType: const Value('manual'),
          tags: const Value('["daily"]'),
          requiresGeofence: const Value(false),
          estimatedDuration: const Value(30),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          lastSyncedAt: Value(DateTime.now()),
        );

        await database.insertForm(form);

        final retrieved = await database.getFormById('test-form-id');
        expect(retrieved, matcher.isNotNull);
        expect(retrieved!.title, equals('Test Form'));
      });

      test('should list all forms', () async {
        final form1 = FormsCompanion(
          id: const Value('form-1'),
          title: const Value('Form 1'),
          description: const Value(null),
          status: const Value('active'),
          scheduleType: const Value('manual'),
          tags: const Value('[]'),
          requiresGeofence: const Value(false),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          lastSyncedAt: Value(DateTime.now()),
        );

        final form2 = FormsCompanion(
          id: const Value('form-2'),
          title: const Value('Form 2'),
          description: const Value(null),
          status: const Value('active'),
          scheduleType: const Value('manual'),
          tags: const Value('[]'),
          requiresGeofence: const Value(false),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          lastSyncedAt: Value(DateTime.now()),
        );

        await database.insertForm(form1);
        await database.insertForm(form2);

        final forms = await database.getAllForms();
        expect(forms.length, equals(2));
      });

      test('should delete form', () async {
        final form = FormsCompanion(
          id: const Value('delete-test'),
          title: const Value('Delete Test'),
          description: const Value(null),
          status: const Value('active'),
          scheduleType: const Value('manual'),
          tags: const Value('[]'),
          requiresGeofence: const Value(false),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          lastSyncedAt: Value(DateTime.now()),
        );

        await database.insertForm(form);
        await database.deleteForm('delete-test');

        final retrieved = await database.getFormById('delete-test');
        expect(retrieved, matcher.isNull);
      });
    });

    group('Submissions', () {
      test('should insert and retrieve submission', () async {
        final submission = SubmissionsCompanion(
          id: const Value('test-submission-id'),
          formId: const Value('test-form-id'),
          userId: const Value('test-user-id'),
          status: const Value('in_progress'),
          responses: const Value('{}'),
          submittedAt: Value(DateTime.now()),
          completedAt: const Value(null),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          lastSyncedAt: const Value(null),
          isDirty: const Value(true),
        );

        await database.insertSubmission(submission);

        final retrieved = await database.getSubmissionById('test-submission-id');
        expect(retrieved, matcher.isNotNull);
        expect(retrieved!.formId, equals('test-form-id'));
        expect(retrieved.isDirty, isTrue);
      });

      test('should get dirty submissions', () async {
        final submission1 = SubmissionsCompanion(
          id: const Value('submission-1'),
          formId: const Value('form-1'),
          userId: const Value('user-1'),
          status: const Value('in_progress'),
          responses: const Value('{}'),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          isDirty: const Value(true),
        );

        final submission2 = SubmissionsCompanion(
          id: const Value('submission-2'),
          formId: const Value('form-1'),
          userId: const Value('user-1'),
          status: const Value('completed'),
          responses: const Value('{}'),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          isDirty: const Value(false),
        );

        await database.insertSubmission(submission1);
        await database.insertSubmission(submission2);

        final dirtySubmissions = await database.getDirtySubmissions();
        expect(dirtySubmissions.length, equals(1));
        expect(dirtySubmissions.first.id, equals('submission-1'));
      });
    });

    group('SyncQueue', () {
      test('should add and retrieve sync queue items', () async {
        final item = SyncQueueCompanion(
          operationType: const Value('create'),
          entityType: const Value('submission'),
          entityId: const Value('entity-1'),
          data: const Value('{"test": "data"}'),
          retryCount: const Value(0),
          createdAt: Value(DateTime.now()),
        );

        await database.addToSyncQueue(item);

        final items = await database.getPendingSyncItems();
        expect(items.length, equals(1));
        expect(items.first.entityId, equals('entity-1'));
      });

      test('should remove sync queue item', () async {
        final item = SyncQueueCompanion(
          operationType: const Value('create'),
          entityType: const Value('submission'),
          entityId: const Value('entity-2'),
          data: const Value('{}'),
          retryCount: const Value(0),
          createdAt: Value(DateTime.now()),
        );

        final id = await database.addToSyncQueue(item);
        await database.removeSyncQueueItem(id);

        final items = await database.getPendingSyncItems();
        expect(items, isEmpty);
      });
    });
  });
}
