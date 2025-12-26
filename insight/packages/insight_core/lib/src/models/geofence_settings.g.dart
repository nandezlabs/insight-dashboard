// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeofenceSettingsImpl _$$GeofenceSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$GeofenceSettingsImpl(
      id: json['id'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num?)?.toInt() ?? 100,
      enabled: json['enabled'] as bool? ?? true,
      testMode: json['testMode'] as bool? ?? false,
    );

Map<String, dynamic> _$$GeofenceSettingsImplToJson(
        _$GeofenceSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusMeters': instance.radiusMeters,
      'enabled': instance.enabled,
      'testMode': instance.testMode,
    };
