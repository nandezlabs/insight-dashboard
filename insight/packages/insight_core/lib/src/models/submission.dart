import 'package:freezed_annotation/freezed_annotation.dart';

part 'submission.freezed.dart';
part 'submission.g.dart';

enum SubmissionStatus {
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('auto_submitted')
  autoSubmitted,
}

@freezed
class Submission with _$Submission {
  const factory Submission({
    required String id,
    required String formId,
    required String submittedBy,
    required DateTime submissionDate,
    required DateTime submissionTime,
    @Default(SubmissionStatus.inProgress) SubmissionStatus status,
    @Default(0.0) double completionPercentage,
    @Default(false) bool isAutoSubmitted,
    @Default([]) List<SubmissionAnswer> answers,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Submission;

  factory Submission.fromJson(Map<String, dynamic> json) =>
      _$SubmissionFromJson(json);
}

@freezed
class SubmissionAnswer with _$SubmissionAnswer {
  const factory SubmissionAnswer({
    required String id,
    required String submissionId,
    required String fieldId,
    required String fieldLabel,
    String? answerValue,
    String? value,
    String? fileUrl,
    required DateTime answeredAt,
  }) = _SubmissionAnswer;

  factory SubmissionAnswer.fromJson(Map<String, dynamic> json) =>
      _$SubmissionAnswerFromJson(json);
}
