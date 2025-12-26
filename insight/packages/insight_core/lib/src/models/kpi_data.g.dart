// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpi_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KpiDataImpl _$$KpiDataImplFromJson(Map<String, dynamic> json) =>
    _$KpiDataImpl(
      id: json['id'] as String,
      dataDate: DateTime.parse(json['dataDate'] as String),
      gemScore: (json['gemScore'] as num?)?.toDouble(),
      hoursScheduled: (json['hoursScheduled'] as num?)?.toDouble(),
      hoursRecommended: (json['hoursRecommended'] as num?)?.toDouble(),
      laborUsedPercentage: (json['laborUsedPercentage'] as num?)?.toDouble(),
      salesActual: (json['salesActual'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$KpiDataImplToJson(_$KpiDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dataDate': instance.dataDate.toIso8601String(),
      'gemScore': instance.gemScore,
      'hoursScheduled': instance.hoursScheduled,
      'hoursRecommended': instance.hoursRecommended,
      'laborUsedPercentage': instance.laborUsedPercentage,
      'salesActual': instance.salesActual,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
