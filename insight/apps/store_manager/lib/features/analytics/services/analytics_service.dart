import 'package:insight_core/insight_core.dart';
import '../models/kpi_trend_data.dart';

/// Service for calculating analytics and trend data
class AnalyticsService {
  final GoalRepository _goalRepository;
  
  AnalyticsService(this._goalRepository);
  
  /// Get KPI trend data for a date range
  Future<List<KpiTrendPoint>> getKpiTrends({
    required DateTime startDate,
    required DateTime endDate,
    AnalyticsPeriodType periodType = AnalyticsPeriodType.week,
  }) async {
    // Fetch all KPI data in range
    final kpiDataList = await _goalRepository.getKpiDataRange(
      startDate: startDate,
      endDate: endDate,
    );
    
    if (kpiDataList.isEmpty) {
      return [];
    }
    
    // Fetch goals that overlap with this date range
    final allGoals = await _goalRepository.getGoals();
    
    // Convert to trend points with goal targets
    final trendPoints = <KpiTrendPoint>[];
    
    for (final kpiData in kpiDataList) {
      // Find matching goals for this date
      final salesGoal = _findGoalForDate(
        allGoals,
        kpiData.dataDate,
        'SALES',
      );
      
      final gemGoal = _findGoalForDate(
        allGoals,
        kpiData.dataDate,
        'GEM',
      );
      
      final laborGoal = _findGoalForDate(
        allGoals,
        kpiData.dataDate,
        'LABOR',
      );
      
      // Generate period label based on period type
      final periodLabel = _generatePeriodLabel(
        kpiData.dataDate,
        periodType,
      );
      
      trendPoints.add(
        KpiTrendPoint.fromKpiData(
          kpiData,
          salesGoal,
          gemGoal,
          laborGoal,
          periodLabel,
        ),
      );
    }
    
    // Sort by date
    trendPoints.sort((a, b) => a.date.compareTo(b.date));
    
    return trendPoints;
  }
  
  /// Get aggregated summaries by period
  Future<List<KpiPeriodSummary>> getPeriodSummaries({
    required DateTime startDate,
    required DateTime endDate,
    required AnalyticsPeriodType periodType,
  }) async {
    final trendPoints = await getKpiTrends(
      startDate: startDate,
      endDate: endDate,
      periodType: periodType,
    );
    
    if (trendPoints.isEmpty) {
      return [];
    }
    
    // Group by period
    final periodGroups = <String, List<KpiTrendPoint>>{};
    
    for (final point in trendPoints) {
      final periodKey = point.periodLabel;
      periodGroups.putIfAbsent(periodKey, () => []).add(point);
    }
    
    // Create summaries
    return periodGroups.entries.map((entry) {
      return KpiPeriodSummary.fromTrendPoints(
        entry.value,
        entry.key,
      );
    }).toList();
  }
  
  /// Calculate forecast based on historical trends
  Future<Map<String, double?>> calculateForecast({
    required DateTime targetDate,
    int historicalDays = 28,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: historicalDays));
    
    final trendPoints = await getKpiTrends(
      startDate: startDate,
      endDate: endDate,
      periodType: AnalyticsPeriodType.week,
    );
    
    if (trendPoints.length < 3) {
      // Not enough data for forecasting
      return {
        'salesForecast': null,
        'gemForecast': null,
        'laborForecast': null,
      };
    }
    
    // Simple linear regression for each metric
    final salesForecast = _calculateLinearForecast(
      trendPoints.map((p) => p.salesActual).whereType<double>().toList(),
      trendPoints.length,
    );
    
    final gemForecast = _calculateLinearForecast(
      trendPoints.map((p) => p.gemScore).whereType<double>().toList(),
      trendPoints.length,
    );
    
    final laborForecast = _calculateLinearForecast(
      trendPoints.map((p) => p.laborUsedPercentage).whereType<double>().toList(),
      trendPoints.length,
    );
    
    return {
      'salesForecast': salesForecast,
      'gemForecast': gemForecast,
      'laborForecast': laborForecast,
    };
  }
  
  /// Find goal that matches the date and type
  Goal? _findGoalForDate(
    List<Goal> goals,
    DateTime date,
    String goalTypePrefix,
  ) {
    // Convert prefix to GoalType patterns
    final matchingTypes = <GoalType>[];
    switch (goalTypePrefix) {
      case 'SALES':
        matchingTypes.addAll([GoalType.salesWeek, GoalType.salesPeriod]);
        break;
      case 'GEM':
        matchingTypes.add(GoalType.gemPeriod);
        break;
      case 'LABOR':
        matchingTypes.add(GoalType.laborPercentage);
        break;
    }
    
    // Find goals that match the type and are valid for this date
    final matchingGoals = goals.where((goal) {
      // Check if goal type matches
      if (!matchingTypes.contains(goal.goalType)) {
        return false;
      }
      
      // Check if date falls within goal's period
      return _isSamePeriod(goal.periodDate, date, goal.goalType);
    }).toList();
    
    // Return the most specific/recent goal
    if (matchingGoals.isEmpty) return null;
    
    matchingGoals.sort((a, b) => b.periodDate.compareTo(a.periodDate));
    return matchingGoals.first;
  }
  
  /// Check if two dates are in the same period based on goal type
  bool _isSamePeriod(DateTime goalDate, DateTime checkDate, GoalType goalType) {
    switch (goalType) {
      case GoalType.salesWeek:
        // Same week if within 7 days and same week of year
        final weeksDiff = checkDate.difference(goalDate).inDays ~/ 7;
        return weeksDiff == 0;
      case GoalType.salesPeriod:
      case GoalType.gemPeriod:
        // Same period if within 28 days and same 4-week period
        final periodsDiff = checkDate.difference(goalDate).inDays ~/ 28;
        return periodsDiff == 0;
      case GoalType.laborPercentage:
        // Same day for daily labor goals
        return goalDate.year == checkDate.year &&
            goalDate.month == checkDate.month &&
            goalDate.day == checkDate.day;
    }
  }
  
  /// Generate period label for display
  String _generatePeriodLabel(DateTime date, AnalyticsPeriodType periodType) {
    switch (periodType) {
      case AnalyticsPeriodType.week:
        final weekNumber = _getWeekNumber(date);
        return 'W$weekNumber';
      case AnalyticsPeriodType.period:
        final periodNumber = _getPeriodNumber(date);
        return 'P$periodNumber';
      case AnalyticsPeriodType.quarter:
        final quarterNumber = _getQuarterNumber(date);
        return 'Q$quarterNumber';
      case AnalyticsPeriodType.year:
        return date.year.toString();
      case AnalyticsPeriodType.custom:
        return '${date.month}/${date.day}';
    }
  }
  
  /// Get week number (1-52)
  int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(startOfYear).inDays;
    return (daysDifference ~/ 7) + 1;
  }
  
  /// Get period number (1-13, each period is 4 weeks)
  int _getPeriodNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(startOfYear).inDays;
    return (daysDifference ~/ 28) + 1;
  }
  
  /// Get quarter number (1-4, each quarter is 13 weeks)
  int _getQuarterNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(startOfYear).inDays;
    return (daysDifference ~/ 91) + 1; // ~13 weeks
  }
  
  /// Simple linear regression forecast
  double? _calculateLinearForecast(List<double> values, int currentLength) {
    if (values.length < 2) return null;
    
    final n = values.length;
    final sumX = List.generate(n, (i) => i).reduce((a, b) => a + b);
    final sumY = values.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => i * values[i]).reduce((a, b) => a + b);
    final sumX2 = List.generate(n, (i) => i * i).reduce((a, b) => a + b);
    
    // Calculate slope (m) and intercept (b) for y = mx + b
    final m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final b = (sumY - m * sumX) / n;
    
    // Forecast next value
    return m * currentLength + b;
  }
}
