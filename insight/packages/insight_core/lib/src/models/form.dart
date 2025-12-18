import 'package:freezed_annotation/freezed_annotation.dart';

part 'form.freezed.dart';
part 'form.g.dart';

enum FormScheduleType {
  @JsonValue('tag_based')
  tagBased,
  @JsonValue('custom')
  custom,
  @JsonValue('manual')
  manual,
}

enum FormStatus {
  @JsonValue('active')
  active,
  @JsonValue('archived')
  archived,
  @JsonValue('draft')
  draft,
}

@freezed
class FormModel with _$FormModel {
  const factory FormModel({
    required String id,
    required String title,
    String? description,
    @Default([]) List<String> tags,
    @Default(false) bool isTemplate,
    @Default(FormScheduleType.tagBased) FormScheduleType scheduleType,
    DateTime? customStartDate,
    DateTime? customEndDate,
    String? customTime,
    int? maxSubmissions,
    @Default(FormStatus.draft) FormStatus status,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FormModel;

  factory FormModel.fromJson(Map<String, dynamic> json) =>
      _$FormModelFromJson(json);
}

@freezed
class FormSection with _$FormSection {
  const factory FormSection({
    required String id,
    required String formId,
    required String title,
    String? description,
    required int order,
    required DateTime createdAt,
  }) = _FormSection;

  factory FormSection.fromJson(Map<String, dynamic> json) =>
      _$FormSectionFromJson(json);
}
