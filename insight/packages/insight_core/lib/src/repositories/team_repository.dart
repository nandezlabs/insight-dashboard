import '../models/team_member.dart';
import '../services/api_client.dart';
import 'auth_repository.dart';

class TeamRepository {
  // Test mode mock data
  static final List<TeamMember> _mockTeamMembers = [
    TeamMember(
      id: 'team-1',
      name: 'Test Manager',
      role: TeamRole.manager,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    TeamMember(
      id: 'team-2',
      name: 'Store Employee',
      role: TeamRole.employee,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  /// Get all team members
  Future<List<TeamMember>> getTeamMembers() async {
    if (AuthRepository.testMode) {
      print('Test mode: Returning mock team members');
      await Future.delayed(const Duration(milliseconds: 200));
      return _mockTeamMembers;
    }
    
    final response = await ApiClient.get('/api/v1/team');
    return (response.data as List)
        .map((json) => TeamMember.fromJson(json))
        .toList();
  }

  /// Get team member by ID
  Future<TeamMember?> getTeamMemberById(String id) async {
    if (AuthRepository.testMode) {
      print('Test mode: Getting mock team member by ID: $id');
      await Future.delayed(const Duration(milliseconds: 100));
      try {
        return _mockTeamMembers.firstWhere((m) => m.id == id);
      } catch (e) {
        return null;
      }
    }
    
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
    if (AuthRepository.testMode) {
      print('Test mode: Returning mock team members by role: $role');
      await Future.delayed(const Duration(milliseconds: 150));
      return _mockTeamMembers.where((m) => m.role == role).toList();
    }
    
    final response = await ApiClient.get(
      '/api/v1/team',
      queryParameters: {'role': role.name},
    );
    return (response.data as List)
        .map((json) => TeamMember.fromJson(json))
        .toList();
  }
}
