import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessPeriod = ref.watch(currentBusinessDateProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Store'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh all providers
          ref.invalidate(formsProvider);
          ref.invalidate(teamMembersProvider);
          ref.invalidate(kpiDataProvider);
          ref.invalidate(goalsProvider);
          ref.invalidate(currentWeatherProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentPeriodCard(businessPeriod),
              const SizedBox(height: 16),
              _buildTodaySection(context, ref),
              const SizedBox(height: 16),
              _buildTeamScheduleSection(ref),
              const SizedBox(height: 16),
              _buildKPIsSection(ref),
              const SizedBox(height: 16),
              _buildGoalsSection(ref),
              const SizedBox(height: 16),
              _buildFormsSection(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPeriodCard(BusinessPeriod businessPeriod) {
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPeriodItem('Week', '${businessPeriod.week}'),
            _buildDivider(),
            _buildPeriodItem('Period', '${businessPeriod.period}'),
            _buildDivider(),
            _buildPeriodItem('Quarter', 'Q${businessPeriod.quarter}'),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white30,
    );
  }

  Widget _buildTodaySection(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              dateFormat.format(now),
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            weatherAsync.when(
              data: (weather) {
                if (weather == null) {
                  return const Text('Weather data unavailable');
                }
                final temp = weather.temperature?.celsius?.round() ?? 0;
                final condition = weather.weatherDescription ?? 'Unknown';
                return Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      '$temp°C',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      condition,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                );
              },
              loading: () => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => const Text('Weather data unavailable'),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.schedule, size: 20),
                SizedBox(width: 8),
                Text('Peak Hours: 12:00 PM - 2:00 PM'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamScheduleSection(WidgetRef ref) {
    final teamAsync = ref.watch(teamMembersProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Schedule',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 12),
            teamAsync.when(
              data: (members) {
                if (members.isEmpty) {
                  return const Text('No team members scheduled today');
                }
                return Column(
                  children: members.take(5).map((member) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              member.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: AppTextStyles.bodyMedium,
                                ),
                                Text(
                                  member.role.name.toUpperCase(),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '9:00 AM - 5:00 PM',
                            style: AppTextStyles.labelSmall,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Unable to load team schedule'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIsSection(WidgetRef ref) {
    final kpiAsync = ref.watch(kpiDataProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Metrics',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 12),
            kpiAsync.when(
              data: (kpi) {
                if (kpi == null) {
                  return const Text('No KPI data available');
                }
                return Column(
                  children: [
                    if (kpi.gemScore != null)
                      _buildKPIRow('GEM Score', '${kpi.gemScore}'),
                    if (kpi.laborUsedPercentage != null)
                      _buildKPIRow('Labor Used', '${kpi.laborUsedPercentage}%'),
                    if (kpi.salesActual != null)
                      _buildKPIRow('Sales', '\$${kpi.salesActual?.toStringAsFixed(0)}'),
                    if (kpi.hoursScheduled != null && kpi.hoursRecommended != null)
                      _buildKPIRow(
                        'Hours',
                        '${kpi.hoursScheduled}h / ${kpi.hoursRecommended}h',
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Unable to load KPI data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goals',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 12),
            goalsAsync.when(
              data: (goals) {
                if (goals.isEmpty) {
                  return const Text('No goals set');
                }
                return Column(
                  children: goals.take(3).map((goal) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                goal.goalType.name.replaceAll('_', ' ').toUpperCase(),
                                style: AppTextStyles.bodyMedium,
                              ),
                              Text(
                                'Target: ${goal.targetValue}',
                                style: AppTextStyles.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: _calculateGoalProgress(goal),
                            backgroundColor: Colors.grey[200],
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Unable to load goals'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormsSection(BuildContext context, WidgetRef ref) {
    final formsAsync = ref.watch(formsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forms',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 12),
        formsAsync.when(
          data: (forms) {
            if (forms.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No forms available'),
                ),
              );
            }

            // Group forms by tag
            final dailyForms = forms.where((f) => f.tags.contains('daily')).toList();
            final weeklyForms = forms.where((f) => f.tags.contains('weekly')).toList();
            final periodForms = forms.where((f) => f.tags.contains('period')).toList();
            final otherForms = forms.where(
              (f) => !f.tags.contains('daily') && 
                     !f.tags.contains('weekly') && 
                     !f.tags.contains('period'),
            ).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dailyForms.isNotEmpty) ...[
                  _buildFormGroup(context, 'Daily Forms', dailyForms),
                  const SizedBox(height: 16),
                ],
                if (weeklyForms.isNotEmpty) ...[
                  _buildFormGroup(context, 'Weekly Forms', weeklyForms),
                  const SizedBox(height: 16),
                ],
                if (periodForms.isNotEmpty) ...[
                  _buildFormGroup(context, 'Period Forms', periodForms),
                  const SizedBox(height: 16),
                ],
                if (otherForms.isNotEmpty) ...[
                  _buildFormGroup(context, 'Other Forms', otherForms),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Error loading forms'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormGroup(BuildContext context, String title, List<FormModel> forms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: forms.length,
          itemBuilder: (context, index) {
            final form = forms[index];
            return _buildFormCard(context, form);
          },
        ),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context, FormModel form) {
    return Card(
      child: InkWell(
        onTap: () {
          context.push('/form/${form.id}', extra: form);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                form.title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Icon(
                    _getFormIcon(form),
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      form.status.name.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFormIcon(FormModel form) {
    if (form.tags.contains('operations')) return Icons.business;
    if (form.tags.contains('daily')) return Icons.today;
    if (form.tags.contains('weekly')) return Icons.calendar_view_week;
    if (form.tags.contains('period')) return Icons.calendar_month;
    return Icons.description;
  }
  
  double _calculateGoalProgress(Goal goal) {
    // Calculate progress based on current value vs target
    // In production, this would get the actual current value from KPI data
    if (goal.targetValue == 0) return 0.0;
    
    // Mock calculation - in production, fetch actual value from repository
    final mockCurrentValue = goal.targetValue * 0.7; // Assume 70% progress
    return (mockCurrentValue / goal.targetValue).clamp(0.0, 1.0);
  }
}
