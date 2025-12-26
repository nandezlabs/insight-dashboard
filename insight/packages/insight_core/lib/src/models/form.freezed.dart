// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FormModel _$FormModelFromJson(Map<String, dynamic> json) {
  return _FormModel.fromJson(json);
}

/// @nodoc
mixin _$FormModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isTemplate => throw _privateConstructorUsedError;
  FormScheduleType get scheduleType => throw _privateConstructorUsedError;
  DateTime? get customStartDate => throw _privateConstructorUsedError;
  DateTime? get customEndDate => throw _privateConstructorUsedError;
  String? get customTime => throw _privateConstructorUsedError;
  int? get maxSubmissions => throw _privateConstructorUsedError;
  FormStatus get status => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FormModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FormModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FormModelCopyWith<FormModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormModelCopyWith<$Res> {
  factory $FormModelCopyWith(FormModel value, $Res Function(FormModel) then) =
      _$FormModelCopyWithImpl<$Res, FormModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      List<String> tags,
      bool isTemplate,
      FormScheduleType scheduleType,
      DateTime? customStartDate,
      DateTime? customEndDate,
      String? customTime,
      int? maxSubmissions,
      FormStatus status,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$FormModelCopyWithImpl<$Res, $Val extends FormModel>
    implements $FormModelCopyWith<$Res> {
  _$FormModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FormModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? tags = null,
    Object? isTemplate = null,
    Object? scheduleType = null,
    Object? customStartDate = freezed,
    Object? customEndDate = freezed,
    Object? customTime = freezed,
    Object? maxSubmissions = freezed,
    Object? status = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isTemplate: null == isTemplate
          ? _value.isTemplate
          : isTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      scheduleType: null == scheduleType
          ? _value.scheduleType
          : scheduleType // ignore: cast_nullable_to_non_nullable
              as FormScheduleType,
      customStartDate: freezed == customStartDate
          ? _value.customStartDate
          : customStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customEndDate: freezed == customEndDate
          ? _value.customEndDate
          : customEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customTime: freezed == customTime
          ? _value.customTime
          : customTime // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSubmissions: freezed == maxSubmissions
          ? _value.maxSubmissions
          : maxSubmissions // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FormStatus,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$FormModelImplCopyWith<$Res>
    implements $FormModelCopyWith<$Res> {
  factory _$$FormModelImplCopyWith(
          _$FormModelImpl value, $Res Function(_$FormModelImpl) then) =
      __$$FormModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      List<String> tags,
      bool isTemplate,
      FormScheduleType scheduleType,
      DateTime? customStartDate,
      DateTime? customEndDate,
      String? customTime,
      int? maxSubmissions,
      FormStatus status,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$FormModelImplCopyWithImpl<$Res>
    extends _$FormModelCopyWithImpl<$Res, _$FormModelImpl>
    implements _$$FormModelImplCopyWith<$Res> {
  __$$FormModelImplCopyWithImpl(
      _$FormModelImpl _value, $Res Function(_$FormModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FormModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? tags = null,
    Object? isTemplate = null,
    Object? scheduleType = null,
    Object? customStartDate = freezed,
    Object? customEndDate = freezed,
    Object? customTime = freezed,
    Object? maxSubmissions = freezed,
    Object? status = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$FormModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isTemplate: null == isTemplate
          ? _value.isTemplate
          : isTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      scheduleType: null == scheduleType
          ? _value.scheduleType
          : scheduleType // ignore: cast_nullable_to_non_nullable
              as FormScheduleType,
      customStartDate: freezed == customStartDate
          ? _value.customStartDate
          : customStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customEndDate: freezed == customEndDate
          ? _value.customEndDate
          : customEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      customTime: freezed == customTime
          ? _value.customTime
          : customTime // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSubmissions: freezed == maxSubmissions
          ? _value.maxSubmissions
          : maxSubmissions // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FormStatus,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$FormModelImpl implements _FormModel {
  const _$FormModelImpl(
      {required this.id,
      required this.title,
      this.description,
      final List<String> tags = const [],
      this.isTemplate = false,
      this.scheduleType = FormScheduleType.tagBased,
      this.customStartDate,
      this.customEndDate,
      this.customTime,
      this.maxSubmissions,
      this.status = FormStatus.draft,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt})
      : _tags = tags;

  factory _$FormModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isTemplate;
  @override
  @JsonKey()
  final FormScheduleType scheduleType;
  @override
  final DateTime? customStartDate;
  @override
  final DateTime? customEndDate;
  @override
  final String? customTime;
  @override
  final int? maxSubmissions;
  @override
  @JsonKey()
  final FormStatus status;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'FormModel(id: $id, title: $title, description: $description, tags: $tags, isTemplate: $isTemplate, scheduleType: $scheduleType, customStartDate: $customStartDate, customEndDate: $customEndDate, customTime: $customTime, maxSubmissions: $maxSubmissions, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isTemplate, isTemplate) ||
                other.isTemplate == isTemplate) &&
            (identical(other.scheduleType, scheduleType) ||
                other.scheduleType == scheduleType) &&
            (identical(other.customStartDate, customStartDate) ||
                other.customStartDate == customStartDate) &&
            (identical(other.customEndDate, customEndDate) ||
                other.customEndDate == customEndDate) &&
            (identical(other.customTime, customTime) ||
                other.customTime == customTime) &&
            (identical(other.maxSubmissions, maxSubmissions) ||
                other.maxSubmissions == maxSubmissions) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
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
      title,
      description,
      const DeepCollectionEquality().hash(_tags),
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

  /// Create a copy of FormModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormModelImplCopyWith<_$FormModelImpl> get copyWith =>
      __$$FormModelImplCopyWithImpl<_$FormModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormModelImplToJson(
      this,
    );
  }
}

abstract class _FormModel implements FormModel {
  const factory _FormModel(
      {required final String id,
      required final String title,
      final String? description,
      final List<String> tags,
      final bool isTemplate,
      final FormScheduleType scheduleType,
      final DateTime? customStartDate,
      final DateTime? customEndDate,
      final String? customTime,
      final int? maxSubmissions,
      final FormStatus status,
      required final String createdBy,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$FormModelImpl;

  factory _FormModel.fromJson(Map<String, dynamic> json) =
      _$FormModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  List<String> get tags;
  @override
  bool get isTemplate;
  @override
  FormScheduleType get scheduleType;
  @override
  DateTime? get customStartDate;
  @override
  DateTime? get customEndDate;
  @override
  String? get customTime;
  @override
  int? get maxSubmissions;
  @override
  FormStatus get status;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of FormModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormModelImplCopyWith<_$FormModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FormSection _$FormSectionFromJson(Map<String, dynamic> json) {
  return _FormSection.fromJson(json);
}

/// @nodoc
mixin _$FormSection {
  String get id => throw _privateConstructorUsedError;
  String get formId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FormSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FormSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FormSectionCopyWith<FormSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormSectionCopyWith<$Res> {
  factory $FormSectionCopyWith(
          FormSection value, $Res Function(FormSection) then) =
      _$FormSectionCopyWithImpl<$Res, FormSection>;
  @useResult
  $Res call(
      {String id,
      String formId,
      String title,
      String? description,
      int order,
      DateTime createdAt});
}

/// @nodoc
class _$FormSectionCopyWithImpl<$Res, $Val extends FormSection>
    implements $FormSectionCopyWith<$Res> {
  _$FormSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FormSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formId = null,
    Object? title = null,
    Object? description = freezed,
    Object? order = null,
    Object? createdAt = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormSectionImplCopyWith<$Res>
    implements $FormSectionCopyWith<$Res> {
  factory _$$FormSectionImplCopyWith(
          _$FormSectionImpl value, $Res Function(_$FormSectionImpl) then) =
      __$$FormSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String formId,
      String title,
      String? description,
      int order,
      DateTime createdAt});
}

/// @nodoc
class __$$FormSectionImplCopyWithImpl<$Res>
    extends _$FormSectionCopyWithImpl<$Res, _$FormSectionImpl>
    implements _$$FormSectionImplCopyWith<$Res> {
  __$$FormSectionImplCopyWithImpl(
      _$FormSectionImpl _value, $Res Function(_$FormSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of FormSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formId = null,
    Object? title = null,
    Object? description = freezed,
    Object? order = null,
    Object? createdAt = null,
  }) {
    return _then(_$FormSectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      formId: null == formId
          ? _value.formId
          : formId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormSectionImpl implements _FormSection {
  const _$FormSectionImpl(
      {required this.id,
      required this.formId,
      required this.title,
      this.description,
      required this.order,
      required this.createdAt});

  factory _$FormSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormSectionImplFromJson(json);

  @override
  final String id;
  @override
  final String formId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final int order;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FormSection(id: $id, formId: $formId, title: $title, description: $description, order: $order, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormSectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.formId, formId) || other.formId == formId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, formId, title, description, order, createdAt);

  /// Create a copy of FormSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormSectionImplCopyWith<_$FormSectionImpl> get copyWith =>
      __$$FormSectionImplCopyWithImpl<_$FormSectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormSectionImplToJson(
      this,
    );
  }
}

abstract class _FormSection implements FormSection {
  const factory _FormSection(
      {required final String id,
      required final String formId,
      required final String title,
      final String? description,
      required final int order,
      required final DateTime createdAt}) = _$FormSectionImpl;

  factory _FormSection.fromJson(Map<String, dynamic> json) =
      _$FormSectionImpl.fromJson;

  @override
  String get id;
  @override
  String get formId;
  @override
  String get title;
  @override
  String? get description;
  @override
  int get order;
  @override
  DateTime get createdAt;

  /// Create a copy of FormSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormSectionImplCopyWith<_$FormSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
