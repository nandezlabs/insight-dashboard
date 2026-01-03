import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Forms table for caching forms locally
class Forms extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text()(); // 'active', 'archived', 'draft'
  TextColumn get scheduleType => text()(); // 'tagBased', 'custom', 'manual'
  TextColumn get tags => text()(); // JSON array
  BoolColumn get requiresGeofence => boolean().withDefault(const Constant(false))();
  IntColumn get estimatedDuration => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Submissions table for storing submissions locally
class Submissions extends Table {
  TextColumn get id => text()();
  TextColumn get formId => text()();
  TextColumn get userId => text()();
  TextColumn get status => text()(); // 'draft', 'submitted', 'completed'
  TextColumn get responses => text()(); // JSON object
  DateTimeColumn get submittedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sync queue for tracking pending operations
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operationType => text()(); // 'create', 'update', 'delete'
  TextColumn get entityType => text()(); // 'form', 'submission'
  TextColumn get entityId => text()();
  TextColumn get data => text()(); // JSON data
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
}

@DriftDatabase(tables: [Forms, Submissions, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Constructor for testing with custom connection
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // Form operations
  Future<List<Form>> getAllForms() => select(forms).get();
  
  Future<Form?> getFormById(String id) =>
      (select(forms)..where((f) => f.id.equals(id))).getSingleOrNull();
  
  Future<int> insertForm(FormsCompanion form) =>
      into(forms).insert(form);
  
  Future<bool> updateForm(FormsCompanion form) =>
      update(forms).replace(form);
  
  Future<int> deleteForm(String id) =>
      (delete(forms)..where((f) => f.id.equals(id))).go();

  // Submission operations
  Future<List<Submission>> getAllSubmissions() => select(submissions).get();
  
  Future<List<Submission>> getSubmissionsByFormId(String formId) =>
      (select(submissions)..where((s) => s.formId.equals(formId))).get();
  
  Future<Submission?> getSubmissionById(String id) =>
      (select(submissions)..where((s) => s.id.equals(id))).getSingleOrNull();
  
  Future<List<Submission>> getDirtySubmissions() =>
      (select(submissions)..where((s) => s.isDirty.equals(true))).get();
  
  Future<int> insertSubmission(SubmissionsCompanion submission) =>
      into(submissions).insert(submission);
  
  Future<bool> updateSubmission(SubmissionsCompanion submission) =>
      update(submissions).replace(submission);
  
  Future<int> deleteSubmission(String id) =>
      (delete(submissions)..where((s) => s.id.equals(id))).go();

  // Sync queue operations
  Future<List<SyncQueueData>> getPendingSyncItems() =>
      (select(syncQueue)..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
  
  Future<int> addToSyncQueue(SyncQueueCompanion item) =>
      into(syncQueue).insert(item);
  
  Future<bool> updateSyncQueueItem(SyncQueueCompanion item) =>
      update(syncQueue).replace(item);
  
  Future<int> removeSyncQueueItem(int id) =>
      (delete(syncQueue)..where((t) => t.id.equals(id))).go();
  
  Future<int> clearCompletedSyncItems() =>
      delete(syncQueue).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'store.db'));
    
    return driftDatabase(
      name: 'store',
      native: DriftNativeOptions(
        databasePath: () async => file.path,
      ),
    );
  });
}
