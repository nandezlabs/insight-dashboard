import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';

// ============================================================================
// Business Calendar Providers
// ============================================================================

final businessCalendarServiceProvider = Provider<DateTime>((ref) {
  // Start from January 1, 2024 as the fiscal year start
  return DateTime(2024, 1, 1);
});

final currentBusinessDateProvider = Provider<BusinessPeriod>((ref) {
  final startDate = ref.watch(businessCalendarServiceProvider);
  return BusinessCalendarService.calculateCurrentPeriod(startDate);
});

// ============================================================================
// Repository Providers
// ============================================================================

final formRepositoryProvider = Provider<FormRepository>((ref) {
  return FormRepository();
});

final submissionRepositoryProvider = Provider<SubmissionRepository>((ref) {
  return SubmissionRepository();
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository();
});

// GoalRepository not yet implemented in core package
// final goalRepositoryProvider = Provider<GoalRepository>((ref) {
//   return GoalRepository();
// });

// ============================================================================
// Forms Providers
// ============================================================================

final formsListProvider = FutureProvider<List<FormModel>>((ref) async {
  final repository = ref.watch(formRepositoryProvider);
  return repository.getAllForms();
});

final activeFormsProvider = FutureProvider<List<FormModel>>((ref) async {
  final repository = ref.watch(formRepositoryProvider);
  final forms = await repository.getAllForms();
  return forms.where((form) => form.status == FormStatus.active).toList();
});

// ============================================================================
// Submissions Providers
// ============================================================================

final submissionsProvider = FutureProvider<List<Submission>>((ref) async {
  final repository = ref.watch(submissionRepositoryProvider);
  // Get submissions by status or implement getAllSubmissions in repository
  final inProgress = await repository.getSubmissionsByStatus(SubmissionStatus.inProgress);
  final completed = await repository.getSubmissionsByStatus(SubmissionStatus.completed);
  final autoSubmitted = await repository.getSubmissionsByStatus(SubmissionStatus.autoSubmitted);
  return [...inProgress, ...completed, ...autoSubmitted];
});

final submissionsForPeriodProvider = FutureProvider.family<List<Submission>, DateTime>(
  (ref, date) async {
    final repository = ref.watch(submissionRepositoryProvider);
    final startDate = ref.watch(businessCalendarServiceProvider);
    final businessDate = BusinessCalendarService.calculateCurrentPeriod(startDate);
    
    // Calculate period start/end dates (28 days per period)
    final periodOffset = (businessDate.period - 1) * 28;
    final periodStart = startDate.add(Duration(days: periodOffset));
    final periodEnd = periodStart.add(const Duration(days: 28));
    
    return repository.getSubmissionsByDateRange(periodStart, periodEnd);
  },
);

// ============================================================================
// Team Providers
// ============================================================================

final teamMembersProvider = FutureProvider<List<TeamMember>>((ref) async {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.getTeamMembers();
});

// ============================================================================
// Goals Providers
// ============================================================================

// Goals not yet implemented in core package
final goalsProvider = FutureProvider<List<Goal>>((ref) async {
  return <Goal>[]; // Return empty list until GoalRepository is implemented
});

// ============================================================================
// Statistics Providers
// ============================================================================

final completionStatsProvider = FutureProvider<CompletionStats>((ref) async {
  final submissions = await ref.watch(submissionsProvider.future);
  
  if (submissions.isEmpty) {
    return CompletionStats(
      totalForms: 0,
      completedForms: 0,
      userSubmittedCount: 0,
      autoSubmittedCount: 0,
      completionRate: 0.0,
      userSubmitRate: 0.0,
    );
  }
  
  final totalForms = submissions.length;
  final completedForms = submissions.where((s) => s.status == SubmissionStatus.completed).length;
  final userSubmitted = submissions.where((s) => s.status == SubmissionStatus.completed && !s.isAutoSubmitted).length;
  final autoSubmitted = submissions.where((s) => s.isAutoSubmitted == true).length;
  
  return CompletionStats(
    totalForms: totalForms,
    completedForms: completedForms,
    userSubmittedCount: userSubmitted,
    autoSubmittedCount: autoSubmitted,
    completionRate: totalForms > 0 ? completedForms / totalForms : 0.0,
    userSubmitRate: totalForms > 0 ? userSubmitted / totalForms : 0.0,
  );
});

// ============================================================================
// Data Classes
// ============================================================================

class CompletionStats {
  final int totalForms;
  final int completedForms;
  final int userSubmittedCount;
  final int autoSubmittedCount;
  final double completionRate;
  final double userSubmitRate;

  CompletionStats({
    required this.totalForms,
    required this.completedForms,
    required this.userSubmittedCount,
    required this.autoSubmittedCount,
    required this.completionRate,
    required this.userSubmitRate,
  });
}
