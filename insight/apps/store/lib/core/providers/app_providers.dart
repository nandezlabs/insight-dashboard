import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insight_core/insight_core.dart';

// Geofence Service Provider
final geofenceServiceProvider = Provider<GeofenceService>((ref) {
  return GeofenceService();
});

// Location Provider
final locationProvider = FutureProvider<Position>((ref) async {
  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );
});

// Geofence Status Provider
final geofenceStatusProvider = FutureProvider<bool>((ref) async {
  // Get geofence settings (in real app, this would come from database)
  final settings = GeofenceSettings(
    id: 'default',
    address: 'Store Location',
    latitude: 37.7749, // San Francisco coordinates for demo
    longitude: -122.4194,
    radiusMeters: AppConstants.defaultGeofenceRadius,
    enabled: false, // Disabled for now
    testMode: true,
  );
  
  return await GeofenceService.validateLocation(settings);
});

// Weather Service Provider
final weatherServiceProvider = Provider<WeatherService>((ref) {
  // In production, load API key from environment variables
  const apiKey = String.fromEnvironment('WEATHER_API_KEY', defaultValue: 'demo_key');
  return WeatherService(apiKey: apiKey);
});

// Current Weather Provider
final currentWeatherProvider = FutureProvider.autoDispose((ref) async {
  final weatherService = ref.watch(weatherServiceProvider);
  try {
    // Use city name for now
    return await weatherService.getCurrentWeather('New York');
  } catch (e) {
    return null;
  }
});

// Business Calendar Service Provider - fiscal year start date
final fiscalYearStartDateProvider = Provider<DateTime>((ref) {
  // Fiscal year starts January 1, 2024 (configurable in settings)
  return DateTime(2024, 1, 1);
});

// Current Business Date Provider
final currentBusinessDateProvider = Provider<BusinessPeriod>((ref) {
  final startDate = ref.watch(fiscalYearStartDateProvider);
  return BusinessCalendarService.calculateCurrentPeriod(startDate);
});

// Repositories
final formRepositoryProvider = Provider<FormRepository>((ref) {
  return FormRepository();
});

final submissionRepositoryProvider = Provider<SubmissionRepository>((ref) {
  return SubmissionRepository();
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository();
});

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  return FileRepository();
});

// Forms List Provider
final formsProvider = FutureProvider<List<FormModel>>((ref) async {
  final repository = ref.watch(formRepositoryProvider);
  return await repository.getAllForms();
});

final activeFormsProvider = FutureProvider<List<FormModel>>((ref) async {
  final repository = ref.watch(formRepositoryProvider);
  final allForms = await repository.getAllForms();
  return allForms.where((f) => f.status == FormStatus.active).toList();
});

// Submissions Provider - user's submissions
final mySubmissionsProvider = FutureProvider<List<Submission>>((ref) async {
  // In real app, would filter by current user
  // For now, return empty list (needs backend endpoint)
  return [];
});

// Team Members Provider
final teamMembersProvider = FutureProvider<List<TeamMember>>((ref) async {
  final repository = ref.watch(teamRepositoryProvider);
  return await repository.getTeamMembers();
});

// KPI Data Provider
final kpiDataProvider = FutureProvider<KpiData?>((ref) async {
  // KPI calculation from forms and submissions
  // Return null for now as KPI calculation needs proper implementation
  return null;
});

// Goals Provider
final goalsProvider = FutureProvider<List<Goal>>((ref) async {
  // Goals not yet fully implemented
  return <Goal>[];
});
