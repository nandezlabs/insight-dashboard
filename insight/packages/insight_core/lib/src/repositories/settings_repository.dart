import '../models/business_calendar.dart';
import '../models/geofence_settings.dart';
import '../models/timeframe.dart';
import '../models/kpi_data.dart';
import '../models/goal.dart';
import '../services/supabase_service.dart';

class SettingsRepository {
  final _supabase = SupabaseService.client;

  /// Get business calendar
  Future<BusinessCalendar?> getBusinessCalendar() async {
    final response = await _supabase
        .from('business_calendar')
        .select()
        .maybeSingle();

    return response != null ? BusinessCalendar.fromJson(response) : null;
  }

  /// Update business calendar
  Future<BusinessCalendar> updateBusinessCalendar(
    BusinessCalendar calendar,
  ) async {
    final response = await _supabase
        .from('business_calendar')
        .upsert(calendar.toJson())
        .select()
        .single();

    return BusinessCalendar.fromJson(response);
  }

  /// Get geofence settings
  Future<GeofenceSettings?> getGeofenceSettings() async {
    final response = await _supabase
        .from('geofence_settings')
        .select()
        .maybeSingle();

    return response != null ? GeofenceSettings.fromJson(response) : null;
  }

  /// Update geofence settings
  Future<GeofenceSettings> updateGeofenceSettings(
    GeofenceSettings settings,
  ) async {
    final response = await _supabase
        .from('geofence_settings')
        .upsert(settings.toJson())
        .select()
        .single();

    return GeofenceSettings.fromJson(response);
  }

  /// Get timeframes
  Future<List<Timeframe>> getTimeframes() async {
    final response = await _supabase.from('timeframe').select();

    return (response as List)
        .map((json) => Timeframe.fromJson(json))
        .toList();
  }

  /// Create/Update timeframe
  Future<Timeframe> upsertTimeframe(Timeframe timeframe) async {
    final response = await _supabase
        .from('timeframe')
        .upsert(timeframe.toJson())
        .select()
        .single();

    return Timeframe.fromJson(response);
  }

  /// Get KPI data for a date
  Future<KpiData?> getKpiData(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    final response = await _supabase
        .from('kpi_data')
        .select()
        .eq('data_date', dateStr)
        .maybeSingle();

    return response != null ? KpiData.fromJson(response) : null;
  }

  /// Upsert KPI data
  Future<KpiData> upsertKpiData(KpiData data) async {
    final response = await _supabase
        .from('kpi_data')
        .upsert(data.toJson())
        .select()
        .single();

    return KpiData.fromJson(response);
  }

  /// Get goals
  Future<List<Goal>> getGoals() async {
    final response = await _supabase
        .from('goals')
        .select()
        .order('period_date', ascending: false);

    return (response as List).map((json) => Goal.fromJson(json)).toList();
  }

  /// Create goal
  Future<Goal> createGoal(Goal goal) async {
    final response = await _supabase
        .from('goals')
        .insert(goal.toJson())
        .select()
        .single();

    return Goal.fromJson(response);
  }
}
