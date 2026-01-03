import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:insight_ui/insight_ui.dart';
import '../models/kpi_trend_data.dart';

class PeriodComparisonChart extends StatelessWidget {
  final List<KpiPeriodSummary> periods;
  final String title;
  final String metricType; // 'sales', 'gem', 'labor'
  
  const PeriodComparisonChart({
    super.key,
    required this.periods,
    required this.title,
    required this.metricType,
  });
  
  @override
  Widget build(BuildContext context) {
    if (periods.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: EmptyState(
            icon: Icons.bar_chart,
            title: 'No Data Available',
            message: 'No $title data for comparison',
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Goal vs Actual Comparison',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                _buildBarChartData(),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }
  
  BarChartData _buildBarChartData() {
    final barGroups = <BarChartGroupData>[];
    
    for (int i = 0; i < periods.length; i++) {
      final period = periods[i];
      double? actualValue;
      double? targetValue;
      
      switch (metricType) {
        case 'sales':
          actualValue = period.totalSales;
          targetValue = period.totalSalesTarget;
          break;
        case 'gem':
          actualValue = period.avgGemScore;
          targetValue = period.avgGemTarget;
          break;
        case 'labor':
          actualValue = period.avgLaborUsed;
          targetValue = period.avgLaborTarget;
          break;
      }
      
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            // Actual bar
            BarChartRodData(
              toY: actualValue ?? 0,
              color: _getActualColor(actualValue, targetValue),
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            // Target bar
            BarChartRodData(
              toY: targetValue ?? 0,
              color: AppColors.accent.withValues(alpha: 0.5),
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
          barsSpace: 4,
        ),
      );
    }
    
    // Calculate max value for Y axis
    final allValues = periods.expand((p) {
      switch (metricType) {
        case 'sales':
          return [p.totalSales, p.totalSalesTarget];
        case 'gem':
          return [p.avgGemScore, p.avgGemTarget];
        case 'labor':
          return [p.avgLaborUsed, p.avgLaborTarget];
        default:
          return <double?>[];
      }
    }).whereType<double>();
    
    final maxY = allValues.isEmpty ? 100.0 : allValues.reduce((a, b) => a > b ? a : b) * 1.2;
    
    return BarChartData(
      maxY: maxY,
      barGroups: barGroups,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              return Text(
                _formatYAxisValue(value),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < periods.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    periods[index].periodLabel,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
          left: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final period = periods[groupIndex];
            final isActual = rodIndex == 0;
            
            return BarTooltipItem(
              '${period.periodLabel}\n',
              AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '${isActual ? "Actual" : "Target"}: ${_formatTooltipValue(rod.toY)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Color _getActualColor(double? actual, double? target) {
    if (actual == null || target == null) {
      return AppColors.textSecondary;
    }
    
    if (metricType == 'labor') {
      // Lower is better for labor
      return actual <= target ? AppColors.success : AppColors.warning;
    } else {
      // Higher is better for sales and GEM
      return actual >= target ? AppColors.success : AppColors.warning;
    }
  }
  
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Actual', AppColors.success),
        const SizedBox(width: 16),
        _buildLegendItem('Target', AppColors.accent.withValues(alpha: 0.5)),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  String _formatYAxisValue(double value) {
    if (metricType == 'sales') {
      if (value >= 1000) {
        return '\$${(value / 1000).toStringAsFixed(0)}K';
      }
      return '\$${value.toStringAsFixed(0)}';
    } else if (metricType == 'labor') {
      return '${value.toStringAsFixed(0)}%';
    } else {
      return value.toStringAsFixed(1);
    }
  }
  
  String _formatTooltipValue(double value) {
    if (metricType == 'sales') {
      if (value >= 1000) {
        return '\$${(value / 1000).toStringAsFixed(1)}K';
      }
      return '\$${value.toStringAsFixed(0)}';
    } else if (metricType == 'labor') {
      return '${value.toStringAsFixed(1)}%';
    } else {
      return value.toStringAsFixed(1);
    }
  }
}
