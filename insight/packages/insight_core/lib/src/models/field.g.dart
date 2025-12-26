// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FieldImpl _$$FieldImplFromJson(Map<String, dynamic> json) => _$FieldImpl(
      id: json['id'] as String,
      formId: json['formId'] as String?,
      sectionId: json['sectionId'] as String?,
      fieldType: $enumDecode(_$FieldTypeEnumMap, json['fieldType']),
      label: json['label'] as String,
      placeholder: json['placeholder'] as String?,
      helpText: json['helpText'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      order: (json['order'] as num).toInt(),
      validationRules: json['validationRules'] as Map<String, dynamic>?,
      defaultValue: json['defaultValue'] as String?,
      conditionalLogic: json['conditionalLogic'] as Map<String, dynamic>?,
      templateId: json['templateId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FieldImplToJson(_$FieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formId': instance.formId,
      'sectionId': instance.sectionId,
      'fieldType': _$FieldTypeEnumMap[instance.fieldType]!,
      'label': instance.label,
      'placeholder': instance.placeholder,
      'helpText': instance.helpText,
      'isRequired': instance.isRequired,
      'order': instance.order,
      'validationRules': instance.validationRules,
      'defaultValue': instance.defaultValue,
      'conditionalLogic': instance.conditionalLogic,
      'templateId': instance.templateId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FieldTypeEnumMap = {
  FieldType.shortText: 'short_text',
  FieldType.longText: 'long_text',
  FieldType.email: 'email',
  FieldType.phone: 'phone',
  FieldType.dropdown: 'dropdown',
  FieldType.radio: 'radio',
  FieldType.checkbox: 'checkbox',
  FieldType.number: 'number',
  FieldType.date: 'date',
  FieldType.time: 'time',
  FieldType.file: 'file',
};

_$FieldTemplateImpl _$$FieldTemplateImplFromJson(Map<String, dynamic> json) =>
    _$FieldTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      fieldType: $enumDecode(_$FieldTypeEnumMap, json['fieldType']),
      label: json['label'] as String,
      placeholder: json['placeholder'] as String?,
      helpText: json['helpText'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      validationRules: json['validationRules'] as Map<String, dynamic>?,
      defaultValue: json['defaultValue'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FieldTemplateImplToJson(_$FieldTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fieldType': _$FieldTypeEnumMap[instance.fieldType]!,
      'label': instance.label,
      'placeholder': instance.placeholder,
      'helpText': instance.helpText,
      'isRequired': instance.isRequired,
      'validationRules': instance.validationRules,
      'defaultValue': instance.defaultValue,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$DropdownOptionImpl _$$DropdownOptionImplFromJson(Map<String, dynamic> json) =>
    _$DropdownOptionImpl(
      id: json['id'] as String,
      fieldId: json['fieldId'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$$DropdownOptionImplToJson(
        _$DropdownOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fieldId': instance.fieldId,
      'label': instance.label,
      'value': instance.value,
      'order': instance.order,
    };
