// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GeofenceSettings _$GeofenceSettingsFromJson(Map<String, dynamic> json) {
  return _GeofenceSettings.fromJson(json);
}

/// @nodoc
mixin _$GeofenceSettings {
  String get id => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  int get radiusMeters => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  bool get testMode => throw _privateConstructorUsedError;

  /// Serializes this GeofenceSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeofenceSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeofenceSettingsCopyWith<GeofenceSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceSettingsCopyWith<$Res> {
  factory $GeofenceSettingsCopyWith(
          GeofenceSettings value, $Res Function(GeofenceSettings) then) =
      _$GeofenceSettingsCopyWithImpl<$Res, GeofenceSettings>;
  @useResult
  $Res call(
      {String id,
      String address,
      double latitude,
      double longitude,
      int radiusMeters,
      bool enabled,
      bool testMode});
}

/// @nodoc
class _$GeofenceSettingsCopyWithImpl<$Res, $Val extends GeofenceSettings>
    implements $GeofenceSettingsCopyWith<$Res> {
  _$GeofenceSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeofenceSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radiusMeters = null,
    Object? enabled = null,
    Object? testMode = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      radiusMeters: null == radiusMeters
          ? _value.radiusMeters
          : radiusMeters // ignore: cast_nullable_to_non_nullable
              as int,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      testMode: null == testMode
          ? _value.testMode
          : testMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeofenceSettingsImplCopyWith<$Res>
    implements $GeofenceSettingsCopyWith<$Res> {
  factory _$$GeofenceSettingsImplCopyWith(_$GeofenceSettingsImpl value,
          $Res Function(_$GeofenceSettingsImpl) then) =
      __$$GeofenceSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String address,
      double latitude,
      double longitude,
      int radiusMeters,
      bool enabled,
      bool testMode});
}

/// @nodoc
class __$$GeofenceSettingsImplCopyWithImpl<$Res>
    extends _$GeofenceSettingsCopyWithImpl<$Res, _$GeofenceSettingsImpl>
    implements _$$GeofenceSettingsImplCopyWith<$Res> {
  __$$GeofenceSettingsImplCopyWithImpl(_$GeofenceSettingsImpl _value,
      $Res Function(_$GeofenceSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeofenceSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radiusMeters = null,
    Object? enabled = null,
    Object? testMode = null,
  }) {
    return _then(_$GeofenceSettingsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      radiusMeters: null == radiusMeters
          ? _value.radiusMeters
          : radiusMeters // ignore: cast_nullable_to_non_nullable
              as int,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      testMode: null == testMode
          ? _value.testMode
          : testMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeofenceSettingsImpl implements _GeofenceSettings {
  const _$GeofenceSettingsImpl(
      {required this.id,
      required this.address,
      required this.latitude,
      required this.longitude,
      this.radiusMeters = 100,
      this.enabled = true,
      this.testMode = false});

  factory _$GeofenceSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeofenceSettingsImplFromJson(json);

  @override
  final String id;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey()
  final int radiusMeters;
  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool testMode;

  @override
  String toString() {
    return 'GeofenceSettings(id: $id, address: $address, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, enabled: $enabled, testMode: $testMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeofenceSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.radiusMeters, radiusMeters) ||
                other.radiusMeters == radiusMeters) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.testMode, testMode) ||
                other.testMode == testMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, address, latitude, longitude,
      radiusMeters, enabled, testMode);

  /// Create a copy of GeofenceSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeofenceSettingsImplCopyWith<_$GeofenceSettingsImpl> get copyWith =>
      __$$GeofenceSettingsImplCopyWithImpl<_$GeofenceSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeofenceSettingsImplToJson(
      this,
    );
  }
}

abstract class _GeofenceSettings implements GeofenceSettings {
  const factory _GeofenceSettings(
      {required final String id,
      required final String address,
      required final double latitude,
      required final double longitude,
      final int radiusMeters,
      final bool enabled,
      final bool testMode}) = _$GeofenceSettingsImpl;

  factory _GeofenceSettings.fromJson(Map<String, dynamic> json) =
      _$GeofenceSettingsImpl.fromJson;

  @override
  String get id;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  int get radiusMeters;
  @override
  bool get enabled;
  @override
  bool get testMode;

  /// Create a copy of GeofenceSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeofenceSettingsImplCopyWith<_$GeofenceSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
