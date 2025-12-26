// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeframe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeframeImpl _$$TimeframeImplFromJson(Map<String, dynamic> json) =>
    _$TimeframeImpl(
      id: json['id'] as String,
      tag: json['tag'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      autoSubmitTime: json['autoSubmitTime'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$$TimeframeImplToJson(_$TimeframeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'autoSubmitTime': instance.autoSubmitTime,
      'isDefault': instance.isDefault,
    };
