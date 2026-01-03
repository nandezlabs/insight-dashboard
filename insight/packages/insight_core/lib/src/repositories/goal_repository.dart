import '../models/goal.dart';
import '../models/kpi_data.dart';
import '../services/api_client.dart';

class GoalRepository {
  /// Get all goals
  Future<List<Goal>> getGoals() async {
    final response = await ApiClient.get('/api/v1/goals');
    return (response.data as List)
        .map((json) => Goal.fromJson(json))
        .toList();
  }

  /// Get goal by ID
  Future<Goal?> getGoalById(String id) async {
    try {
      final response = await ApiClient.get('/api/v1/goals/$id');
      return Goal.fromJson(response.data);
    } on ApiException {
      return null;
    }
  }

  /// Get goals by type
  Future<List<Goal>> getGoalsByType(GoalType type) async {
    final typeValue = type.name;
    final response = await ApiClient.get('/api/v1/goals', 
      queryParameters: {'type': typeValue});
    return (response.data as List)
        .map((json) => Goal.fromJson(json))
        .toList();
  }

  /// Get goals for a specific period
  Future<List<Goal>> getGoalsByPeriod(DateTime periodDate) async {
    final response = await ApiClient.get('/api/v1/goals',
      queryParameters: {'period_date': periodDate.toIso8601String()});
    return (response.data as List)
        .map((json) => Goal.fromJson(json))
        .toList();
  }

  /// Create goal
  Future<Goal> createGoal({
    required GoalType goalType,
    required double targetValue,
    required DateTime periodDate,
  }) async {
    final response = await ApiClient.post('/api/v1/goals', data: {
      'goal_type': goalType.name,
      'target_value': targetValue,
      'period_date': periodDate.toIso8601String(),
    });
    return Goal.fromJson(response.data);
  }

  /// Update goal
  Future<Goal> updateGoal(String id, {
    GoalType? goalType,
    double? targetValue,
    DateTime? periodDate,
  }) async {
    final data = <String, dynamic>{};
    if (goalType != null) data['goal_type'] = goalType.name;
    if (targetValue != null) data['target_value'] = targetValue;
    if (periodDate != null) data['period_date'] = periodDate.toIso8601String();

    final response = await ApiClient.put('/api/v1/goals/$id', data: data);
    return Goal.fromJson(response.data);
  }

  /// Delete goal
  Future<void> deleteGoal(String id) async {
    await ApiClient.delete('/api/v1/goals/$id');
  }

  // KPI Data methods

  /// Get latest KPI data
  Future<KpiData?> getLatestKpiData() async {
    try {
      final response = await ApiClient.get('/api/v1/kpi-data/latest');
      return KpiData.fromJson(response.data);
    } on ApiException {
      return null;
    }
  }

  /// Get KPI data by date
  Future<KpiData?> getKpiDataByDate(DateTime date) async {
    try {
      final response = await ApiClient.get('/api/v1/kpi-data',
        queryParameters: {'date': date.toIso8601String()});
      return KpiData.fromJson(response.data);
    } on ApiException {
      return null;
    }
  }

  /// Get KPI data for a date range
  Future<List<KpiData>> getKpiDataRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await ApiClient.get('/api/v1/kpi-data/range',
      queryParameters: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      });
    return (response.data as List)
        .map((json) => KpiData.fromJson(json))
        .toList();
  }

  /// Create or update KPI data
  Future<KpiData> upsertKpiData({
    required DateTime dataDate,
    double? gemScore,
    double? hoursScheduled,
    double? hoursRecommended,
    double? laborUsedPercentage,
    double? salesActual,
  }) async {
    final data = <String, dynamic>{
      'data_date': dataDate.toIso8601String(),
    };
    if (gemScore != null) data['gem_score'] = gemScore;
    if (hoursScheduled != null) data['hours_scheduled'] = hoursScheduled;
    if (hoursRecommended != null) data['hours_recommended'] = hoursRecommended;
    if (laborUsedPercentage != null) data['labor_used_percentage'] = laborUsedPercentage;
    if (salesActual != null) data['sales_actual'] = salesActual;

    final response = await ApiClient.post('/api/v1/kpi-data', data: data);
    return KpiData.fromJson(response.data);
  }
}
