// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isSuperuser: json['isSuperuser'] as bool? ?? false,
      teamMemberId: json['teamMemberId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'fullName': instance.fullName,
      'email': instance.email,
      'isActive': instance.isActive,
      'isSuperuser': instance.isSuperuser,
      'teamMemberId': instance.teamMemberId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$AuthTokenImpl _$$AuthTokenImplFromJson(Map<String, dynamic> json) =>
    _$AuthTokenImpl(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthTokenImplToJson(_$AuthTokenImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'tokenType': instance.tokenType,
      'user': instance.user,
    };
