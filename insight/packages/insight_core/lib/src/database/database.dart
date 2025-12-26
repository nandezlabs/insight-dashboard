import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  SyncMetadataTable,
  PendingChangesTable,
  FormsTable,
  FormSectionsTable,
  FieldsTable,
  DropdownOptionsTable,
  SubmissionsTable,
  SubmissionAnswersTable,
  TeamTable,
  GoalsTable,
  KPIDataTable,
  BusinessCalendarTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'insight.db'));
      return NativeDatabase(file);
    });
  }

  // ============ Sync Metadata Operations ============

  Future<Map<String, DateTime>> getSyncMetadata(List<String> tableNames) async {
    final results = await (select(syncMetadataTable)
          ..where((tbl) => tbl.table.isIn(tableNames)))
        .get();
    
    return {for (var r in results) r.table: r.lastSyncAt};
  }

  Future<void> updateSyncMetadata(String tableName, DateTime syncTime) async {
    await into(syncMetadataTable).insertOnConflictUpdate(
      SyncMetadataTableCompanion.insert(
        table: tableName,
        lastSyncAt: syncTime,
      ),
    );
  }

  // ============ Pending Changes Operations ============

  Future<List<PendingChangesTableData>> getPendingChanges({bool syncedOnly = false}) async {
    final query = select(pendingChangesTable)
      ..where((tbl) => tbl.synced.equals(syncedOnly))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]);
    return query.get();
  }

  Future<void> addPendingChange({
    required String tableName,
    required String recordId,
    required String operation,
    required String data,
  }) async {
    await into(pendingChangesTable).insert(
      PendingChangesTableCompanion.insert(
        table: tableName,
        recordId: recordId,
        operation: operation,
        data: data,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> markChangeSynced(int id) async {
    await (update(pendingChangesTable)..where((tbl) => tbl.id.equals(id)))
        .write(const PendingChangesTableCompanion(synced: Value(true)));
  }

  Future<void> clearSyncedChanges() async {
    await (delete(pendingChangesTable)..where((tbl) => tbl.synced.equals(true)))
        .go();
  }

  // ============ Forms Operations ============

  Future<List<FormsTableData>> getAllForms() async {
    return select(formsTable).get();
  }

  Future<FormsTableData?> getFormById(String id) async {
    return (select(formsTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertOrUpdateForm(FormsTableCompanion form) async {
    await into(formsTable).insertOnConflictUpdate(form);
  }

  Future<void> deleteForm(String id) async {
    await (delete(formsTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ============ Submissions Operations ============

  Future<List<SubmissionsTableData>> getAllSubmissions() async {
    return select(submissionsTable).get();
  }

  Future<List<SubmissionsTableData>> getSubmissionsByFormId(String formId) async {
    return (select(submissionsTable)
          ..where((tbl) => tbl.formId.equals(formId)))
        .get();
  }

  Future<void> insertOrUpdateSubmission(SubmissionsTableCompanion submission) async {
    await into(submissionsTable).insertOnConflictUpdate(submission);
  }

  // ============ Team Operations ============

  Future<List<TeamTableData>> getAllTeamMembers() async {
    return select(teamTable).get();
  }

  Future<void> insertOrUpdateTeamMember(TeamTableCompanion member) async {
    await into(teamTable).insertOnConflictUpdate(member);
  }

  // ============ KPI Operations ============

  Future<List<KPIDataTableData>> getKPIData({DateTime? startDate, DateTime? endDate}) async {
    var query = select(kPIDataTable);
    
    if (startDate != null) {
      query = query..where((tbl) => tbl.dataDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((tbl) => tbl.dataDate.isSmallerOrEqualValue(endDate));
    }
    
    return query.get();
  }

  Future<void> insertOrUpdateKPIData(KPIDataTableCompanion data) async {
    await into(kPIDataTable).insertOnConflictUpdate(data);
  }

  // ============ Business Calendar Operations ============

  Future<BusinessCalendarTableData?> getCurrentCalendar() async {
    return (select(businessCalendarTable)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> insertOrUpdateCalendar(BusinessCalendarTableCompanion calendar) async {
    await into(businessCalendarTable).insertOnConflictUpdate(calendar);
  }
}
