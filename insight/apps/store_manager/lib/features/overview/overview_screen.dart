import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import '../../core/providers/app_providers.dart';
import '../analytics/models/completion_stats.dart';

class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessDate = ref.watch(currentBusinessDateProvider);
    final statsAsync = ref.watch(completionStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Calendar Header
            _BusinessCalendarHeader(businessDate: businessDate),
            
            const SizedBox(height: 24),
            
            // Progress Section
            Text(
              'Operations Progress',
              style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            _ProgressSection(businessDate: businessDate),
            
            const SizedBox(height: 32),
            
            // Statistics Section
            Text(
              'Statistics',
              style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            statsAsync.when(
              data: (stats) => _StatisticsSection(stats: stats),
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading statistics: $error'),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            const _QuickActionsSection(),
          ],
        ),
      ),
    );
  }
}

class _BusinessCalendarHeader extends StatelessWidget {
  final BusinessPeriod businessDate;

  const _BusinessCalendarHeader({required this.businessDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _CalendarItem(
                  label: 'Week',
                  value: '${businessDate.week}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _CalendarItem(
                  label: 'Period',
                  value: '${businessDate.period}',
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _CalendarItem(
                  label: 'Quarter',
                  value: 'Q${businessDate.quarter}',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Current Date: ${_formatDate(businessDate.currentDate)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _CalendarItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _CalendarItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ProgressSection extends ConsumerWidget {
  final BusinessPeriod businessDate;

  const _ProgressSection({required this.businessDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ProgressCard(
            label: 'Daily Operations',
            progress: 0.75,
            progressColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ProgressCard(
            label: 'Weekly Operations',
            progress: 0.60,
            progressColor: AppColors.accent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ProgressCard(
            label: 'Period Operations',
            progress: 0.45,
            progressColor: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  final CompletionStats stats;

  const _StatisticsSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Completion Rate',
            value: '${stats.completionRate.toStringAsFixed(0)}%',
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            label: 'Total Submissions',
            value: '${stats.totalSubmissions}',
            icon: Icons.person_outline,
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            label: 'Active Forms',
            value: '${stats.activeForms}',
            icon: Icons.auto_awesome,
            iconColor: AppColors.warning,
          ),
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            title: 'Create Form',
            subtitle: 'Build a new form',
            icon: Icons.add_box,
            color: AppColors.primary,
            onTap: () {
              // Navigate to form builder
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _QuickActionCard(
            title: 'View Submissions',
            subtitle: 'Recent completions',
            icon: Icons.assignment,
            color: AppColors.accent,
            onTap: () {
              // Navigate to submissions
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _QuickActionCard(
            title: 'Manage Team',
            subtitle: 'Team members',
            icon: Icons.people,
            color: AppColors.success,
            onTap: () {
              // Navigate to team settings
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
