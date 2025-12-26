import '../models/team_member.dart';
import '../services/api_client.dart';

class TeamRepository {
  /// Get all team members
  Future<List<TeamMember>> getTeamMembers() async {
    final response = await ApiClient.get('/api/v1/team');
    return (response.data as List)
        .map((json) => TeamMember.fromJson(json))
        .toList();
  }

  /// Get team member by ID
  Future<TeamMember?> getTeamMemberById(String id) async {
    try {
      final response = await ApiClient.get('/api/v1/team/$id');
      return TeamMember.fromJson(response.data);
    } on ApiException {
      return null;
    }
  }

  /// Create team member
  Future<TeamMember> createTeamMember(TeamMember member) async {
    final response = await ApiClient.post('/api/v1/team', data: member.toJson());
    return TeamMember.fromJson(response.data);
  }

  /// Update team member
  Future<TeamMember> updateTeamMember(TeamMember member) async {
    final response =
        await ApiClient.put('/api/v1/team/${member.id}', data: member.toJson());
    return TeamMember.fromJson(response.data);
  }

  /// Delete team member
  Future<void> deleteTeamMember(String id) async {
    await ApiClient.delete('/api/v1/team/$id');
  }

  /// Get team members by role
  Future<List<TeamMember>> getTeamMembersByRole(TeamRole role) async {
    final response = await ApiClient.get(
      '/api/v1/team',
      queryParameters: {'role': role.name},
    );
    return (response.data as List)
        .map((json) => TeamMember.fromJson(json))
        .toList();
  }
}
