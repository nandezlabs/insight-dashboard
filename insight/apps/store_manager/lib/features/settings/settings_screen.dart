import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_ui/insight_ui.dart';
import '../../core/providers/auth_provider.dart';
import '../sync/sync_status_indicator.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header with user info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.username,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SyncStatusIndicator(),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Profile Section
          _SettingsSection(
            title: 'Profile',
            items: [
              _SettingsItem(
                icon: Icons.person_outline,
                title: 'Account Information',
                subtitle: user?.fullName ?? 'Not set',
                onTap: () => _showComingSoon(context, 'Profile Settings'),
              ),
              _SettingsItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () => _showComingSoon(context, 'Change Password'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Sync Section
          _SettingsSection(
            title: 'Data Sync',
            items: [
              _SettingsItem(
                icon: Icons.cloud_sync,
                title: 'Sync Settings',
                subtitle: 'Manage data synchronization',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SyncDialog(),
                  );
                },
              ),
              _SettingsItem(
                icon: Icons.storage,
                title: 'Local Storage',
                subtitle: 'Manage offline data',
                onTap: () => _showComingSoon(context, 'Local Storage'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Business Configuration
          _SettingsSection(
            title: 'Business Configuration',
            items: [
              _SettingsItem(
                icon: Icons.calendar_today,
                title: 'Business Calendar',
                subtitle: 'Configure fiscal year and periods',
                onTap: () => _showComingSoon(context, 'Business Calendar'),
              ),
              _SettingsItem(
                icon: Icons.flag_outlined,
                title: 'Goals & Targets',
                subtitle: 'Set performance goals',
                onTap: () => _showComingSoon(context, 'Goals & Targets'),
              ),
              _SettingsItem(
                icon: Icons.schedule,
                title: 'Form Scheduling',
                subtitle: 'Configure default schedules',
                onTap: () => _showComingSoon(context, 'Form Scheduling'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Store Configuration (for Store app)
          _SettingsSection(
            title: 'Store Configuration',
            items: [
              _SettingsItem(
                icon: Icons.location_on_outlined,
                title: 'Geofencing',
                subtitle: 'Location-based access control',
                onTap: () => _showComingSoon(context, 'Geofencing'),
              ),
              _SettingsItem(
                icon: Icons.cloud_outlined,
                title: 'Weather Integration',
                subtitle: 'Configure weather service',
                onTap: () => _showComingSoon(context, 'Weather Integration'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Notifications
          _SettingsSection(
            title: 'Notifications',
            items: [
              _SettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () => _showComingSoon(context, 'Notifications'),
              ),
              _SettingsItem(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Configure email alerts',
                onTap: () => _showComingSoon(context, 'Email Notifications'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // About
          _SettingsSection(
            title: 'About',
            items: [
              _SettingsItem(
                icon: Icons.info_outline,
                title: 'App Version',
                subtitle: '1.0.0+1',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.description_outlined,
                title: 'Terms & Privacy',
                subtitle: 'Legal information',
                onTap: () => _showComingSoon(context, 'Terms & Privacy'),
              ),
              _SettingsItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get assistance',
                onTap: () => _showComingSoon(context, 'Help & Support'),
              ),
            ],
          ),
          
          const SizedBox(height: 48),
          
          // Logout Button
          Center(
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  await ref.read(authProvider.notifier).logout();
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }
}

// Settings Section Widget
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: items
                .map((item) => Column(
                      children: [
                        item,
                        if (item != items.last)
                          const Divider(height: 1, color: AppColors.border),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// Settings Item Widget
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
