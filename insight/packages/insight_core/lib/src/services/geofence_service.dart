import 'package:geolocator/geolocator.dart';
import '../models/geofence_settings.dart';

class GeofenceService {
  static Future<bool> checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<bool> validateLocation(GeofenceSettings settings) async {
    // If geofencing is disabled or in test mode, allow access
    if (!settings.enabled || settings.testMode) {
      return true;
    }

    // Check permissions
    final hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      throw Exception('Location permission required');
    }

    try {
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Calculate distance
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        settings.latitude,
        settings.longitude,
      );

      // Check if within radius
      return distance <= settings.radiusMeters;
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  static Future<Position> getCurrentPosition() async {
    final hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      throw Exception('Location permission required');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
