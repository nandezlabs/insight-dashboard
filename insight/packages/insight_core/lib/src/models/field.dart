import 'package:freezed_annotation/freezed_annotation.dart';

part 'field.freezed.dart';
part 'field.g.dart';

enum FieldType {
  @JsonValue('short_text')
  shortText,
  @JsonValue('long_text')
  longText,
  @JsonValue('email')
  email,
  @JsonValue('phone')
  phone,
  @JsonValue('dropdown')
  dropdown,
  @JsonValue('radio')
  radio,
  @JsonValue('checkbox')
  checkbox,
  @JsonValue('number')
  number,
  @JsonValue('date')
  date,
  @JsonValue('time')
  time,
  @JsonValue('file')
  file,
}

@freezed
class Field with _$Field {
  const factory Field({
    required String id,
    String? formId,
    String? sectionId,
    required FieldType fieldType,
    required String label,
    String? placeholder,
    String? helpText,
    @Default(false) bool isRequired,
    required int order,
    Map<String, dynamic>? validationRules,
    String? defaultValue,
    Map<String, dynamic>? conditionalLogic,
    String? templateId,
    required DateTime createdAt,
  }) = _Field;

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
}

@freezed
class FieldTemplate with _$FieldTemplate {
  const factory FieldTemplate({
    required String id,
    required String name,
    required FieldType fieldType,
    required String label,
    String? placeholder,
    String? helpText,
    @Default(false) bool isRequired,
    Map<String, dynamic>? validationRules,
    String? defaultValue,
    required String createdBy,
    required DateTime createdAt,
  }) = _FieldTemplate;

  factory FieldTemplate.fromJson(Map<String, dynamic> json) =>
      _$FieldTemplateFromJson(json);
}

@freezed
class DropdownOption with _$DropdownOption {
  const factory DropdownOption({
    required String id,
    required String fieldId,
    required String label,
    required String value,
    required int order,
  }) = _DropdownOption;

  factory DropdownOption.fromJson(Map<String, dynamic> json) =>
      _$DropdownOptionFromJson(json);
}
