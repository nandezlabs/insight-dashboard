import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_member.freezed.dart';
part 'team_member.g.dart';

enum TeamRole {
  @JsonValue('manager')
  manager,
  @JsonValue('employee')
  employee,
}

@freezed
class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String id,
    required String name,
    required TeamRole role,
    required DateTime createdAt,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);
}
