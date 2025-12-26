import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync.freezed.dart';
part 'sync.g.dart';

/// Sync pull request
@freezed
class SyncPullRequest with _$SyncPullRequest {
  const factory SyncPullRequest({
    required String deviceId,
    required Map<String, DateTime> lastSyncTimestamps,
    required List<String> tables,
  }) = _SyncPullRequest;

  factory SyncPullRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncPullRequestFromJson(json);
}

/// Sync push request
@freezed
class SyncPushRequest with _$SyncPushRequest {
  const factory SyncPushRequest({
    required String deviceId,
    required Map<String, List<Map<String, dynamic>>> changes,
  }) = _SyncPushRequest;

  factory SyncPushRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncPushRequestFromJson(json);
}

/// Sync conflict
@freezed
class SyncConflict with _$SyncConflict {
  const factory SyncConflict({
    required String table,
    required String recordId,
    required Map<String, dynamic> clientData,
    required Map<String, dynamic> serverData,
    String? error,
  }) = _SyncConflict;

  factory SyncConflict.fromJson(Map<String, dynamic> json) =>
      _$SyncConflictFromJson(json);
}

/// Sync response
@freezed
class SyncResponse with _$SyncResponse {
  const factory SyncResponse({
    required bool success,
    required DateTime timestamp,
    required Map<String, List<Map<String, dynamic>>> changes,
    List<SyncConflict>? conflicts,
  }) = _SyncResponse;

  factory SyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);
}

/// Sync status - local status for tracking sync state
@freezed
class SyncStatus with _$SyncStatus {
  const factory SyncStatus.idle() = _SyncStatusIdle;
  const factory SyncStatus.syncing() = _SyncStatusSyncing;
  const factory SyncStatus.success() = _SyncStatusSuccess;
  const factory SyncStatus.error(List<SyncConflict> conflicts) = _SyncStatusError;
  const factory SyncStatus.alreadySyncing() = _SyncStatusAlreadySyncing;

  factory SyncStatus.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusFromJson(json);
}

/// Pending change operation type
enum PendingOperation {
  @JsonValue('INSERT')
  insert,
  @JsonValue('UPDATE')
  update,
  @JsonValue('DELETE')
  delete,
}

/// Pending change record
@freezed
class PendingChange with _$PendingChange {
  const factory PendingChange({
    int? id,
    required String tableName,
    required String recordId,
    required PendingOperation operation,
    required Map<String, dynamic> data,
    required DateTime createdAt,
    @Default(false) bool synced,
  }) = _PendingChange;

  factory PendingChange.fromJson(Map<String, dynamic> json) =>
      _$PendingChangeFromJson(json);
}

/// Sync metadata for tracking last sync time per table
@freezed
class SyncMetadata with _$SyncMetadata {
  const factory SyncMetadata({
    int? id,
    required String tableName,
    required DateTime lastSyncAt,
    @Default(0) int lastSyncVersion,
  }) = _SyncMetadata;

  factory SyncMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataFromJson(json);
}
