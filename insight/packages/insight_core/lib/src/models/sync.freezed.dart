// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SyncPullRequest _$SyncPullRequestFromJson(Map<String, dynamic> json) {
  return _SyncPullRequest.fromJson(json);
}

/// @nodoc
mixin _$SyncPullRequest {
  String get deviceId => throw _privateConstructorUsedError;
  Map<String, DateTime> get lastSyncTimestamps =>
      throw _privateConstructorUsedError;
  List<String> get tables => throw _privateConstructorUsedError;

  /// Serializes this SyncPullRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncPullRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncPullRequestCopyWith<SyncPullRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncPullRequestCopyWith<$Res> {
  factory $SyncPullRequestCopyWith(
          SyncPullRequest value, $Res Function(SyncPullRequest) then) =
      _$SyncPullRequestCopyWithImpl<$Res, SyncPullRequest>;
  @useResult
  $Res call(
      {String deviceId,
      Map<String, DateTime> lastSyncTimestamps,
      List<String> tables});
}

/// @nodoc
class _$SyncPullRequestCopyWithImpl<$Res, $Val extends SyncPullRequest>
    implements $SyncPullRequestCopyWith<$Res> {
  _$SyncPullRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncPullRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? lastSyncTimestamps = null,
    Object? tables = null,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncTimestamps: null == lastSyncTimestamps
          ? _value.lastSyncTimestamps
          : lastSyncTimestamps // ignore: cast_nullable_to_non_nullable
              as Map<String, DateTime>,
      tables: null == tables
          ? _value.tables
          : tables // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncPullRequestImplCopyWith<$Res>
    implements $SyncPullRequestCopyWith<$Res> {
  factory _$$SyncPullRequestImplCopyWith(_$SyncPullRequestImpl value,
          $Res Function(_$SyncPullRequestImpl) then) =
      __$$SyncPullRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      Map<String, DateTime> lastSyncTimestamps,
      List<String> tables});
}

/// @nodoc
class __$$SyncPullRequestImplCopyWithImpl<$Res>
    extends _$SyncPullRequestCopyWithImpl<$Res, _$SyncPullRequestImpl>
    implements _$$SyncPullRequestImplCopyWith<$Res> {
  __$$SyncPullRequestImplCopyWithImpl(
      _$SyncPullRequestImpl _value, $Res Function(_$SyncPullRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncPullRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? lastSyncTimestamps = null,
    Object? tables = null,
  }) {
    return _then(_$SyncPullRequestImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncTimestamps: null == lastSyncTimestamps
          ? _value._lastSyncTimestamps
          : lastSyncTimestamps // ignore: cast_nullable_to_non_nullable
              as Map<String, DateTime>,
      tables: null == tables
          ? _value._tables
          : tables // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncPullRequestImpl implements _SyncPullRequest {
  const _$SyncPullRequestImpl(
      {required this.deviceId,
      required final Map<String, DateTime> lastSyncTimestamps,
      required final List<String> tables})
      : _lastSyncTimestamps = lastSyncTimestamps,
        _tables = tables;

  factory _$SyncPullRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncPullRequestImplFromJson(json);

  @override
  final String deviceId;
  final Map<String, DateTime> _lastSyncTimestamps;
  @override
  Map<String, DateTime> get lastSyncTimestamps {
    if (_lastSyncTimestamps is EqualUnmodifiableMapView)
      return _lastSyncTimestamps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_lastSyncTimestamps);
  }

  final List<String> _tables;
  @override
  List<String> get tables {
    if (_tables is EqualUnmodifiableListView) return _tables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tables);
  }

  @override
  String toString() {
    return 'SyncPullRequest(deviceId: $deviceId, lastSyncTimestamps: $lastSyncTimestamps, tables: $tables)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPullRequestImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            const DeepCollectionEquality()
                .equals(other._lastSyncTimestamps, _lastSyncTimestamps) &&
            const DeepCollectionEquality().equals(other._tables, _tables));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      deviceId,
      const DeepCollectionEquality().hash(_lastSyncTimestamps),
      const DeepCollectionEquality().hash(_tables));

  /// Create a copy of SyncPullRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncPullRequestImplCopyWith<_$SyncPullRequestImpl> get copyWith =>
      __$$SyncPullRequestImplCopyWithImpl<_$SyncPullRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncPullRequestImplToJson(
      this,
    );
  }
}

abstract class _SyncPullRequest implements SyncPullRequest {
  const factory _SyncPullRequest(
      {required final String deviceId,
      required final Map<String, DateTime> lastSyncTimestamps,
      required final List<String> tables}) = _$SyncPullRequestImpl;

  factory _SyncPullRequest.fromJson(Map<String, dynamic> json) =
      _$SyncPullRequestImpl.fromJson;

  @override
  String get deviceId;
  @override
  Map<String, DateTime> get lastSyncTimestamps;
  @override
  List<String> get tables;

  /// Create a copy of SyncPullRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPullRequestImplCopyWith<_$SyncPullRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncPushRequest _$SyncPushRequestFromJson(Map<String, dynamic> json) {
  return _SyncPushRequest.fromJson(json);
}

/// @nodoc
mixin _$SyncPushRequest {
  String get deviceId => throw _privateConstructorUsedError;
  Map<String, List<Map<String, dynamic>>> get changes =>
      throw _privateConstructorUsedError;

  /// Serializes this SyncPushRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncPushRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncPushRequestCopyWith<SyncPushRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncPushRequestCopyWith<$Res> {
  factory $SyncPushRequestCopyWith(
          SyncPushRequest value, $Res Function(SyncPushRequest) then) =
      _$SyncPushRequestCopyWithImpl<$Res, SyncPushRequest>;
  @useResult
  $Res call({String deviceId, Map<String, List<Map<String, dynamic>>> changes});
}

/// @nodoc
class _$SyncPushRequestCopyWithImpl<$Res, $Val extends SyncPushRequest>
    implements $SyncPushRequestCopyWith<$Res> {
  _$SyncPushRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncPushRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? changes = null,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      changes: null == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Map<String, dynamic>>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncPushRequestImplCopyWith<$Res>
    implements $SyncPushRequestCopyWith<$Res> {
  factory _$$SyncPushRequestImplCopyWith(_$SyncPushRequestImpl value,
          $Res Function(_$SyncPushRequestImpl) then) =
      __$$SyncPushRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String deviceId, Map<String, List<Map<String, dynamic>>> changes});
}

/// @nodoc
class __$$SyncPushRequestImplCopyWithImpl<$Res>
    extends _$SyncPushRequestCopyWithImpl<$Res, _$SyncPushRequestImpl>
    implements _$$SyncPushRequestImplCopyWith<$Res> {
  __$$SyncPushRequestImplCopyWithImpl(
      _$SyncPushRequestImpl _value, $Res Function(_$SyncPushRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncPushRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? changes = null,
  }) {
    return _then(_$SyncPushRequestImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      changes: null == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Map<String, dynamic>>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncPushRequestImpl implements _SyncPushRequest {
  const _$SyncPushRequestImpl(
      {required this.deviceId,
      required final Map<String, List<Map<String, dynamic>>> changes})
      : _changes = changes;

  factory _$SyncPushRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncPushRequestImplFromJson(json);

  @override
  final String deviceId;
  final Map<String, List<Map<String, dynamic>>> _changes;
  @override
  Map<String, List<Map<String, dynamic>>> get changes {
    if (_changes is EqualUnmodifiableMapView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_changes);
  }

  @override
  String toString() {
    return 'SyncPushRequest(deviceId: $deviceId, changes: $changes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncPushRequestImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            const DeepCollectionEquality().equals(other._changes, _changes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, deviceId, const DeepCollectionEquality().hash(_changes));

  /// Create a copy of SyncPushRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncPushRequestImplCopyWith<_$SyncPushRequestImpl> get copyWith =>
      __$$SyncPushRequestImplCopyWithImpl<_$SyncPushRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncPushRequestImplToJson(
      this,
    );
  }
}

abstract class _SyncPushRequest implements SyncPushRequest {
  const factory _SyncPushRequest(
          {required final String deviceId,
          required final Map<String, List<Map<String, dynamic>>> changes}) =
      _$SyncPushRequestImpl;

  factory _SyncPushRequest.fromJson(Map<String, dynamic> json) =
      _$SyncPushRequestImpl.fromJson;

  @override
  String get deviceId;
  @override
  Map<String, List<Map<String, dynamic>>> get changes;

  /// Create a copy of SyncPushRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncPushRequestImplCopyWith<_$SyncPushRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncConflict _$SyncConflictFromJson(Map<String, dynamic> json) {
  return _SyncConflict.fromJson(json);
}

/// @nodoc
mixin _$SyncConflict {
  String get table => throw _privateConstructorUsedError;
  String get recordId => throw _privateConstructorUsedError;
  Map<String, dynamic> get clientData => throw _privateConstructorUsedError;
  Map<String, dynamic> get serverData => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this SyncConflict to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncConflictCopyWith<SyncConflict> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncConflictCopyWith<$Res> {
  factory $SyncConflictCopyWith(
          SyncConflict value, $Res Function(SyncConflict) then) =
      _$SyncConflictCopyWithImpl<$Res, SyncConflict>;
  @useResult
  $Res call(
      {String table,
      String recordId,
      Map<String, dynamic> clientData,
      Map<String, dynamic> serverData,
      String? error});
}

/// @nodoc
class _$SyncConflictCopyWithImpl<$Res, $Val extends SyncConflict>
    implements $SyncConflictCopyWith<$Res> {
  _$SyncConflictCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? table = null,
    Object? recordId = null,
    Object? clientData = null,
    Object? serverData = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      table: null == table
          ? _value.table
          : table // ignore: cast_nullable_to_non_nullable
              as String,
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      clientData: null == clientData
          ? _value.clientData
          : clientData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      serverData: null == serverData
          ? _value.serverData
          : serverData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncConflictImplCopyWith<$Res>
    implements $SyncConflictCopyWith<$Res> {
  factory _$$SyncConflictImplCopyWith(
          _$SyncConflictImpl value, $Res Function(_$SyncConflictImpl) then) =
      __$$SyncConflictImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String table,
      String recordId,
      Map<String, dynamic> clientData,
      Map<String, dynamic> serverData,
      String? error});
}

/// @nodoc
class __$$SyncConflictImplCopyWithImpl<$Res>
    extends _$SyncConflictCopyWithImpl<$Res, _$SyncConflictImpl>
    implements _$$SyncConflictImplCopyWith<$Res> {
  __$$SyncConflictImplCopyWithImpl(
      _$SyncConflictImpl _value, $Res Function(_$SyncConflictImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? table = null,
    Object? recordId = null,
    Object? clientData = null,
    Object? serverData = null,
    Object? error = freezed,
  }) {
    return _then(_$SyncConflictImpl(
      table: null == table
          ? _value.table
          : table // ignore: cast_nullable_to_non_nullable
              as String,
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      clientData: null == clientData
          ? _value._clientData
          : clientData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      serverData: null == serverData
          ? _value._serverData
          : serverData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncConflictImpl implements _SyncConflict {
  const _$SyncConflictImpl(
      {required this.table,
      required this.recordId,
      required final Map<String, dynamic> clientData,
      required final Map<String, dynamic> serverData,
      this.error})
      : _clientData = clientData,
        _serverData = serverData;

  factory _$SyncConflictImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncConflictImplFromJson(json);

  @override
  final String table;
  @override
  final String recordId;
  final Map<String, dynamic> _clientData;
  @override
  Map<String, dynamic> get clientData {
    if (_clientData is EqualUnmodifiableMapView) return _clientData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_clientData);
  }

  final Map<String, dynamic> _serverData;
  @override
  Map<String, dynamic> get serverData {
    if (_serverData is EqualUnmodifiableMapView) return _serverData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_serverData);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'SyncConflict(table: $table, recordId: $recordId, clientData: $clientData, serverData: $serverData, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncConflictImpl &&
            (identical(other.table, table) || other.table == table) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            const DeepCollectionEquality()
                .equals(other._clientData, _clientData) &&
            const DeepCollectionEquality()
                .equals(other._serverData, _serverData) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      table,
      recordId,
      const DeepCollectionEquality().hash(_clientData),
      const DeepCollectionEquality().hash(_serverData),
      error);

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncConflictImplCopyWith<_$SyncConflictImpl> get copyWith =>
      __$$SyncConflictImplCopyWithImpl<_$SyncConflictImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncConflictImplToJson(
      this,
    );
  }
}

abstract class _SyncConflict implements SyncConflict {
  const factory _SyncConflict(
      {required final String table,
      required final String recordId,
      required final Map<String, dynamic> clientData,
      required final Map<String, dynamic> serverData,
      final String? error}) = _$SyncConflictImpl;

  factory _SyncConflict.fromJson(Map<String, dynamic> json) =
      _$SyncConflictImpl.fromJson;

  @override
  String get table;
  @override
  String get recordId;
  @override
  Map<String, dynamic> get clientData;
  @override
  Map<String, dynamic> get serverData;
  @override
  String? get error;

  /// Create a copy of SyncConflict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncConflictImplCopyWith<_$SyncConflictImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) {
  return _SyncResponse.fromJson(json);
}

/// @nodoc
mixin _$SyncResponse {
  bool get success => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, List<Map<String, dynamic>>> get changes =>
      throw _privateConstructorUsedError;
  List<SyncConflict>? get conflicts => throw _privateConstructorUsedError;

  /// Serializes this SyncResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncResponseCopyWith<SyncResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncResponseCopyWith<$Res> {
  factory $SyncResponseCopyWith(
          SyncResponse value, $Res Function(SyncResponse) then) =
      _$SyncResponseCopyWithImpl<$Res, SyncResponse>;
  @useResult
  $Res call(
      {bool success,
      DateTime timestamp,
      Map<String, List<Map<String, dynamic>>> changes,
      List<SyncConflict>? conflicts});
}

/// @nodoc
class _$SyncResponseCopyWithImpl<$Res, $Val extends SyncResponse>
    implements $SyncResponseCopyWith<$Res> {
  _$SyncResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? timestamp = null,
    Object? changes = null,
    Object? conflicts = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changes: null == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Map<String, dynamic>>>,
      conflicts: freezed == conflicts
          ? _value.conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<SyncConflict>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncResponseImplCopyWith<$Res>
    implements $SyncResponseCopyWith<$Res> {
  factory _$$SyncResponseImplCopyWith(
          _$SyncResponseImpl value, $Res Function(_$SyncResponseImpl) then) =
      __$$SyncResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      DateTime timestamp,
      Map<String, List<Map<String, dynamic>>> changes,
      List<SyncConflict>? conflicts});
}

/// @nodoc
class __$$SyncResponseImplCopyWithImpl<$Res>
    extends _$SyncResponseCopyWithImpl<$Res, _$SyncResponseImpl>
    implements _$$SyncResponseImplCopyWith<$Res> {
  __$$SyncResponseImplCopyWithImpl(
      _$SyncResponseImpl _value, $Res Function(_$SyncResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? timestamp = null,
    Object? changes = null,
    Object? conflicts = freezed,
  }) {
    return _then(_$SyncResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      changes: null == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Map<String, dynamic>>>,
      conflicts: freezed == conflicts
          ? _value._conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<SyncConflict>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncResponseImpl implements _SyncResponse {
  const _$SyncResponseImpl(
      {required this.success,
      required this.timestamp,
      required final Map<String, List<Map<String, dynamic>>> changes,
      final List<SyncConflict>? conflicts})
      : _changes = changes,
        _conflicts = conflicts;

  factory _$SyncResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final DateTime timestamp;
  final Map<String, List<Map<String, dynamic>>> _changes;
  @override
  Map<String, List<Map<String, dynamic>>> get changes {
    if (_changes is EqualUnmodifiableMapView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_changes);
  }

  final List<SyncConflict>? _conflicts;
  @override
  List<SyncConflict>? get conflicts {
    final value = _conflicts;
    if (value == null) return null;
    if (_conflicts is EqualUnmodifiableListView) return _conflicts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SyncResponse(success: $success, timestamp: $timestamp, changes: $changes, conflicts: $conflicts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            const DeepCollectionEquality()
                .equals(other._conflicts, _conflicts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      timestamp,
      const DeepCollectionEquality().hash(_changes),
      const DeepCollectionEquality().hash(_conflicts));

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncResponseImplCopyWith<_$SyncResponseImpl> get copyWith =>
      __$$SyncResponseImplCopyWithImpl<_$SyncResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncResponseImplToJson(
      this,
    );
  }
}

abstract class _SyncResponse implements SyncResponse {
  const factory _SyncResponse(
      {required final bool success,
      required final DateTime timestamp,
      required final Map<String, List<Map<String, dynamic>>> changes,
      final List<SyncConflict>? conflicts}) = _$SyncResponseImpl;

  factory _SyncResponse.fromJson(Map<String, dynamic> json) =
      _$SyncResponseImpl.fromJson;

  @override
  bool get success;
  @override
  DateTime get timestamp;
  @override
  Map<String, List<Map<String, dynamic>>> get changes;
  @override
  List<SyncConflict>? get conflicts;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncResponseImplCopyWith<_$SyncResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncStatus _$SyncStatusFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'idle':
      return _SyncStatusIdle.fromJson(json);
    case 'syncing':
      return _SyncStatusSyncing.fromJson(json);
    case 'success':
      return _SyncStatusSuccess.fromJson(json);
    case 'error':
      return _SyncStatusError.fromJson(json);
    case 'alreadySyncing':
      return _SyncStatusAlreadySyncing.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'SyncStatus',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$SyncStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() syncing,
    required TResult Function() success,
    required TResult Function(List<SyncConflict> conflicts) error,
    required TResult Function() alreadySyncing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? syncing,
    TResult? Function()? success,
    TResult? Function(List<SyncConflict> conflicts)? error,
    TResult? Function()? alreadySyncing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? syncing,
    TResult Function()? success,
    TResult Function(List<SyncConflict> conflicts)? error,
    TResult Function()? alreadySyncing,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SyncStatusIdle value) idle,
    required TResult Function(_SyncStatusSyncing value) syncing,
    required TResult Function(_SyncStatusSuccess value) success,
    required TResult Function(_SyncStatusError value) error,
    required TResult Function(_SyncStatusAlreadySyncing value) alreadySyncing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SyncStatusIdle value)? idle,
    TResult? Function(_SyncStatusSyncing value)? syncing,
    TResult? Function(_SyncStatusSuccess value)? success,
    TResult? Function(_SyncStatusError value)? error,
    TResult? Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SyncStatusIdle value)? idle,
    TResult Function(_SyncStatusSyncing value)? syncing,
    TResult Function(_SyncStatusSuccess value)? success,
    TResult Function(_SyncStatusError value)? error,
    TResult Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SyncStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStatusCopyWith<$Res> {
  factory $SyncStatusCopyWith(
          SyncStatus value, $Res Function(SyncStatus) then) =
      _$SyncStatusCopyWithImpl<$Res, SyncStatus>;
}

/// @nodoc
class _$SyncStatusCopyWithImpl<$Res, $Val extends SyncStatus>
    implements $SyncStatusCopyWith<$Res> {
  _$SyncStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncStatusIdleImplCopyWith<$Res> {
  factory _$$SyncStatusIdleImplCopyWith(_$SyncStatusIdleImpl value,
          $Res Function(_$SyncStatusIdleImpl) then) =
      __$$SyncStatusIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStatusIdleImplCopyWithImpl<$Res>
    extends _$SyncStatusCopyWithImpl<$Res, _$SyncStatusIdleImpl>
    implements _$$SyncStatusIdleImplCopyWith<$Res> {
  __$$SyncStatusIdleImplCopyWithImpl(
      _$SyncStatusIdleImpl _value, $Res Function(_$SyncStatusIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$SyncStatusIdleImpl implements _SyncStatusIdle {
  const _$SyncStatusIdleImpl({final String? $type}) : $type = $type ?? 'idle';

  factory _$SyncStatusIdleImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStatusIdleImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SyncStatus.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncStatusIdleImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() syncing,
    required TResult Function() success,
    required TResult Function(List<SyncConflict> conflicts) error,
    required TResult Function() alreadySyncing,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? syncing,
    TResult? Function()? success,
    TResult? Function(List<SyncConflict> conflicts)? error,
    TResult? Function()? alreadySyncing,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? syncing,
    TResult Function()? success,
    TResult Function(List<SyncConflict> conflicts)? error,
    TResult Function()? alreadySyncing,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SyncStatusIdle value) idle,
    required TResult Function(_SyncStatusSyncing value) syncing,
    required TResult Function(_SyncStatusSuccess value) success,
    required TResult Function(_SyncStatusError value) error,
    required TResult Function(_SyncStatusAlreadySyncing value) alreadySyncing,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SyncStatusIdle value)? idle,
    TResult? Function(_SyncStatusSyncing value)? syncing,
    TResult? Function(_SyncStatusSuccess value)? success,
    TResult? Function(_SyncStatusError value)? error,
    TResult? Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SyncStatusIdle value)? idle,
    TResult Function(_SyncStatusSyncing value)? syncing,
    TResult Function(_SyncStatusSuccess value)? success,
    TResult Function(_SyncStatusError value)? error,
    TResult Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStatusIdleImplToJson(
      this,
    );
  }
}

abstract class _SyncStatusIdle implements SyncStatus {
  const factory _SyncStatusIdle() = _$SyncStatusIdleImpl;

  factory _SyncStatusIdle.fromJson(Map<String, dynamic> json) =
      _$SyncStatusIdleImpl.fromJson;
}

/// @nodoc
abstract class _$$SyncStatusSyncingImplCopyWith<$Res> {
  factory _$$SyncStatusSyncingImplCopyWith(_$SyncStatusSyncingImpl value,
          $Res Function(_$SyncStatusSyncingImpl) then) =
      __$$SyncStatusSyncingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStatusSyncingImplCopyWithImpl<$Res>
    extends _$SyncStatusCopyWithImpl<$Res, _$SyncStatusSyncingImpl>
    implements _$$SyncStatusSyncingImplCopyWith<$Res> {
  __$$SyncStatusSyncingImplCopyWithImpl(_$SyncStatusSyncingImpl _value,
      $Res Function(_$SyncStatusSyncingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$SyncStatusSyncingImpl implements _SyncStatusSyncing {
  const _$SyncStatusSyncingImpl({final String? $type})
      : $type = $type ?? 'syncing';

  factory _$SyncStatusSyncingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStatusSyncingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SyncStatus.syncing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncStatusSyncingImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() syncing,
    required TResult Function() success,
    required TResult Function(List<SyncConflict> conflicts) error,
    required TResult Function() alreadySyncing,
  }) {
    return syncing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? syncing,
    TResult? Function()? success,
    TResult? Function(List<SyncConflict> conflicts)? error,
    TResult? Function()? alreadySyncing,
  }) {
    return syncing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? syncing,
    TResult Function()? success,
    TResult Function(List<SyncConflict> conflicts)? error,
    TResult Function()? alreadySyncing,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SyncStatusIdle value) idle,
    required TResult Function(_SyncStatusSyncing value) syncing,
    required TResult Function(_SyncStatusSuccess value) success,
    required TResult Function(_SyncStatusError value) error,
    required TResult Function(_SyncStatusAlreadySyncing value) alreadySyncing,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SyncStatusIdle value)? idle,
    TResult? Function(_SyncStatusSyncing value)? syncing,
    TResult? Function(_SyncStatusSuccess value)? success,
    TResult? Function(_SyncStatusError value)? error,
    TResult? Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SyncStatusIdle value)? idle,
    TResult Function(_SyncStatusSyncing value)? syncing,
    TResult Function(_SyncStatusSuccess value)? success,
    TResult Function(_SyncStatusError value)? error,
    TResult Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStatusSyncingImplToJson(
      this,
    );
  }
}

abstract class _SyncStatusSyncing implements SyncStatus {
  const factory _SyncStatusSyncing() = _$SyncStatusSyncingImpl;

  factory _SyncStatusSyncing.fromJson(Map<String, dynamic> json) =
      _$SyncStatusSyncingImpl.fromJson;
}

/// @nodoc
abstract class _$$SyncStatusSuccessImplCopyWith<$Res> {
  factory _$$SyncStatusSuccessImplCopyWith(_$SyncStatusSuccessImpl value,
          $Res Function(_$SyncStatusSuccessImpl) then) =
      __$$SyncStatusSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStatusSuccessImplCopyWithImpl<$Res>
    extends _$SyncStatusCopyWithImpl<$Res, _$SyncStatusSuccessImpl>
    implements _$$SyncStatusSuccessImplCopyWith<$Res> {
  __$$SyncStatusSuccessImplCopyWithImpl(_$SyncStatusSuccessImpl _value,
      $Res Function(_$SyncStatusSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$SyncStatusSuccessImpl implements _SyncStatusSuccess {
  const _$SyncStatusSuccessImpl({final String? $type})
      : $type = $type ?? 'success';

  factory _$SyncStatusSuccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStatusSuccessImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SyncStatus.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncStatusSuccessImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() syncing,
    required TResult Function() success,
    required TResult Function(List<SyncConflict> conflicts) error,
    required TResult Function() alreadySyncing,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? syncing,
    TResult? Function()? success,
    TResult? Function(List<SyncConflict> conflicts)? error,
    TResult? Function()? alreadySyncing,
  }) {
    return success?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? syncing,
    TResult Function()? success,
    TResult Function(List<SyncConflict> conflicts)? error,
    TResult Function()? alreadySyncing,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SyncStatusIdle value) idle,
    required TResult Function(_SyncStatusSyncing value) syncing,
    required TResult Function(_SyncStatusSuccess value) success,
    required TResult Function(_SyncStatusError value) error,
    required TResult Function(_SyncStatusAlreadySyncing value) alreadySyncing,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SyncStatusIdle value)? idle,
    TResult? Function(_SyncStatusSyncing value)? syncing,
    TResult? Function(_SyncStatusSuccess value)? success,
    TResult? Function(_SyncStatusError value)? error,
    TResult? Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SyncStatusIdle value)? idle,
    TResult Function(_SyncStatusSyncing value)? syncing,
    TResult Function(_SyncStatusSuccess value)? success,
    TResult Function(_SyncStatusError value)? error,
    TResult Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStatusSuccessImplToJson(
      this,
    );
  }
}

abstract class _SyncStatusSuccess implements SyncStatus {
  const factory _SyncStatusSuccess() = _$SyncStatusSuccessImpl;

  factory _SyncStatusSuccess.fromJson(Map<String, dynamic> json) =
      _$SyncStatusSuccessImpl.fromJson;
}

/// @nodoc
abstract class _$$SyncStatusErrorImplCopyWith<$Res> {
  factory _$$SyncStatusErrorImplCopyWith(_$SyncStatusErrorImpl value,
          $Res Function(_$SyncStatusErrorImpl) then) =
      __$$SyncStatusErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SyncConflict> conflicts});
}

/// @nodoc
class __$$SyncStatusErrorImplCopyWithImpl<$Res>
    extends _$SyncStatusCopyWithImpl<$Res, _$SyncStatusErrorImpl>
    implements _$$SyncStatusErrorImplCopyWith<$Res> {
  __$$SyncStatusErrorImplCopyWithImpl(
      _$SyncStatusErrorImpl _value, $Res Function(_$SyncStatusErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conflicts = null,
  }) {
    return _then(_$SyncStatusErrorImpl(
      null == conflicts
          ? _value._conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<SyncConflict>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncStatusErrorImpl implements _SyncStatusError {
  const _$SyncStatusErrorImpl(final List<SyncConflict> conflicts,
      {final String? $type})
      : _conflicts = conflicts,
        $type = $type ?? 'error';

  factory _$SyncStatusErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStatusErrorImplFromJson(json);

  final List<SyncConflict> _conflicts;
  @override
  List<SyncConflict> get conflicts {
    if (_conflicts is EqualUnmodifiableListView) return _conflicts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conflicts);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SyncStatus.error(conflicts: $conflicts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusErrorImpl &&
            const DeepCollectionEquality()
                .equals(other._conflicts, _conflicts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_conflicts));

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusErrorImplCopyWith<_$SyncStatusErrorImpl> get copyWith =>
      __$$SyncStatusErrorImplCopyWithImpl<_$SyncStatusErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() syncing,
    required TResult Function() success,
    required TResult Function(List<SyncConflict> conflicts) error,
    required TResult Function() alreadySyncing,
  }) {
    return error(conflicts);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? syncing,
    TResult? Function()? success,
    TResult? Function(List<SyncConflict> conflicts)? error,
    TResult? Function()? alreadySyncing,
  }) {
    return error?.call(conflicts);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? syncing,
    TResult Function()? success,
    TResult Function(List<SyncConflict> conflicts)? error,
    TResult Function()? alreadySyncing,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(conflicts);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SyncStatusIdle value) idle,
    required TResult Function(_SyncStatusSyncing value) syncing,
    required TResult Function(_SyncStatusSuccess value) success,
    required TResult Function(_SyncStatusError value) error,
    required TResult Function(_SyncStatusAlreadySyncing value) alreadySyncing,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SyncStatusIdle value)? idle,
    TResult? Function(_SyncStatusSyncing value)? syncing,
    TResult? Function(_SyncStatusSuccess value)? success,
    TResult? Function(_SyncStatusError value)? error,
    TResult? Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SyncStatusIdle value)? idle,
    TResult Function(_SyncStatusSyncing value)? syncing,
    TResult Function(_SyncStatusSuccess value)? success,
    TResult Function(_SyncStatusError value)? error,
    TResult Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStatusErrorImplToJson(
      this,
    );
  }
}

abstract class _SyncStatusError implements SyncStatus {
  const factory _SyncStatusError(final List<SyncConflict> conflicts) =
      _$SyncStatusErrorImpl;

  factory _SyncStatusError.fromJson(Map<String, dynamic> json) =
      _$SyncStatusErrorImpl.fromJson;

  List<SyncConflict> get conflicts;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusErrorImplCopyWith<_$SyncStatusErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncStatusAlreadySyncingImplCopyWith<$Res> {
  factory _$$SyncStatusAlreadySyncingImplCopyWith(
          _$SyncStatusAlreadySyncingImpl value,
          $Res Function(_$SyncStatusAlreadySyncingImpl) then) =
      __$$SyncStatusAlreadySyncingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncStatusAlreadySyncingImplCopyWithImpl<$Res>
    extends _$SyncStatusCopyWithImpl<$Res, _$SyncStatusAlreadySyncingImpl>
    implements _$$SyncStatusAlreadySyncingImplCopyWith<$Res> {
  __$$SyncStatusAlreadySyncingImplCopyWithImpl(
      _$SyncStatusAlreadySyncingImpl _value,
      $Res Function(_$SyncStatusAlreadySyncingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$SyncStatusAlreadySyncingImpl implements _SyncStatusAlreadySyncing {
  const _$SyncStatusAlreadySyncingImpl({final String? $type})
      : $type = $type ?? 'alreadySyncing';

  factory _$SyncStatusAlreadySyncingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStatusAlreadySyncingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SyncStatus.alreadySyncing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusAlreadySyncingImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() syncing,
    required TResult Function() success,
    required TResult Function(List<SyncConflict> conflicts) error,
    required TResult Function() alreadySyncing,
  }) {
    return alreadySyncing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? syncing,
    TResult? Function()? success,
    TResult? Function(List<SyncConflict> conflicts)? error,
    TResult? Function()? alreadySyncing,
  }) {
    return alreadySyncing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? syncing,
    TResult Function()? success,
    TResult Function(List<SyncConflict> conflicts)? error,
    TResult Function()? alreadySyncing,
    required TResult orElse(),
  }) {
    if (alreadySyncing != null) {
      return alreadySyncing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SyncStatusIdle value) idle,
    required TResult Function(_SyncStatusSyncing value) syncing,
    required TResult Function(_SyncStatusSuccess value) success,
    required TResult Function(_SyncStatusError value) error,
    required TResult Function(_SyncStatusAlreadySyncing value) alreadySyncing,
  }) {
    return alreadySyncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_SyncStatusIdle value)? idle,
    TResult? Function(_SyncStatusSyncing value)? syncing,
    TResult? Function(_SyncStatusSuccess value)? success,
    TResult? Function(_SyncStatusError value)? error,
    TResult? Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
  }) {
    return alreadySyncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SyncStatusIdle value)? idle,
    TResult Function(_SyncStatusSyncing value)? syncing,
    TResult Function(_SyncStatusSuccess value)? success,
    TResult Function(_SyncStatusError value)? error,
    TResult Function(_SyncStatusAlreadySyncing value)? alreadySyncing,
    required TResult orElse(),
  }) {
    if (alreadySyncing != null) {
      return alreadySyncing(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStatusAlreadySyncingImplToJson(
      this,
    );
  }
}

abstract class _SyncStatusAlreadySyncing implements SyncStatus {
  const factory _SyncStatusAlreadySyncing() = _$SyncStatusAlreadySyncingImpl;

  factory _SyncStatusAlreadySyncing.fromJson(Map<String, dynamic> json) =
      _$SyncStatusAlreadySyncingImpl.fromJson;
}

PendingChange _$PendingChangeFromJson(Map<String, dynamic> json) {
  return _PendingChange.fromJson(json);
}

/// @nodoc
mixin _$PendingChange {
  int? get id => throw _privateConstructorUsedError;
  String get tableName => throw _privateConstructorUsedError;
  String get recordId => throw _privateConstructorUsedError;
  PendingOperation get operation => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;

  /// Serializes this PendingChange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PendingChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PendingChangeCopyWith<PendingChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PendingChangeCopyWith<$Res> {
  factory $PendingChangeCopyWith(
          PendingChange value, $Res Function(PendingChange) then) =
      _$PendingChangeCopyWithImpl<$Res, PendingChange>;
  @useResult
  $Res call(
      {int? id,
      String tableName,
      String recordId,
      PendingOperation operation,
      Map<String, dynamic> data,
      DateTime createdAt,
      bool synced});
}

/// @nodoc
class _$PendingChangeCopyWithImpl<$Res, $Val extends PendingChange>
    implements $PendingChangeCopyWith<$Res> {
  _$PendingChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PendingChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tableName = null,
    Object? recordId = null,
    Object? operation = null,
    Object? data = null,
    Object? createdAt = null,
    Object? synced = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tableName: null == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String,
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as PendingOperation,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PendingChangeImplCopyWith<$Res>
    implements $PendingChangeCopyWith<$Res> {
  factory _$$PendingChangeImplCopyWith(
          _$PendingChangeImpl value, $Res Function(_$PendingChangeImpl) then) =
      __$$PendingChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String tableName,
      String recordId,
      PendingOperation operation,
      Map<String, dynamic> data,
      DateTime createdAt,
      bool synced});
}

/// @nodoc
class __$$PendingChangeImplCopyWithImpl<$Res>
    extends _$PendingChangeCopyWithImpl<$Res, _$PendingChangeImpl>
    implements _$$PendingChangeImplCopyWith<$Res> {
  __$$PendingChangeImplCopyWithImpl(
      _$PendingChangeImpl _value, $Res Function(_$PendingChangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PendingChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tableName = null,
    Object? recordId = null,
    Object? operation = null,
    Object? data = null,
    Object? createdAt = null,
    Object? synced = null,
  }) {
    return _then(_$PendingChangeImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tableName: null == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String,
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as PendingOperation,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PendingChangeImpl implements _PendingChange {
  const _$PendingChangeImpl(
      {this.id,
      required this.tableName,
      required this.recordId,
      required this.operation,
      required final Map<String, dynamic> data,
      required this.createdAt,
      this.synced = false})
      : _data = data;

  factory _$PendingChangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PendingChangeImplFromJson(json);

  @override
  final int? id;
  @override
  final String tableName;
  @override
  final String recordId;
  @override
  final PendingOperation operation;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool synced;

  @override
  String toString() {
    return 'PendingChange(id: $id, tableName: $tableName, recordId: $recordId, operation: $operation, data: $data, createdAt: $createdAt, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingChangeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.synced, synced) || other.synced == synced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, tableName, recordId,
      operation, const DeepCollectionEquality().hash(_data), createdAt, synced);

  /// Create a copy of PendingChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingChangeImplCopyWith<_$PendingChangeImpl> get copyWith =>
      __$$PendingChangeImplCopyWithImpl<_$PendingChangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PendingChangeImplToJson(
      this,
    );
  }
}

abstract class _PendingChange implements PendingChange {
  const factory _PendingChange(
      {final int? id,
      required final String tableName,
      required final String recordId,
      required final PendingOperation operation,
      required final Map<String, dynamic> data,
      required final DateTime createdAt,
      final bool synced}) = _$PendingChangeImpl;

  factory _PendingChange.fromJson(Map<String, dynamic> json) =
      _$PendingChangeImpl.fromJson;

  @override
  int? get id;
  @override
  String get tableName;
  @override
  String get recordId;
  @override
  PendingOperation get operation;
  @override
  Map<String, dynamic> get data;
  @override
  DateTime get createdAt;
  @override
  bool get synced;

  /// Create a copy of PendingChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PendingChangeImplCopyWith<_$PendingChangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncMetadata _$SyncMetadataFromJson(Map<String, dynamic> json) {
  return _SyncMetadata.fromJson(json);
}

/// @nodoc
mixin _$SyncMetadata {
  int? get id => throw _privateConstructorUsedError;
  String get tableName => throw _privateConstructorUsedError;
  DateTime get lastSyncAt => throw _privateConstructorUsedError;
  int get lastSyncVersion => throw _privateConstructorUsedError;

  /// Serializes this SyncMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncMetadataCopyWith<SyncMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncMetadataCopyWith<$Res> {
  factory $SyncMetadataCopyWith(
          SyncMetadata value, $Res Function(SyncMetadata) then) =
      _$SyncMetadataCopyWithImpl<$Res, SyncMetadata>;
  @useResult
  $Res call(
      {int? id, String tableName, DateTime lastSyncAt, int lastSyncVersion});
}

/// @nodoc
class _$SyncMetadataCopyWithImpl<$Res, $Val extends SyncMetadata>
    implements $SyncMetadataCopyWith<$Res> {
  _$SyncMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tableName = null,
    Object? lastSyncAt = null,
    Object? lastSyncVersion = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tableName: null == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncAt: null == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncVersion: null == lastSyncVersion
          ? _value.lastSyncVersion
          : lastSyncVersion // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncMetadataImplCopyWith<$Res>
    implements $SyncMetadataCopyWith<$Res> {
  factory _$$SyncMetadataImplCopyWith(
          _$SyncMetadataImpl value, $Res Function(_$SyncMetadataImpl) then) =
      __$$SyncMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id, String tableName, DateTime lastSyncAt, int lastSyncVersion});
}

/// @nodoc
class __$$SyncMetadataImplCopyWithImpl<$Res>
    extends _$SyncMetadataCopyWithImpl<$Res, _$SyncMetadataImpl>
    implements _$$SyncMetadataImplCopyWith<$Res> {
  __$$SyncMetadataImplCopyWithImpl(
      _$SyncMetadataImpl _value, $Res Function(_$SyncMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tableName = null,
    Object? lastSyncAt = null,
    Object? lastSyncVersion = null,
  }) {
    return _then(_$SyncMetadataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      tableName: null == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncAt: null == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncVersion: null == lastSyncVersion
          ? _value.lastSyncVersion
          : lastSyncVersion // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncMetadataImpl implements _SyncMetadata {
  const _$SyncMetadataImpl(
      {this.id,
      required this.tableName,
      required this.lastSyncAt,
      this.lastSyncVersion = 0});

  factory _$SyncMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncMetadataImplFromJson(json);

  @override
  final int? id;
  @override
  final String tableName;
  @override
  final DateTime lastSyncAt;
  @override
  @JsonKey()
  final int lastSyncVersion;

  @override
  String toString() {
    return 'SyncMetadata(id: $id, tableName: $tableName, lastSyncAt: $lastSyncAt, lastSyncVersion: $lastSyncVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncMetadataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.lastSyncVersion, lastSyncVersion) ||
                other.lastSyncVersion == lastSyncVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tableName, lastSyncAt, lastSyncVersion);

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncMetadataImplCopyWith<_$SyncMetadataImpl> get copyWith =>
      __$$SyncMetadataImplCopyWithImpl<_$SyncMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncMetadataImplToJson(
      this,
    );
  }
}

abstract class _SyncMetadata implements SyncMetadata {
  const factory _SyncMetadata(
      {final int? id,
      required final String tableName,
      required final DateTime lastSyncAt,
      final int lastSyncVersion}) = _$SyncMetadataImpl;

  factory _SyncMetadata.fromJson(Map<String, dynamic> json) =
      _$SyncMetadataImpl.fromJson;

  @override
  int? get id;
  @override
  String get tableName;
  @override
  DateTime get lastSyncAt;
  @override
  int get lastSyncVersion;

  /// Create a copy of SyncMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncMetadataImplCopyWith<_$SyncMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
