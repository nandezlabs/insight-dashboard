// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_calendar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessCalendar _$BusinessCalendarFromJson(Map<String, dynamic> json) {
  return _BusinessCalendar.fromJson(json);
}

/// @nodoc
mixin _$BusinessCalendar {
  String get id => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  int get currentWeek => throw _privateConstructorUsedError;
  int get currentPeriod => throw _privateConstructorUsedError;
  int get currentQuarter => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BusinessCalendar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessCalendar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessCalendarCopyWith<BusinessCalendar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessCalendarCopyWith<$Res> {
  factory $BusinessCalendarCopyWith(
          BusinessCalendar value, $Res Function(BusinessCalendar) then) =
      _$BusinessCalendarCopyWithImpl<$Res, BusinessCalendar>;
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      int currentWeek,
      int currentPeriod,
      int currentQuarter,
      DateTime updatedAt});
}

/// @nodoc
class _$BusinessCalendarCopyWithImpl<$Res, $Val extends BusinessCalendar>
    implements $BusinessCalendarCopyWith<$Res> {
  _$BusinessCalendarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessCalendar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? currentWeek = null,
    Object? currentPeriod = null,
    Object? currentQuarter = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentWeek: null == currentWeek
          ? _value.currentWeek
          : currentWeek // ignore: cast_nullable_to_non_nullable
              as int,
      currentPeriod: null == currentPeriod
          ? _value.currentPeriod
          : currentPeriod // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuarter: null == currentQuarter
          ? _value.currentQuarter
          : currentQuarter // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessCalendarImplCopyWith<$Res>
    implements $BusinessCalendarCopyWith<$Res> {
  factory _$$BusinessCalendarImplCopyWith(_$BusinessCalendarImpl value,
          $Res Function(_$BusinessCalendarImpl) then) =
      __$$BusinessCalendarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startDate,
      int currentWeek,
      int currentPeriod,
      int currentQuarter,
      DateTime updatedAt});
}

/// @nodoc
class __$$BusinessCalendarImplCopyWithImpl<$Res>
    extends _$BusinessCalendarCopyWithImpl<$Res, _$BusinessCalendarImpl>
    implements _$$BusinessCalendarImplCopyWith<$Res> {
  __$$BusinessCalendarImplCopyWithImpl(_$BusinessCalendarImpl _value,
      $Res Function(_$BusinessCalendarImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusinessCalendar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startDate = null,
    Object? currentWeek = null,
    Object? currentPeriod = null,
    Object? currentQuarter = null,
    Object? updatedAt = null,
  }) {
    return _then(_$BusinessCalendarImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentWeek: null == currentWeek
          ? _value.currentWeek
          : currentWeek // ignore: cast_nullable_to_non_nullable
              as int,
      currentPeriod: null == currentPeriod
          ? _value.currentPeriod
          : currentPeriod // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuarter: null == currentQuarter
          ? _value.currentQuarter
          : currentQuarter // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessCalendarImpl implements _BusinessCalendar {
  const _$BusinessCalendarImpl(
      {required this.id,
      required this.startDate,
      required this.currentWeek,
      required this.currentPeriod,
      required this.currentQuarter,
      required this.updatedAt});

  factory _$BusinessCalendarImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessCalendarImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startDate;
  @override
  final int currentWeek;
  @override
  final int currentPeriod;
  @override
  final int currentQuarter;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BusinessCalendar(id: $id, startDate: $startDate, currentWeek: $currentWeek, currentPeriod: $currentPeriod, currentQuarter: $currentQuarter, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessCalendarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.currentWeek, currentWeek) ||
                other.currentWeek == currentWeek) &&
            (identical(other.currentPeriod, currentPeriod) ||
                other.currentPeriod == currentPeriod) &&
            (identical(other.currentQuarter, currentQuarter) ||
                other.currentQuarter == currentQuarter) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, startDate, currentWeek,
      currentPeriod, currentQuarter, updatedAt);

  /// Create a copy of BusinessCalendar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessCalendarImplCopyWith<_$BusinessCalendarImpl> get copyWith =>
      __$$BusinessCalendarImplCopyWithImpl<_$BusinessCalendarImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessCalendarImplToJson(
      this,
    );
  }
}

abstract class _BusinessCalendar implements BusinessCalendar {
  const factory _BusinessCalendar(
      {required final String id,
      required final DateTime startDate,
      required final int currentWeek,
      required final int currentPeriod,
      required final int currentQuarter,
      required final DateTime updatedAt}) = _$BusinessCalendarImpl;

  factory _BusinessCalendar.fromJson(Map<String, dynamic> json) =
      _$BusinessCalendarImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startDate;
  @override
  int get currentWeek;
  @override
  int get currentPeriod;
  @override
  int get currentQuarter;
  @override
  DateTime get updatedAt;

  /// Create a copy of BusinessCalendar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessCalendarImplCopyWith<_$BusinessCalendarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessPeriod _$BusinessPeriodFromJson(Map<String, dynamic> json) {
  return _BusinessPeriod.fromJson(json);
}

/// @nodoc
mixin _$BusinessPeriod {
  int get week => throw _privateConstructorUsedError;
  int get period => throw _privateConstructorUsedError;
  int get quarter => throw _privateConstructorUsedError;
  DateTime get currentDate => throw _privateConstructorUsedError;

  /// Serializes this BusinessPeriod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessPeriodCopyWith<BusinessPeriod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessPeriodCopyWith<$Res> {
  factory $BusinessPeriodCopyWith(
          BusinessPeriod value, $Res Function(BusinessPeriod) then) =
      _$BusinessPeriodCopyWithImpl<$Res, BusinessPeriod>;
  @useResult
  $Res call({int week, int period, int quarter, DateTime currentDate});
}

/// @nodoc
class _$BusinessPeriodCopyWithImpl<$Res, $Val extends BusinessPeriod>
    implements $BusinessPeriodCopyWith<$Res> {
  _$BusinessPeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? week = null,
    Object? period = null,
    Object? quarter = null,
    Object? currentDate = null,
  }) {
    return _then(_value.copyWith(
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as int,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as int,
      quarter: null == quarter
          ? _value.quarter
          : quarter // ignore: cast_nullable_to_non_nullable
              as int,
      currentDate: null == currentDate
          ? _value.currentDate
          : currentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessPeriodImplCopyWith<$Res>
    implements $BusinessPeriodCopyWith<$Res> {
  factory _$$BusinessPeriodImplCopyWith(_$BusinessPeriodImpl value,
          $Res Function(_$BusinessPeriodImpl) then) =
      __$$BusinessPeriodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int week, int period, int quarter, DateTime currentDate});
}

/// @nodoc
class __$$BusinessPeriodImplCopyWithImpl<$Res>
    extends _$BusinessPeriodCopyWithImpl<$Res, _$BusinessPeriodImpl>
    implements _$$BusinessPeriodImplCopyWith<$Res> {
  __$$BusinessPeriodImplCopyWithImpl(
      _$BusinessPeriodImpl _value, $Res Function(_$BusinessPeriodImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusinessPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? week = null,
    Object? period = null,
    Object? quarter = null,
    Object? currentDate = null,
  }) {
    return _then(_$BusinessPeriodImpl(
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as int,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as int,
      quarter: null == quarter
          ? _value.quarter
          : quarter // ignore: cast_nullable_to_non_nullable
              as int,
      currentDate: null == currentDate
          ? _value.currentDate
          : currentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessPeriodImpl implements _BusinessPeriod {
  const _$BusinessPeriodImpl(
      {required this.week,
      required this.period,
      required this.quarter,
      required this.currentDate});

  factory _$BusinessPeriodImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessPeriodImplFromJson(json);

  @override
  final int week;
  @override
  final int period;
  @override
  final int quarter;
  @override
  final DateTime currentDate;

  @override
  String toString() {
    return 'BusinessPeriod(week: $week, period: $period, quarter: $quarter, currentDate: $currentDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessPeriodImpl &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.quarter, quarter) || other.quarter == quarter) &&
            (identical(other.currentDate, currentDate) ||
                other.currentDate == currentDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, week, period, quarter, currentDate);

  /// Create a copy of BusinessPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessPeriodImplCopyWith<_$BusinessPeriodImpl> get copyWith =>
      __$$BusinessPeriodImplCopyWithImpl<_$BusinessPeriodImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessPeriodImplToJson(
      this,
    );
  }
}

abstract class _BusinessPeriod implements BusinessPeriod {
  const factory _BusinessPeriod(
      {required final int week,
      required final int period,
      required final int quarter,
      required final DateTime currentDate}) = _$BusinessPeriodImpl;

  factory _BusinessPeriod.fromJson(Map<String, dynamic> json) =
      _$BusinessPeriodImpl.fromJson;

  @override
  int get week;
  @override
  int get period;
  @override
  int get quarter;
  @override
  DateTime get currentDate;

  /// Create a copy of BusinessPeriod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessPeriodImplCopyWith<_$BusinessPeriodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
