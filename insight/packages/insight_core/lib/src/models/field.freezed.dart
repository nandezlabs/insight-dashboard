// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Field _$FieldFromJson(Map<String, dynamic> json) {
  return _Field.fromJson(json);
}

/// @nodoc
mixin _$Field {
  String get id => throw _privateConstructorUsedError;
  String? get formId => throw _privateConstructorUsedError;
  String? get sectionId => throw _privateConstructorUsedError;
  FieldType get fieldType => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get placeholder => throw _privateConstructorUsedError;
  String? get helpText => throw _privateConstructorUsedError;
  bool get isRequired => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  Map<String, dynamic>? get validationRules =>
      throw _privateConstructorUsedError;
  String? get defaultValue => throw _privateConstructorUsedError;
  Map<String, dynamic>? get conditionalLogic =>
      throw _privateConstructorUsedError;
  String? get templateId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Field to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldCopyWith<Field> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldCopyWith<$Res> {
  factory $FieldCopyWith(Field value, $Res Function(Field) then) =
      _$FieldCopyWithImpl<$Res, Field>;
  @useResult
  $Res call(
      {String id,
      String? formId,
      String? sectionId,
      FieldType fieldType,
      String label,
      String? placeholder,
      String? helpText,
      bool isRequired,
      int order,
      Map<String, dynamic>? validationRules,
      String? defaultValue,
      Map<String, dynamic>? conditionalLogic,
      String? templateId,
      DateTime createdAt});
}

/// @nodoc
class _$FieldCopyWithImpl<$Res, $Val extends Field>
    implements $FieldCopyWith<$Res> {
  _$FieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formId = freezed,
    Object? sectionId = freezed,
    Object? fieldType = null,
    Object? label = null,
    Object? placeholder = freezed,
    Object? helpText = freezed,
    Object? isRequired = null,
    Object? order = null,
    Object? validationRules = freezed,
    Object? defaultValue = freezed,
    Object? conditionalLogic = freezed,
    Object? templateId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      formId: freezed == formId
          ? _value.formId
          : formId // ignore: cast_nullable_to_non_nullable
              as String?,
      sectionId: freezed == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldType: null == fieldType
          ? _value.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as FieldType,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      helpText: freezed == helpText
          ? _value.helpText
          : helpText // ignore: cast_nullable_to_non_nullable
              as String?,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      validationRules: freezed == validationRules
          ? _value.validationRules
          : validationRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      conditionalLogic: freezed == conditionalLogic
          ? _value.conditionalLogic
          : conditionalLogic // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FieldImplCopyWith<$Res> implements $FieldCopyWith<$Res> {
  factory _$$FieldImplCopyWith(
          _$FieldImpl value, $Res Function(_$FieldImpl) then) =
      __$$FieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? formId,
      String? sectionId,
      FieldType fieldType,
      String label,
      String? placeholder,
      String? helpText,
      bool isRequired,
      int order,
      Map<String, dynamic>? validationRules,
      String? defaultValue,
      Map<String, dynamic>? conditionalLogic,
      String? templateId,
      DateTime createdAt});
}

/// @nodoc
class __$$FieldImplCopyWithImpl<$Res>
    extends _$FieldCopyWithImpl<$Res, _$FieldImpl>
    implements _$$FieldImplCopyWith<$Res> {
  __$$FieldImplCopyWithImpl(
      _$FieldImpl _value, $Res Function(_$FieldImpl) _then)
      : super(_value, _then);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? formId = freezed,
    Object? sectionId = freezed,
    Object? fieldType = null,
    Object? label = null,
    Object? placeholder = freezed,
    Object? helpText = freezed,
    Object? isRequired = null,
    Object? order = null,
    Object? validationRules = freezed,
    Object? defaultValue = freezed,
    Object? conditionalLogic = freezed,
    Object? templateId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$FieldImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      formId: freezed == formId
          ? _value.formId
          : formId // ignore: cast_nullable_to_non_nullable
              as String?,
      sectionId: freezed == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldType: null == fieldType
          ? _value.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as FieldType,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      helpText: freezed == helpText
          ? _value.helpText
          : helpText // ignore: cast_nullable_to_non_nullable
              as String?,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      validationRules: freezed == validationRules
          ? _value._validationRules
          : validationRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      conditionalLogic: freezed == conditionalLogic
          ? _value._conditionalLogic
          : conditionalLogic // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldImpl implements _Field {
  const _$FieldImpl(
      {required this.id,
      this.formId,
      this.sectionId,
      required this.fieldType,
      required this.label,
      this.placeholder,
      this.helpText,
      this.isRequired = false,
      required this.order,
      final Map<String, dynamic>? validationRules,
      this.defaultValue,
      final Map<String, dynamic>? conditionalLogic,
      this.templateId,
      required this.createdAt})
      : _validationRules = validationRules,
        _conditionalLogic = conditionalLogic;

  factory _$FieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldImplFromJson(json);

  @override
  final String id;
  @override
  final String? formId;
  @override
  final String? sectionId;
  @override
  final FieldType fieldType;
  @override
  final String label;
  @override
  final String? placeholder;
  @override
  final String? helpText;
  @override
  @JsonKey()
  final bool isRequired;
  @override
  final int order;
  final Map<String, dynamic>? _validationRules;
  @override
  Map<String, dynamic>? get validationRules {
    final value = _validationRules;
    if (value == null) return null;
    if (_validationRules is EqualUnmodifiableMapView) return _validationRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? defaultValue;
  final Map<String, dynamic>? _conditionalLogic;
  @override
  Map<String, dynamic>? get conditionalLogic {
    final value = _conditionalLogic;
    if (value == null) return null;
    if (_conditionalLogic is EqualUnmodifiableMapView) return _conditionalLogic;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? templateId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Field(id: $id, formId: $formId, sectionId: $sectionId, fieldType: $fieldType, label: $label, placeholder: $placeholder, helpText: $helpText, isRequired: $isRequired, order: $order, validationRules: $validationRules, defaultValue: $defaultValue, conditionalLogic: $conditionalLogic, templateId: $templateId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.formId, formId) || other.formId == formId) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.fieldType, fieldType) ||
                other.fieldType == fieldType) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.helpText, helpText) ||
                other.helpText == helpText) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality()
                .equals(other._validationRules, _validationRules) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            const DeepCollectionEquality()
                .equals(other._conditionalLogic, _conditionalLogic) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      formId,
      sectionId,
      fieldType,
      label,
      placeholder,
      helpText,
      isRequired,
      order,
      const DeepCollectionEquality().hash(_validationRules),
      defaultValue,
      const DeepCollectionEquality().hash(_conditionalLogic),
      templateId,
      createdAt);

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldImplCopyWith<_$FieldImpl> get copyWith =>
      __$$FieldImplCopyWithImpl<_$FieldImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldImplToJson(
      this,
    );
  }
}

abstract class _Field implements Field {
  const factory _Field(
      {required final String id,
      final String? formId,
      final String? sectionId,
      required final FieldType fieldType,
      required final String label,
      final String? placeholder,
      final String? helpText,
      final bool isRequired,
      required final int order,
      final Map<String, dynamic>? validationRules,
      final String? defaultValue,
      final Map<String, dynamic>? conditionalLogic,
      final String? templateId,
      required final DateTime createdAt}) = _$FieldImpl;

  factory _Field.fromJson(Map<String, dynamic> json) = _$FieldImpl.fromJson;

  @override
  String get id;
  @override
  String? get formId;
  @override
  String? get sectionId;
  @override
  FieldType get fieldType;
  @override
  String get label;
  @override
  String? get placeholder;
  @override
  String? get helpText;
  @override
  bool get isRequired;
  @override
  int get order;
  @override
  Map<String, dynamic>? get validationRules;
  @override
  String? get defaultValue;
  @override
  Map<String, dynamic>? get conditionalLogic;
  @override
  String? get templateId;
  @override
  DateTime get createdAt;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldImplCopyWith<_$FieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FieldTemplate _$FieldTemplateFromJson(Map<String, dynamic> json) {
  return _FieldTemplate.fromJson(json);
}

/// @nodoc
mixin _$FieldTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  FieldType get fieldType => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get placeholder => throw _privateConstructorUsedError;
  String? get helpText => throw _privateConstructorUsedError;
  bool get isRequired => throw _privateConstructorUsedError;
  Map<String, dynamic>? get validationRules =>
      throw _privateConstructorUsedError;
  String? get defaultValue => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this FieldTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldTemplateCopyWith<FieldTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldTemplateCopyWith<$Res> {
  factory $FieldTemplateCopyWith(
          FieldTemplate value, $Res Function(FieldTemplate) then) =
      _$FieldTemplateCopyWithImpl<$Res, FieldTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      FieldType fieldType,
      String label,
      String? placeholder,
      String? helpText,
      bool isRequired,
      Map<String, dynamic>? validationRules,
      String? defaultValue,
      String createdBy,
      DateTime createdAt});
}

/// @nodoc
class _$FieldTemplateCopyWithImpl<$Res, $Val extends FieldTemplate>
    implements $FieldTemplateCopyWith<$Res> {
  _$FieldTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fieldType = null,
    Object? label = null,
    Object? placeholder = freezed,
    Object? helpText = freezed,
    Object? isRequired = null,
    Object? validationRules = freezed,
    Object? defaultValue = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fieldType: null == fieldType
          ? _value.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as FieldType,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      helpText: freezed == helpText
          ? _value.helpText
          : helpText // ignore: cast_nullable_to_non_nullable
              as String?,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      validationRules: freezed == validationRules
          ? _value.validationRules
          : validationRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FieldTemplateImplCopyWith<$Res>
    implements $FieldTemplateCopyWith<$Res> {
  factory _$$FieldTemplateImplCopyWith(
          _$FieldTemplateImpl value, $Res Function(_$FieldTemplateImpl) then) =
      __$$FieldTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      FieldType fieldType,
      String label,
      String? placeholder,
      String? helpText,
      bool isRequired,
      Map<String, dynamic>? validationRules,
      String? defaultValue,
      String createdBy,
      DateTime createdAt});
}

/// @nodoc
class __$$FieldTemplateImplCopyWithImpl<$Res>
    extends _$FieldTemplateCopyWithImpl<$Res, _$FieldTemplateImpl>
    implements _$$FieldTemplateImplCopyWith<$Res> {
  __$$FieldTemplateImplCopyWithImpl(
      _$FieldTemplateImpl _value, $Res Function(_$FieldTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fieldType = null,
    Object? label = null,
    Object? placeholder = freezed,
    Object? helpText = freezed,
    Object? isRequired = null,
    Object? validationRules = freezed,
    Object? defaultValue = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_$FieldTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fieldType: null == fieldType
          ? _value.fieldType
          : fieldType // ignore: cast_nullable_to_non_nullable
              as FieldType,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      helpText: freezed == helpText
          ? _value.helpText
          : helpText // ignore: cast_nullable_to_non_nullable
              as String?,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      validationRules: freezed == validationRules
          ? _value._validationRules
          : validationRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldTemplateImpl implements _FieldTemplate {
  const _$FieldTemplateImpl(
      {required this.id,
      required this.name,
      required this.fieldType,
      required this.label,
      this.placeholder,
      this.helpText,
      this.isRequired = false,
      final Map<String, dynamic>? validationRules,
      this.defaultValue,
      required this.createdBy,
      required this.createdAt})
      : _validationRules = validationRules;

  factory _$FieldTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final FieldType fieldType;
  @override
  final String label;
  @override
  final String? placeholder;
  @override
  final String? helpText;
  @override
  @JsonKey()
  final bool isRequired;
  final Map<String, dynamic>? _validationRules;
  @override
  Map<String, dynamic>? get validationRules {
    final value = _validationRules;
    if (value == null) return null;
    if (_validationRules is EqualUnmodifiableMapView) return _validationRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? defaultValue;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FieldTemplate(id: $id, name: $name, fieldType: $fieldType, label: $label, placeholder: $placeholder, helpText: $helpText, isRequired: $isRequired, validationRules: $validationRules, defaultValue: $defaultValue, createdBy: $createdBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fieldType, fieldType) ||
                other.fieldType == fieldType) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.helpText, helpText) ||
                other.helpText == helpText) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            const DeepCollectionEquality()
                .equals(other._validationRules, _validationRules) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      fieldType,
      label,
      placeholder,
      helpText,
      isRequired,
      const DeepCollectionEquality().hash(_validationRules),
      defaultValue,
      createdBy,
      createdAt);

  /// Create a copy of FieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldTemplateImplCopyWith<_$FieldTemplateImpl> get copyWith =>
      __$$FieldTemplateImplCopyWithImpl<_$FieldTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldTemplateImplToJson(
      this,
    );
  }
}

abstract class _FieldTemplate implements FieldTemplate {
  const factory _FieldTemplate(
      {required final String id,
      required final String name,
      required final FieldType fieldType,
      required final String label,
      final String? placeholder,
      final String? helpText,
      final bool isRequired,
      final Map<String, dynamic>? validationRules,
      final String? defaultValue,
      required final String createdBy,
      required final DateTime createdAt}) = _$FieldTemplateImpl;

  factory _FieldTemplate.fromJson(Map<String, dynamic> json) =
      _$FieldTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  FieldType get fieldType;
  @override
  String get label;
  @override
  String? get placeholder;
  @override
  String? get helpText;
  @override
  bool get isRequired;
  @override
  Map<String, dynamic>? get validationRules;
  @override
  String? get defaultValue;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;

  /// Create a copy of FieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldTemplateImplCopyWith<_$FieldTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DropdownOption _$DropdownOptionFromJson(Map<String, dynamic> json) {
  return _DropdownOption.fromJson(json);
}

/// @nodoc
mixin _$DropdownOption {
  String get id => throw _privateConstructorUsedError;
  String get fieldId => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this DropdownOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DropdownOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DropdownOptionCopyWith<DropdownOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DropdownOptionCopyWith<$Res> {
  factory $DropdownOptionCopyWith(
          DropdownOption value, $Res Function(DropdownOption) then) =
      _$DropdownOptionCopyWithImpl<$Res, DropdownOption>;
  @useResult
  $Res call({String id, String fieldId, String label, String value, int order});
}

/// @nodoc
class _$DropdownOptionCopyWithImpl<$Res, $Val extends DropdownOption>
    implements $DropdownOptionCopyWith<$Res> {
  _$DropdownOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DropdownOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fieldId = null,
    Object? label = null,
    Object? value = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fieldId: null == fieldId
          ? _value.fieldId
          : fieldId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DropdownOptionImplCopyWith<$Res>
    implements $DropdownOptionCopyWith<$Res> {
  factory _$$DropdownOptionImplCopyWith(_$DropdownOptionImpl value,
          $Res Function(_$DropdownOptionImpl) then) =
      __$$DropdownOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String fieldId, String label, String value, int order});
}

/// @nodoc
class __$$DropdownOptionImplCopyWithImpl<$Res>
    extends _$DropdownOptionCopyWithImpl<$Res, _$DropdownOptionImpl>
    implements _$$DropdownOptionImplCopyWith<$Res> {
  __$$DropdownOptionImplCopyWithImpl(
      _$DropdownOptionImpl _value, $Res Function(_$DropdownOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DropdownOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fieldId = null,
    Object? label = null,
    Object? value = null,
    Object? order = null,
  }) {
    return _then(_$DropdownOptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fieldId: null == fieldId
          ? _value.fieldId
          : fieldId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DropdownOptionImpl implements _DropdownOption {
  const _$DropdownOptionImpl(
      {required this.id,
      required this.fieldId,
      required this.label,
      required this.value,
      required this.order});

  factory _$DropdownOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DropdownOptionImplFromJson(json);

  @override
  final String id;
  @override
  final String fieldId;
  @override
  final String label;
  @override
  final String value;
  @override
  final int order;

  @override
  String toString() {
    return 'DropdownOption(id: $id, fieldId: $fieldId, label: $label, value: $value, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DropdownOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fieldId, fieldId) || other.fieldId == fieldId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fieldId, label, value, order);

  /// Create a copy of DropdownOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DropdownOptionImplCopyWith<_$DropdownOptionImpl> get copyWith =>
      __$$DropdownOptionImplCopyWithImpl<_$DropdownOptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DropdownOptionImplToJson(
      this,
    );
  }
}

abstract class _DropdownOption implements DropdownOption {
  const factory _DropdownOption(
      {required final String id,
      required final String fieldId,
      required final String label,
      required final String value,
      required final int order}) = _$DropdownOptionImpl;

  factory _DropdownOption.fromJson(Map<String, dynamic> json) =
      _$DropdownOptionImpl.fromJson;

  @override
  String get id;
  @override
  String get fieldId;
  @override
  String get label;
  @override
  String get value;
  @override
  int get order;

  /// Create a copy of DropdownOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DropdownOptionImplCopyWith<_$DropdownOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
