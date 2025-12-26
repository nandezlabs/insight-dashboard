// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeframe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Timeframe _$TimeframeFromJson(Map<String, dynamic> json) {
  return _Timeframe.fromJson(json);
}

/// @nodoc
mixin _$Timeframe {
  String get id => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String get autoSubmitTime => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this Timeframe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Timeframe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeframeCopyWith<Timeframe> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeframeCopyWith<$Res> {
  factory $TimeframeCopyWith(Timeframe value, $Res Function(Timeframe) then) =
      _$TimeframeCopyWithImpl<$Res, Timeframe>;
  @useResult
  $Res call(
      {String id,
      String tag,
      String startTime,
      String endTime,
      String autoSubmitTime,
      bool isDefault});
}

/// @nodoc
class _$TimeframeCopyWithImpl<$Res, $Val extends Timeframe>
    implements $TimeframeCopyWith<$Res> {
  _$TimeframeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Timeframe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tag = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? autoSubmitTime = null,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      autoSubmitTime: null == autoSubmitTime
          ? _value.autoSubmitTime
          : autoSubmitTime // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeframeImplCopyWith<$Res>
    implements $TimeframeCopyWith<$Res> {
  factory _$$TimeframeImplCopyWith(
          _$TimeframeImpl value, $Res Function(_$TimeframeImpl) then) =
      __$$TimeframeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tag,
      String startTime,
      String endTime,
      String autoSubmitTime,
      bool isDefault});
}

/// @nodoc
class __$$TimeframeImplCopyWithImpl<$Res>
    extends _$TimeframeCopyWithImpl<$Res, _$TimeframeImpl>
    implements _$$TimeframeImplCopyWith<$Res> {
  __$$TimeframeImplCopyWithImpl(
      _$TimeframeImpl _value, $Res Function(_$TimeframeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Timeframe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tag = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? autoSubmitTime = null,
    Object? isDefault = null,
  }) {
    return _then(_$TimeframeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      autoSubmitTime: null == autoSubmitTime
          ? _value.autoSubmitTime
          : autoSubmitTime // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeframeImpl implements _Timeframe {
  const _$TimeframeImpl(
      {required this.id,
      required this.tag,
      required this.startTime,
      required this.endTime,
      required this.autoSubmitTime,
      this.isDefault = false});

  factory _$TimeframeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeframeImplFromJson(json);

  @override
  final String id;
  @override
  final String tag;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final String autoSubmitTime;
  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'Timeframe(id: $id, tag: $tag, startTime: $startTime, endTime: $endTime, autoSubmitTime: $autoSubmitTime, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeframeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.autoSubmitTime, autoSubmitTime) ||
                other.autoSubmitTime == autoSubmitTime) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tag, startTime, endTime, autoSubmitTime, isDefault);

  /// Create a copy of Timeframe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeframeImplCopyWith<_$TimeframeImpl> get copyWith =>
      __$$TimeframeImplCopyWithImpl<_$TimeframeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeframeImplToJson(
      this,
    );
  }
}

abstract class _Timeframe implements Timeframe {
  const factory _Timeframe(
      {required final String id,
      required final String tag,
      required final String startTime,
      required final String endTime,
      required final String autoSubmitTime,
      final bool isDefault}) = _$TimeframeImpl;

  factory _Timeframe.fromJson(Map<String, dynamic> json) =
      _$TimeframeImpl.fromJson;

  @override
  String get id;
  @override
  String get tag;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  String get autoSubmitTime;
  @override
  bool get isDefault;

  /// Create a copy of Timeframe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeframeImplCopyWith<_$TimeframeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
