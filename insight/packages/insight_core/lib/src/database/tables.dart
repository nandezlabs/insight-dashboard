import 'package:drift/drift.dart';

/// Sync metadata table
class SyncMetadataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get table => text().unique()();
  DateTimeColumn get lastSyncAt => dateTime()();
  IntColumn get lastSyncVersion => integer().withDefault(const Constant(0))();
}

/// Pending changes table
class PendingChangesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get table => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // 'INSERT', 'UPDATE', 'DELETE'
  TextColumn get data => text()(); // JSON string
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// Forms table
class FormsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))(); // JSON array
  BoolColumn get isTemplate => boolean().withDefault(const Constant(false))();
  TextColumn get scheduleType => text().withDefault(const Constant('tag_based'))();
  DateTimeColumn get customStartDate => dateTime().nullable()();
  DateTimeColumn get customEndDate => dateTime().nullable()();
  TextColumn get customTime => text().nullable()();
  IntColumn get maxSubmissions => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Form sections table
class FormSectionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get formId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get order => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Fields table
class FieldsTable extends Table {
  TextColumn get id => text()();
  TextColumn get formId => text().nullable()();
  TextColumn get sectionId => text().nullable()();
  TextColumn get fieldType => text()();
  TextColumn get label => text()();
  TextColumn get placeholder => text().nullable()();
  TextColumn get helpText => text().nullable()();
  BoolColumn get isRequired => boolean().withDefault(const Constant(false))();
  IntColumn get order => integer()();
  TextColumn get validationRules => text().nullable()(); // JSON
  TextColumn get defaultValue => text().nullable()();
  TextColumn get conditionalLogic => text().nullable()(); // JSON
  TextColumn get templateId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Dropdown options table
class DropdownOptionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get fieldId => text()();
  TextColumn get label => text()();
  TextColumn get value => text()();
  IntColumn get order => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Submissions table
class SubmissionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get formId => text()();
  TextColumn get submittedBy => text()();
  DateTimeColumn get submissionDate => dateTime()();
  DateTimeColumn get submissionTime => dateTime()();
  TextColumn get status => text().withDefault(const Constant('in_progress'))();
  RealColumn get completionPercentage => real().withDefault(const Constant(0.0))();
  BoolColumn get isAutoSubmitted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Submission answers table
class SubmissionAnswersTable extends Table {
  TextColumn get id => text()();
  TextColumn get submissionId => text()();
  TextColumn get fieldId => text()();
  TextColumn get answerValue => text().nullable()();
  TextColumn get fileUrl => text().nullable()();
  DateTimeColumn get answeredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Team table
class TeamTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get role => text().withDefault(const Constant('employee'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Goals table
class GoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get goalType => text()();
  RealColumn get targetValue => real()();
  DateTimeColumn get periodDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// KPI data table
class KPIDataTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get dataDate => dateTime().unique()();
  RealColumn get gemScore => real().nullable()();
  RealColumn get hoursScheduled => real().nullable()();
  RealColumn get hoursRecommended => real().nullable()();
  RealColumn get laborUsedPercentage => real().nullable()();
  RealColumn get salesActual => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Business calendar table
class BusinessCalendarTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startDate => dateTime()();
  IntColumn get currentWeek => integer()();
  IntColumn get currentPeriod => integer()();
  IntColumn get currentQuarter => integer()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
