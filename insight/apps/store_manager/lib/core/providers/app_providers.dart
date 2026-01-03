import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';
import '../../features/analytics/models/completion_stats.dart';
import '../../features/analytics/models/kpi_trend_data.dart';
import '../../features/analytics/services/analytics_service.dart';

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

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});

final goalsProvider = FutureProvider<List<Goal>>((ref) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getGoals();
});

final kpiDataProvider = FutureProvider<KpiData?>((ref) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getLatestKpiData();
});

// ============================================================================
// Statistics Providers
// ============================================================================

final completionStatsProvider = FutureProvider<CompletionStats>((ref) async {
  final submissions = await ref.watch(submissionsProvider.future);
  final forms = await ref.watch(formsListProvider.future);
  final activeForms = forms.where((f) => f.status == FormStatus.active).length;
  
  if (submissions.isEmpty) {
    return CompletionStats(
      totalSubmissions: 0,
      completionRate: 0.0,
      averageCompletionTime: 0.0,
      activeForms: activeForms,
      submissionsByForm: {},
      dailySubmissions: [],
    );
  }
  
  // Calculate total submissions
  final totalSubmissions = submissions.length;
  
  // Calculate completion rate
  final completedSubmissions = submissions.where(
    (s) => s.status == SubmissionStatus.completed || s.status == SubmissionStatus.autoSubmitted
  ).length;
  final completionRate = totalSubmissions > 0 
      ? (completedSubmissions / totalSubmissions) * 100 
      : 0.0;
  
  // Calculate average completion time (mock for now)
  // TODO: Implement proper time tracking in submissions
  final averageCompletionTime = 15.0;
  
  // Group submissions by form
  final submissionsByForm = <String, int>{};
  for (final submission in submissions) {
    submissionsByForm[submission.formId] = 
        (submissionsByForm[submission.formId] ?? 0) + 1;
  }
  
  // Group submissions by day (last 7 days for now)
  final dailySubmissions = <DailySubmission>[];
  // TODO: Implement daily grouping when we have proper date queries
  
  return CompletionStats(
    totalSubmissions: totalSubmissions,
    completionRate: completionRate,
    averageCompletionTime: averageCompletionTime,
    activeForms: activeForms,
    submissionsByForm: submissionsByForm,
    dailySubmissions: dailySubmissions,
  );
});

// Alias for backward compatibility
final formsProvider = formsListProvider;

// ============================================================================
// Analytics Service Provider
// ============================================================================

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final goalRepository = ref.watch(goalRepositoryProvider);
  return AnalyticsService(goalRepository);
});

/// Provider for KPI trend data with configurable date range and period type
final kpiTrendsProvider = FutureProvider.family<List<KpiTrendPoint>, KpiTrendsParams>(
  (ref, params) async {
    final service = ref.watch(analyticsServiceProvider);
    return service.getKpiTrends(
      startDate: params.startDate,
      endDate: params.endDate,
      periodType: params.periodType,
    );
  },
);

/// Provider for period summaries
final periodSummariesProvider = FutureProvider.family<List<KpiPeriodSummary>, KpiTrendsParams>(
  (ref, params) async {
    final service = ref.watch(analyticsServiceProvider);
    return service.getPeriodSummaries(
      startDate: params.startDate,
      endDate: params.endDate,
      periodType: params.periodType,
    );
  },
);

/// Parameters for KPI trends queries
class KpiTrendsParams {
  final DateTime startDate;
  final DateTime endDate;
  final AnalyticsPeriodType periodType;
  
  const KpiTrendsParams({
    required this.startDate,
    required this.endDate,
    required this.periodType,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KpiTrendsParams &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.periodType == periodType;
  }
  
  @override
  int get hashCode => Object.hash(startDate, endDate, periodType);
}
