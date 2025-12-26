// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncPullRequestImpl _$$SyncPullRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SyncPullRequestImpl(
      deviceId: json['deviceId'] as String,
      lastSyncTimestamps:
          (json['lastSyncTimestamps'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, DateTime.parse(e as String)),
      ),
      tables:
          (json['tables'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SyncPullRequestImplToJson(
        _$SyncPullRequestImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'lastSyncTimestamps': instance.lastSyncTimestamps
          .map((k, e) => MapEntry(k, e.toIso8601String())),
      'tables': instance.tables,
    };

_$SyncPushRequestImpl _$$SyncPushRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SyncPushRequestImpl(
      deviceId: json['deviceId'] as String,
      changes: (json['changes'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => e as Map<String, dynamic>)
                .toList()),
      ),
    );

Map<String, dynamic> _$$SyncPushRequestImplToJson(
        _$SyncPushRequestImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'changes': instance.changes,
    };

_$SyncConflictImpl _$$SyncConflictImplFromJson(Map<String, dynamic> json) =>
    _$SyncConflictImpl(
      table: json['table'] as String,
      recordId: json['recordId'] as String,
      clientData: json['clientData'] as Map<String, dynamic>,
      serverData: json['serverData'] as Map<String, dynamic>,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$SyncConflictImplToJson(_$SyncConflictImpl instance) =>
    <String, dynamic>{
      'table': instance.table,
      'recordId': instance.recordId,
      'clientData': instance.clientData,
      'serverData': instance.serverData,
      'error': instance.error,
    };

_$SyncResponseImpl _$$SyncResponseImplFromJson(Map<String, dynamic> json) =>
    _$SyncResponseImpl(
      success: json['success'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      changes: (json['changes'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => e as Map<String, dynamic>)
                .toList()),
      ),
      conflicts: (json['conflicts'] as List<dynamic>?)
          ?.map((e) => SyncConflict.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SyncResponseImplToJson(_$SyncResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp.toIso8601String(),
      'changes': instance.changes,
      'conflicts': instance.conflicts,
    };

_$SyncStatusIdleImpl _$$SyncStatusIdleImplFromJson(Map<String, dynamic> json) =>
    _$SyncStatusIdleImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SyncStatusIdleImplToJson(
        _$SyncStatusIdleImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$SyncStatusSyncingImpl _$$SyncStatusSyncingImplFromJson(
        Map<String, dynamic> json) =>
    _$SyncStatusSyncingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SyncStatusSyncingImplToJson(
        _$SyncStatusSyncingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$SyncStatusSuccessImpl _$$SyncStatusSuccessImplFromJson(
        Map<String, dynamic> json) =>
    _$SyncStatusSuccessImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SyncStatusSuccessImplToJson(
        _$SyncStatusSuccessImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$SyncStatusErrorImpl _$$SyncStatusErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$SyncStatusErrorImpl(
      (json['conflicts'] as List<dynamic>)
          .map((e) => SyncConflict.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SyncStatusErrorImplToJson(
        _$SyncStatusErrorImpl instance) =>
    <String, dynamic>{
      'conflicts': instance.conflicts,
      'runtimeType': instance.$type,
    };

_$SyncStatusAlreadySyncingImpl _$$SyncStatusAlreadySyncingImplFromJson(
        Map<String, dynamic> json) =>
    _$SyncStatusAlreadySyncingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SyncStatusAlreadySyncingImplToJson(
        _$SyncStatusAlreadySyncingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$PendingChangeImpl _$$PendingChangeImplFromJson(Map<String, dynamic> json) =>
    _$PendingChangeImpl(
      id: (json['id'] as num?)?.toInt(),
      tableName: json['tableName'] as String,
      recordId: json['recordId'] as String,
      operation: $enumDecode(_$PendingOperationEnumMap, json['operation']),
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      synced: json['synced'] as bool? ?? false,
    );

Map<String, dynamic> _$$PendingChangeImplToJson(_$PendingChangeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableName': instance.tableName,
      'recordId': instance.recordId,
      'operation': _$PendingOperationEnumMap[instance.operation]!,
      'data': instance.data,
      'createdAt': instance.createdAt.toIso8601String(),
      'synced': instance.synced,
    };

const _$PendingOperationEnumMap = {
  PendingOperation.insert: 'INSERT',
  PendingOperation.update: 'UPDATE',
  PendingOperation.delete: 'DELETE',
};

_$SyncMetadataImpl _$$SyncMetadataImplFromJson(Map<String, dynamic> json) =>
    _$SyncMetadataImpl(
      id: (json['id'] as num?)?.toInt(),
      tableName: json['tableName'] as String,
      lastSyncAt: DateTime.parse(json['lastSyncAt'] as String),
      lastSyncVersion: (json['lastSyncVersion'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SyncMetadataImplToJson(_$SyncMetadataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableName': instance.tableName,
      'lastSyncAt': instance.lastSyncAt.toIso8601String(),
      'lastSyncVersion': instance.lastSyncVersion,
    };
