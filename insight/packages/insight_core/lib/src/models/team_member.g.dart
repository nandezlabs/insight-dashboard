// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamMemberImpl _$$TeamMemberImplFromJson(Map<String, dynamic> json) =>
    _$TeamMemberImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$TeamRoleEnumMap, json['role']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TeamMemberImplToJson(_$TeamMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': _$TeamRoleEnumMap[instance.role]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TeamRoleEnumMap = {
  TeamRole.manager: 'manager',
  TeamRole.employee: 'employee',
};
