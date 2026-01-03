import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,  // Store code (e.g., "PX0000")
    required String fullName,
    String? email,  // Optional
    @Default(true) bool isActive,
    @Default(false) bool isSuperuser,
    String? teamMemberId,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String accessToken,
    required String tokenType,
    required User user,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
}
