import '../models/team_member.dart';
import '../services/supabase_service.dart';

class TeamRepository {
  final _supabase = SupabaseService.client;

  /// Get all team members
  Future<List<TeamMember>> getTeamMembers() async {
    final response = await _supabase
        .from('team')
        .select()
        .order('name', ascending: true);

    return (response as List)
        .map((json) => TeamMember.fromJson(json))
        .toList();
  }

  /// Get team member by ID
  Future<TeamMember?> getTeamMemberById(String id) async {
    final response = await _supabase
        .from('team')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? TeamMember.fromJson(response) : null;
  }

  /// Create team member
  Future<TeamMember> createTeamMember(TeamMember member) async {
    final response = await _supabase
        .from('team')
        .insert(member.toJson())
        .select()
        .single();

    return TeamMember.fromJson(response);
  }

  /// Update team member
  Future<TeamMember> updateTeamMember(TeamMember member) async {
    final response = await _supabase
        .from('team')
        .update(member.toJson())
        .eq('id', member.id)
        .select()
        .single();

    return TeamMember.fromJson(response);
  }

  /// Delete team member
  Future<void> deleteTeamMember(String id) async {
    await _supabase.from('team').delete().eq('id', id);
  }
}
