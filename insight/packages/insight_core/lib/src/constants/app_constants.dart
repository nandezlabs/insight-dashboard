class AppConstants {
  // App info
  static const String appName = 'Insight';
  static const String appVersion = '1.0.0';

  // Business calendar
  static const int daysInWeek = 7;
  static const int weeksInPeriod = 4;
  static const int periodsInQuarter = 3;
  static const int periodsInYear = 13;
  static const int quartersInYear = 4;

  // Geofencing
  static const int defaultGeofenceRadius = 100; // meters
  static const int geofenceUpdateInterval = 5; // seconds

  // Auto-submit
  static const String noResponseText = 'No Response';

  // Database
  static const String databaseName = 'insight.db';
  static const int databaseVersion = 1;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);

  // API
  static const Duration apiTimeout = Duration(seconds: 30);
}
