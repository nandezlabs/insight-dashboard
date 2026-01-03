// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Submission _$SubmissionFromJson(Map<String, dynamic> json) {
  return _Submission.fromJson(json);
}

/// @nodoc
mixin _$Submission {
  String get id => throw _privateConstructorUsedError;
  String get formId => throw _privateConstructorUsedError;
  String get submittedBy => throw _privateConstructorUsedError;
  DateTime get submissionDate => throw _privateConstructorUsedError;
  DateTime get submissionTime => throw _privateConstructorUsedError;
  SubmissionStatus get status => throw _privateConstructorUsedError;
  double get completionPercentage => throw _privateConstructorUsedError;
  bool get isAutoSubmitted => throw _privateConstructorUsedError;
  List<SubmissionAnswer> get answers => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Submission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmissionCopyWith<Submission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmissionCopyWith<$Res> {
  factory $SubmissionCopyWith(
          Submission value, $Res Function(Submission) then) =
      _$SubmissionCopyWithImpl<$Res, Submission>;
  @useResult
  $Res call(
      {String id,
      String formId,
      String submittedBy,
      DateTime submissionDate,
      DateTime submissionTime,
      SubmissionStatus status,
      double completionPercentage,
      bool isAutoSubmitted,
      List<SubmissionAnswer> answers,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$SubmissionCopyWithImpl<$Res, $Val extends Submission>
    implements $SubmissionCopyWith<$Res> {
  _$SubmissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formId = null,
    Object? submittedBy = null,
    Object? submissionDate = null,
    Object? submissionTime = null,
    Object? status = null,
    Object? completionPercentage = null,
    Object? isAutoSubmitted = null,
    Object? answers = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      formId: null == formId
          ? _value.formId
          : formId // ignore: cast_nullable_to_non_nullable
              as String,
      submittedBy: null == submittedBy
          ? _value.submittedBy
          : submittedBy // ignore: cast_nullable_to_non_nullable
              as String,
      submissionDate: null == submissionDate
          ? _value.submissionDate
          : submissionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      submissionTime: null == submissionTime
          ? _value.submissionTime
          : submissionTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubmissionStatus,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      isAutoSubmitted: null == isAutoSubmitted
          ? _value.isAutoSubmitted
          : isAutoSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<SubmissionAnswer>,
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
abstract class _$$SubmissionImplCopyWith<$Res>
    implements $SubmissionCopyWith<$Res> {
  factory _$$SubmissionImplCopyWith(
          _$SubmissionImpl value, $Res Function(_$SubmissionImpl) then) =
      __$$SubmissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String formId,
      String submittedBy,
      DateTime submissionDate,
      DateTime submissionTime,
      SubmissionStatus status,
      double completionPercentage,
      bool isAutoSubmitted,
      List<SubmissionAnswer> answers,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$SubmissionImplCopyWithImpl<$Res>
    extends _$SubmissionCopyWithImpl<$Res, _$SubmissionImpl>
    implements _$$SubmissionImplCopyWith<$Res> {
  __$$SubmissionImplCopyWithImpl(
      _$SubmissionImpl _value, $Res Function(_$SubmissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formId = null,
    Object? submittedBy = null,
    Object? submissionDate = null,
    Object? submissionTime = null,
    Object? status = null,
    Object? completionPercentage = null,
    Object? isAutoSubmitted = null,
    Object? answers = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SubmissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      formId: null == formId
          ? _value.formId
          : formId // ignore: cast_nullable_to_non_nullable
              as String,
      submittedBy: null == submittedBy
          ? _value.submittedBy
          : submittedBy // ignore: cast_nullable_to_non_nullable
              as String,
      submissionDate: null == submissionDate
          ? _value.submissionDate
          : submissionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      submissionTime: null == submissionTime
          ? _value.submissionTime
          : submissionTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubmissionStatus,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      isAutoSubmitted: null == isAutoSubmitted
          ? _value.isAutoSubmitted
          : isAutoSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<SubmissionAnswer>,
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
class _$SubmissionImpl implements _Submission {
  const _$SubmissionImpl(
      {required this.id,
      required this.formId,
      required this.submittedBy,
      required this.submissionDate,
      required this.submissionTime,
      this.status = SubmissionStatus.inProgress,
      this.completionPercentage = 0.0,
      this.isAutoSubmitted = false,
      final List<SubmissionAnswer> answers = const [],
      required this.createdAt,
      required this.updatedAt})
      : _answers = answers;

  factory _$SubmissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmissionImplFromJson(json);

  @override
  final String id;
  @override
  final String formId;
  @override
  final String submittedBy;
  @override
  final DateTime submissionDate;
  @override
  final DateTime submissionTime;
  @override
  @JsonKey()
  final SubmissionStatus status;
  @override
  @JsonKey()
  final double completionPercentage;
  @override
  @JsonKey()
  final bool isAutoSubmitted;
  final List<SubmissionAnswer> _answers;
  @override
  @JsonKey()
  List<SubmissionAnswer> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Submission(id: $id, formId: $formId, submittedBy: $submittedBy, submissionDate: $submissionDate, submissionTime: $submissionTime, status: $status, completionPercentage: $completionPercentage, isAutoSubmitted: $isAutoSubmitted, answers: $answers, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.formId, formId) || other.formId == formId) &&
            (identical(other.submittedBy, submittedBy) ||
                other.submittedBy == submittedBy) &&
            (identical(other.submissionDate, submissionDate) ||
                other.submissionDate == submissionDate) &&
            (identical(other.submissionTime, submissionTime) ||
                other.submissionTime == submissionTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.isAutoSubmitted, isAutoSubmitted) ||
                other.isAutoSubmitted == isAutoSubmitted) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
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
      formId,
      submittedBy,
      submissionDate,
      submissionTime,
      status,
      completionPercentage,
      isAutoSubmitted,
      const DeepCollectionEquality().hash(_answers),
      createdAt,
      updatedAt);

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmissionImplCopyWith<_$SubmissionImpl> get copyWith =>
      __$$SubmissionImplCopyWithImpl<_$SubmissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmissionImplToJson(
      this,
    );
  }
}

abstract class _Submission implements Submission {
  const factory _Submission(
      {required final String id,
      required final String formId,
      required final String submittedBy,
      required final DateTime submissionDate,
      required final DateTime submissionTime,
      final SubmissionStatus status,
      final double completionPercentage,
      final bool isAutoSubmitted,
      final List<SubmissionAnswer> answers,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$SubmissionImpl;

  factory _Submission.fromJson(Map<String, dynamic> json) =
      _$SubmissionImpl.fromJson;

  @override
  String get id;
  @override
  String get formId;
  @override
  String get submittedBy;
  @override
  DateTime get submissionDate;
  @override
  DateTime get submissionTime;
  @override
  SubmissionStatus get status;
  @override
  double get completionPercentage;
  @override
  bool get isAutoSubmitted;
  @override
  List<SubmissionAnswer> get answers;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Submission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmissionImplCopyWith<_$SubmissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubmissionAnswer _$SubmissionAnswerFromJson(Map<String, dynamic> json) {
  return _SubmissionAnswer.fromJson(json);
}

/// @nodoc
mixin _$SubmissionAnswer {
  String get id => throw _privateConstructorUsedError;
  String get submissionId => throw _privateConstructorUsedError;
  String get fieldId => throw _privateConstructorUsedError;
  String get fieldLabel => throw _privateConstructorUsedError;
  String? get answerValue => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get fileUrl => throw _privateConstructorUsedError;
  DateTime get answeredAt => throw _privateConstructorUsedError;

  /// Serializes this SubmissionAnswer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmissionAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmissionAnswerCopyWith<SubmissionAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmissionAnswerCopyWith<$Res> {
  factory $SubmissionAnswerCopyWith(
          SubmissionAnswer value, $Res Function(SubmissionAnswer) then) =
      _$SubmissionAnswerCopyWithImpl<$Res, SubmissionAnswer>;
  @useResult
  $Res call(
      {String id,
      String submissionId,
      String fieldId,
      String fieldLabel,
      String? answerValue,
      String? value,
      String? fileUrl,
      DateTime answeredAt});
}

/// @nodoc
class _$SubmissionAnswerCopyWithImpl<$Res, $Val extends SubmissionAnswer>
    implements $SubmissionAnswerCopyWith<$Res> {
  _$SubmissionAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmissionAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? submissionId = null,
    Object? fieldId = null,
    Object? fieldLabel = null,
    Object? answerValue = freezed,
    Object? value = freezed,
    Object? fileUrl = freezed,
    Object? answeredAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      submissionId: null == submissionId
          ? _value.submissionId
          : submissionId // ignore: cast_nullable_to_non_nullable
              as String,
      fieldId: null == fieldId
          ? _value.fieldId
          : fieldId // ignore: cast_nullable_to_non_nullable
              as String,
      fieldLabel: null == fieldLabel
          ? _value.fieldLabel
          : fieldLabel // ignore: cast_nullable_to_non_nullable
              as String,
      answerValue: freezed == answerValue
          ? _value.answerValue
          : answerValue // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      answeredAt: null == answeredAt
          ? _value.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubmissionAnswerImplCopyWith<$Res>
    implements $SubmissionAnswerCopyWith<$Res> {
  factory _$$SubmissionAnswerImplCopyWith(_$SubmissionAnswerImpl value,
          $Res Function(_$SubmissionAnswerImpl) then) =
      __$$SubmissionAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String submissionId,
      String fieldId,
      String fieldLabel,
      String? answerValue,
      String? value,
      String? fileUrl,
      DateTime answeredAt});
}

/// @nodoc
class __$$SubmissionAnswerImplCopyWithImpl<$Res>
    extends _$SubmissionAnswerCopyWithImpl<$Res, _$SubmissionAnswerImpl>
    implements _$$SubmissionAnswerImplCopyWith<$Res> {
  __$$SubmissionAnswerImplCopyWithImpl(_$SubmissionAnswerImpl _value,
      $Res Function(_$SubmissionAnswerImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubmissionAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? submissionId = null,
    Object? fieldId = null,
    Object? fieldLabel = null,
    Object? answerValue = freezed,
    Object? value = freezed,
    Object? fileUrl = freezed,
    Object? answeredAt = null,
  }) {
    return _then(_$SubmissionAnswerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      submissionId: null == submissionId
          ? _value.submissionId
          : submissionId // ignore: cast_nullable_to_non_nullable
              as String,
      fieldId: null == fieldId
          ? _value.fieldId
          : fieldId // ignore: cast_nullable_to_non_nullable
              as String,
      fieldLabel: null == fieldLabel
          ? _value.fieldLabel
          : fieldLabel // ignore: cast_nullable_to_non_nullable
              as String,
      answerValue: freezed == answerValue
          ? _value.answerValue
          : answerValue // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      answeredAt: null == answeredAt
          ? _value.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmissionAnswerImpl implements _SubmissionAnswer {
  const _$SubmissionAnswerImpl(
      {required this.id,
      required this.submissionId,
      required this.fieldId,
      required this.fieldLabel,
      this.answerValue,
      this.value,
      this.fileUrl,
      required this.answeredAt});

  factory _$SubmissionAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmissionAnswerImplFromJson(json);

  @override
  final String id;
  @override
  final String submissionId;
  @override
  final String fieldId;
  @override
  final String fieldLabel;
  @override
  final String? answerValue;
  @override
  final String? value;
  @override
  final String? fileUrl;
  @override
  final DateTime answeredAt;

  @override
  String toString() {
    return 'SubmissionAnswer(id: $id, submissionId: $submissionId, fieldId: $fieldId, fieldLabel: $fieldLabel, answerValue: $answerValue, value: $value, fileUrl: $fileUrl, answeredAt: $answeredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmissionAnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.submissionId, submissionId) ||
                other.submissionId == submissionId) &&
            (identical(other.fieldId, fieldId) || other.fieldId == fieldId) &&
            (identical(other.fieldLabel, fieldLabel) ||
                other.fieldLabel == fieldLabel) &&
            (identical(other.answerValue, answerValue) ||
                other.answerValue == answerValue) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, submissionId, fieldId,
      fieldLabel, answerValue, value, fileUrl, answeredAt);

  /// Create a copy of SubmissionAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmissionAnswerImplCopyWith<_$SubmissionAnswerImpl> get copyWith =>
      __$$SubmissionAnswerImplCopyWithImpl<_$SubmissionAnswerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmissionAnswerImplToJson(
      this,
    );
  }
}

abstract class _SubmissionAnswer implements SubmissionAnswer {
  const factory _SubmissionAnswer(
      {required final String id,
      required final String submissionId,
      required final String fieldId,
      required final String fieldLabel,
      final String? answerValue,
      final String? value,
      final String? fileUrl,
      required final DateTime answeredAt}) = _$SubmissionAnswerImpl;

  factory _SubmissionAnswer.fromJson(Map<String, dynamic> json) =
      _$SubmissionAnswerImpl.fromJson;

  @override
  String get id;
  @override
  String get submissionId;
  @override
  String get fieldId;
  @override
  String get fieldLabel;
  @override
  String? get answerValue;
  @override
  String? get value;
  @override
  String? get fileUrl;
  @override
  DateTime get answeredAt;

  /// Create a copy of SubmissionAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmissionAnswerImplCopyWith<_$SubmissionAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
