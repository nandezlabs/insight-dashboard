// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kpi_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KpiData _$KpiDataFromJson(Map<String, dynamic> json) {
  return _KpiData.fromJson(json);
}

/// @nodoc
mixin _$KpiData {
  String get id => throw _privateConstructorUsedError;
  DateTime get dataDate => throw _privateConstructorUsedError;
  double? get gemScore => throw _privateConstructorUsedError;
  double? get hoursScheduled => throw _privateConstructorUsedError;
  double? get hoursRecommended => throw _privateConstructorUsedError;
  double? get laborUsedPercentage => throw _privateConstructorUsedError;
  double? get salesActual => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this KpiData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KpiData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KpiDataCopyWith<KpiData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KpiDataCopyWith<$Res> {
  factory $KpiDataCopyWith(KpiData value, $Res Function(KpiData) then) =
      _$KpiDataCopyWithImpl<$Res, KpiData>;
  @useResult
  $Res call(
      {String id,
      DateTime dataDate,
      double? gemScore,
      double? hoursScheduled,
      double? hoursRecommended,
      double? laborUsedPercentage,
      double? salesActual,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$KpiDataCopyWithImpl<$Res, $Val extends KpiData>
    implements $KpiDataCopyWith<$Res> {
  _$KpiDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KpiData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataDate = null,
    Object? gemScore = freezed,
    Object? hoursScheduled = freezed,
    Object? hoursRecommended = freezed,
    Object? laborUsedPercentage = freezed,
    Object? salesActual = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dataDate: null == dataDate
          ? _value.dataDate
          : dataDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gemScore: freezed == gemScore
          ? _value.gemScore
          : gemScore // ignore: cast_nullable_to_non_nullable
              as double?,
      hoursScheduled: freezed == hoursScheduled
          ? _value.hoursScheduled
          : hoursScheduled // ignore: cast_nullable_to_non_nullable
              as double?,
      hoursRecommended: freezed == hoursRecommended
          ? _value.hoursRecommended
          : hoursRecommended // ignore: cast_nullable_to_non_nullable
              as double?,
      laborUsedPercentage: freezed == laborUsedPercentage
          ? _value.laborUsedPercentage
          : laborUsedPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      salesActual: freezed == salesActual
          ? _value.salesActual
          : salesActual // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KpiDataImplCopyWith<$Res> implements $KpiDataCopyWith<$Res> {
  factory _$$KpiDataImplCopyWith(
          _$KpiDataImpl value, $Res Function(_$KpiDataImpl) then) =
      __$$KpiDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime dataDate,
      double? gemScore,
      double? hoursScheduled,
      double? hoursRecommended,
      double? laborUsedPercentage,
      double? salesActual,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$KpiDataImplCopyWithImpl<$Res>
    extends _$KpiDataCopyWithImpl<$Res, _$KpiDataImpl>
    implements _$$KpiDataImplCopyWith<$Res> {
  __$$KpiDataImplCopyWithImpl(
      _$KpiDataImpl _value, $Res Function(_$KpiDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of KpiData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataDate = null,
    Object? gemScore = freezed,
    Object? hoursScheduled = freezed,
    Object? hoursRecommended = freezed,
    Object? laborUsedPercentage = freezed,
    Object? salesActual = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$KpiDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dataDate: null == dataDate
          ? _value.dataDate
          : dataDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gemScore: freezed == gemScore
          ? _value.gemScore
          : gemScore // ignore: cast_nullable_to_non_nullable
              as double?,
      hoursScheduled: freezed == hoursScheduled
          ? _value.hoursScheduled
          : hoursScheduled // ignore: cast_nullable_to_non_nullable
              as double?,
      hoursRecommended: freezed == hoursRecommended
          ? _value.hoursRecommended
          : hoursRecommended // ignore: cast_nullable_to_non_nullable
              as double?,
      laborUsedPercentage: freezed == laborUsedPercentage
          ? _value.laborUsedPercentage
          : laborUsedPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      salesActual: freezed == salesActual
          ? _value.salesActual
          : salesActual // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KpiDataImpl implements _KpiData {
  const _$KpiDataImpl(
      {required this.id,
      required this.dataDate,
      this.gemScore,
      this.hoursScheduled,
      this.hoursRecommended,
      this.laborUsedPercentage,
      this.salesActual,
      required this.createdAt,
      required this.updatedAt});

  factory _$KpiDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$KpiDataImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime dataDate;
  @override
  final double? gemScore;
  @override
  final double? hoursScheduled;
  @override
  final double? hoursRecommended;
  @override
  final double? laborUsedPercentage;
  @override
  final double? salesActual;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'KpiData(id: $id, dataDate: $dataDate, gemScore: $gemScore, hoursScheduled: $hoursScheduled, hoursRecommended: $hoursRecommended, laborUsedPercentage: $laborUsedPercentage, salesActual: $salesActual, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KpiDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dataDate, dataDate) ||
                other.dataDate == dataDate) &&
            (identical(other.gemScore, gemScore) ||
                other.gemScore == gemScore) &&
            (identical(other.hoursScheduled, hoursScheduled) ||
                other.hoursScheduled == hoursScheduled) &&
            (identical(other.hoursRecommended, hoursRecommended) ||
                other.hoursRecommended == hoursRecommended) &&
            (identical(other.laborUsedPercentage, laborUsedPercentage) ||
                other.laborUsedPercentage == laborUsedPercentage) &&
            (identical(other.salesActual, salesActual) ||
                other.salesActual == salesActual) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dataDate,
      gemScore,
      hoursScheduled,
      hoursRecommended,
      laborUsedPercentage,
      salesActual,
      createdAt,
      updatedAt);

  /// Create a copy of KpiData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KpiDataImplCopyWith<_$KpiDataImpl> get copyWith =>
      __$$KpiDataImplCopyWithImpl<_$KpiDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KpiDataImplToJson(
      this,
    );
  }
}

abstract class _KpiData implements KpiData {
  const factory _KpiData(
      {required final String id,
      required final DateTime dataDate,
      final double? gemScore,
      final double? hoursScheduled,
      final double? hoursRecommended,
      final double? laborUsedPercentage,
      final double? salesActual,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$KpiDataImpl;

  factory _KpiData.fromJson(Map<String, dynamic> json) = _$KpiDataImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get dataDate;
  @override
  double? get gemScore;
  @override
  double? get hoursScheduled;
  @override
  double? get hoursRecommended;
  @override
  double? get laborUsedPercentage;
  @override
  double? get salesActual;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of KpiData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KpiDataImplCopyWith<_$KpiDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
