// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessCalendarImpl _$$BusinessCalendarImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessCalendarImpl(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      currentWeek: (json['currentWeek'] as num).toInt(),
      currentPeriod: (json['currentPeriod'] as num).toInt(),
      currentQuarter: (json['currentQuarter'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BusinessCalendarImplToJson(
        _$BusinessCalendarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'currentWeek': instance.currentWeek,
      'currentPeriod': instance.currentPeriod,
      'currentQuarter': instance.currentQuarter,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$BusinessPeriodImpl _$$BusinessPeriodImplFromJson(Map<String, dynamic> json) =>
    _$BusinessPeriodImpl(
      week: (json['week'] as num).toInt(),
      period: (json['period'] as num).toInt(),
      quarter: (json['quarter'] as num).toInt(),
      currentDate: DateTime.parse(json['currentDate'] as String),
    );

Map<String, dynamic> _$$BusinessPeriodImplToJson(
        _$BusinessPeriodImpl instance) =>
    <String, dynamic>{
      'week': instance.week,
      'period': instance.period,
      'quarter': instance.quarter,
      'currentDate': instance.currentDate.toIso8601String(),
    };
