import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_ui/insight_ui.dart';
import '../../core/providers/app_providers.dart';
import 'models/kpi_trend_data.dart';
import 'widgets/kpi_trend_chart.dart';
import 'widgets/period_comparison_chart.dart';

class KpiTrendsTab extends ConsumerStatefulWidget {
  const KpiTrendsTab({super.key});

  @override
  ConsumerState<KpiTrendsTab> createState() => _KpiTrendsTabState();
}

class _KpiTrendsTabState extends ConsumerState<KpiTrendsTab> {
  AnalyticsPeriodType _selectedPeriod = AnalyticsPeriodType.period;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  
  @override
  Widget build(BuildContext context) {
    final params = _buildParams();
    final trendsAsync = ref.watch(kpiTrendsProvider(params));
    final summariesAsync = ref.watch(periodSummariesProvider(params));
    
    return CustomScrollView(
      slivers: [
        // Period filter chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Period',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AnalyticsPeriodType.values.map((type) {
                    return ChoiceChip(
                      label: Text(type.label),
                      selected: _selectedPeriod == type,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedPeriod = type);
                          if (type != AnalyticsPeriodType.custom) {
                            // Clear custom dates when switching away from custom
                            _customStartDate = null;
                            _customEndDate = null;
                          }
                        }
                      },
                    );
                  }).toList(),
                ),
                if (_selectedPeriod == AnalyticsPeriodType.custom) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateButton(
                          label: 'Start Date',
                          date: _customStartDate,
                          onPressed: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateButton(
                          label: 'End Date',
                          date: _customEndDate,
                          onPressed: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        
        // Trend charts
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: trendsAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: EmptyState(
                icon: Icons.error_outline,
                title: 'Error Loading Trends',
                message: error.toString(),
              ),
            ),
            data: (trends) {
              if (trends.isEmpty) {
                return const SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Icons.show_chart,
                    title: 'No Trend Data',
                    message: 'No KPI data available for this period',
                  ),
                );
              }
              
              return SliverList(
                delegate: SliverChildListDelegate([
                  KpiTrendChart(
                    trendPoints: trends,
                    title: 'Sales Trend',
                    kpiType: 'sales',
                    actualColor: AppColors.primary,
                    targetColor: AppColors.accent,
                  ),
                  const SizedBox(height: 16),
                  KpiTrendChart(
                    trendPoints: trends,
                    title: 'GEM Score Trend',
                    kpiType: 'gem',
                    actualColor: const Color(0xFF4CAF50),
                    targetColor: const Color(0xFF81C784),
                  ),
                  const SizedBox(height: 16),
                  KpiTrendChart(
                    trendPoints: trends,
                    title: 'Labor Usage Trend',
                    kpiType: 'labor',
                    actualColor: const Color(0xFFFF9800),
                    targetColor: const Color(0xFFFFB74D),
                  ),
                ]),
              );
            },
          ),
        ),
        
        // Period comparisons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Period Comparisons',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: summariesAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: EmptyState(
                icon: Icons.error_outline,
                title: 'Error Loading Comparisons',
                message: error.toString(),
              ),
            ),
            data: (summaries) {
              if (summaries.isEmpty) {
                return const SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Icons.bar_chart,
                    title: 'No Comparison Data',
                    message: 'No period summaries available',
                  ),
                );
              }
              
              return SliverList(
                delegate: SliverChildListDelegate([
                  PeriodComparisonChart(
                    periods: summaries,
                    title: 'Sales by Period',
                    metricType: 'sales',
                  ),
                  const SizedBox(height: 16),
                  PeriodComparisonChart(
                    periods: summaries,
                    title: 'GEM Score by Period',
                    metricType: 'gem',
                  ),
                  const SizedBox(height: 16),
                  PeriodComparisonChart(
                    periods: summaries,
                    title: 'Labor Usage by Period',
                    metricType: 'labor',
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCards(summaries),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calendar_today),
      label: Text(
        date != null
            ? '${date.month}/${date.day}/${date.year}'
            : label,
      ),
    );
  }
  
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_customStartDate ?? DateTime.now().subtract(const Duration(days: 28)))
          : (_customEndDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _customStartDate = picked;
        } else {
          _customEndDate = picked;
        }
      });
    }
  }
  
  KpiTrendsParams _buildParams() {
    late DateTime startDate;
    late DateTime endDate;
    
    if (_selectedPeriod == AnalyticsPeriodType.custom) {
      startDate = _customStartDate ?? DateTime.now().subtract(const Duration(days: 28));
      endDate = _customEndDate ?? DateTime.now();
    } else {
      endDate = DateTime.now();
      startDate = endDate.subtract(Duration(days: _selectedPeriod.daysCount));
    }
    
    return KpiTrendsParams(
      startDate: startDate,
      endDate: endDate,
      periodType: _selectedPeriod,
    );
  }
  
  Widget _buildSummaryCards(List<KpiPeriodSummary> summaries) {
    // Calculate overall metrics
    final totalSales = summaries.fold<double>(
      0,
      (sum, s) => sum + (s.totalSales ?? 0),
    );
    
    final avgGem = summaries.where((s) => s.avgGemScore != null).isEmpty
        ? 0.0
        : summaries.fold<double>(0, (sum, s) => sum + (s.avgGemScore ?? 0)) /
            summaries.where((s) => s.avgGemScore != null).length;
    
    final avgLabor = summaries.where((s) => s.avgLaborUsed != null).isEmpty
        ? 0.0
        : summaries.fold<double>(0, (sum, s) => sum + (s.avgLaborUsed ?? 0)) /
            summaries.where((s) => s.avgLaborUsed != null).length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryMetric(
                    label: 'Total Sales',
                    value: '\$${totalSales.toStringAsFixed(0)}',
                    icon: Icons.attach_money,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildSummaryMetric(
                    label: 'Avg GEM',
                    value: avgGem.toStringAsFixed(1),
                    icon: Icons.star,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                Expanded(
                  child: _buildSummaryMetric(
                    label: 'Avg Labor',
                    value: '${avgLabor.toStringAsFixed(1)}%',
                    icon: Icons.people,
                    color: const Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryMetric({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
