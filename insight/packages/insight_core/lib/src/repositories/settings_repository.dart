import '../models/business_calendar.dart';
import '../models/geofence_settings.dart';
import '../models/timeframe.dart';
import '../models/goal.dart';
import '../models/kpi_data.dart';
import '../services/api_client.dart';

class SettingsRepository {
  /// Get business calendar
  Future<BusinessCalendar?> getBusinessCalendar() async {
    try {
      final response = await ApiClient.get('/api/settings/calendar');
      return BusinessCalendar.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// Update business calendar
  Future<BusinessCalendar> updateBusinessCalendar(
      BusinessCalendar calendar) async {
    final response =
        await ApiClient.put('/api/settings/calendar', data: calendar.toJson());
    return BusinessCalendar.fromJson(response.data);
  }

  /// Get geofence settings
  Future<GeofenceSettings?> getGeofenceSettings() async {
    try {
      final response = await ApiClient.get('/api/settings/geofence');
      return GeofenceSettings.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// Update geofence settings
  Future<GeofenceSettings> updateGeofenceSettings(
      GeofenceSettings settings) async {
    final response =
        await ApiClient.put('/api/settings/geofence', data: settings.toJson());
    return GeofenceSettings.fromJson(response.data);
  }

  /// Get all timeframes
  Future<List<Timeframe>> getTimeframes() async {
    final response = await ApiClient.get('/api/settings/timeframes');
    return (response.data as List)
        .map((json) => Timeframe.fromJson(json))
        .toList();
  }

  /// Create timeframe
  Future<Timeframe> createTimeframe(Timeframe timeframe) async {
    final response = await ApiClient.post('/api/settings/timeframes',
        data: timeframe.toJson());
    return Timeframe.fromJson(response.data);
  }

  /// Update timeframe
  Future<Timeframe> updateTimeframe(Timeframe timeframe) async {
    final response = await ApiClient.put(
        '/api/settings/timeframes/${timeframe.id}',
        data: timeframe.toJson());
    return Timeframe.fromJson(response.data);
  }

  /// Delete timeframe
  Future<void> deleteTimeframe(String id) async {
    await ApiClient.delete('/api/settings/timeframes/$id');
  }

  /// Get all goals
  Future<List<Goal>> getGoals() async {
    final response = await ApiClient.get('/api/settings/goals');
    return (response.data as List).map((json) => Goal.fromJson(json)).toList();
  }

  /// Create goal
  Future<Goal> createGoal(Goal goal) async {
    final response =
        await ApiClient.post('/api/settings/goals', data: goal.toJson());
    return Goal.fromJson(response.data);
  }

  /// Update goal
  Future<Goal> updateGoal(Goal goal) async {
    final response = await ApiClient.put('/api/settings/goals/${goal.id}',
        data: goal.toJson());
    return Goal.fromJson(response.data);
  }

  /// Delete goal
  Future<void> deleteGoal(String id) async {
    await ApiClient.delete('/api/settings/goals/$id');
  }

  /// Get KPI data
  Future<KpiData?> getKpiData(DateTime date) async {
    try {
      final response = await ApiClient.get(
        '/api/kpi',
        queryParameters: {'date': date.toIso8601String()},
      );
      return KpiData.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// Save KPI data
  Future<KpiData> saveKpiData(KpiData kpiData) async {
    final response = await ApiClient.post('/api/kpi', data: kpiData.toJson());
    return KpiData.fromJson(response.data);
  }
}
