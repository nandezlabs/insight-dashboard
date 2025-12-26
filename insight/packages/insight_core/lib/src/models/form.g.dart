// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FormModelImpl _$$FormModelImplFromJson(Map<String, dynamic> json) =>
    _$FormModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isTemplate: json['isTemplate'] as bool? ?? false,
      scheduleType: $enumDecodeNullable(
              _$FormScheduleTypeEnumMap, json['scheduleType']) ??
          FormScheduleType.tagBased,
      customStartDate: json['customStartDate'] == null
          ? null
          : DateTime.parse(json['customStartDate'] as String),
      customEndDate: json['customEndDate'] == null
          ? null
          : DateTime.parse(json['customEndDate'] as String),
      customTime: json['customTime'] as String?,
      maxSubmissions: (json['maxSubmissions'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$FormStatusEnumMap, json['status']) ??
          FormStatus.draft,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FormModelImplToJson(_$FormModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags,
      'isTemplate': instance.isTemplate,
      'scheduleType': _$FormScheduleTypeEnumMap[instance.scheduleType]!,
      'customStartDate': instance.customStartDate?.toIso8601String(),
      'customEndDate': instance.customEndDate?.toIso8601String(),
      'customTime': instance.customTime,
      'maxSubmissions': instance.maxSubmissions,
      'status': _$FormStatusEnumMap[instance.status]!,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$FormScheduleTypeEnumMap = {
  FormScheduleType.tagBased: 'tag_based',
  FormScheduleType.custom: 'custom',
  FormScheduleType.manual: 'manual',
};

const _$FormStatusEnumMap = {
  FormStatus.active: 'active',
  FormStatus.archived: 'archived',
  FormStatus.draft: 'draft',
};

_$FormSectionImpl _$$FormSectionImplFromJson(Map<String, dynamic> json) =>
    _$FormSectionImpl(
      id: json['id'] as String,
      formId: json['formId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      order: (json['order'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FormSectionImplToJson(_$FormSectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formId': instance.formId,
      'title': instance.title,
      'description': instance.description,
      'order': instance.order,
      'createdAt': instance.createdAt.toIso8601String(),
    };
