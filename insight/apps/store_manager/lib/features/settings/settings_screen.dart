import 'package:flutter/material.dart';
import 'package:insight_ui/insight_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Settings',
            style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          
          _SettingsSection(
            title: 'Business Configuration',
            items: [
              _SettingsItem(
                icon: Icons.calendar_today,
                title: 'Business Calendar',
                subtitle: 'Configure fiscal year and periods',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.flag,
                title: 'Goals & Targets',
                subtitle: 'Set performance goals',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.access_time,
                title: 'Timeframes',
                subtitle: 'Manage custom timeframes',
                onTap: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _SettingsSection(
            title: 'Team Management',
            items: [
              _SettingsItem(
                icon: Icons.people,
                title: 'Team Members',
                subtitle: 'Manage your team',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.location_on,
                title: 'Geofencing',
                subtitle: 'Location-based access',
                onTap: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _SettingsSection(
            title: 'Data',
            items: [
              _SettingsItem(
                icon: Icons.import_export,
                title: 'Import/Export',
                subtitle: 'Manage your data',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.sync,
                title: 'Sync Settings',
                subtitle: 'Configure synchronization',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
                          Divider(height: 1, color: AppColors.border),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

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
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
