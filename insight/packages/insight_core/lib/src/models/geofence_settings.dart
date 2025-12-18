import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_settings.freezed.dart';
part 'geofence_settings.g.dart';

@freezed
class GeofenceSettings with _$GeofenceSettings {
  const factory GeofenceSettings({
    required String id,
    required String address,
    required double latitude,
    required double longitude,
    @Default(100) int radiusMeters,
    @Default(true) bool enabled,
    @Default(false) bool testMode,
  }) = _GeofenceSettings;

  factory GeofenceSettings.fromJson(Map<String, dynamic> json) =>
      _$GeofenceSettingsFromJson(json);
}
