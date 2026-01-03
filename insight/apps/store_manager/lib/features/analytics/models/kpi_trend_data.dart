import 'package:insight_core/insight_core.dart';

/// Data point for KPI trends over time
class KpiTrendPoint {
  final DateTime date;
  final double? salesActual;
  final double? salesTarget;
  final double? gemScore;
  final double? gemTarget;
  final double? laborUsedPercentage;
  final double? laborTarget;
  final String periodLabel; // e.g., "Week 1", "P1", "Q1"
  
  const KpiTrendPoint({
    required this.date,
    this.salesActual,
    this.salesTarget,
    this.gemScore,
    this.gemTarget,
    this.laborUsedPercentage,
    this.laborTarget,
    required this.periodLabel,
  });
  
  factory KpiTrendPoint.fromKpiData(
    KpiData kpi,
    Goal? salesGoal,
    Goal? gemGoal,
    Goal? laborGoal,
    String periodLabel,
  ) {
    return KpiTrendPoint(
      date: kpi.dataDate,
      salesActual: kpi.salesActual,
      salesTarget: salesGoal?.targetValue,
      gemScore: kpi.gemScore,
      gemTarget: gemGoal?.targetValue,
      laborUsedPercentage: kpi.laborUsedPercentage,
      laborTarget: laborGoal?.targetValue,
      periodLabel: periodLabel,
    );
  }
  
  /// Calculate variance percentage for sales
  double? get salesVariance {
    if (salesActual == null || salesTarget == null || salesTarget == 0) {
      return null;
    }
    return ((salesActual! - salesTarget!) / salesTarget!) * 100;
  }
  
  /// Calculate variance percentage for GEM
  double? get gemVariance {
    if (gemScore == null || gemTarget == null || gemTarget == 0) {
      return null;
    }
    return ((gemScore! - gemTarget!) / gemTarget!) * 100;
  }
  
  /// Calculate variance percentage for labor
  double? get laborVariance {
    if (laborUsedPercentage == null || laborTarget == null || laborTarget == 0) {
      return null;
    }
    return ((laborUsedPercentage! - laborTarget!) / laborTarget!) * 100;
  }
  
  /// Check if any goal is missed
  bool get hasMissedGoals {
    final salesMissed = salesVariance != null && salesVariance! < 0;
    final gemMissed = gemVariance != null && gemVariance! < 0;
    final laborMissed = laborVariance != null && laborVariance! > 0; // Higher is worse for labor
    return salesMissed || gemMissed || laborMissed;
  }
}

/// Aggregated KPI data for a time period
class KpiPeriodSummary {
  final String periodLabel;
  final DateTime startDate;
  final DateTime endDate;
  final double? totalSales;
  final double? totalSalesTarget;
  final double? avgGemScore;
  final double? avgGemTarget;
  final double? avgLaborUsed;
  final double? avgLaborTarget;
  final int dataPointsCount;
  
  const KpiPeriodSummary({
    required this.periodLabel,
    required this.startDate,
    required this.endDate,
    this.totalSales,
    this.totalSalesTarget,
    this.avgGemScore,
    this.avgGemTarget,
    this.avgLaborUsed,
    this.avgLaborTarget,
    required this.dataPointsCount,
  });
  
  factory KpiPeriodSummary.fromTrendPoints(
    List<KpiTrendPoint> points,
    String periodLabel,
  ) {
    if (points.isEmpty) {
      return KpiPeriodSummary(
        periodLabel: periodLabel,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        dataPointsCount: 0,
      );
    }
    
    points.sort((a, b) => a.date.compareTo(b.date));
    
    // Sum sales
    final salesPoints = points.where((p) => p.salesActual != null).toList();
    final totalSales = salesPoints.isEmpty
        ? null
        : salesPoints.fold<double>(0, (sum, p) => sum + p.salesActual!);
    
    final salesTargetPoints = points.where((p) => p.salesTarget != null).toList();
    final totalSalesTarget = salesTargetPoints.isEmpty
        ? null
        : salesTargetPoints.fold<double>(0, (sum, p) => sum + p.salesTarget!);
    
    // Average GEM
    final gemPoints = points.where((p) => p.gemScore != null).toList();
    final avgGemScore = gemPoints.isEmpty
        ? null
        : gemPoints.fold<double>(0, (sum, p) => sum + p.gemScore!) / gemPoints.length;
    
    final gemTargetPoints = points.where((p) => p.gemTarget != null).toList();
    final avgGemTarget = gemTargetPoints.isEmpty
        ? null
        : gemTargetPoints.fold<double>(0, (sum, p) => sum + p.gemTarget!) / gemTargetPoints.length;
    
    // Average Labor
    final laborPoints = points.where((p) => p.laborUsedPercentage != null).toList();
    final avgLaborUsed = laborPoints.isEmpty
        ? null
        : laborPoints.fold<double>(0, (sum, p) => sum + p.laborUsedPercentage!) / laborPoints.length;
    
    final laborTargetPoints = points.where((p) => p.laborTarget != null).toList();
    final avgLaborTarget = laborTargetPoints.isEmpty
        ? null
        : laborTargetPoints.fold<double>(0, (sum, p) => sum + p.laborTarget!) / laborTargetPoints.length;
    
    return KpiPeriodSummary(
      periodLabel: periodLabel,
      startDate: points.first.date,
      endDate: points.last.date,
      totalSales: totalSales,
      totalSalesTarget: totalSalesTarget,
      avgGemScore: avgGemScore,
      avgGemTarget: avgGemTarget,
      avgLaborUsed: avgLaborUsed,
      avgLaborTarget: avgLaborTarget,
      dataPointsCount: points.length,
    );
  }
  
  double? get salesVariance {
    if (totalSales == null || totalSalesTarget == null || totalSalesTarget == 0) {
      return null;
    }
    return ((totalSales! - totalSalesTarget!) / totalSalesTarget!) * 100;
  }
  
  double? get gemVariance {
    if (avgGemScore == null || avgGemTarget == null || avgGemTarget == 0) {
      return null;
    }
    return ((avgGemScore! - avgGemTarget!) / avgGemTarget!) * 100;
  }
  
  double? get laborVariance {
    if (avgLaborUsed == null || avgLaborTarget == null || avgLaborTarget == 0) {
      return null;
    }
    return ((avgLaborUsed! - avgLaborTarget!) / avgLaborTarget!) * 100;
  }
}

/// Time period filter options
enum AnalyticsPeriodType {
  week,      // Last 7 days
  period,    // Last 28 days (4 weeks)
  quarter,   // Last 3 periods (12 weeks)
  year,      // Last 13 periods (52 weeks)
  custom,    // User-selected date range
}

extension AnalyticsPeriodTypeExtension on AnalyticsPeriodType {
  String get label {
    switch (this) {
      case AnalyticsPeriodType.week:
        return 'Week';
      case AnalyticsPeriodType.period:
        return 'Period';
      case AnalyticsPeriodType.quarter:
        return 'Quarter';
      case AnalyticsPeriodType.year:
        return 'Year';
      case AnalyticsPeriodType.custom:
        return 'Custom';
    }
  }
  
  int get daysCount {
    switch (this) {
      case AnalyticsPeriodType.week:
        return 7;
      case AnalyticsPeriodType.period:
        return 28;
      case AnalyticsPeriodType.quarter:
        return 84; // 12 weeks
      case AnalyticsPeriodType.year:
        return 364; // 52 weeks
      case AnalyticsPeriodType.custom:
        return 0; // User-defined
    }
  }
}
