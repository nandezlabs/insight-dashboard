// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubmissionImpl _$$SubmissionImplFromJson(Map<String, dynamic> json) =>
    _$SubmissionImpl(
      id: json['id'] as String,
      formId: json['formId'] as String,
      submittedBy: json['submittedBy'] as String,
      submissionDate: DateTime.parse(json['submissionDate'] as String),
      submissionTime: DateTime.parse(json['submissionTime'] as String),
      status: $enumDecodeNullable(_$SubmissionStatusEnumMap, json['status']) ??
          SubmissionStatus.inProgress,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
      isAutoSubmitted: json['isAutoSubmitted'] as bool? ?? false,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => SubmissionAnswer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SubmissionImplToJson(_$SubmissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formId': instance.formId,
      'submittedBy': instance.submittedBy,
      'submissionDate': instance.submissionDate.toIso8601String(),
      'submissionTime': instance.submissionTime.toIso8601String(),
      'status': _$SubmissionStatusEnumMap[instance.status]!,
      'completionPercentage': instance.completionPercentage,
      'isAutoSubmitted': instance.isAutoSubmitted,
      'answers': instance.answers,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$SubmissionStatusEnumMap = {
  SubmissionStatus.inProgress: 'in_progress',
  SubmissionStatus.completed: 'completed',
  SubmissionStatus.autoSubmitted: 'auto_submitted',
};

_$SubmissionAnswerImpl _$$SubmissionAnswerImplFromJson(
        Map<String, dynamic> json) =>
    _$SubmissionAnswerImpl(
      id: json['id'] as String,
      submissionId: json['submissionId'] as String,
      fieldId: json['fieldId'] as String,
      fieldLabel: json['fieldLabel'] as String,
      answerValue: json['answerValue'] as String?,
      value: json['value'] as String?,
      fileUrl: json['fileUrl'] as String?,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );

Map<String, dynamic> _$$SubmissionAnswerImplToJson(
        _$SubmissionAnswerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'submissionId': instance.submissionId,
      'fieldId': instance.fieldId,
      'fieldLabel': instance.fieldLabel,
      'answerValue': instance.answerValue,
      'value': instance.value,
      'fileUrl': instance.fileUrl,
      'answeredAt': instance.answeredAt.toIso8601String(),
    };
