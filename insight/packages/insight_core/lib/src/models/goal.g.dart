// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      id: json['id'] as String,
      goalType: $enumDecode(_$GoalTypeEnumMap, json['goalType']),
      targetValue: (json['targetValue'] as num).toDouble(),
      periodDate: DateTime.parse(json['periodDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goalType': _$GoalTypeEnumMap[instance.goalType]!,
      'targetValue': instance.targetValue,
      'periodDate': instance.periodDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$GoalTypeEnumMap = {
  GoalType.salesWeek: 'sales_week',
  GoalType.salesPeriod: 'sales_period',
  GoalType.gemPeriod: 'gem_period',
  GoalType.laborPercentage: 'labor_percentage',
};
