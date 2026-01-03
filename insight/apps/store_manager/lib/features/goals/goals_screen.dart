import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/goal_provider.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  GoalType _selectedGoalType = GoalType.salesWeek;

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalNotifierProvider);
    final kpiDataAsync = ref.watch(kpiDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Goals & Performance',
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Track your targets and achievements',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => _showCreateGoalDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('New Goal'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Goal Type Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: GoalType.values.map((type) {
                        final isSelected = _selectedGoalType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(_getGoalTypeLabel(type)),
                            onSelected: (_) {
                              setState(() => _selectedGoalType = type);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // KPI Overview Cards
          SliverToBoxAdapter(
            child: kpiDataAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Error loading KPI data: $error'),
              ),
              data: (kpiData) => kpiData != null
                  ? _buildKPICards(kpiData)
                  : _buildEmptyKPIState(),
            ),
          ),

          // Goals List
          goalsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Error Loading Goals',
                  message: error.toString(),
                ),
              ),
            ),
            data: (goals) {
              final filteredGoals = goals
                  .where((g) => g.goalType == _selectedGoalType)
                  .toList()
                ..sort((a, b) => b.periodDate.compareTo(a.periodDate));

              if (filteredGoals.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.flag_outlined,
                    title: 'No Goals Set',
                    message: 'Create a goal to start tracking performance',
                    actionText: 'Create Goal',
                    onAction: () => _showCreateGoalDialog(context),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final goal = filteredGoals[index];
                      return _buildGoalCard(goal, kpiDataAsync.value);
                    },
                    childCount: filteredGoals.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards(KpiData kpiData) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _KPICard(
              icon: Icons.trending_up,
              title: 'Sales',
              value: kpiData.salesActual != null
                  ? '\$${kpiData.salesActual!.toStringAsFixed(0)}'
                  : 'N/A',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _KPICard(
              icon: Icons.diamond_outlined,
              title: 'GEM Score',
              value: kpiData.gemScore != null
                  ? kpiData.gemScore!.toStringAsFixed(1)
                  : 'N/A',
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _KPICard(
              icon: Icons.pie_chart_outline,
              title: 'Labor %',
              value: kpiData.laborUsedPercentage != null
                  ? '${kpiData.laborUsedPercentage!.toStringAsFixed(1)}%'
                  : 'N/A',
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyKPIState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.analytics_outlined, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text(
                'No KPI data available',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'KPI data will appear here once submissions are recorded',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(Goal goal, KpiData? kpiData) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final progress = _calculateProgress(goal, kpiData);
    final isAchieved = progress >= 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _getGoalTypeLabel(goal.goalType),
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isAchieved) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Achieved',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Period: ${dateFormat.format(goal.periodDate)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.error),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      _confirmDeleteGoal(context, goal);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current: ${_getCurrentValue(goal, kpiData)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Target: ${_formatTargetValue(goal)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 12,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(
                      isAchieved ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${progress.toStringAsFixed(1)}% of target',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGoalTypeLabel(GoalType type) {
    switch (type) {
      case GoalType.salesWeek:
        return 'Weekly Sales';
      case GoalType.salesPeriod:
        return 'Period Sales';
      case GoalType.gemPeriod:
        return 'GEM Period';
      case GoalType.laborPercentage:
        return 'Labor %';
    }
  }

  String _formatTargetValue(Goal goal) {
    switch (goal.goalType) {
      case GoalType.salesWeek:
      case GoalType.salesPeriod:
        return '\$${goal.targetValue.toStringAsFixed(0)}';
      case GoalType.gemPeriod:
        return goal.targetValue.toStringAsFixed(1);
      case GoalType.laborPercentage:
        return '${goal.targetValue.toStringAsFixed(1)}%';
    }
  }

  String _getCurrentValue(Goal goal, KpiData? kpiData) {
    if (kpiData == null) return 'N/A';
    
    switch (goal.goalType) {
      case GoalType.salesWeek:
      case GoalType.salesPeriod:
        return kpiData.salesActual != null
            ? '\$${kpiData.salesActual!.toStringAsFixed(0)}'
            : 'N/A';
      case GoalType.gemPeriod:
        return kpiData.gemScore != null
            ? kpiData.gemScore!.toStringAsFixed(1)
            : 'N/A';
      case GoalType.laborPercentage:
        return kpiData.laborUsedPercentage != null
            ? '${kpiData.laborUsedPercentage!.toStringAsFixed(1)}%'
            : 'N/A';
    }
  }

  double _calculateProgress(Goal goal, KpiData? kpiData) {
    if (kpiData == null) return 0.0;
    
    double? currentValue;
    switch (goal.goalType) {
      case GoalType.salesWeek:
      case GoalType.salesPeriod:
        currentValue = kpiData.salesActual;
        break;
      case GoalType.gemPeriod:
        currentValue = kpiData.gemScore;
        break;
      case GoalType.laborPercentage:
        currentValue = kpiData.laborUsedPercentage;
        break;
    }
    
    if (currentValue == null || goal.targetValue == 0) return 0.0;
    
    final progress = (currentValue / goal.targetValue) * 100;
    return progress.clamp(0.0, 200.0); // Cap at 200% for display
  }

  void _showCreateGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CreateGoalDialog(
        goalType: _selectedGoalType,
        onGoalCreated: () {
          ref.read(goalNotifierProvider.notifier).loadGoals();
        },
      ),
    );
  }

  void _confirmDeleteGoal(BuildContext context, Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: const Text('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(goalNotifierProvider.notifier).deleteGoal(goal.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Goal deleted successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete goal: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// KPI Card Widget
class _KPICard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _KPICard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Create Goal Dialog
class _CreateGoalDialog extends ConsumerStatefulWidget {
  final GoalType goalType;
  final VoidCallback onGoalCreated;

  const _CreateGoalDialog({
    required this.goalType,
    required this.onGoalCreated,
  });

  @override
  ConsumerState<_CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends ConsumerState<_CreateGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController();
  DateTime _periodDate = DateTime.now();
  late GoalType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.goalType;
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Goal'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<GoalType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Goal Type',
                border: OutlineInputBorder(),
              ),
              items: GoalType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getGoalTypeLabel(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetController,
              decoration: InputDecoration(
                labelText: 'Target Value',
                border: const OutlineInputBorder(),
                prefixText: _getPrefixText(_selectedType),
                suffixText: _getSuffixText(_selectedType),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a target value';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Period Date'),
              subtitle: Text(DateFormat('MMM d, yyyy').format(_periodDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _periodDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() => _periodDate = date);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _createGoal,
          child: const Text('Create'),
        ),
      ],
    );
  }

  String _getGoalTypeLabel(GoalType type) {
    switch (type) {
      case GoalType.salesWeek:
        return 'Weekly Sales';
      case GoalType.salesPeriod:
        return 'Period Sales';
      case GoalType.gemPeriod:
        return 'GEM Period';
      case GoalType.laborPercentage:
        return 'Labor %';
    }
  }

  String? _getPrefixText(GoalType type) {
    switch (type) {
      case GoalType.salesWeek:
      case GoalType.salesPeriod:
        return '\$';
      default:
        return null;
    }
  }

  String? _getSuffixText(GoalType type) {
    switch (type) {
      case GoalType.laborPercentage:
        return '%';
      default:
        return null;
    }
  }

  void _createGoal() async {
    if (_formKey.currentState!.validate()) {
      final targetValue = double.parse(_targetController.text);
      
      try {
        await ref.read(goalNotifierProvider.notifier).createGoal(
          goalType: _selectedType,
          targetValue: targetValue,
          periodDate: _periodDate,
        );
        
        if (mounted) {
          widget.onGoalCreated();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Goal created successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create goal: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
