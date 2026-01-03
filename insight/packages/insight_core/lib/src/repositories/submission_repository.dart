import '../models/submission.dart';
import '../services/api_client.dart';
import 'auth_repository.dart';

class SubmissionRepository {
  /// Get all submissions for a form
  Future<List<Submission>> getFormSubmissions(String formId) async {
    if (AuthRepository.testMode) {
      print('Test mode: Returning empty submissions list for form $formId');
      await Future.delayed(const Duration(milliseconds: 100));
      return [];
    }
    
    final response = await ApiClient.get('/api/v1/submissions/form/$formId');
    return (response.data as List)
        .map((json) => Submission.fromJson(json))
        .toList();
  }

  /// Get submission by ID
  Future<Submission?> getSubmissionById(String id) async {
    try {
      final response = await ApiClient.get('/api/v1/submissions/$id');
      return Submission.fromJson(response.data);
    } on ApiException {
      return null;
    }
  }

  /// Create submission
  Future<Submission> createSubmission(Submission submission) async {
    final response =
        await ApiClient.post('/api/v1/submissions', data: submission.toJson());
    return Submission.fromJson(response.data);
  }

  /// Update submission
  Future<Submission> updateSubmission(Submission submission) async {
    final response = await ApiClient.put(
      '/api/v1/submissions/${submission.id}',
      data: submission.toJson(),
    );
    return Submission.fromJson(response.data);
  }

  /// Delete submission
  Future<void> deleteSubmission(String id) async {
    await ApiClient.delete('/api/v1/submissions/$id');
  }

  /// Get answers for a submission
  Future<List<SubmissionAnswer>> getSubmissionAnswers(
      String submissionId) async {
    final response =
        await ApiClient.get('/api/v1/submissions/$submissionId/answers');
    return (response.data as List)
        .map((json) => SubmissionAnswer.fromJson(json))
        .toList();
  }

  /// Save answer (create or update)
  Future<SubmissionAnswer> saveAnswer(SubmissionAnswer answer) async {
    final response = await ApiClient.post(
      '/api/v1/submissions/${answer.submissionId}/answers',
      data: answer.toJson(),
    );
    return SubmissionAnswer.fromJson(response.data);
  }

  /// Calculate completion percentage
  double calculateCompletionPercentage(
    List<SubmissionAnswer> answers,
    int totalFields,
  ) {
    if (totalFields == 0) return 0.0;
    final answeredFields = answers
        .where((a) => a.answerValue != null && a.answerValue!.isNotEmpty)
        .length;
    return (answeredFields / totalFields) * 100;
  }

  /// Get submissions by status
  Future<List<Submission>> getSubmissionsByStatus(
      SubmissionStatus status) async {
    final response = await ApiClient.get(
      '/api/v1/submissions',
      queryParameters: {'status': status.name},
    );
    return (response.data as List)
        .map((json) => Submission.fromJson(json))
        .toList();
  }

  /// Get submissions by date range
  Future<List<Submission>> getSubmissionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await ApiClient.get(
      '/api/v1/submissions/date-range',
      queryParameters: {
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
      },
    );
    return (response.data as List)
        .map((json) => Submission.fromJson(json))
        .toList();
  }
}
