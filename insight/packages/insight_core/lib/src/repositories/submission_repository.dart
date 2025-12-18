import '../models/submission.dart';
import '../services/supabase_service.dart';

class SubmissionRepository {
  final _supabase = SupabaseService.client;

  /// Get submissions for a form
  Future<List<Submission>> getFormSubmissions(String formId) async {
    final response = await _supabase
        .from('submissions')
        .select()
        .eq('form_id', formId)
        .order('submission_date', ascending: false);

    return (response as List)
        .map((json) => Submission.fromJson(json))
        .toList();
  }

  /// Get active submission for a form (in progress)
  Future<Submission?> getActiveSubmission(
    String formId,
    String userId,
  ) async {
    final response = await _supabase
        .from('submissions')
        .select()
        .eq('form_id', formId)
        .eq('submitted_by', userId)
        .eq('status', 'in_progress')
        .maybeSingle();

    return response != null ? Submission.fromJson(response) : null;
  }

  /// Create submission
  Future<Submission> createSubmission(Submission submission) async {
    final response = await _supabase
        .from('submissions')
        .insert(submission.toJson())
        .select()
        .single();

    return Submission.fromJson(response);
  }

  /// Update submission
  Future<Submission> updateSubmission(Submission submission) async {
    final response = await _supabase
        .from('submissions')
        .update(submission.toJson())
        .eq('id', submission.id)
        .select()
        .single();

    return Submission.fromJson(response);
  }

  /// Save answer
  Future<SubmissionAnswer> saveAnswer(SubmissionAnswer answer) async {
    // Check if answer exists
    final existing = await _supabase
        .from('submission_answers')
        .select()
        .eq('submission_id', answer.submissionId)
        .eq('field_id', answer.fieldId)
        .maybeSingle();

    if (existing != null) {
      // Update existing answer
      final response = await _supabase
          .from('submission_answers')
          .update(answer.toJson())
          .eq('id', existing['id'])
          .select()
          .single();

      return SubmissionAnswer.fromJson(response);
    } else {
      // Create new answer
      final response = await _supabase
          .from('submission_answers')
          .insert(answer.toJson())
          .select()
          .single();

      return SubmissionAnswer.fromJson(response);
    }
  }

  /// Get answers for a submission
  Future<List<SubmissionAnswer>> getSubmissionAnswers(
    String submissionId,
  ) async {
    final response = await _supabase
        .from('submission_answers')
        .select()
        .eq('submission_id', submissionId);

    return (response as List)
        .map((json) => SubmissionAnswer.fromJson(json))
        .toList();
  }

  /// Calculate completion percentage
  Future<double> calculateCompletionPercentage(
    String submissionId,
    int totalFields,
  ) async {
    final answers = await getSubmissionAnswers(submissionId);
    final answeredFields = answers.where((a) => a.answerValue != null).length;
    
    return (answeredFields / totalFields) * 100;
  }
}
