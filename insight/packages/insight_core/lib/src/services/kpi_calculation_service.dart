import '../models/kpi_data.dart';
import '../models/submission.dart';
import '../models/form.dart';
import '../repositories/submission_repository.dart';
import '../repositories/goal_repository.dart';

/// Service for calculating KPI metrics from submission data
class KpiCalculationService {
  final SubmissionRepository _submissionRepository;
  final GoalRepository _goalRepository;

  KpiCalculationService({
    required SubmissionRepository submissionRepository,
    required GoalRepository goalRepository,
  })  : _submissionRepository = submissionRepository,
        _goalRepository = goalRepository;

  /// Calculate and save KPI data for a specific date
  Future<KpiData> calculateAndSaveKpiData({
    required DateTime dataDate,
    required List<Submission> submissions,
    required List<FormModel> forms,
  }) async {
    // Calculate sales from submissions
    final salesActual = _calculateSales(submissions);

    // Calculate labor metrics
    final laborMetrics = _calculateLaborMetrics(submissions);

    // Calculate GEM score
    final gemScore = _calculateGemScore(submissions, forms);

    // Upsert KPI data
    return await _goalRepository.upsertKpiData(
      dataDate: dataDate,
      salesActual: salesActual,
      hoursScheduled: laborMetrics['hoursScheduled'],
      hoursRecommended: laborMetrics['hoursRecommended'],
      laborUsedPercentage: laborMetrics['laborUsedPercentage'],
      gemScore: gemScore,
    );
  }

  /// Calculate total sales from submissions
  double _calculateSales(List<Submission> submissions) {
    double totalSales = 0.0;

    for (final submission in submissions) {
      // Look for sales-related answers in the submission
      for (final answer in submission.answers) {
        final fieldLabel = answer.fieldLabel.toLowerCase();
        
        // Check if this field contains sales data
        if (fieldLabel.contains('sales') || 
            fieldLabel.contains('revenue') ||
            fieldLabel.contains('total')) {
          
          // Try to parse the answer value as a number
          final value = _parseNumericValue(answer.value);
          if (value != null) {
            totalSales += value;
          }
        }
      }
    }

    return totalSales;
  }

  /// Calculate labor metrics from submissions
  Map<String, double?> _calculateLaborMetrics(List<Submission> submissions) {
    double? totalHoursScheduled;
    double? totalHoursRecommended;
    double? laborUsedPercentage;

    // Look for labor-related fields in submissions
    for (final submission in submissions) {
      for (final answer in submission.answers) {
        final fieldLabel = answer.fieldLabel.toLowerCase();
        
        if (fieldLabel.contains('hours scheduled') || 
            fieldLabel.contains('scheduled hours')) {
          final value = _parseNumericValue(answer.value);
          if (value != null) {
            totalHoursScheduled = (totalHoursScheduled ?? 0) + value;
          }
        }
        
        if (fieldLabel.contains('hours recommended') || 
            fieldLabel.contains('recommended hours')) {
          final value = _parseNumericValue(answer.value);
          if (value != null) {
            totalHoursRecommended = (totalHoursRecommended ?? 0) + value;
          }
        }
        
        if (fieldLabel.contains('labor') && fieldLabel.contains('%')) {
          final value = _parseNumericValue(answer.value);
          if (value != null) {
            laborUsedPercentage = value;
          }
        }
      }
    }

    // Calculate labor percentage if we have both scheduled and recommended
    if (laborUsedPercentage == null && 
        totalHoursScheduled != null && 
        totalHoursRecommended != null &&
        totalHoursRecommended > 0) {
      laborUsedPercentage = (totalHoursScheduled / totalHoursRecommended) * 100;
    }

    return {
      'hoursScheduled': totalHoursScheduled,
      'hoursRecommended': totalHoursRecommended,
      'laborUsedPercentage': laborUsedPercentage,
    };
  }

  /// Calculate GEM (Guest Experience Management) score from submissions
  double? _calculateGemScore(
    List<Submission> submissions,
    List<FormModel> forms,
  ) {
    // Find GEM-related forms
    final gemForms = forms.where((form) =>
      form.title.toLowerCase().contains('gem') ||
      form.tags.any((tag) => tag.toLowerCase() == 'gem')
    ).toList();

    if (gemForms.isEmpty) return null;

    // Get GEM form IDs
    final gemFormIds = gemForms.map((f) => f.id).toSet();

    // Filter submissions for GEM forms
    final gemSubmissions = submissions.where((s) => 
      gemFormIds.contains(s.formId)
    ).toList();

    if (gemSubmissions.isEmpty) return null;

    // Calculate average GEM score
    double totalScore = 0.0;
    int scoreCount = 0;

    for (final submission in gemSubmissions) {
      for (final answer in submission.answers) {
        final fieldLabel = answer.fieldLabel.toLowerCase();
        
        // Look for score/rating fields
        if (fieldLabel.contains('score') || 
            fieldLabel.contains('rating') ||
            fieldLabel.contains('total')) {
          
          final value = _parseNumericValue(answer.value);
          if (value != null) {
            totalScore += value;
            scoreCount++;
          }
        }
      }
    }

    return scoreCount > 0 ? totalScore / scoreCount : null;
  }

  /// Helper to parse numeric values from various formats
  double? _parseNumericValue(String? value) {
    if (value == null || value.isEmpty) return null;

    // Remove common non-numeric characters
    final cleaned = value
        .replaceAll(RegExp(r'[^\d.-]'), '') // Keep digits, dots, and minus
        .trim();

    if (cleaned.isEmpty) return null;

    return double.tryParse(cleaned);
  }

  /// Calculate KPI data for a date range
  Future<List<KpiData>> calculateKpiDataRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final kpiDataList = <KpiData>[];
    
    // Iterate through each day in the range
    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final endDateNormalized = DateTime(endDate.year, endDate.month, endDate.day);

    while (currentDate.isBefore(endDateNormalized) || 
           currentDate.isAtSameMomentAs(endDateNormalized)) {
      
      // Get submissions for this date
      final submissions = await _getSubmissionsForDate(currentDate);
      
      if (submissions.isNotEmpty) {
        // Calculate and save KPI data
        final kpiData = await calculateAndSaveKpiData(
          dataDate: currentDate,
          submissions: submissions,
          forms: [], // Would need to fetch forms if needed
        );
        
        kpiDataList.add(kpiData);
      }

      // Move to next day
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return kpiDataList;
  }

  /// Get submissions for a specific date
  Future<List<Submission>> _getSubmissionsForDate(DateTime date) async {
    // This would need to be implemented to filter submissions by date
    // For now, return empty list as placeholder
    // In a real implementation, you'd call the submission repository
    // with date filters
    return [];
  }
}
