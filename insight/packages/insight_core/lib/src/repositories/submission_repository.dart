import '../models/submission.dart';
import '../services/api_client.dart';

class SubmissionRepository {
  /// Get all submissions for a form
  Future<List<Submission>> getFormSubmissions(String formId) async {
    final response = await ApiClient.get('/api/forms/$formId/submissions');
    return (response.data as List)
        .map((json) => Submission.fromJson(json))
        .toList();
  }

  /// Get submission by ID
  Future<Submission?> getSubmissionById(String id) async {
    try {
      final response = await ApiClient.get('/api/submissions/$id');
      return Submission.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// Create submission
  Future<Submission> createSubmission(Submission submission) async {
    final response =
        await ApiClient.post('/api/submissions', data: submission.toJson());
    return Submission.fromJson(response.data);
  }

  /// Update submission
  Future<Submission> updateSubmission(Submission submission) async {
    final response = await ApiClient.put(
      '/api/submissions/${submission.id}',
      data: submission.toJson(),
    );
    return Submission.fromJson(response.data);
  }

  /// Delete submission
  Future<void> deleteSubmission(String id) async {
    await ApiClient.delete('/api/submissions/$id');
  }

  /// Get answers for a submission
  Future<List<SubmissionAnswer>> getSubmissionAnswers(
      String submissionId) async {
    final response =
        await ApiClient.get('/api/submissions/$submissionId/answers');
    return (response.data as List)
        .map((json) => SubmissionAnswer.fromJson(json))
        .toList();
  }

  /// Save answer
  Future<SubmissionAnswer> saveAnswer(SubmissionAnswer answer) async {
    final response =
        await ApiClient.post('/api/answers', data: answer.toJson());
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
      '/api/submissions',
      queryParameters: {'status': status.toString().split('.').last},
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
      '/api/submissions',
      queryParameters: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      },
    );
    return (response.data as List)
        .map((json) => Submission.fromJson(json))
        .toList();
  }
}
