// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SyncMetadataTableTable extends SyncMetadataTable
    with TableInfo<$SyncMetadataTableTable, SyncMetadataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tableMeta = const VerificationMeta('table');
  @override
  late final GeneratedColumn<String> table = GeneratedColumn<String>(
      'table', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastSyncVersionMeta =
      const VerificationMeta('lastSyncVersion');
  @override
  late final GeneratedColumn<int> lastSyncVersion = GeneratedColumn<int>(
      'last_sync_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, table, lastSyncAt, lastSyncVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SyncMetadataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table')) {
      context.handle(
          _tableMeta, table.isAcceptableOrUnknown(data['table']!, _tableMeta));
    } else if (isInserting) {
      context.missing(_tableMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncAtMeta);
    }
    if (data.containsKey('last_sync_version')) {
      context.handle(
          _lastSyncVersionMeta,
          lastSyncVersion.isAcceptableOrUnknown(
              data['last_sync_version']!, _lastSyncVersionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMetadataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      table: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table'])!,
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at'])!,
      lastSyncVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_sync_version'])!,
    );
  }

  @override
  $SyncMetadataTableTable createAlias(String alias) {
    return $SyncMetadataTableTable(attachedDatabase, alias);
  }
}

class SyncMetadataTableData extends DataClass
    implements Insertable<SyncMetadataTableData> {
  final int id;
  final String table;
  final DateTime lastSyncAt;
  final int lastSyncVersion;
  const SyncMetadataTableData(
      {required this.id,
      required this.table,
      required this.lastSyncAt,
      required this.lastSyncVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table'] = Variable<String>(table);
    map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    map['last_sync_version'] = Variable<int>(lastSyncVersion);
    return map;
  }

  SyncMetadataTableCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataTableCompanion(
      id: Value(id),
      table: Value(table),
      lastSyncAt: Value(lastSyncAt),
      lastSyncVersion: Value(lastSyncVersion),
    );
  }

  factory SyncMetadataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataTableData(
      id: serializer.fromJson<int>(json['id']),
      table: serializer.fromJson<String>(json['table']),
      lastSyncAt: serializer.fromJson<DateTime>(json['lastSyncAt']),
      lastSyncVersion: serializer.fromJson<int>(json['lastSyncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'table': serializer.toJson<String>(table),
      'lastSyncAt': serializer.toJson<DateTime>(lastSyncAt),
      'lastSyncVersion': serializer.toJson<int>(lastSyncVersion),
    };
  }

  SyncMetadataTableData copyWith(
          {int? id,
          String? table,
          DateTime? lastSyncAt,
          int? lastSyncVersion}) =>
      SyncMetadataTableData(
        id: id ?? this.id,
        table: table ?? this.table,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        lastSyncVersion: lastSyncVersion ?? this.lastSyncVersion,
      );
  SyncMetadataTableData copyWithCompanion(SyncMetadataTableCompanion data) {
    return SyncMetadataTableData(
      id: data.id.present ? data.id.value : this.id,
      table: data.table.present ? data.table.value : this.table,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
      lastSyncVersion: data.lastSyncVersion.present
          ? data.lastSyncVersion.value
          : this.lastSyncVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataTableData(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('lastSyncVersion: $lastSyncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, table, lastSyncAt, lastSyncVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataTableData &&
          other.id == this.id &&
          other.table == this.table &&
          other.lastSyncAt == this.lastSyncAt &&
          other.lastSyncVersion == this.lastSyncVersion);
}

class SyncMetadataTableCompanion
    extends UpdateCompanion<SyncMetadataTableData> {
  final Value<int> id;
  final Value<String> table;
  final Value<DateTime> lastSyncAt;
  final Value<int> lastSyncVersion;
  const SyncMetadataTableCompanion({
    this.id = const Value.absent(),
    this.table = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.lastSyncVersion = const Value.absent(),
  });
  SyncMetadataTableCompanion.insert({
    this.id = const Value.absent(),
    required String table,
    required DateTime lastSyncAt,
    this.lastSyncVersion = const Value.absent(),
  })  : table = Value(table),
        lastSyncAt = Value(lastSyncAt);
  static Insertable<SyncMetadataTableData> custom({
    Expression<int>? id,
    Expression<String>? table,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? lastSyncVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (table != null) 'table': table,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (lastSyncVersion != null) 'last_sync_version': lastSyncVersion,
    });
  }

  SyncMetadataTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? table,
      Value<DateTime>? lastSyncAt,
      Value<int>? lastSyncVersion}) {
    return SyncMetadataTableCompanion(
      id: id ?? this.id,
      table: table ?? this.table,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      lastSyncVersion: lastSyncVersion ?? this.lastSyncVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (table.present) {
      map['table'] = Variable<String>(table.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (lastSyncVersion.present) {
      map['last_sync_version'] = Variable<int>(lastSyncVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataTableCompanion(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('lastSyncVersion: $lastSyncVersion')
          ..write(')'))
        .toString();
  }
}

class $PendingChangesTableTable extends PendingChangesTable
    with TableInfo<$PendingChangesTableTable, PendingChangesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingChangesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tableMeta = const VerificationMeta('table');
  @override
  late final GeneratedColumn<String> table = GeneratedColumn<String>(
      'table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, table, recordId, operation, data, createdAt, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_changes_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PendingChangesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table')) {
      context.handle(
          _tableMeta, table.isAcceptableOrUnknown(data['table']!, _tableMeta));
    } else if (isInserting) {
      context.missing(_tableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingChangesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingChangesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      table: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $PendingChangesTableTable createAlias(String alias) {
    return $PendingChangesTableTable(attachedDatabase, alias);
  }
}

class PendingChangesTableData extends DataClass
    implements Insertable<PendingChangesTableData> {
  final int id;
  final String table;
  final String recordId;
  final String operation;
  final String data;
  final DateTime createdAt;
  final bool synced;
  const PendingChangesTableData(
      {required this.id,
      required this.table,
      required this.recordId,
      required this.operation,
      required this.data,
      required this.createdAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table'] = Variable<String>(table);
    map['record_id'] = Variable<String>(recordId);
    map['operation'] = Variable<String>(operation);
    map['data'] = Variable<String>(data);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  PendingChangesTableCompanion toCompanion(bool nullToAbsent) {
    return PendingChangesTableCompanion(
      id: Value(id),
      table: Value(table),
      recordId: Value(recordId),
      operation: Value(operation),
      data: Value(data),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory PendingChangesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingChangesTableData(
      id: serializer.fromJson<int>(json['id']),
      table: serializer.fromJson<String>(json['table']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: serializer.fromJson<String>(json['operation']),
      data: serializer.fromJson<String>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'table': serializer.toJson<String>(table),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(operation),
      'data': serializer.toJson<String>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  PendingChangesTableData copyWith(
          {int? id,
          String? table,
          String? recordId,
          String? operation,
          String? data,
          DateTime? createdAt,
          bool? synced}) =>
      PendingChangesTableData(
        id: id ?? this.id,
        table: table ?? this.table,
        recordId: recordId ?? this.recordId,
        operation: operation ?? this.operation,
        data: data ?? this.data,
        createdAt: createdAt ?? this.createdAt,
        synced: synced ?? this.synced,
      );
  PendingChangesTableData copyWithCompanion(PendingChangesTableCompanion data) {
    return PendingChangesTableData(
      id: data.id.present ? data.id.value : this.id,
      table: data.table.present ? data.table.value : this.table,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      operation: data.operation.present ? data.operation.value : this.operation,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingChangesTableData(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, table, recordId, operation, data, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingChangesTableData &&
          other.id == this.id &&
          other.table == this.table &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.data == this.data &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class PendingChangesTableCompanion
    extends UpdateCompanion<PendingChangesTableData> {
  final Value<int> id;
  final Value<String> table;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String> data;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  const PendingChangesTableCompanion({
    this.id = const Value.absent(),
    this.table = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
  });
  PendingChangesTableCompanion.insert({
    this.id = const Value.absent(),
    required String table,
    required String recordId,
    required String operation,
    required String data,
    required DateTime createdAt,
    this.synced = const Value.absent(),
  })  : table = Value(table),
        recordId = Value(recordId),
        operation = Value(operation),
        data = Value(data),
        createdAt = Value(createdAt);
  static Insertable<PendingChangesTableData> custom({
    Expression<int>? id,
    Expression<String>? table,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? data,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (table != null) 'table': table,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
    });
  }

  PendingChangesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? table,
      Value<String>? recordId,
      Value<String>? operation,
      Value<String>? data,
      Value<DateTime>? createdAt,
      Value<bool>? synced}) {
    return PendingChangesTableCompanion(
      id: id ?? this.id,
      table: table ?? this.table,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (table.present) {
      map['table'] = Variable<String>(table.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingChangesTableCompanion(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $FormsTableTable extends FormsTable
    with TableInfo<$FormsTableTable, FormsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isTemplateMeta =
      const VerificationMeta('isTemplate');
  @override
  late final GeneratedColumn<bool> isTemplate = GeneratedColumn<bool>(
      'is_template', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_template" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _scheduleTypeMeta =
      const VerificationMeta('scheduleType');
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
      'schedule_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('tag_based'));
  static const VerificationMeta _customStartDateMeta =
      const VerificationMeta('customStartDate');
  @override
  late final GeneratedColumn<DateTime> customStartDate =
      GeneratedColumn<DateTime>('custom_start_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _customEndDateMeta =
      const VerificationMeta('customEndDate');
  @override
  late final GeneratedColumn<DateTime> customEndDate =
      GeneratedColumn<DateTime>('custom_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _customTimeMeta =
      const VerificationMeta('customTime');
  @override
  late final GeneratedColumn<String> customTime = GeneratedColumn<String>(
      'custom_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maxSubmissionsMeta =
      const VerificationMeta('maxSubmissions');
  @override
  late final GeneratedColumn<int> maxSubmissions = GeneratedColumn<int>(
      'max_submissions', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        tags,
        isTemplate,
        scheduleType,
        customStartDate,
        customEndDate,
        customTime,
        maxSubmissions,
        status,
        createdBy,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forms_table';
  @override
  VerificationContext validateIntegrity(Insertable<FormsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('is_template')) {
      context.handle(
          _isTemplateMeta,
          isTemplate.isAcceptableOrUnknown(
              data['is_template']!, _isTemplateMeta));
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
          _scheduleTypeMeta,
          scheduleType.isAcceptableOrUnknown(
              data['schedule_type']!, _scheduleTypeMeta));
    }
    if (data.containsKey('custom_start_date')) {
      context.handle(
          _customStartDateMeta,
          customStartDate.isAcceptableOrUnknown(
              data['custom_start_date']!, _customStartDateMeta));
    }
    if (data.containsKey('custom_end_date')) {
      context.handle(
          _customEndDateMeta,
          customEndDate.isAcceptableOrUnknown(
              data['custom_end_date']!, _customEndDateMeta));
    }
    if (data.containsKey('custom_time')) {
      context.handle(
          _customTimeMeta,
          customTime.isAcceptableOrUnknown(
              data['custom_time']!, _customTimeMeta));
    }
    if (data.containsKey('max_submissions')) {
      context.handle(
          _maxSubmissionsMeta,
          maxSubmissions.isAcceptableOrUnknown(
              data['max_submissions']!, _maxSubmissionsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      isTemplate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_template'])!,
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      customStartDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}custom_start_date']),
      customEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}custom_end_date']),
      customTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_time']),
      maxSubmissions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_submissions']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FormsTableTable createAlias(String alias) {
    return $FormsTableTable(attachedDatabase, alias);
  }
}

class FormsTableData extends DataClass implements Insertable<FormsTableData> {
  final String id;
  final String title;
  final String? description;
  final String tags;
  final bool isTemplate;
  final String scheduleType;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final String? customTime;
  final int? maxSubmissions;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FormsTableData(
      {required this.id,
      required this.title,
      this.description,
      required this.tags,
      required this.isTemplate,
      required this.scheduleType,
      this.customStartDate,
      this.customEndDate,
      this.customTime,
      this.maxSubmissions,
      required this.status,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['tags'] = Variable<String>(tags);
    map['is_template'] = Variable<bool>(isTemplate);
    map['schedule_type'] = Variable<String>(scheduleType);
    if (!nullToAbsent || customStartDate != null) {
      map['custom_start_date'] = Variable<DateTime>(customStartDate);
    }
    if (!nullToAbsent || customEndDate != null) {
      map['custom_end_date'] = Variable<DateTime>(customEndDate);
    }
    if (!nullToAbsent || customTime != null) {
      map['custom_time'] = Variable<String>(customTime);
    }
    if (!nullToAbsent || maxSubmissions != null) {
      map['max_submissions'] = Variable<int>(maxSubmissions);
    }
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FormsTableCompanion toCompanion(bool nullToAbsent) {
    return FormsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      tags: Value(tags),
      isTemplate: Value(isTemplate),
      scheduleType: Value(scheduleType),
      customStartDate: customStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(customStartDate),
      customEndDate: customEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(customEndDate),
      customTime: customTime == null && nullToAbsent
          ? const Value.absent()
          : Value(customTime),
      maxSubmissions: maxSubmissions == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSubmissions),
      status: Value(status),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FormsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      tags: serializer.fromJson<String>(json['tags']),
      isTemplate: serializer.fromJson<bool>(json['isTemplate']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      customStartDate: serializer.fromJson<DateTime?>(json['customStartDate']),
      customEndDate: serializer.fromJson<DateTime?>(json['customEndDate']),
      customTime: serializer.fromJson<String?>(json['customTime']),
      maxSubmissions: serializer.fromJson<int?>(json['maxSubmissions']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'tags': serializer.toJson<String>(tags),
      'isTemplate': serializer.toJson<bool>(isTemplate),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'customStartDate': serializer.toJson<DateTime?>(customStartDate),
      'customEndDate': serializer.toJson<DateTime?>(customEndDate),
      'customTime': serializer.toJson<String?>(customTime),
      'maxSubmissions': serializer.toJson<int?>(maxSubmissions),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FormsTableData copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? tags,
          bool? isTemplate,
          String? scheduleType,
          Value<DateTime?> customStartDate = const Value.absent(),
          Value<DateTime?> customEndDate = const Value.absent(),
          Value<String?> customTime = const Value.absent(),
          Value<int?> maxSubmissions = const Value.absent(),
          String? status,
          String? createdBy,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FormsTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        tags: tags ?? this.tags,
        isTemplate: isTemplate ?? this.isTemplate,
        scheduleType: scheduleType ?? this.scheduleType,
        customStartDate: customStartDate.present
            ? customStartDate.value
            : this.customStartDate,
        customEndDate:
            customEndDate.present ? customEndDate.value : this.customEndDate,
        customTime: customTime.present ? customTime.value : this.customTime,
        maxSubmissions:
            maxSubmissions.present ? maxSubmissions.value : this.maxSubmissions,
        status: status ?? this.status,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FormsTableData copyWithCompanion(FormsTableCompanion data) {
    return FormsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
      isTemplate:
          data.isTemplate.present ? data.isTemplate.value : this.isTemplate,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      customStartDate: data.customStartDate.present
          ? data.customStartDate.value
          : this.customStartDate,
      customEndDate: data.customEndDate.present
          ? data.customEndDate.value
          : this.customEndDate,
      customTime:
          data.customTime.present ? data.customTime.value : this.customTime,
      maxSubmissions: data.maxSubmissions.present
          ? data.maxSubmissions.value
          : this.maxSubmissions,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('isTemplate: $isTemplate, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('customStartDate: $customStartDate, ')
          ..write('customEndDate: $customEndDate, ')
          ..write('customTime: $customTime, ')
          ..write('maxSubmissions: $maxSubmissions, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      tags,
      isTemplate,
      scheduleType,
      customStartDate,
      customEndDate,
      customTime,
      maxSubmissions,
      status,
      createdBy,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.tags == this.tags &&
          other.isTemplate == this.isTemplate &&
          other.scheduleType == this.scheduleType &&
          other.customStartDate == this.customStartDate &&
          other.customEndDate == this.customEndDate &&
          other.customTime == this.customTime &&
          other.maxSubmissions == this.maxSubmissions &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FormsTableCompanion extends UpdateCompanion<FormsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> tags;
  final Value<bool> isTemplate;
  final Value<String> scheduleType;
  final Value<DateTime?> customStartDate;
  final Value<DateTime?> customEndDate;
  final Value<String?> customTime;
  final Value<int?> maxSubmissions;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FormsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.isTemplate = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.customStartDate = const Value.absent(),
    this.customEndDate = const Value.absent(),
    this.customTime = const Value.absent(),
    this.maxSubmissions = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormsTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.isTemplate = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.customStartDate = const Value.absent(),
    this.customEndDate = const Value.absent(),
    this.customTime = const Value.absent(),
    this.maxSubmissions = const Value.absent(),
    this.status = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<FormsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? tags,
    Expression<bool>? isTemplate,
    Expression<String>? scheduleType,
    Expression<DateTime>? customStartDate,
    Expression<DateTime>? customEndDate,
    Expression<String>? customTime,
    Expression<int>? maxSubmissions,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (isTemplate != null) 'is_template': isTemplate,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (customStartDate != null) 'custom_start_date': customStartDate,
      if (customEndDate != null) 'custom_end_date': customEndDate,
      if (customTime != null) 'custom_time': customTime,
      if (maxSubmissions != null) 'max_submissions': maxSubmissions,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? tags,
      Value<bool>? isTemplate,
      Value<String>? scheduleType,
      Value<DateTime?>? customStartDate,
      Value<DateTime?>? customEndDate,
      Value<String?>? customTime,
      Value<int?>? maxSubmissions,
      Value<String>? status,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FormsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isTemplate: isTemplate ?? this.isTemplate,
      scheduleType: scheduleType ?? this.scheduleType,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      customTime: customTime ?? this.customTime,
      maxSubmissions: maxSubmissions ?? this.maxSubmissions,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (isTemplate.present) {
      map['is_template'] = Variable<bool>(isTemplate.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (customStartDate.present) {
      map['custom_start_date'] = Variable<DateTime>(customStartDate.value);
    }
    if (customEndDate.present) {
      map['custom_end_date'] = Variable<DateTime>(customEndDate.value);
    }
    if (customTime.present) {
      map['custom_time'] = Variable<String>(customTime.value);
    }
    if (maxSubmissions.present) {
      map['max_submissions'] = Variable<int>(maxSubmissions.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('isTemplate: $isTemplate, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('customStartDate: $customStartDate, ')
          ..write('customEndDate: $customEndDate, ')
          ..write('customTime: $customTime, ')
          ..write('maxSubmissions: $maxSubmissions, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FormSectionsTableTable extends FormSectionsTable
    with TableInfo<$FormSectionsTableTable, FormSectionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormSectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
      'form_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, formId, title, description, order, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'form_sections_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<FormSectionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(_formIdMeta,
          formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta));
    } else if (isInserting) {
      context.missing(_formIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormSectionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormSectionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      formId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FormSectionsTableTable createAlias(String alias) {
    return $FormSectionsTableTable(attachedDatabase, alias);
  }
}

class FormSectionsTableData extends DataClass
    implements Insertable<FormSectionsTableData> {
  final String id;
  final String formId;
  final String title;
  final String? description;
  final int order;
  final DateTime createdAt;
  const FormSectionsTableData(
      {required this.id,
      required this.formId,
      required this.title,
      this.description,
      required this.order,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['form_id'] = Variable<String>(formId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['order'] = Variable<int>(order);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FormSectionsTableCompanion toCompanion(bool nullToAbsent) {
    return FormSectionsTableCompanion(
      id: Value(id),
      formId: Value(formId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      order: Value(order),
      createdAt: Value(createdAt),
    );
  }

  factory FormSectionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormSectionsTableData(
      id: serializer.fromJson<String>(json['id']),
      formId: serializer.fromJson<String>(json['formId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      order: serializer.fromJson<int>(json['order']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formId': serializer.toJson<String>(formId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'order': serializer.toJson<int>(order),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FormSectionsTableData copyWith(
          {String? id,
          String? formId,
          String? title,
          Value<String?> description = const Value.absent(),
          int? order,
          DateTime? createdAt}) =>
      FormSectionsTableData(
        id: id ?? this.id,
        formId: formId ?? this.formId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        order: order ?? this.order,
        createdAt: createdAt ?? this.createdAt,
      );
  FormSectionsTableData copyWithCompanion(FormSectionsTableCompanion data) {
    return FormSectionsTableData(
      id: data.id.present ? data.id.value : this.id,
      formId: data.formId.present ? data.formId.value : this.formId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      order: data.order.present ? data.order.value : this.order,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormSectionsTableData(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, formId, title, description, order, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormSectionsTableData &&
          other.id == this.id &&
          other.formId == this.formId &&
          other.title == this.title &&
          other.description == this.description &&
          other.order == this.order &&
          other.createdAt == this.createdAt);
}

class FormSectionsTableCompanion
    extends UpdateCompanion<FormSectionsTableData> {
  final Value<String> id;
  final Value<String> formId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> order;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FormSectionsTableCompanion({
    this.id = const Value.absent(),
    this.formId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormSectionsTableCompanion.insert({
    required String id,
    required String formId,
    required String title,
    this.description = const Value.absent(),
    required int order,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        formId = Value(formId),
        title = Value(title),
        order = Value(order),
        createdAt = Value(createdAt);
  static Insertable<FormSectionsTableData> custom({
    Expression<String>? id,
    Expression<String>? formId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? order,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formId != null) 'form_id': formId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (order != null) 'order': order,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormSectionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? formId,
      Value<String>? title,
      Value<String?>? description,
      Value<int>? order,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FormSectionsTableCompanion(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormSectionsTableCompanion(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FieldsTableTable extends FieldsTable
    with TableInfo<$FieldsTableTable, FieldsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
      'form_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sectionIdMeta =
      const VerificationMeta('sectionId');
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
      'section_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fieldTypeMeta =
      const VerificationMeta('fieldType');
  @override
  late final GeneratedColumn<String> fieldType = GeneratedColumn<String>(
      'field_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _placeholderMeta =
      const VerificationMeta('placeholder');
  @override
  late final GeneratedColumn<String> placeholder = GeneratedColumn<String>(
      'placeholder', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _helpTextMeta =
      const VerificationMeta('helpText');
  @override
  late final GeneratedColumn<String> helpText = GeneratedColumn<String>(
      'help_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isRequiredMeta =
      const VerificationMeta('isRequired');
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
      'is_required', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_required" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _validationRulesMeta =
      const VerificationMeta('validationRules');
  @override
  late final GeneratedColumn<String> validationRules = GeneratedColumn<String>(
      'validation_rules', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultValueMeta =
      const VerificationMeta('defaultValue');
  @override
  late final GeneratedColumn<String> defaultValue = GeneratedColumn<String>(
      'default_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conditionalLogicMeta =
      const VerificationMeta('conditionalLogic');
  @override
  late final GeneratedColumn<String> conditionalLogic = GeneratedColumn<String>(
      'conditional_logic', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
      'template_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        formId,
        sectionId,
        fieldType,
        label,
        placeholder,
        helpText,
        isRequired,
        order,
        validationRules,
        defaultValue,
        conditionalLogic,
        templateId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fields_table';
  @override
  VerificationContext validateIntegrity(Insertable<FieldsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(_formIdMeta,
          formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta));
    }
    if (data.containsKey('section_id')) {
      context.handle(_sectionIdMeta,
          sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta));
    }
    if (data.containsKey('field_type')) {
      context.handle(_fieldTypeMeta,
          fieldType.isAcceptableOrUnknown(data['field_type']!, _fieldTypeMeta));
    } else if (isInserting) {
      context.missing(_fieldTypeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('placeholder')) {
      context.handle(
          _placeholderMeta,
          placeholder.isAcceptableOrUnknown(
              data['placeholder']!, _placeholderMeta));
    }
    if (data.containsKey('help_text')) {
      context.handle(_helpTextMeta,
          helpText.isAcceptableOrUnknown(data['help_text']!, _helpTextMeta));
    }
    if (data.containsKey('is_required')) {
      context.handle(
          _isRequiredMeta,
          isRequired.isAcceptableOrUnknown(
              data['is_required']!, _isRequiredMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('validation_rules')) {
      context.handle(
          _validationRulesMeta,
          validationRules.isAcceptableOrUnknown(
              data['validation_rules']!, _validationRulesMeta));
    }
    if (data.containsKey('default_value')) {
      context.handle(
          _defaultValueMeta,
          defaultValue.isAcceptableOrUnknown(
              data['default_value']!, _defaultValueMeta));
    }
    if (data.containsKey('conditional_logic')) {
      context.handle(
          _conditionalLogicMeta,
          conditionalLogic.isAcceptableOrUnknown(
              data['conditional_logic']!, _conditionalLogicMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FieldsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FieldsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      formId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form_id']),
      sectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section_id']),
      fieldType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_type'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      placeholder: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}placeholder']),
      helpText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}help_text']),
      isRequired: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_required'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      validationRules: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}validation_rules']),
      defaultValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_value']),
      conditionalLogic: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conditional_logic']),
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FieldsTableTable createAlias(String alias) {
    return $FieldsTableTable(attachedDatabase, alias);
  }
}

class FieldsTableData extends DataClass implements Insertable<FieldsTableData> {
  final String id;
  final String? formId;
  final String? sectionId;
  final String fieldType;
  final String label;
  final String? placeholder;
  final String? helpText;
  final bool isRequired;
  final int order;
  final String? validationRules;
  final String? defaultValue;
  final String? conditionalLogic;
  final String? templateId;
  final DateTime createdAt;
  const FieldsTableData(
      {required this.id,
      this.formId,
      this.sectionId,
      required this.fieldType,
      required this.label,
      this.placeholder,
      this.helpText,
      required this.isRequired,
      required this.order,
      this.validationRules,
      this.defaultValue,
      this.conditionalLogic,
      this.templateId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || formId != null) {
      map['form_id'] = Variable<String>(formId);
    }
    if (!nullToAbsent || sectionId != null) {
      map['section_id'] = Variable<String>(sectionId);
    }
    map['field_type'] = Variable<String>(fieldType);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || placeholder != null) {
      map['placeholder'] = Variable<String>(placeholder);
    }
    if (!nullToAbsent || helpText != null) {
      map['help_text'] = Variable<String>(helpText);
    }
    map['is_required'] = Variable<bool>(isRequired);
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || validationRules != null) {
      map['validation_rules'] = Variable<String>(validationRules);
    }
    if (!nullToAbsent || defaultValue != null) {
      map['default_value'] = Variable<String>(defaultValue);
    }
    if (!nullToAbsent || conditionalLogic != null) {
      map['conditional_logic'] = Variable<String>(conditionalLogic);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FieldsTableCompanion toCompanion(bool nullToAbsent) {
    return FieldsTableCompanion(
      id: Value(id),
      formId:
          formId == null && nullToAbsent ? const Value.absent() : Value(formId),
      sectionId: sectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionId),
      fieldType: Value(fieldType),
      label: Value(label),
      placeholder: placeholder == null && nullToAbsent
          ? const Value.absent()
          : Value(placeholder),
      helpText: helpText == null && nullToAbsent
          ? const Value.absent()
          : Value(helpText),
      isRequired: Value(isRequired),
      order: Value(order),
      validationRules: validationRules == null && nullToAbsent
          ? const Value.absent()
          : Value(validationRules),
      defaultValue: defaultValue == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultValue),
      conditionalLogic: conditionalLogic == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionalLogic),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      createdAt: Value(createdAt),
    );
  }

  factory FieldsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FieldsTableData(
      id: serializer.fromJson<String>(json['id']),
      formId: serializer.fromJson<String?>(json['formId']),
      sectionId: serializer.fromJson<String?>(json['sectionId']),
      fieldType: serializer.fromJson<String>(json['fieldType']),
      label: serializer.fromJson<String>(json['label']),
      placeholder: serializer.fromJson<String?>(json['placeholder']),
      helpText: serializer.fromJson<String?>(json['helpText']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      order: serializer.fromJson<int>(json['order']),
      validationRules: serializer.fromJson<String?>(json['validationRules']),
      defaultValue: serializer.fromJson<String?>(json['defaultValue']),
      conditionalLogic: serializer.fromJson<String?>(json['conditionalLogic']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formId': serializer.toJson<String?>(formId),
      'sectionId': serializer.toJson<String?>(sectionId),
      'fieldType': serializer.toJson<String>(fieldType),
      'label': serializer.toJson<String>(label),
      'placeholder': serializer.toJson<String?>(placeholder),
      'helpText': serializer.toJson<String?>(helpText),
      'isRequired': serializer.toJson<bool>(isRequired),
      'order': serializer.toJson<int>(order),
      'validationRules': serializer.toJson<String?>(validationRules),
      'defaultValue': serializer.toJson<String?>(defaultValue),
      'conditionalLogic': serializer.toJson<String?>(conditionalLogic),
      'templateId': serializer.toJson<String?>(templateId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FieldsTableData copyWith(
          {String? id,
          Value<String?> formId = const Value.absent(),
          Value<String?> sectionId = const Value.absent(),
          String? fieldType,
          String? label,
          Value<String?> placeholder = const Value.absent(),
          Value<String?> helpText = const Value.absent(),
          bool? isRequired,
          int? order,
          Value<String?> validationRules = const Value.absent(),
          Value<String?> defaultValue = const Value.absent(),
          Value<String?> conditionalLogic = const Value.absent(),
          Value<String?> templateId = const Value.absent(),
          DateTime? createdAt}) =>
      FieldsTableData(
        id: id ?? this.id,
        formId: formId.present ? formId.value : this.formId,
        sectionId: sectionId.present ? sectionId.value : this.sectionId,
        fieldType: fieldType ?? this.fieldType,
        label: label ?? this.label,
        placeholder: placeholder.present ? placeholder.value : this.placeholder,
        helpText: helpText.present ? helpText.value : this.helpText,
        isRequired: isRequired ?? this.isRequired,
        order: order ?? this.order,
        validationRules: validationRules.present
            ? validationRules.value
            : this.validationRules,
        defaultValue:
            defaultValue.present ? defaultValue.value : this.defaultValue,
        conditionalLogic: conditionalLogic.present
            ? conditionalLogic.value
            : this.conditionalLogic,
        templateId: templateId.present ? templateId.value : this.templateId,
        createdAt: createdAt ?? this.createdAt,
      );
  FieldsTableData copyWithCompanion(FieldsTableCompanion data) {
    return FieldsTableData(
      id: data.id.present ? data.id.value : this.id,
      formId: data.formId.present ? data.formId.value : this.formId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      fieldType: data.fieldType.present ? data.fieldType.value : this.fieldType,
      label: data.label.present ? data.label.value : this.label,
      placeholder:
          data.placeholder.present ? data.placeholder.value : this.placeholder,
      helpText: data.helpText.present ? data.helpText.value : this.helpText,
      isRequired:
          data.isRequired.present ? data.isRequired.value : this.isRequired,
      order: data.order.present ? data.order.value : this.order,
      validationRules: data.validationRules.present
          ? data.validationRules.value
          : this.validationRules,
      defaultValue: data.defaultValue.present
          ? data.defaultValue.value
          : this.defaultValue,
      conditionalLogic: data.conditionalLogic.present
          ? data.conditionalLogic.value
          : this.conditionalLogic,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FieldsTableData(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('sectionId: $sectionId, ')
          ..write('fieldType: $fieldType, ')
          ..write('label: $label, ')
          ..write('placeholder: $placeholder, ')
          ..write('helpText: $helpText, ')
          ..write('isRequired: $isRequired, ')
          ..write('order: $order, ')
          ..write('validationRules: $validationRules, ')
          ..write('defaultValue: $defaultValue, ')
          ..write('conditionalLogic: $conditionalLogic, ')
          ..write('templateId: $templateId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      formId,
      sectionId,
      fieldType,
      label,
      placeholder,
      helpText,
      isRequired,
      order,
      validationRules,
      defaultValue,
      conditionalLogic,
      templateId,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FieldsTableData &&
          other.id == this.id &&
          other.formId == this.formId &&
          other.sectionId == this.sectionId &&
          other.fieldType == this.fieldType &&
          other.label == this.label &&
          other.placeholder == this.placeholder &&
          other.helpText == this.helpText &&
          other.isRequired == this.isRequired &&
          other.order == this.order &&
          other.validationRules == this.validationRules &&
          other.defaultValue == this.defaultValue &&
          other.conditionalLogic == this.conditionalLogic &&
          other.templateId == this.templateId &&
          other.createdAt == this.createdAt);
}

class FieldsTableCompanion extends UpdateCompanion<FieldsTableData> {
  final Value<String> id;
  final Value<String?> formId;
  final Value<String?> sectionId;
  final Value<String> fieldType;
  final Value<String> label;
  final Value<String?> placeholder;
  final Value<String?> helpText;
  final Value<bool> isRequired;
  final Value<int> order;
  final Value<String?> validationRules;
  final Value<String?> defaultValue;
  final Value<String?> conditionalLogic;
  final Value<String?> templateId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FieldsTableCompanion({
    this.id = const Value.absent(),
    this.formId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.fieldType = const Value.absent(),
    this.label = const Value.absent(),
    this.placeholder = const Value.absent(),
    this.helpText = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.order = const Value.absent(),
    this.validationRules = const Value.absent(),
    this.defaultValue = const Value.absent(),
    this.conditionalLogic = const Value.absent(),
    this.templateId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FieldsTableCompanion.insert({
    required String id,
    this.formId = const Value.absent(),
    this.sectionId = const Value.absent(),
    required String fieldType,
    required String label,
    this.placeholder = const Value.absent(),
    this.helpText = const Value.absent(),
    this.isRequired = const Value.absent(),
    required int order,
    this.validationRules = const Value.absent(),
    this.defaultValue = const Value.absent(),
    this.conditionalLogic = const Value.absent(),
    this.templateId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fieldType = Value(fieldType),
        label = Value(label),
        order = Value(order),
        createdAt = Value(createdAt);
  static Insertable<FieldsTableData> custom({
    Expression<String>? id,
    Expression<String>? formId,
    Expression<String>? sectionId,
    Expression<String>? fieldType,
    Expression<String>? label,
    Expression<String>? placeholder,
    Expression<String>? helpText,
    Expression<bool>? isRequired,
    Expression<int>? order,
    Expression<String>? validationRules,
    Expression<String>? defaultValue,
    Expression<String>? conditionalLogic,
    Expression<String>? templateId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formId != null) 'form_id': formId,
      if (sectionId != null) 'section_id': sectionId,
      if (fieldType != null) 'field_type': fieldType,
      if (label != null) 'label': label,
      if (placeholder != null) 'placeholder': placeholder,
      if (helpText != null) 'help_text': helpText,
      if (isRequired != null) 'is_required': isRequired,
      if (order != null) 'order': order,
      if (validationRules != null) 'validation_rules': validationRules,
      if (defaultValue != null) 'default_value': defaultValue,
      if (conditionalLogic != null) 'conditional_logic': conditionalLogic,
      if (templateId != null) 'template_id': templateId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FieldsTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? formId,
      Value<String?>? sectionId,
      Value<String>? fieldType,
      Value<String>? label,
      Value<String?>? placeholder,
      Value<String?>? helpText,
      Value<bool>? isRequired,
      Value<int>? order,
      Value<String?>? validationRules,
      Value<String?>? defaultValue,
      Value<String?>? conditionalLogic,
      Value<String?>? templateId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FieldsTableCompanion(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      sectionId: sectionId ?? this.sectionId,
      fieldType: fieldType ?? this.fieldType,
      label: label ?? this.label,
      placeholder: placeholder ?? this.placeholder,
      helpText: helpText ?? this.helpText,
      isRequired: isRequired ?? this.isRequired,
      order: order ?? this.order,
      validationRules: validationRules ?? this.validationRules,
      defaultValue: defaultValue ?? this.defaultValue,
      conditionalLogic: conditionalLogic ?? this.conditionalLogic,
      templateId: templateId ?? this.templateId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (fieldType.present) {
      map['field_type'] = Variable<String>(fieldType.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (placeholder.present) {
      map['placeholder'] = Variable<String>(placeholder.value);
    }
    if (helpText.present) {
      map['help_text'] = Variable<String>(helpText.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (validationRules.present) {
      map['validation_rules'] = Variable<String>(validationRules.value);
    }
    if (defaultValue.present) {
      map['default_value'] = Variable<String>(defaultValue.value);
    }
    if (conditionalLogic.present) {
      map['conditional_logic'] = Variable<String>(conditionalLogic.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldsTableCompanion(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('sectionId: $sectionId, ')
          ..write('fieldType: $fieldType, ')
          ..write('label: $label, ')
          ..write('placeholder: $placeholder, ')
          ..write('helpText: $helpText, ')
          ..write('isRequired: $isRequired, ')
          ..write('order: $order, ')
          ..write('validationRules: $validationRules, ')
          ..write('defaultValue: $defaultValue, ')
          ..write('conditionalLogic: $conditionalLogic, ')
          ..write('templateId: $templateId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DropdownOptionsTableTable extends DropdownOptionsTable
    with TableInfo<$DropdownOptionsTableTable, DropdownOptionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DropdownOptionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldIdMeta =
      const VerificationMeta('fieldId');
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
      'field_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, fieldId, label, value, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dropdown_options_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DropdownOptionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('field_id')) {
      context.handle(_fieldIdMeta,
          fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta));
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DropdownOptionsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DropdownOptionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fieldId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
    );
  }

  @override
  $DropdownOptionsTableTable createAlias(String alias) {
    return $DropdownOptionsTableTable(attachedDatabase, alias);
  }
}

class DropdownOptionsTableData extends DataClass
    implements Insertable<DropdownOptionsTableData> {
  final String id;
  final String fieldId;
  final String label;
  final String value;
  final int order;
  const DropdownOptionsTableData(
      {required this.id,
      required this.fieldId,
      required this.label,
      required this.value,
      required this.order});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['field_id'] = Variable<String>(fieldId);
    map['label'] = Variable<String>(label);
    map['value'] = Variable<String>(value);
    map['order'] = Variable<int>(order);
    return map;
  }

  DropdownOptionsTableCompanion toCompanion(bool nullToAbsent) {
    return DropdownOptionsTableCompanion(
      id: Value(id),
      fieldId: Value(fieldId),
      label: Value(label),
      value: Value(value),
      order: Value(order),
    );
  }

  factory DropdownOptionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DropdownOptionsTableData(
      id: serializer.fromJson<String>(json['id']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      label: serializer.fromJson<String>(json['label']),
      value: serializer.fromJson<String>(json['value']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fieldId': serializer.toJson<String>(fieldId),
      'label': serializer.toJson<String>(label),
      'value': serializer.toJson<String>(value),
      'order': serializer.toJson<int>(order),
    };
  }

  DropdownOptionsTableData copyWith(
          {String? id,
          String? fieldId,
          String? label,
          String? value,
          int? order}) =>
      DropdownOptionsTableData(
        id: id ?? this.id,
        fieldId: fieldId ?? this.fieldId,
        label: label ?? this.label,
        value: value ?? this.value,
        order: order ?? this.order,
      );
  DropdownOptionsTableData copyWithCompanion(
      DropdownOptionsTableCompanion data) {
    return DropdownOptionsTableData(
      id: data.id.present ? data.id.value : this.id,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      label: data.label.present ? data.label.value : this.label,
      value: data.value.present ? data.value.value : this.value,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DropdownOptionsTableData(')
          ..write('id: $id, ')
          ..write('fieldId: $fieldId, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fieldId, label, value, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DropdownOptionsTableData &&
          other.id == this.id &&
          other.fieldId == this.fieldId &&
          other.label == this.label &&
          other.value == this.value &&
          other.order == this.order);
}

class DropdownOptionsTableCompanion
    extends UpdateCompanion<DropdownOptionsTableData> {
  final Value<String> id;
  final Value<String> fieldId;
  final Value<String> label;
  final Value<String> value;
  final Value<int> order;
  final Value<int> rowid;
  const DropdownOptionsTableCompanion({
    this.id = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.label = const Value.absent(),
    this.value = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DropdownOptionsTableCompanion.insert({
    required String id,
    required String fieldId,
    required String label,
    required String value,
    required int order,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fieldId = Value(fieldId),
        label = Value(label),
        value = Value(value),
        order = Value(order);
  static Insertable<DropdownOptionsTableData> custom({
    Expression<String>? id,
    Expression<String>? fieldId,
    Expression<String>? label,
    Expression<String>? value,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fieldId != null) 'field_id': fieldId,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DropdownOptionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? fieldId,
      Value<String>? label,
      Value<String>? value,
      Value<int>? order,
      Value<int>? rowid}) {
    return DropdownOptionsTableCompanion(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      label: label ?? this.label,
      value: value ?? this.value,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DropdownOptionsTableCompanion(')
          ..write('id: $id, ')
          ..write('fieldId: $fieldId, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubmissionsTableTable extends SubmissionsTable
    with TableInfo<$SubmissionsTableTable, SubmissionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
      'form_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _submittedByMeta =
      const VerificationMeta('submittedBy');
  @override
  late final GeneratedColumn<String> submittedBy = GeneratedColumn<String>(
      'submitted_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _submissionDateMeta =
      const VerificationMeta('submissionDate');
  @override
  late final GeneratedColumn<DateTime> submissionDate =
      GeneratedColumn<DateTime>('submission_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _submissionTimeMeta =
      const VerificationMeta('submissionTime');
  @override
  late final GeneratedColumn<DateTime> submissionTime =
      GeneratedColumn<DateTime>('submission_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('in_progress'));
  static const VerificationMeta _completionPercentageMeta =
      const VerificationMeta('completionPercentage');
  @override
  late final GeneratedColumn<double> completionPercentage =
      GeneratedColumn<double>('completion_percentage', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _isAutoSubmittedMeta =
      const VerificationMeta('isAutoSubmitted');
  @override
  late final GeneratedColumn<bool> isAutoSubmitted = GeneratedColumn<bool>(
      'is_auto_submitted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_auto_submitted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        formId,
        submittedBy,
        submissionDate,
        submissionTime,
        status,
        completionPercentage,
        isAutoSubmitted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submissions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SubmissionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(_formIdMeta,
          formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta));
    } else if (isInserting) {
      context.missing(_formIdMeta);
    }
    if (data.containsKey('submitted_by')) {
      context.handle(
          _submittedByMeta,
          submittedBy.isAcceptableOrUnknown(
              data['submitted_by']!, _submittedByMeta));
    } else if (isInserting) {
      context.missing(_submittedByMeta);
    }
    if (data.containsKey('submission_date')) {
      context.handle(
          _submissionDateMeta,
          submissionDate.isAcceptableOrUnknown(
              data['submission_date']!, _submissionDateMeta));
    } else if (isInserting) {
      context.missing(_submissionDateMeta);
    }
    if (data.containsKey('submission_time')) {
      context.handle(
          _submissionTimeMeta,
          submissionTime.isAcceptableOrUnknown(
              data['submission_time']!, _submissionTimeMeta));
    } else if (isInserting) {
      context.missing(_submissionTimeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('completion_percentage')) {
      context.handle(
          _completionPercentageMeta,
          completionPercentage.isAcceptableOrUnknown(
              data['completion_percentage']!, _completionPercentageMeta));
    }
    if (data.containsKey('is_auto_submitted')) {
      context.handle(
          _isAutoSubmittedMeta,
          isAutoSubmitted.isAcceptableOrUnknown(
              data['is_auto_submitted']!, _isAutoSubmittedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubmissionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmissionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      formId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form_id'])!,
      submittedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}submitted_by'])!,
      submissionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}submission_date'])!,
      submissionTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}submission_time'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      completionPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}completion_percentage'])!,
      isAutoSubmitted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_auto_submitted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SubmissionsTableTable createAlias(String alias) {
    return $SubmissionsTableTable(attachedDatabase, alias);
  }
}

class SubmissionsTableData extends DataClass
    implements Insertable<SubmissionsTableData> {
  final String id;
  final String formId;
  final String submittedBy;
  final DateTime submissionDate;
  final DateTime submissionTime;
  final String status;
  final double completionPercentage;
  final bool isAutoSubmitted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SubmissionsTableData(
      {required this.id,
      required this.formId,
      required this.submittedBy,
      required this.submissionDate,
      required this.submissionTime,
      required this.status,
      required this.completionPercentage,
      required this.isAutoSubmitted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['form_id'] = Variable<String>(formId);
    map['submitted_by'] = Variable<String>(submittedBy);
    map['submission_date'] = Variable<DateTime>(submissionDate);
    map['submission_time'] = Variable<DateTime>(submissionTime);
    map['status'] = Variable<String>(status);
    map['completion_percentage'] = Variable<double>(completionPercentage);
    map['is_auto_submitted'] = Variable<bool>(isAutoSubmitted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubmissionsTableCompanion toCompanion(bool nullToAbsent) {
    return SubmissionsTableCompanion(
      id: Value(id),
      formId: Value(formId),
      submittedBy: Value(submittedBy),
      submissionDate: Value(submissionDate),
      submissionTime: Value(submissionTime),
      status: Value(status),
      completionPercentage: Value(completionPercentage),
      isAutoSubmitted: Value(isAutoSubmitted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubmissionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmissionsTableData(
      id: serializer.fromJson<String>(json['id']),
      formId: serializer.fromJson<String>(json['formId']),
      submittedBy: serializer.fromJson<String>(json['submittedBy']),
      submissionDate: serializer.fromJson<DateTime>(json['submissionDate']),
      submissionTime: serializer.fromJson<DateTime>(json['submissionTime']),
      status: serializer.fromJson<String>(json['status']),
      completionPercentage:
          serializer.fromJson<double>(json['completionPercentage']),
      isAutoSubmitted: serializer.fromJson<bool>(json['isAutoSubmitted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formId': serializer.toJson<String>(formId),
      'submittedBy': serializer.toJson<String>(submittedBy),
      'submissionDate': serializer.toJson<DateTime>(submissionDate),
      'submissionTime': serializer.toJson<DateTime>(submissionTime),
      'status': serializer.toJson<String>(status),
      'completionPercentage': serializer.toJson<double>(completionPercentage),
      'isAutoSubmitted': serializer.toJson<bool>(isAutoSubmitted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubmissionsTableData copyWith(
          {String? id,
          String? formId,
          String? submittedBy,
          DateTime? submissionDate,
          DateTime? submissionTime,
          String? status,
          double? completionPercentage,
          bool? isAutoSubmitted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SubmissionsTableData(
        id: id ?? this.id,
        formId: formId ?? this.formId,
        submittedBy: submittedBy ?? this.submittedBy,
        submissionDate: submissionDate ?? this.submissionDate,
        submissionTime: submissionTime ?? this.submissionTime,
        status: status ?? this.status,
        completionPercentage: completionPercentage ?? this.completionPercentage,
        isAutoSubmitted: isAutoSubmitted ?? this.isAutoSubmitted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SubmissionsTableData copyWithCompanion(SubmissionsTableCompanion data) {
    return SubmissionsTableData(
      id: data.id.present ? data.id.value : this.id,
      formId: data.formId.present ? data.formId.value : this.formId,
      submittedBy:
          data.submittedBy.present ? data.submittedBy.value : this.submittedBy,
      submissionDate: data.submissionDate.present
          ? data.submissionDate.value
          : this.submissionDate,
      submissionTime: data.submissionTime.present
          ? data.submissionTime.value
          : this.submissionTime,
      status: data.status.present ? data.status.value : this.status,
      completionPercentage: data.completionPercentage.present
          ? data.completionPercentage.value
          : this.completionPercentage,
      isAutoSubmitted: data.isAutoSubmitted.present
          ? data.isAutoSubmitted.value
          : this.isAutoSubmitted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionsTableData(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('submittedBy: $submittedBy, ')
          ..write('submissionDate: $submissionDate, ')
          ..write('submissionTime: $submissionTime, ')
          ..write('status: $status, ')
          ..write('completionPercentage: $completionPercentage, ')
          ..write('isAutoSubmitted: $isAutoSubmitted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      formId,
      submittedBy,
      submissionDate,
      submissionTime,
      status,
      completionPercentage,
      isAutoSubmitted,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmissionsTableData &&
          other.id == this.id &&
          other.formId == this.formId &&
          other.submittedBy == this.submittedBy &&
          other.submissionDate == this.submissionDate &&
          other.submissionTime == this.submissionTime &&
          other.status == this.status &&
          other.completionPercentage == this.completionPercentage &&
          other.isAutoSubmitted == this.isAutoSubmitted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubmissionsTableCompanion extends UpdateCompanion<SubmissionsTableData> {
  final Value<String> id;
  final Value<String> formId;
  final Value<String> submittedBy;
  final Value<DateTime> submissionDate;
  final Value<DateTime> submissionTime;
  final Value<String> status;
  final Value<double> completionPercentage;
  final Value<bool> isAutoSubmitted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubmissionsTableCompanion({
    this.id = const Value.absent(),
    this.formId = const Value.absent(),
    this.submittedBy = const Value.absent(),
    this.submissionDate = const Value.absent(),
    this.submissionTime = const Value.absent(),
    this.status = const Value.absent(),
    this.completionPercentage = const Value.absent(),
    this.isAutoSubmitted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubmissionsTableCompanion.insert({
    required String id,
    required String formId,
    required String submittedBy,
    required DateTime submissionDate,
    required DateTime submissionTime,
    this.status = const Value.absent(),
    this.completionPercentage = const Value.absent(),
    this.isAutoSubmitted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        formId = Value(formId),
        submittedBy = Value(submittedBy),
        submissionDate = Value(submissionDate),
        submissionTime = Value(submissionTime),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SubmissionsTableData> custom({
    Expression<String>? id,
    Expression<String>? formId,
    Expression<String>? submittedBy,
    Expression<DateTime>? submissionDate,
    Expression<DateTime>? submissionTime,
    Expression<String>? status,
    Expression<double>? completionPercentage,
    Expression<bool>? isAutoSubmitted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formId != null) 'form_id': formId,
      if (submittedBy != null) 'submitted_by': submittedBy,
      if (submissionDate != null) 'submission_date': submissionDate,
      if (submissionTime != null) 'submission_time': submissionTime,
      if (status != null) 'status': status,
      if (completionPercentage != null)
        'completion_percentage': completionPercentage,
      if (isAutoSubmitted != null) 'is_auto_submitted': isAutoSubmitted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubmissionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? formId,
      Value<String>? submittedBy,
      Value<DateTime>? submissionDate,
      Value<DateTime>? submissionTime,
      Value<String>? status,
      Value<double>? completionPercentage,
      Value<bool>? isAutoSubmitted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SubmissionsTableCompanion(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      submittedBy: submittedBy ?? this.submittedBy,
      submissionDate: submissionDate ?? this.submissionDate,
      submissionTime: submissionTime ?? this.submissionTime,
      status: status ?? this.status,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      isAutoSubmitted: isAutoSubmitted ?? this.isAutoSubmitted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (submittedBy.present) {
      map['submitted_by'] = Variable<String>(submittedBy.value);
    }
    if (submissionDate.present) {
      map['submission_date'] = Variable<DateTime>(submissionDate.value);
    }
    if (submissionTime.present) {
      map['submission_time'] = Variable<DateTime>(submissionTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completionPercentage.present) {
      map['completion_percentage'] =
          Variable<double>(completionPercentage.value);
    }
    if (isAutoSubmitted.present) {
      map['is_auto_submitted'] = Variable<bool>(isAutoSubmitted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionsTableCompanion(')
          ..write('id: $id, ')
          ..write('formId: $formId, ')
          ..write('submittedBy: $submittedBy, ')
          ..write('submissionDate: $submissionDate, ')
          ..write('submissionTime: $submissionTime, ')
          ..write('status: $status, ')
          ..write('completionPercentage: $completionPercentage, ')
          ..write('isAutoSubmitted: $isAutoSubmitted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubmissionAnswersTableTable extends SubmissionAnswersTable
    with TableInfo<$SubmissionAnswersTableTable, SubmissionAnswersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionAnswersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _submissionIdMeta =
      const VerificationMeta('submissionId');
  @override
  late final GeneratedColumn<String> submissionId = GeneratedColumn<String>(
      'submission_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldIdMeta =
      const VerificationMeta('fieldId');
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
      'field_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerValueMeta =
      const VerificationMeta('answerValue');
  @override
  late final GeneratedColumn<String> answerValue = GeneratedColumn<String>(
      'answer_value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileUrlMeta =
      const VerificationMeta('fileUrl');
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
      'file_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _answeredAtMeta =
      const VerificationMeta('answeredAt');
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
      'answered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, submissionId, fieldId, answerValue, fileUrl, answeredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submission_answers_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SubmissionAnswersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('submission_id')) {
      context.handle(
          _submissionIdMeta,
          submissionId.isAcceptableOrUnknown(
              data['submission_id']!, _submissionIdMeta));
    } else if (isInserting) {
      context.missing(_submissionIdMeta);
    }
    if (data.containsKey('field_id')) {
      context.handle(_fieldIdMeta,
          fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta));
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('answer_value')) {
      context.handle(
          _answerValueMeta,
          answerValue.isAcceptableOrUnknown(
              data['answer_value']!, _answerValueMeta));
    }
    if (data.containsKey('file_url')) {
      context.handle(_fileUrlMeta,
          fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta));
    }
    if (data.containsKey('answered_at')) {
      context.handle(
          _answeredAtMeta,
          answeredAt.isAcceptableOrUnknown(
              data['answered_at']!, _answeredAtMeta));
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubmissionAnswersTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmissionAnswersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      submissionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}submission_id'])!,
      fieldId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_id'])!,
      answerValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer_value']),
      fileUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_url']),
      answeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}answered_at'])!,
    );
  }

  @override
  $SubmissionAnswersTableTable createAlias(String alias) {
    return $SubmissionAnswersTableTable(attachedDatabase, alias);
  }
}

class SubmissionAnswersTableData extends DataClass
    implements Insertable<SubmissionAnswersTableData> {
  final String id;
  final String submissionId;
  final String fieldId;
  final String? answerValue;
  final String? fileUrl;
  final DateTime answeredAt;
  const SubmissionAnswersTableData(
      {required this.id,
      required this.submissionId,
      required this.fieldId,
      this.answerValue,
      this.fileUrl,
      required this.answeredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['submission_id'] = Variable<String>(submissionId);
    map['field_id'] = Variable<String>(fieldId);
    if (!nullToAbsent || answerValue != null) {
      map['answer_value'] = Variable<String>(answerValue);
    }
    if (!nullToAbsent || fileUrl != null) {
      map['file_url'] = Variable<String>(fileUrl);
    }
    map['answered_at'] = Variable<DateTime>(answeredAt);
    return map;
  }

  SubmissionAnswersTableCompanion toCompanion(bool nullToAbsent) {
    return SubmissionAnswersTableCompanion(
      id: Value(id),
      submissionId: Value(submissionId),
      fieldId: Value(fieldId),
      answerValue: answerValue == null && nullToAbsent
          ? const Value.absent()
          : Value(answerValue),
      fileUrl: fileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fileUrl),
      answeredAt: Value(answeredAt),
    );
  }

  factory SubmissionAnswersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmissionAnswersTableData(
      id: serializer.fromJson<String>(json['id']),
      submissionId: serializer.fromJson<String>(json['submissionId']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      answerValue: serializer.fromJson<String?>(json['answerValue']),
      fileUrl: serializer.fromJson<String?>(json['fileUrl']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'submissionId': serializer.toJson<String>(submissionId),
      'fieldId': serializer.toJson<String>(fieldId),
      'answerValue': serializer.toJson<String?>(answerValue),
      'fileUrl': serializer.toJson<String?>(fileUrl),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
    };
  }

  SubmissionAnswersTableData copyWith(
          {String? id,
          String? submissionId,
          String? fieldId,
          Value<String?> answerValue = const Value.absent(),
          Value<String?> fileUrl = const Value.absent(),
          DateTime? answeredAt}) =>
      SubmissionAnswersTableData(
        id: id ?? this.id,
        submissionId: submissionId ?? this.submissionId,
        fieldId: fieldId ?? this.fieldId,
        answerValue: answerValue.present ? answerValue.value : this.answerValue,
        fileUrl: fileUrl.present ? fileUrl.value : this.fileUrl,
        answeredAt: answeredAt ?? this.answeredAt,
      );
  SubmissionAnswersTableData copyWithCompanion(
      SubmissionAnswersTableCompanion data) {
    return SubmissionAnswersTableData(
      id: data.id.present ? data.id.value : this.id,
      submissionId: data.submissionId.present
          ? data.submissionId.value
          : this.submissionId,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      answerValue:
          data.answerValue.present ? data.answerValue.value : this.answerValue,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      answeredAt:
          data.answeredAt.present ? data.answeredAt.value : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionAnswersTableData(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('fieldId: $fieldId, ')
          ..write('answerValue: $answerValue, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, submissionId, fieldId, answerValue, fileUrl, answeredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmissionAnswersTableData &&
          other.id == this.id &&
          other.submissionId == this.submissionId &&
          other.fieldId == this.fieldId &&
          other.answerValue == this.answerValue &&
          other.fileUrl == this.fileUrl &&
          other.answeredAt == this.answeredAt);
}

class SubmissionAnswersTableCompanion
    extends UpdateCompanion<SubmissionAnswersTableData> {
  final Value<String> id;
  final Value<String> submissionId;
  final Value<String> fieldId;
  final Value<String?> answerValue;
  final Value<String?> fileUrl;
  final Value<DateTime> answeredAt;
  final Value<int> rowid;
  const SubmissionAnswersTableCompanion({
    this.id = const Value.absent(),
    this.submissionId = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.answerValue = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.answeredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubmissionAnswersTableCompanion.insert({
    required String id,
    required String submissionId,
    required String fieldId,
    this.answerValue = const Value.absent(),
    this.fileUrl = const Value.absent(),
    required DateTime answeredAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        submissionId = Value(submissionId),
        fieldId = Value(fieldId),
        answeredAt = Value(answeredAt);
  static Insertable<SubmissionAnswersTableData> custom({
    Expression<String>? id,
    Expression<String>? submissionId,
    Expression<String>? fieldId,
    Expression<String>? answerValue,
    Expression<String>? fileUrl,
    Expression<DateTime>? answeredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (submissionId != null) 'submission_id': submissionId,
      if (fieldId != null) 'field_id': fieldId,
      if (answerValue != null) 'answer_value': answerValue,
      if (fileUrl != null) 'file_url': fileUrl,
      if (answeredAt != null) 'answered_at': answeredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubmissionAnswersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? submissionId,
      Value<String>? fieldId,
      Value<String?>? answerValue,
      Value<String?>? fileUrl,
      Value<DateTime>? answeredAt,
      Value<int>? rowid}) {
    return SubmissionAnswersTableCompanion(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      fieldId: fieldId ?? this.fieldId,
      answerValue: answerValue ?? this.answerValue,
      fileUrl: fileUrl ?? this.fileUrl,
      answeredAt: answeredAt ?? this.answeredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (submissionId.present) {
      map['submission_id'] = Variable<String>(submissionId.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (answerValue.present) {
      map['answer_value'] = Variable<String>(answerValue.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionAnswersTableCompanion(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('fieldId: $fieldId, ')
          ..write('answerValue: $answerValue, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeamTableTable extends TeamTable
    with TableInfo<$TeamTableTable, TeamTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('employee'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, role, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_table';
  @override
  VerificationContext validateIntegrity(Insertable<TeamTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TeamTableTable createAlias(String alias) {
    return $TeamTableTable(attachedDatabase, alias);
  }
}

class TeamTableData extends DataClass implements Insertable<TeamTableData> {
  final String id;
  final String name;
  final String role;
  final DateTime createdAt;
  const TeamTableData(
      {required this.id,
      required this.name,
      required this.role,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TeamTableCompanion toCompanion(bool nullToAbsent) {
    return TeamTableCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      createdAt: Value(createdAt),
    );
  }

  factory TeamTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TeamTableData copyWith(
          {String? id, String? name, String? role, DateTime? createdAt}) =>
      TeamTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
      );
  TeamTableData copyWithCompanion(TeamTableCompanion data) {
    return TeamTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, role, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.createdAt == this.createdAt);
}

class TeamTableCompanion extends UpdateCompanion<TeamTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TeamTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeamTableCompanion.insert({
    required String id,
    required String name,
    this.role = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<TeamTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeamTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? role,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TeamTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalTypeMeta =
      const VerificationMeta('goalType');
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
      'goal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetValueMeta =
      const VerificationMeta('targetValue');
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
      'target_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _periodDateMeta =
      const VerificationMeta('periodDate');
  @override
  late final GeneratedColumn<DateTime> periodDate = GeneratedColumn<DateTime>(
      'period_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, goalType, targetValue, periodDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals_table';
  @override
  VerificationContext validateIntegrity(Insertable<GoalsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_type')) {
      context.handle(_goalTypeMeta,
          goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta));
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
          _targetValueMeta,
          targetValue.isAcceptableOrUnknown(
              data['target_value']!, _targetValueMeta));
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('period_date')) {
      context.handle(
          _periodDateMeta,
          periodDate.isAcceptableOrUnknown(
              data['period_date']!, _periodDateMeta));
    } else if (isInserting) {
      context.missing(_periodDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_type'])!,
      targetValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_value'])!,
      periodDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalsTableData extends DataClass implements Insertable<GoalsTableData> {
  final String id;
  final String goalType;
  final double targetValue;
  final DateTime periodDate;
  final DateTime createdAt;
  const GoalsTableData(
      {required this.id,
      required this.goalType,
      required this.targetValue,
      required this.periodDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_type'] = Variable<String>(goalType);
    map['target_value'] = Variable<double>(targetValue);
    map['period_date'] = Variable<DateTime>(periodDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      goalType: Value(goalType),
      targetValue: Value(targetValue),
      periodDate: Value(periodDate),
      createdAt: Value(createdAt),
    );
  }

  factory GoalsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalsTableData(
      id: serializer.fromJson<String>(json['id']),
      goalType: serializer.fromJson<String>(json['goalType']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      periodDate: serializer.fromJson<DateTime>(json['periodDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalType': serializer.toJson<String>(goalType),
      'targetValue': serializer.toJson<double>(targetValue),
      'periodDate': serializer.toJson<DateTime>(periodDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalsTableData copyWith(
          {String? id,
          String? goalType,
          double? targetValue,
          DateTime? periodDate,
          DateTime? createdAt}) =>
      GoalsTableData(
        id: id ?? this.id,
        goalType: goalType ?? this.goalType,
        targetValue: targetValue ?? this.targetValue,
        periodDate: periodDate ?? this.periodDate,
        createdAt: createdAt ?? this.createdAt,
      );
  GoalsTableData copyWithCompanion(GoalsTableCompanion data) {
    return GoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      targetValue:
          data.targetValue.present ? data.targetValue.value : this.targetValue,
      periodDate:
          data.periodDate.present ? data.periodDate.value : this.periodDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableData(')
          ..write('id: $id, ')
          ..write('goalType: $goalType, ')
          ..write('targetValue: $targetValue, ')
          ..write('periodDate: $periodDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, goalType, targetValue, periodDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalsTableData &&
          other.id == this.id &&
          other.goalType == this.goalType &&
          other.targetValue == this.targetValue &&
          other.periodDate == this.periodDate &&
          other.createdAt == this.createdAt);
}

class GoalsTableCompanion extends UpdateCompanion<GoalsTableData> {
  final Value<String> id;
  final Value<String> goalType;
  final Value<double> targetValue;
  final Value<DateTime> periodDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.goalType = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.periodDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required String goalType,
    required double targetValue,
    required DateTime periodDate,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        goalType = Value(goalType),
        targetValue = Value(targetValue),
        periodDate = Value(periodDate),
        createdAt = Value(createdAt);
  static Insertable<GoalsTableData> custom({
    Expression<String>? id,
    Expression<String>? goalType,
    Expression<double>? targetValue,
    Expression<DateTime>? periodDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalType != null) 'goal_type': goalType,
      if (targetValue != null) 'target_value': targetValue,
      if (periodDate != null) 'period_date': periodDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? goalType,
      Value<double>? targetValue,
      Value<DateTime>? periodDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      goalType: goalType ?? this.goalType,
      targetValue: targetValue ?? this.targetValue,
      periodDate: periodDate ?? this.periodDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (periodDate.present) {
      map['period_date'] = Variable<DateTime>(periodDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('goalType: $goalType, ')
          ..write('targetValue: $targetValue, ')
          ..write('periodDate: $periodDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KPIDataTableTable extends KPIDataTable
    with TableInfo<$KPIDataTableTable, KPIDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KPIDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataDateMeta =
      const VerificationMeta('dataDate');
  @override
  late final GeneratedColumn<DateTime> dataDate = GeneratedColumn<DateTime>(
      'data_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _gemScoreMeta =
      const VerificationMeta('gemScore');
  @override
  late final GeneratedColumn<double> gemScore = GeneratedColumn<double>(
      'gem_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _hoursScheduledMeta =
      const VerificationMeta('hoursScheduled');
  @override
  late final GeneratedColumn<double> hoursScheduled = GeneratedColumn<double>(
      'hours_scheduled', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _hoursRecommendedMeta =
      const VerificationMeta('hoursRecommended');
  @override
  late final GeneratedColumn<double> hoursRecommended = GeneratedColumn<double>(
      'hours_recommended', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _laborUsedPercentageMeta =
      const VerificationMeta('laborUsedPercentage');
  @override
  late final GeneratedColumn<double> laborUsedPercentage =
      GeneratedColumn<double>('labor_used_percentage', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _salesActualMeta =
      const VerificationMeta('salesActual');
  @override
  late final GeneratedColumn<double> salesActual = GeneratedColumn<double>(
      'sales_actual', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dataDate,
        gemScore,
        hoursScheduled,
        hoursRecommended,
        laborUsedPercentage,
        salesActual,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'k_p_i_data_table';
  @override
  VerificationContext validateIntegrity(Insertable<KPIDataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data_date')) {
      context.handle(_dataDateMeta,
          dataDate.isAcceptableOrUnknown(data['data_date']!, _dataDateMeta));
    } else if (isInserting) {
      context.missing(_dataDateMeta);
    }
    if (data.containsKey('gem_score')) {
      context.handle(_gemScoreMeta,
          gemScore.isAcceptableOrUnknown(data['gem_score']!, _gemScoreMeta));
    }
    if (data.containsKey('hours_scheduled')) {
      context.handle(
          _hoursScheduledMeta,
          hoursScheduled.isAcceptableOrUnknown(
              data['hours_scheduled']!, _hoursScheduledMeta));
    }
    if (data.containsKey('hours_recommended')) {
      context.handle(
          _hoursRecommendedMeta,
          hoursRecommended.isAcceptableOrUnknown(
              data['hours_recommended']!, _hoursRecommendedMeta));
    }
    if (data.containsKey('labor_used_percentage')) {
      context.handle(
          _laborUsedPercentageMeta,
          laborUsedPercentage.isAcceptableOrUnknown(
              data['labor_used_percentage']!, _laborUsedPercentageMeta));
    }
    if (data.containsKey('sales_actual')) {
      context.handle(
          _salesActualMeta,
          salesActual.isAcceptableOrUnknown(
              data['sales_actual']!, _salesActualMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KPIDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KPIDataTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      dataDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data_date'])!,
      gemScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gem_score']),
      hoursScheduled: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}hours_scheduled']),
      hoursRecommended: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}hours_recommended']),
      laborUsedPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}labor_used_percentage']),
      salesActual: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sales_actual']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $KPIDataTableTable createAlias(String alias) {
    return $KPIDataTableTable(attachedDatabase, alias);
  }
}

class KPIDataTableData extends DataClass
    implements Insertable<KPIDataTableData> {
  final String id;
  final DateTime dataDate;
  final double? gemScore;
  final double? hoursScheduled;
  final double? hoursRecommended;
  final double? laborUsedPercentage;
  final double? salesActual;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KPIDataTableData(
      {required this.id,
      required this.dataDate,
      this.gemScore,
      this.hoursScheduled,
      this.hoursRecommended,
      this.laborUsedPercentage,
      this.salesActual,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['data_date'] = Variable<DateTime>(dataDate);
    if (!nullToAbsent || gemScore != null) {
      map['gem_score'] = Variable<double>(gemScore);
    }
    if (!nullToAbsent || hoursScheduled != null) {
      map['hours_scheduled'] = Variable<double>(hoursScheduled);
    }
    if (!nullToAbsent || hoursRecommended != null) {
      map['hours_recommended'] = Variable<double>(hoursRecommended);
    }
    if (!nullToAbsent || laborUsedPercentage != null) {
      map['labor_used_percentage'] = Variable<double>(laborUsedPercentage);
    }
    if (!nullToAbsent || salesActual != null) {
      map['sales_actual'] = Variable<double>(salesActual);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KPIDataTableCompanion toCompanion(bool nullToAbsent) {
    return KPIDataTableCompanion(
      id: Value(id),
      dataDate: Value(dataDate),
      gemScore: gemScore == null && nullToAbsent
          ? const Value.absent()
          : Value(gemScore),
      hoursScheduled: hoursScheduled == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursScheduled),
      hoursRecommended: hoursRecommended == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursRecommended),
      laborUsedPercentage: laborUsedPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(laborUsedPercentage),
      salesActual: salesActual == null && nullToAbsent
          ? const Value.absent()
          : Value(salesActual),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KPIDataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KPIDataTableData(
      id: serializer.fromJson<String>(json['id']),
      dataDate: serializer.fromJson<DateTime>(json['dataDate']),
      gemScore: serializer.fromJson<double?>(json['gemScore']),
      hoursScheduled: serializer.fromJson<double?>(json['hoursScheduled']),
      hoursRecommended: serializer.fromJson<double?>(json['hoursRecommended']),
      laborUsedPercentage:
          serializer.fromJson<double?>(json['laborUsedPercentage']),
      salesActual: serializer.fromJson<double?>(json['salesActual']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dataDate': serializer.toJson<DateTime>(dataDate),
      'gemScore': serializer.toJson<double?>(gemScore),
      'hoursScheduled': serializer.toJson<double?>(hoursScheduled),
      'hoursRecommended': serializer.toJson<double?>(hoursRecommended),
      'laborUsedPercentage': serializer.toJson<double?>(laborUsedPercentage),
      'salesActual': serializer.toJson<double?>(salesActual),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KPIDataTableData copyWith(
          {String? id,
          DateTime? dataDate,
          Value<double?> gemScore = const Value.absent(),
          Value<double?> hoursScheduled = const Value.absent(),
          Value<double?> hoursRecommended = const Value.absent(),
          Value<double?> laborUsedPercentage = const Value.absent(),
          Value<double?> salesActual = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      KPIDataTableData(
        id: id ?? this.id,
        dataDate: dataDate ?? this.dataDate,
        gemScore: gemScore.present ? gemScore.value : this.gemScore,
        hoursScheduled:
            hoursScheduled.present ? hoursScheduled.value : this.hoursScheduled,
        hoursRecommended: hoursRecommended.present
            ? hoursRecommended.value
            : this.hoursRecommended,
        laborUsedPercentage: laborUsedPercentage.present
            ? laborUsedPercentage.value
            : this.laborUsedPercentage,
        salesActual: salesActual.present ? salesActual.value : this.salesActual,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  KPIDataTableData copyWithCompanion(KPIDataTableCompanion data) {
    return KPIDataTableData(
      id: data.id.present ? data.id.value : this.id,
      dataDate: data.dataDate.present ? data.dataDate.value : this.dataDate,
      gemScore: data.gemScore.present ? data.gemScore.value : this.gemScore,
      hoursScheduled: data.hoursScheduled.present
          ? data.hoursScheduled.value
          : this.hoursScheduled,
      hoursRecommended: data.hoursRecommended.present
          ? data.hoursRecommended.value
          : this.hoursRecommended,
      laborUsedPercentage: data.laborUsedPercentage.present
          ? data.laborUsedPercentage.value
          : this.laborUsedPercentage,
      salesActual:
          data.salesActual.present ? data.salesActual.value : this.salesActual,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KPIDataTableData(')
          ..write('id: $id, ')
          ..write('dataDate: $dataDate, ')
          ..write('gemScore: $gemScore, ')
          ..write('hoursScheduled: $hoursScheduled, ')
          ..write('hoursRecommended: $hoursRecommended, ')
          ..write('laborUsedPercentage: $laborUsedPercentage, ')
          ..write('salesActual: $salesActual, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dataDate, gemScore, hoursScheduled,
      hoursRecommended, laborUsedPercentage, salesActual, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KPIDataTableData &&
          other.id == this.id &&
          other.dataDate == this.dataDate &&
          other.gemScore == this.gemScore &&
          other.hoursScheduled == this.hoursScheduled &&
          other.hoursRecommended == this.hoursRecommended &&
          other.laborUsedPercentage == this.laborUsedPercentage &&
          other.salesActual == this.salesActual &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KPIDataTableCompanion extends UpdateCompanion<KPIDataTableData> {
  final Value<String> id;
  final Value<DateTime> dataDate;
  final Value<double?> gemScore;
  final Value<double?> hoursScheduled;
  final Value<double?> hoursRecommended;
  final Value<double?> laborUsedPercentage;
  final Value<double?> salesActual;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KPIDataTableCompanion({
    this.id = const Value.absent(),
    this.dataDate = const Value.absent(),
    this.gemScore = const Value.absent(),
    this.hoursScheduled = const Value.absent(),
    this.hoursRecommended = const Value.absent(),
    this.laborUsedPercentage = const Value.absent(),
    this.salesActual = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KPIDataTableCompanion.insert({
    required String id,
    required DateTime dataDate,
    this.gemScore = const Value.absent(),
    this.hoursScheduled = const Value.absent(),
    this.hoursRecommended = const Value.absent(),
    this.laborUsedPercentage = const Value.absent(),
    this.salesActual = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        dataDate = Value(dataDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<KPIDataTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? dataDate,
    Expression<double>? gemScore,
    Expression<double>? hoursScheduled,
    Expression<double>? hoursRecommended,
    Expression<double>? laborUsedPercentage,
    Expression<double>? salesActual,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataDate != null) 'data_date': dataDate,
      if (gemScore != null) 'gem_score': gemScore,
      if (hoursScheduled != null) 'hours_scheduled': hoursScheduled,
      if (hoursRecommended != null) 'hours_recommended': hoursRecommended,
      if (laborUsedPercentage != null)
        'labor_used_percentage': laborUsedPercentage,
      if (salesActual != null) 'sales_actual': salesActual,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KPIDataTableCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? dataDate,
      Value<double?>? gemScore,
      Value<double?>? hoursScheduled,
      Value<double?>? hoursRecommended,
      Value<double?>? laborUsedPercentage,
      Value<double?>? salesActual,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return KPIDataTableCompanion(
      id: id ?? this.id,
      dataDate: dataDate ?? this.dataDate,
      gemScore: gemScore ?? this.gemScore,
      hoursScheduled: hoursScheduled ?? this.hoursScheduled,
      hoursRecommended: hoursRecommended ?? this.hoursRecommended,
      laborUsedPercentage: laborUsedPercentage ?? this.laborUsedPercentage,
      salesActual: salesActual ?? this.salesActual,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dataDate.present) {
      map['data_date'] = Variable<DateTime>(dataDate.value);
    }
    if (gemScore.present) {
      map['gem_score'] = Variable<double>(gemScore.value);
    }
    if (hoursScheduled.present) {
      map['hours_scheduled'] = Variable<double>(hoursScheduled.value);
    }
    if (hoursRecommended.present) {
      map['hours_recommended'] = Variable<double>(hoursRecommended.value);
    }
    if (laborUsedPercentage.present) {
      map['labor_used_percentage'] =
          Variable<double>(laborUsedPercentage.value);
    }
    if (salesActual.present) {
      map['sales_actual'] = Variable<double>(salesActual.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KPIDataTableCompanion(')
          ..write('id: $id, ')
          ..write('dataDate: $dataDate, ')
          ..write('gemScore: $gemScore, ')
          ..write('hoursScheduled: $hoursScheduled, ')
          ..write('hoursRecommended: $hoursRecommended, ')
          ..write('laborUsedPercentage: $laborUsedPercentage, ')
          ..write('salesActual: $salesActual, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BusinessCalendarTableTable extends BusinessCalendarTable
    with TableInfo<$BusinessCalendarTableTable, BusinessCalendarTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessCalendarTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _currentWeekMeta =
      const VerificationMeta('currentWeek');
  @override
  late final GeneratedColumn<int> currentWeek = GeneratedColumn<int>(
      'current_week', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentPeriodMeta =
      const VerificationMeta('currentPeriod');
  @override
  late final GeneratedColumn<int> currentPeriod = GeneratedColumn<int>(
      'current_period', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentQuarterMeta =
      const VerificationMeta('currentQuarter');
  @override
  late final GeneratedColumn<int> currentQuarter = GeneratedColumn<int>(
      'current_quarter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, startDate, currentWeek, currentPeriod, currentQuarter, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_calendar_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<BusinessCalendarTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('current_week')) {
      context.handle(
          _currentWeekMeta,
          currentWeek.isAcceptableOrUnknown(
              data['current_week']!, _currentWeekMeta));
    } else if (isInserting) {
      context.missing(_currentWeekMeta);
    }
    if (data.containsKey('current_period')) {
      context.handle(
          _currentPeriodMeta,
          currentPeriod.isAcceptableOrUnknown(
              data['current_period']!, _currentPeriodMeta));
    } else if (isInserting) {
      context.missing(_currentPeriodMeta);
    }
    if (data.containsKey('current_quarter')) {
      context.handle(
          _currentQuarterMeta,
          currentQuarter.isAcceptableOrUnknown(
              data['current_quarter']!, _currentQuarterMeta));
    } else if (isInserting) {
      context.missing(_currentQuarterMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessCalendarTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessCalendarTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      currentWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_week'])!,
      currentPeriod: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_period'])!,
      currentQuarter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_quarter'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BusinessCalendarTableTable createAlias(String alias) {
    return $BusinessCalendarTableTable(attachedDatabase, alias);
  }
}

class BusinessCalendarTableData extends DataClass
    implements Insertable<BusinessCalendarTableData> {
  final String id;
  final DateTime startDate;
  final int currentWeek;
  final int currentPeriod;
  final int currentQuarter;
  final DateTime updatedAt;
  const BusinessCalendarTableData(
      {required this.id,
      required this.startDate,
      required this.currentWeek,
      required this.currentPeriod,
      required this.currentQuarter,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['current_week'] = Variable<int>(currentWeek);
    map['current_period'] = Variable<int>(currentPeriod);
    map['current_quarter'] = Variable<int>(currentQuarter);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BusinessCalendarTableCompanion toCompanion(bool nullToAbsent) {
    return BusinessCalendarTableCompanion(
      id: Value(id),
      startDate: Value(startDate),
      currentWeek: Value(currentWeek),
      currentPeriod: Value(currentPeriod),
      currentQuarter: Value(currentQuarter),
      updatedAt: Value(updatedAt),
    );
  }

  factory BusinessCalendarTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessCalendarTableData(
      id: serializer.fromJson<String>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      currentWeek: serializer.fromJson<int>(json['currentWeek']),
      currentPeriod: serializer.fromJson<int>(json['currentPeriod']),
      currentQuarter: serializer.fromJson<int>(json['currentQuarter']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'currentWeek': serializer.toJson<int>(currentWeek),
      'currentPeriod': serializer.toJson<int>(currentPeriod),
      'currentQuarter': serializer.toJson<int>(currentQuarter),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BusinessCalendarTableData copyWith(
          {String? id,
          DateTime? startDate,
          int? currentWeek,
          int? currentPeriod,
          int? currentQuarter,
          DateTime? updatedAt}) =>
      BusinessCalendarTableData(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        currentWeek: currentWeek ?? this.currentWeek,
        currentPeriod: currentPeriod ?? this.currentPeriod,
        currentQuarter: currentQuarter ?? this.currentQuarter,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BusinessCalendarTableData copyWithCompanion(
      BusinessCalendarTableCompanion data) {
    return BusinessCalendarTableData(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      currentWeek:
          data.currentWeek.present ? data.currentWeek.value : this.currentWeek,
      currentPeriod: data.currentPeriod.present
          ? data.currentPeriod.value
          : this.currentPeriod,
      currentQuarter: data.currentQuarter.present
          ? data.currentQuarter.value
          : this.currentQuarter,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessCalendarTableData(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentPeriod: $currentPeriod, ')
          ..write('currentQuarter: $currentQuarter, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, startDate, currentWeek, currentPeriod, currentQuarter, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessCalendarTableData &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.currentWeek == this.currentWeek &&
          other.currentPeriod == this.currentPeriod &&
          other.currentQuarter == this.currentQuarter &&
          other.updatedAt == this.updatedAt);
}

class BusinessCalendarTableCompanion
    extends UpdateCompanion<BusinessCalendarTableData> {
  final Value<String> id;
  final Value<DateTime> startDate;
  final Value<int> currentWeek;
  final Value<int> currentPeriod;
  final Value<int> currentQuarter;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BusinessCalendarTableCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.currentWeek = const Value.absent(),
    this.currentPeriod = const Value.absent(),
    this.currentQuarter = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessCalendarTableCompanion.insert({
    required String id,
    required DateTime startDate,
    required int currentWeek,
    required int currentPeriod,
    required int currentQuarter,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startDate = Value(startDate),
        currentWeek = Value(currentWeek),
        currentPeriod = Value(currentPeriod),
        currentQuarter = Value(currentQuarter),
        updatedAt = Value(updatedAt);
  static Insertable<BusinessCalendarTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? startDate,
    Expression<int>? currentWeek,
    Expression<int>? currentPeriod,
    Expression<int>? currentQuarter,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (currentWeek != null) 'current_week': currentWeek,
      if (currentPeriod != null) 'current_period': currentPeriod,
      if (currentQuarter != null) 'current_quarter': currentQuarter,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessCalendarTableCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? startDate,
      Value<int>? currentWeek,
      Value<int>? currentPeriod,
      Value<int>? currentQuarter,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BusinessCalendarTableCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      currentWeek: currentWeek ?? this.currentWeek,
      currentPeriod: currentPeriod ?? this.currentPeriod,
      currentQuarter: currentQuarter ?? this.currentQuarter,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (currentWeek.present) {
      map['current_week'] = Variable<int>(currentWeek.value);
    }
    if (currentPeriod.present) {
      map['current_period'] = Variable<int>(currentPeriod.value);
    }
    if (currentQuarter.present) {
      map['current_quarter'] = Variable<int>(currentQuarter.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessCalendarTableCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('currentWeek: $currentWeek, ')
          ..write('currentPeriod: $currentPeriod, ')
          ..write('currentQuarter: $currentQuarter, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncMetadataTableTable syncMetadataTable =
      $SyncMetadataTableTable(this);
  late final $PendingChangesTableTable pendingChangesTable =
      $PendingChangesTableTable(this);
  late final $FormsTableTable formsTable = $FormsTableTable(this);
  late final $FormSectionsTableTable formSectionsTable =
      $FormSectionsTableTable(this);
  late final $FieldsTableTable fieldsTable = $FieldsTableTable(this);
  late final $DropdownOptionsTableTable dropdownOptionsTable =
      $DropdownOptionsTableTable(this);
  late final $SubmissionsTableTable submissionsTable =
      $SubmissionsTableTable(this);
  late final $SubmissionAnswersTableTable submissionAnswersTable =
      $SubmissionAnswersTableTable(this);
  late final $TeamTableTable teamTable = $TeamTableTable(this);
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $KPIDataTableTable kPIDataTable = $KPIDataTableTable(this);
  late final $BusinessCalendarTableTable businessCalendarTable =
      $BusinessCalendarTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        syncMetadataTable,
        pendingChangesTable,
        formsTable,
        formSectionsTable,
        fieldsTable,
        dropdownOptionsTable,
        submissionsTable,
        submissionAnswersTable,
        teamTable,
        goalsTable,
        kPIDataTable,
        businessCalendarTable
      ];
}

typedef $$SyncMetadataTableTableCreateCompanionBuilder
    = SyncMetadataTableCompanion Function({
  Value<int> id,
  required String table,
  required DateTime lastSyncAt,
  Value<int> lastSyncVersion,
});
typedef $$SyncMetadataTableTableUpdateCompanionBuilder
    = SyncMetadataTableCompanion Function({
  Value<int> id,
  Value<String> table,
  Value<DateTime> lastSyncAt,
  Value<int> lastSyncVersion,
});

class $$SyncMetadataTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get table => $composableBuilder(
      column: $table.table, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSyncVersion => $composableBuilder(
      column: $table.lastSyncVersion,
      builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get table => $composableBuilder(
      column: $table.table, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSyncVersion => $composableBuilder(
      column: $table.lastSyncVersion,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get table =>
      $composableBuilder(column: $table.table, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);

  GeneratedColumn<int> get lastSyncVersion => $composableBuilder(
      column: $table.lastSyncVersion, builder: (column) => column);
}

class $$SyncMetadataTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataTableTable,
    SyncMetadataTableData,
    $$SyncMetadataTableTableFilterComposer,
    $$SyncMetadataTableTableOrderingComposer,
    $$SyncMetadataTableTableAnnotationComposer,
    $$SyncMetadataTableTableCreateCompanionBuilder,
    $$SyncMetadataTableTableUpdateCompanionBuilder,
    (
      SyncMetadataTableData,
      BaseReferences<_$AppDatabase, $SyncMetadataTableTable,
          SyncMetadataTableData>
    ),
    SyncMetadataTableData,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableTableManager(
      _$AppDatabase db, $SyncMetadataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> table = const Value.absent(),
            Value<DateTime> lastSyncAt = const Value.absent(),
            Value<int> lastSyncVersion = const Value.absent(),
          }) =>
              SyncMetadataTableCompanion(
            id: id,
            table: table,
            lastSyncAt: lastSyncAt,
            lastSyncVersion: lastSyncVersion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String table,
            required DateTime lastSyncAt,
            Value<int> lastSyncVersion = const Value.absent(),
          }) =>
              SyncMetadataTableCompanion.insert(
            id: id,
            table: table,
            lastSyncAt: lastSyncAt,
            lastSyncVersion: lastSyncVersion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataTableTable,
    SyncMetadataTableData,
    $$SyncMetadataTableTableFilterComposer,
    $$SyncMetadataTableTableOrderingComposer,
    $$SyncMetadataTableTableAnnotationComposer,
    $$SyncMetadataTableTableCreateCompanionBuilder,
    $$SyncMetadataTableTableUpdateCompanionBuilder,
    (
      SyncMetadataTableData,
      BaseReferences<_$AppDatabase, $SyncMetadataTableTable,
          SyncMetadataTableData>
    ),
    SyncMetadataTableData,
    PrefetchHooks Function()>;
typedef $$PendingChangesTableTableCreateCompanionBuilder
    = PendingChangesTableCompanion Function({
  Value<int> id,
  required String table,
  required String recordId,
  required String operation,
  required String data,
  required DateTime createdAt,
  Value<bool> synced,
});
typedef $$PendingChangesTableTableUpdateCompanionBuilder
    = PendingChangesTableCompanion Function({
  Value<int> id,
  Value<String> table,
  Value<String> recordId,
  Value<String> operation,
  Value<String> data,
  Value<DateTime> createdAt,
  Value<bool> synced,
});

class $$PendingChangesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingChangesTableTable> {
  $$PendingChangesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get table => $composableBuilder(
      column: $table.table, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$PendingChangesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingChangesTableTable> {
  $$PendingChangesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get table => $composableBuilder(
      column: $table.table, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$PendingChangesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingChangesTableTable> {
  $$PendingChangesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get table =>
      $composableBuilder(column: $table.table, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$PendingChangesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingChangesTableTable,
    PendingChangesTableData,
    $$PendingChangesTableTableFilterComposer,
    $$PendingChangesTableTableOrderingComposer,
    $$PendingChangesTableTableAnnotationComposer,
    $$PendingChangesTableTableCreateCompanionBuilder,
    $$PendingChangesTableTableUpdateCompanionBuilder,
    (
      PendingChangesTableData,
      BaseReferences<_$AppDatabase, $PendingChangesTableTable,
          PendingChangesTableData>
    ),
    PendingChangesTableData,
    PrefetchHooks Function()> {
  $$PendingChangesTableTableTableManager(
      _$AppDatabase db, $PendingChangesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingChangesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingChangesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingChangesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> table = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
          }) =>
              PendingChangesTableCompanion(
            id: id,
            table: table,
            recordId: recordId,
            operation: operation,
            data: data,
            createdAt: createdAt,
            synced: synced,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String table,
            required String recordId,
            required String operation,
            required String data,
            required DateTime createdAt,
            Value<bool> synced = const Value.absent(),
          }) =>
              PendingChangesTableCompanion.insert(
            id: id,
            table: table,
            recordId: recordId,
            operation: operation,
            data: data,
            createdAt: createdAt,
            synced: synced,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingChangesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PendingChangesTableTable,
    PendingChangesTableData,
    $$PendingChangesTableTableFilterComposer,
    $$PendingChangesTableTableOrderingComposer,
    $$PendingChangesTableTableAnnotationComposer,
    $$PendingChangesTableTableCreateCompanionBuilder,
    $$PendingChangesTableTableUpdateCompanionBuilder,
    (
      PendingChangesTableData,
      BaseReferences<_$AppDatabase, $PendingChangesTableTable,
          PendingChangesTableData>
    ),
    PendingChangesTableData,
    PrefetchHooks Function()>;
typedef $$FormsTableTableCreateCompanionBuilder = FormsTableCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  Value<String> tags,
  Value<bool> isTemplate,
  Value<String> scheduleType,
  Value<DateTime?> customStartDate,
  Value<DateTime?> customEndDate,
  Value<String?> customTime,
  Value<int?> maxSubmissions,
  Value<String> status,
  required String createdBy,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FormsTableTableUpdateCompanionBuilder = FormsTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String> tags,
  Value<bool> isTemplate,
  Value<String> scheduleType,
  Value<DateTime?> customStartDate,
  Value<DateTime?> customEndDate,
  Value<String?> customTime,
  Value<int?> maxSubmissions,
  Value<String> status,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FormsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FormsTableTable> {
  $$FormsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTemplate => $composableBuilder(
      column: $table.isTemplate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get customStartDate => $composableBuilder(
      column: $table.customStartDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get customEndDate => $composableBuilder(
      column: $table.customEndDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customTime => $composableBuilder(
      column: $table.customTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxSubmissions => $composableBuilder(
      column: $table.maxSubmissions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FormsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FormsTableTable> {
  $$FormsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTemplate => $composableBuilder(
      column: $table.isTemplate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get customStartDate => $composableBuilder(
      column: $table.customStartDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get customEndDate => $composableBuilder(
      column: $table.customEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customTime => $composableBuilder(
      column: $table.customTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxSubmissions => $composableBuilder(
      column: $table.maxSubmissions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FormsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormsTableTable> {
  $$FormsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get isTemplate => $composableBuilder(
      column: $table.isTemplate, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<DateTime> get customStartDate => $composableBuilder(
      column: $table.customStartDate, builder: (column) => column);

  GeneratedColumn<DateTime> get customEndDate => $composableBuilder(
      column: $table.customEndDate, builder: (column) => column);

  GeneratedColumn<String> get customTime => $composableBuilder(
      column: $table.customTime, builder: (column) => column);

  GeneratedColumn<int> get maxSubmissions => $composableBuilder(
      column: $table.maxSubmissions, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FormsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FormsTableTable,
    FormsTableData,
    $$FormsTableTableFilterComposer,
    $$FormsTableTableOrderingComposer,
    $$FormsTableTableAnnotationComposer,
    $$FormsTableTableCreateCompanionBuilder,
    $$FormsTableTableUpdateCompanionBuilder,
    (
      FormsTableData,
      BaseReferences<_$AppDatabase, $FormsTableTable, FormsTableData>
    ),
    FormsTableData,
    PrefetchHooks Function()> {
  $$FormsTableTableTableManager(_$AppDatabase db, $FormsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<bool> isTemplate = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<DateTime?> customStartDate = const Value.absent(),
            Value<DateTime?> customEndDate = const Value.absent(),
            Value<String?> customTime = const Value.absent(),
            Value<int?> maxSubmissions = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FormsTableCompanion(
            id: id,
            title: title,
            description: description,
            tags: tags,
            isTemplate: isTemplate,
            scheduleType: scheduleType,
            customStartDate: customStartDate,
            customEndDate: customEndDate,
            customTime: customTime,
            maxSubmissions: maxSubmissions,
            status: status,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<bool> isTemplate = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<DateTime?> customStartDate = const Value.absent(),
            Value<DateTime?> customEndDate = const Value.absent(),
            Value<String?> customTime = const Value.absent(),
            Value<int?> maxSubmissions = const Value.absent(),
            Value<String> status = const Value.absent(),
            required String createdBy,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FormsTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            tags: tags,
            isTemplate: isTemplate,
            scheduleType: scheduleType,
            customStartDate: customStartDate,
            customEndDate: customEndDate,
            customTime: customTime,
            maxSubmissions: maxSubmissions,
            status: status,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FormsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FormsTableTable,
    FormsTableData,
    $$FormsTableTableFilterComposer,
    $$FormsTableTableOrderingComposer,
    $$FormsTableTableAnnotationComposer,
    $$FormsTableTableCreateCompanionBuilder,
    $$FormsTableTableUpdateCompanionBuilder,
    (
      FormsTableData,
      BaseReferences<_$AppDatabase, $FormsTableTable, FormsTableData>
    ),
    FormsTableData,
    PrefetchHooks Function()>;
typedef $$FormSectionsTableTableCreateCompanionBuilder
    = FormSectionsTableCompanion Function({
  required String id,
  required String formId,
  required String title,
  Value<String?> description,
  required int order,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FormSectionsTableTableUpdateCompanionBuilder
    = FormSectionsTableCompanion Function({
  Value<String> id,
  Value<String> formId,
  Value<String> title,
  Value<String?> description,
  Value<int> order,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FormSectionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FormSectionsTableTable> {
  $$FormSectionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get formId => $composableBuilder(
      column: $table.formId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FormSectionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FormSectionsTableTable> {
  $$FormSectionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get formId => $composableBuilder(
      column: $table.formId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FormSectionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormSectionsTableTable> {
  $$FormSectionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FormSectionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FormSectionsTableTable,
    FormSectionsTableData,
    $$FormSectionsTableTableFilterComposer,
    $$FormSectionsTableTableOrderingComposer,
    $$FormSectionsTableTableAnnotationComposer,
    $$FormSectionsTableTableCreateCompanionBuilder,
    $$FormSectionsTableTableUpdateCompanionBuilder,
    (
      FormSectionsTableData,
      BaseReferences<_$AppDatabase, $FormSectionsTableTable,
          FormSectionsTableData>
    ),
    FormSectionsTableData,
    PrefetchHooks Function()> {
  $$FormSectionsTableTableTableManager(
      _$AppDatabase db, $FormSectionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormSectionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormSectionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormSectionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> formId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FormSectionsTableCompanion(
            id: id,
            formId: formId,
            title: title,
            description: description,
            order: order,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String formId,
            required String title,
            Value<String?> description = const Value.absent(),
            required int order,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FormSectionsTableCompanion.insert(
            id: id,
            formId: formId,
            title: title,
            description: description,
            order: order,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FormSectionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FormSectionsTableTable,
    FormSectionsTableData,
    $$FormSectionsTableTableFilterComposer,
    $$FormSectionsTableTableOrderingComposer,
    $$FormSectionsTableTableAnnotationComposer,
    $$FormSectionsTableTableCreateCompanionBuilder,
    $$FormSectionsTableTableUpdateCompanionBuilder,
    (
      FormSectionsTableData,
      BaseReferences<_$AppDatabase, $FormSectionsTableTable,
          FormSectionsTableData>
    ),
    FormSectionsTableData,
    PrefetchHooks Function()>;
typedef $$FieldsTableTableCreateCompanionBuilder = FieldsTableCompanion
    Function({
  required String id,
  Value<String?> formId,
  Value<String?> sectionId,
  required String fieldType,
  required String label,
  Value<String?> placeholder,
  Value<String?> helpText,
  Value<bool> isRequired,
  required int order,
  Value<String?> validationRules,
  Value<String?> defaultValue,
  Value<String?> conditionalLogic,
  Value<String?> templateId,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FieldsTableTableUpdateCompanionBuilder = FieldsTableCompanion
    Function({
  Value<String> id,
  Value<String?> formId,
  Value<String?> sectionId,
  Value<String> fieldType,
  Value<String> label,
  Value<String?> placeholder,
  Value<String?> helpText,
  Value<bool> isRequired,
  Value<int> order,
  Value<String?> validationRules,
  Value<String?> defaultValue,
  Value<String?> conditionalLogic,
  Value<String?> templateId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FieldsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FieldsTableTable> {
  $$FieldsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get formId => $composableBuilder(
      column: $table.formId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fieldType => $composableBuilder(
      column: $table.fieldType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeholder => $composableBuilder(
      column: $table.placeholder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get helpText => $composableBuilder(
      column: $table.helpText, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRequired => $composableBuilder(
      column: $table.isRequired, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get validationRules => $composableBuilder(
      column: $table.validationRules,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditionalLogic => $composableBuilder(
      column: $table.conditionalLogic,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FieldsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FieldsTableTable> {
  $$FieldsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get formId => $composableBuilder(
      column: $table.formId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fieldType => $composableBuilder(
      column: $table.fieldType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeholder => $composableBuilder(
      column: $table.placeholder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get helpText => $composableBuilder(
      column: $table.helpText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRequired => $composableBuilder(
      column: $table.isRequired, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get validationRules => $composableBuilder(
      column: $table.validationRules,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditionalLogic => $composableBuilder(
      column: $table.conditionalLogic,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FieldsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FieldsTableTable> {
  $$FieldsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get fieldType =>
      $composableBuilder(column: $table.fieldType, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get placeholder => $composableBuilder(
      column: $table.placeholder, builder: (column) => column);

  GeneratedColumn<String> get helpText =>
      $composableBuilder(column: $table.helpText, builder: (column) => column);

  GeneratedColumn<bool> get isRequired => $composableBuilder(
      column: $table.isRequired, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get validationRules => $composableBuilder(
      column: $table.validationRules, builder: (column) => column);

  GeneratedColumn<String> get defaultValue => $composableBuilder(
      column: $table.defaultValue, builder: (column) => column);

  GeneratedColumn<String> get conditionalLogic => $composableBuilder(
      column: $table.conditionalLogic, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FieldsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FieldsTableTable,
    FieldsTableData,
    $$FieldsTableTableFilterComposer,
    $$FieldsTableTableOrderingComposer,
    $$FieldsTableTableAnnotationComposer,
    $$FieldsTableTableCreateCompanionBuilder,
    $$FieldsTableTableUpdateCompanionBuilder,
    (
      FieldsTableData,
      BaseReferences<_$AppDatabase, $FieldsTableTable, FieldsTableData>
    ),
    FieldsTableData,
    PrefetchHooks Function()> {
  $$FieldsTableTableTableManager(_$AppDatabase db, $FieldsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FieldsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FieldsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FieldsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> formId = const Value.absent(),
            Value<String?> sectionId = const Value.absent(),
            Value<String> fieldType = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String?> placeholder = const Value.absent(),
            Value<String?> helpText = const Value.absent(),
            Value<bool> isRequired = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String?> validationRules = const Value.absent(),
            Value<String?> defaultValue = const Value.absent(),
            Value<String?> conditionalLogic = const Value.absent(),
            Value<String?> templateId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FieldsTableCompanion(
            id: id,
            formId: formId,
            sectionId: sectionId,
            fieldType: fieldType,
            label: label,
            placeholder: placeholder,
            helpText: helpText,
            isRequired: isRequired,
            order: order,
            validationRules: validationRules,
            defaultValue: defaultValue,
            conditionalLogic: conditionalLogic,
            templateId: templateId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> formId = const Value.absent(),
            Value<String?> sectionId = const Value.absent(),
            required String fieldType,
            required String label,
            Value<String?> placeholder = const Value.absent(),
            Value<String?> helpText = const Value.absent(),
            Value<bool> isRequired = const Value.absent(),
            required int order,
            Value<String?> validationRules = const Value.absent(),
            Value<String?> defaultValue = const Value.absent(),
            Value<String?> conditionalLogic = const Value.absent(),
            Value<String?> templateId = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FieldsTableCompanion.insert(
            id: id,
            formId: formId,
            sectionId: sectionId,
            fieldType: fieldType,
            label: label,
            placeholder: placeholder,
            helpText: helpText,
            isRequired: isRequired,
            order: order,
            validationRules: validationRules,
            defaultValue: defaultValue,
            conditionalLogic: conditionalLogic,
            templateId: templateId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FieldsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FieldsTableTable,
    FieldsTableData,
    $$FieldsTableTableFilterComposer,
    $$FieldsTableTableOrderingComposer,
    $$FieldsTableTableAnnotationComposer,
    $$FieldsTableTableCreateCompanionBuilder,
    $$FieldsTableTableUpdateCompanionBuilder,
    (
      FieldsTableData,
      BaseReferences<_$AppDatabase, $FieldsTableTable, FieldsTableData>
    ),
    FieldsTableData,
    PrefetchHooks Function()>;
typedef $$DropdownOptionsTableTableCreateCompanionBuilder
    = DropdownOptionsTableCompanion Function({
  required String id,
  required String fieldId,
  required String label,
  required String value,
  required int order,
  Value<int> rowid,
});
typedef $$DropdownOptionsTableTableUpdateCompanionBuilder
    = DropdownOptionsTableCompanion Function({
  Value<String> id,
  Value<String> fieldId,
  Value<String> label,
  Value<String> value,
  Value<int> order,
  Value<int> rowid,
});

class $$DropdownOptionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DropdownOptionsTableTable> {
  $$DropdownOptionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fieldId => $composableBuilder(
      column: $table.fieldId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));
}

class $$DropdownOptionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DropdownOptionsTableTable> {
  $$DropdownOptionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fieldId => $composableBuilder(
      column: $table.fieldId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));
}

class $$DropdownOptionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DropdownOptionsTableTable> {
  $$DropdownOptionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$DropdownOptionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DropdownOptionsTableTable,
    DropdownOptionsTableData,
    $$DropdownOptionsTableTableFilterComposer,
    $$DropdownOptionsTableTableOrderingComposer,
    $$DropdownOptionsTableTableAnnotationComposer,
    $$DropdownOptionsTableTableCreateCompanionBuilder,
    $$DropdownOptionsTableTableUpdateCompanionBuilder,
    (
      DropdownOptionsTableData,
      BaseReferences<_$AppDatabase, $DropdownOptionsTableTable,
          DropdownOptionsTableData>
    ),
    DropdownOptionsTableData,
    PrefetchHooks Function()> {
  $$DropdownOptionsTableTableTableManager(
      _$AppDatabase db, $DropdownOptionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DropdownOptionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DropdownOptionsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DropdownOptionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fieldId = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DropdownOptionsTableCompanion(
            id: id,
            fieldId: fieldId,
            label: label,
            value: value,
            order: order,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fieldId,
            required String label,
            required String value,
            required int order,
            Value<int> rowid = const Value.absent(),
          }) =>
              DropdownOptionsTableCompanion.insert(
            id: id,
            fieldId: fieldId,
            label: label,
            value: value,
            order: order,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DropdownOptionsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DropdownOptionsTableTable,
        DropdownOptionsTableData,
        $$DropdownOptionsTableTableFilterComposer,
        $$DropdownOptionsTableTableOrderingComposer,
        $$DropdownOptionsTableTableAnnotationComposer,
        $$DropdownOptionsTableTableCreateCompanionBuilder,
        $$DropdownOptionsTableTableUpdateCompanionBuilder,
        (
          DropdownOptionsTableData,
          BaseReferences<_$AppDatabase, $DropdownOptionsTableTable,
              DropdownOptionsTableData>
        ),
        DropdownOptionsTableData,
        PrefetchHooks Function()>;
typedef $$SubmissionsTableTableCreateCompanionBuilder
    = SubmissionsTableCompanion Function({
  required String id,
  required String formId,
  required String submittedBy,
  required DateTime submissionDate,
  required DateTime submissionTime,
  Value<String> status,
  Value<double> completionPercentage,
  Value<bool> isAutoSubmitted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SubmissionsTableTableUpdateCompanionBuilder
    = SubmissionsTableCompanion Function({
  Value<String> id,
  Value<String> formId,
  Value<String> submittedBy,
  Value<DateTime> submissionDate,
  Value<DateTime> submissionTime,
  Value<String> status,
  Value<double> completionPercentage,
  Value<bool> isAutoSubmitted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SubmissionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionsTableTable> {
  $$SubmissionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get formId => $composableBuilder(
      column: $table.formId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get submittedBy => $composableBuilder(
      column: $table.submittedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get submissionDate => $composableBuilder(
      column: $table.submissionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get submissionTime => $composableBuilder(
      column: $table.submissionTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAutoSubmitted => $composableBuilder(
      column: $table.isAutoSubmitted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SubmissionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionsTableTable> {
  $$SubmissionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get formId => $composableBuilder(
      column: $table.formId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get submittedBy => $composableBuilder(
      column: $table.submittedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get submissionDate => $composableBuilder(
      column: $table.submissionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get submissionTime => $composableBuilder(
      column: $table.submissionTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAutoSubmitted => $composableBuilder(
      column: $table.isAutoSubmitted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SubmissionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionsTableTable> {
  $$SubmissionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<String> get submittedBy => $composableBuilder(
      column: $table.submittedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get submissionDate => $composableBuilder(
      column: $table.submissionDate, builder: (column) => column);

  GeneratedColumn<DateTime> get submissionTime => $composableBuilder(
      column: $table.submissionTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage, builder: (column) => column);

  GeneratedColumn<bool> get isAutoSubmitted => $composableBuilder(
      column: $table.isAutoSubmitted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubmissionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubmissionsTableTable,
    SubmissionsTableData,
    $$SubmissionsTableTableFilterComposer,
    $$SubmissionsTableTableOrderingComposer,
    $$SubmissionsTableTableAnnotationComposer,
    $$SubmissionsTableTableCreateCompanionBuilder,
    $$SubmissionsTableTableUpdateCompanionBuilder,
    (
      SubmissionsTableData,
      BaseReferences<_$AppDatabase, $SubmissionsTableTable,
          SubmissionsTableData>
    ),
    SubmissionsTableData,
    PrefetchHooks Function()> {
  $$SubmissionsTableTableTableManager(
      _$AppDatabase db, $SubmissionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubmissionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubmissionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubmissionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> formId = const Value.absent(),
            Value<String> submittedBy = const Value.absent(),
            Value<DateTime> submissionDate = const Value.absent(),
            Value<DateTime> submissionTime = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> completionPercentage = const Value.absent(),
            Value<bool> isAutoSubmitted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubmissionsTableCompanion(
            id: id,
            formId: formId,
            submittedBy: submittedBy,
            submissionDate: submissionDate,
            submissionTime: submissionTime,
            status: status,
            completionPercentage: completionPercentage,
            isAutoSubmitted: isAutoSubmitted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String formId,
            required String submittedBy,
            required DateTime submissionDate,
            required DateTime submissionTime,
            Value<String> status = const Value.absent(),
            Value<double> completionPercentage = const Value.absent(),
            Value<bool> isAutoSubmitted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubmissionsTableCompanion.insert(
            id: id,
            formId: formId,
            submittedBy: submittedBy,
            submissionDate: submissionDate,
            submissionTime: submissionTime,
            status: status,
            completionPercentage: completionPercentage,
            isAutoSubmitted: isAutoSubmitted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubmissionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubmissionsTableTable,
    SubmissionsTableData,
    $$SubmissionsTableTableFilterComposer,
    $$SubmissionsTableTableOrderingComposer,
    $$SubmissionsTableTableAnnotationComposer,
    $$SubmissionsTableTableCreateCompanionBuilder,
    $$SubmissionsTableTableUpdateCompanionBuilder,
    (
      SubmissionsTableData,
      BaseReferences<_$AppDatabase, $SubmissionsTableTable,
          SubmissionsTableData>
    ),
    SubmissionsTableData,
    PrefetchHooks Function()>;
typedef $$SubmissionAnswersTableTableCreateCompanionBuilder
    = SubmissionAnswersTableCompanion Function({
  required String id,
  required String submissionId,
  required String fieldId,
  Value<String?> answerValue,
  Value<String?> fileUrl,
  required DateTime answeredAt,
  Value<int> rowid,
});
typedef $$SubmissionAnswersTableTableUpdateCompanionBuilder
    = SubmissionAnswersTableCompanion Function({
  Value<String> id,
  Value<String> submissionId,
  Value<String> fieldId,
  Value<String?> answerValue,
  Value<String?> fileUrl,
  Value<DateTime> answeredAt,
  Value<int> rowid,
});

class $$SubmissionAnswersTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionAnswersTableTable> {
  $$SubmissionAnswersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get submissionId => $composableBuilder(
      column: $table.submissionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fieldId => $composableBuilder(
      column: $table.fieldId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answerValue => $composableBuilder(
      column: $table.answerValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnFilters(column));
}

class $$SubmissionAnswersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionAnswersTableTable> {
  $$SubmissionAnswersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get submissionId => $composableBuilder(
      column: $table.submissionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fieldId => $composableBuilder(
      column: $table.fieldId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answerValue => $composableBuilder(
      column: $table.answerValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => ColumnOrderings(column));
}

class $$SubmissionAnswersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionAnswersTableTable> {
  $$SubmissionAnswersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get submissionId => $composableBuilder(
      column: $table.submissionId, builder: (column) => column);

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get answerValue => $composableBuilder(
      column: $table.answerValue, builder: (column) => column);

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
      column: $table.answeredAt, builder: (column) => column);
}

class $$SubmissionAnswersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubmissionAnswersTableTable,
    SubmissionAnswersTableData,
    $$SubmissionAnswersTableTableFilterComposer,
    $$SubmissionAnswersTableTableOrderingComposer,
    $$SubmissionAnswersTableTableAnnotationComposer,
    $$SubmissionAnswersTableTableCreateCompanionBuilder,
    $$SubmissionAnswersTableTableUpdateCompanionBuilder,
    (
      SubmissionAnswersTableData,
      BaseReferences<_$AppDatabase, $SubmissionAnswersTableTable,
          SubmissionAnswersTableData>
    ),
    SubmissionAnswersTableData,
    PrefetchHooks Function()> {
  $$SubmissionAnswersTableTableTableManager(
      _$AppDatabase db, $SubmissionAnswersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubmissionAnswersTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SubmissionAnswersTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubmissionAnswersTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> submissionId = const Value.absent(),
            Value<String> fieldId = const Value.absent(),
            Value<String?> answerValue = const Value.absent(),
            Value<String?> fileUrl = const Value.absent(),
            Value<DateTime> answeredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubmissionAnswersTableCompanion(
            id: id,
            submissionId: submissionId,
            fieldId: fieldId,
            answerValue: answerValue,
            fileUrl: fileUrl,
            answeredAt: answeredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String submissionId,
            required String fieldId,
            Value<String?> answerValue = const Value.absent(),
            Value<String?> fileUrl = const Value.absent(),
            required DateTime answeredAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubmissionAnswersTableCompanion.insert(
            id: id,
            submissionId: submissionId,
            fieldId: fieldId,
            answerValue: answerValue,
            fileUrl: fileUrl,
            answeredAt: answeredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubmissionAnswersTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SubmissionAnswersTableTable,
        SubmissionAnswersTableData,
        $$SubmissionAnswersTableTableFilterComposer,
        $$SubmissionAnswersTableTableOrderingComposer,
        $$SubmissionAnswersTableTableAnnotationComposer,
        $$SubmissionAnswersTableTableCreateCompanionBuilder,
        $$SubmissionAnswersTableTableUpdateCompanionBuilder,
        (
          SubmissionAnswersTableData,
          BaseReferences<_$AppDatabase, $SubmissionAnswersTableTable,
              SubmissionAnswersTableData>
        ),
        SubmissionAnswersTableData,
        PrefetchHooks Function()>;
typedef $$TeamTableTableCreateCompanionBuilder = TeamTableCompanion Function({
  required String id,
  required String name,
  Value<String> role,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$TeamTableTableUpdateCompanionBuilder = TeamTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> role,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$TeamTableTableFilterComposer
    extends Composer<_$AppDatabase, $TeamTableTable> {
  $$TeamTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TeamTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamTableTable> {
  $$TeamTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TeamTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamTableTable> {
  $$TeamTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TeamTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TeamTableTable,
    TeamTableData,
    $$TeamTableTableFilterComposer,
    $$TeamTableTableOrderingComposer,
    $$TeamTableTableAnnotationComposer,
    $$TeamTableTableCreateCompanionBuilder,
    $$TeamTableTableUpdateCompanionBuilder,
    (
      TeamTableData,
      BaseReferences<_$AppDatabase, $TeamTableTable, TeamTableData>
    ),
    TeamTableData,
    PrefetchHooks Function()> {
  $$TeamTableTableTableManager(_$AppDatabase db, $TeamTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TeamTableCompanion(
            id: id,
            name: name,
            role: role,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> role = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TeamTableCompanion.insert(
            id: id,
            name: name,
            role: role,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TeamTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TeamTableTable,
    TeamTableData,
    $$TeamTableTableFilterComposer,
    $$TeamTableTableOrderingComposer,
    $$TeamTableTableAnnotationComposer,
    $$TeamTableTableCreateCompanionBuilder,
    $$TeamTableTableUpdateCompanionBuilder,
    (
      TeamTableData,
      BaseReferences<_$AppDatabase, $TeamTableTable, TeamTableData>
    ),
    TeamTableData,
    PrefetchHooks Function()>;
typedef $$GoalsTableTableCreateCompanionBuilder = GoalsTableCompanion Function({
  required String id,
  required String goalType,
  required double targetValue,
  required DateTime periodDate,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$GoalsTableTableUpdateCompanionBuilder = GoalsTableCompanion Function({
  Value<String> id,
  Value<String> goalType,
  Value<double> targetValue,
  Value<DateTime> periodDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$GoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalType => $composableBuilder(
      column: $table.goalType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodDate => $composableBuilder(
      column: $table.periodDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$GoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalType => $composableBuilder(
      column: $table.goalType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodDate => $composableBuilder(
      column: $table.periodDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => column);

  GeneratedColumn<DateTime> get periodDate => $composableBuilder(
      column: $table.periodDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GoalsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTableTable,
    GoalsTableData,
    $$GoalsTableTableFilterComposer,
    $$GoalsTableTableOrderingComposer,
    $$GoalsTableTableAnnotationComposer,
    $$GoalsTableTableCreateCompanionBuilder,
    $$GoalsTableTableUpdateCompanionBuilder,
    (
      GoalsTableData,
      BaseReferences<_$AppDatabase, $GoalsTableTable, GoalsTableData>
    ),
    GoalsTableData,
    PrefetchHooks Function()> {
  $$GoalsTableTableTableManager(_$AppDatabase db, $GoalsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> goalType = const Value.absent(),
            Value<double> targetValue = const Value.absent(),
            Value<DateTime> periodDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsTableCompanion(
            id: id,
            goalType: goalType,
            targetValue: targetValue,
            periodDate: periodDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String goalType,
            required double targetValue,
            required DateTime periodDate,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsTableCompanion.insert(
            id: id,
            goalType: goalType,
            targetValue: targetValue,
            periodDate: periodDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTableTable,
    GoalsTableData,
    $$GoalsTableTableFilterComposer,
    $$GoalsTableTableOrderingComposer,
    $$GoalsTableTableAnnotationComposer,
    $$GoalsTableTableCreateCompanionBuilder,
    $$GoalsTableTableUpdateCompanionBuilder,
    (
      GoalsTableData,
      BaseReferences<_$AppDatabase, $GoalsTableTable, GoalsTableData>
    ),
    GoalsTableData,
    PrefetchHooks Function()>;
typedef $$KPIDataTableTableCreateCompanionBuilder = KPIDataTableCompanion
    Function({
  required String id,
  required DateTime dataDate,
  Value<double?> gemScore,
  Value<double?> hoursScheduled,
  Value<double?> hoursRecommended,
  Value<double?> laborUsedPercentage,
  Value<double?> salesActual,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$KPIDataTableTableUpdateCompanionBuilder = KPIDataTableCompanion
    Function({
  Value<String> id,
  Value<DateTime> dataDate,
  Value<double?> gemScore,
  Value<double?> hoursScheduled,
  Value<double?> hoursRecommended,
  Value<double?> laborUsedPercentage,
  Value<double?> salesActual,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$KPIDataTableTableFilterComposer
    extends Composer<_$AppDatabase, $KPIDataTableTable> {
  $$KPIDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataDate => $composableBuilder(
      column: $table.dataDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gemScore => $composableBuilder(
      column: $table.gemScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hoursScheduled => $composableBuilder(
      column: $table.hoursScheduled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hoursRecommended => $composableBuilder(
      column: $table.hoursRecommended,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get laborUsedPercentage => $composableBuilder(
      column: $table.laborUsedPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salesActual => $composableBuilder(
      column: $table.salesActual, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$KPIDataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KPIDataTableTable> {
  $$KPIDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataDate => $composableBuilder(
      column: $table.dataDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gemScore => $composableBuilder(
      column: $table.gemScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hoursScheduled => $composableBuilder(
      column: $table.hoursScheduled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hoursRecommended => $composableBuilder(
      column: $table.hoursRecommended,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get laborUsedPercentage => $composableBuilder(
      column: $table.laborUsedPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salesActual => $composableBuilder(
      column: $table.salesActual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$KPIDataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KPIDataTableTable> {
  $$KPIDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataDate =>
      $composableBuilder(column: $table.dataDate, builder: (column) => column);

  GeneratedColumn<double> get gemScore =>
      $composableBuilder(column: $table.gemScore, builder: (column) => column);

  GeneratedColumn<double> get hoursScheduled => $composableBuilder(
      column: $table.hoursScheduled, builder: (column) => column);

  GeneratedColumn<double> get hoursRecommended => $composableBuilder(
      column: $table.hoursRecommended, builder: (column) => column);

  GeneratedColumn<double> get laborUsedPercentage => $composableBuilder(
      column: $table.laborUsedPercentage, builder: (column) => column);

  GeneratedColumn<double> get salesActual => $composableBuilder(
      column: $table.salesActual, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KPIDataTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KPIDataTableTable,
    KPIDataTableData,
    $$KPIDataTableTableFilterComposer,
    $$KPIDataTableTableOrderingComposer,
    $$KPIDataTableTableAnnotationComposer,
    $$KPIDataTableTableCreateCompanionBuilder,
    $$KPIDataTableTableUpdateCompanionBuilder,
    (
      KPIDataTableData,
      BaseReferences<_$AppDatabase, $KPIDataTableTable, KPIDataTableData>
    ),
    KPIDataTableData,
    PrefetchHooks Function()> {
  $$KPIDataTableTableTableManager(_$AppDatabase db, $KPIDataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KPIDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KPIDataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KPIDataTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> dataDate = const Value.absent(),
            Value<double?> gemScore = const Value.absent(),
            Value<double?> hoursScheduled = const Value.absent(),
            Value<double?> hoursRecommended = const Value.absent(),
            Value<double?> laborUsedPercentage = const Value.absent(),
            Value<double?> salesActual = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KPIDataTableCompanion(
            id: id,
            dataDate: dataDate,
            gemScore: gemScore,
            hoursScheduled: hoursScheduled,
            hoursRecommended: hoursRecommended,
            laborUsedPercentage: laborUsedPercentage,
            salesActual: salesActual,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime dataDate,
            Value<double?> gemScore = const Value.absent(),
            Value<double?> hoursScheduled = const Value.absent(),
            Value<double?> hoursRecommended = const Value.absent(),
            Value<double?> laborUsedPercentage = const Value.absent(),
            Value<double?> salesActual = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              KPIDataTableCompanion.insert(
            id: id,
            dataDate: dataDate,
            gemScore: gemScore,
            hoursScheduled: hoursScheduled,
            hoursRecommended: hoursRecommended,
            laborUsedPercentage: laborUsedPercentage,
            salesActual: salesActual,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KPIDataTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KPIDataTableTable,
    KPIDataTableData,
    $$KPIDataTableTableFilterComposer,
    $$KPIDataTableTableOrderingComposer,
    $$KPIDataTableTableAnnotationComposer,
    $$KPIDataTableTableCreateCompanionBuilder,
    $$KPIDataTableTableUpdateCompanionBuilder,
    (
      KPIDataTableData,
      BaseReferences<_$AppDatabase, $KPIDataTableTable, KPIDataTableData>
    ),
    KPIDataTableData,
    PrefetchHooks Function()>;
typedef $$BusinessCalendarTableTableCreateCompanionBuilder
    = BusinessCalendarTableCompanion Function({
  required String id,
  required DateTime startDate,
  required int currentWeek,
  required int currentPeriod,
  required int currentQuarter,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BusinessCalendarTableTableUpdateCompanionBuilder
    = BusinessCalendarTableCompanion Function({
  Value<String> id,
  Value<DateTime> startDate,
  Value<int> currentWeek,
  Value<int> currentPeriod,
  Value<int> currentQuarter,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BusinessCalendarTableTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessCalendarTableTable> {
  $$BusinessCalendarTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentPeriod => $composableBuilder(
      column: $table.currentPeriod, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentQuarter => $composableBuilder(
      column: $table.currentQuarter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BusinessCalendarTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessCalendarTableTable> {
  $$BusinessCalendarTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentPeriod => $composableBuilder(
      column: $table.currentPeriod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentQuarter => $composableBuilder(
      column: $table.currentQuarter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BusinessCalendarTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessCalendarTableTable> {
  $$BusinessCalendarTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get currentWeek => $composableBuilder(
      column: $table.currentWeek, builder: (column) => column);

  GeneratedColumn<int> get currentPeriod => $composableBuilder(
      column: $table.currentPeriod, builder: (column) => column);

  GeneratedColumn<int> get currentQuarter => $composableBuilder(
      column: $table.currentQuarter, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BusinessCalendarTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BusinessCalendarTableTable,
    BusinessCalendarTableData,
    $$BusinessCalendarTableTableFilterComposer,
    $$BusinessCalendarTableTableOrderingComposer,
    $$BusinessCalendarTableTableAnnotationComposer,
    $$BusinessCalendarTableTableCreateCompanionBuilder,
    $$BusinessCalendarTableTableUpdateCompanionBuilder,
    (
      BusinessCalendarTableData,
      BaseReferences<_$AppDatabase, $BusinessCalendarTableTable,
          BusinessCalendarTableData>
    ),
    BusinessCalendarTableData,
    PrefetchHooks Function()> {
  $$BusinessCalendarTableTableTableManager(
      _$AppDatabase db, $BusinessCalendarTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessCalendarTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessCalendarTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessCalendarTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<int> currentWeek = const Value.absent(),
            Value<int> currentPeriod = const Value.absent(),
            Value<int> currentQuarter = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessCalendarTableCompanion(
            id: id,
            startDate: startDate,
            currentWeek: currentWeek,
            currentPeriod: currentPeriod,
            currentQuarter: currentQuarter,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime startDate,
            required int currentWeek,
            required int currentPeriod,
            required int currentQuarter,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessCalendarTableCompanion.insert(
            id: id,
            startDate: startDate,
            currentWeek: currentWeek,
            currentPeriod: currentPeriod,
            currentQuarter: currentQuarter,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BusinessCalendarTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $BusinessCalendarTableTable,
        BusinessCalendarTableData,
        $$BusinessCalendarTableTableFilterComposer,
        $$BusinessCalendarTableTableOrderingComposer,
        $$BusinessCalendarTableTableAnnotationComposer,
        $$BusinessCalendarTableTableCreateCompanionBuilder,
        $$BusinessCalendarTableTableUpdateCompanionBuilder,
        (
          BusinessCalendarTableData,
          BaseReferences<_$AppDatabase, $BusinessCalendarTableTable,
              BusinessCalendarTableData>
        ),
        BusinessCalendarTableData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncMetadataTableTableTableManager get syncMetadataTable =>
      $$SyncMetadataTableTableTableManager(_db, _db.syncMetadataTable);
  $$PendingChangesTableTableTableManager get pendingChangesTable =>
      $$PendingChangesTableTableTableManager(_db, _db.pendingChangesTable);
  $$FormsTableTableTableManager get formsTable =>
      $$FormsTableTableTableManager(_db, _db.formsTable);
  $$FormSectionsTableTableTableManager get formSectionsTable =>
      $$FormSectionsTableTableTableManager(_db, _db.formSectionsTable);
  $$FieldsTableTableTableManager get fieldsTable =>
      $$FieldsTableTableTableManager(_db, _db.fieldsTable);
  $$DropdownOptionsTableTableTableManager get dropdownOptionsTable =>
      $$DropdownOptionsTableTableTableManager(_db, _db.dropdownOptionsTable);
  $$SubmissionsTableTableTableManager get submissionsTable =>
      $$SubmissionsTableTableTableManager(_db, _db.submissionsTable);
  $$SubmissionAnswersTableTableTableManager get submissionAnswersTable =>
      $$SubmissionAnswersTableTableTableManager(
          _db, _db.submissionAnswersTable);
  $$TeamTableTableTableManager get teamTable =>
      $$TeamTableTableTableManager(_db, _db.teamTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$KPIDataTableTableTableManager get kPIDataTable =>
      $$KPIDataTableTableTableManager(_db, _db.kPIDataTable);
  $$BusinessCalendarTableTableTableManager get businessCalendarTable =>
      $$BusinessCalendarTableTableTableManager(_db, _db.businessCalendarTable);
}
