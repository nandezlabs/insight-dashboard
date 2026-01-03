import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:insight_ui/insight_ui.dart';
import 'package:intl/intl.dart';
import '../models/kpi_trend_data.dart';

class KpiTrendChart extends StatelessWidget {
  final List<KpiTrendPoint> trendPoints;
  final String title;
  final String kpiType; // 'sales', 'gem', 'labor'
  final Color actualColor;
  final Color targetColor;
  
  const KpiTrendChart({
    super.key,
    required this.trendPoints,
    required this.title,
    required this.kpiType,
    this.actualColor = AppColors.primary,
    this.targetColor = AppColors.accent,
  });
  
  @override
  Widget build(BuildContext context) {
    if (trendPoints.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: EmptyState(
            icon: Icons.show_chart,
            title: 'No Data Available',
            message: 'No $title data for this period',
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
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                _buildLineChartData(),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }
  
  LineChartData _buildLineChartData() {
    final actualSpots = <FlSpot>[];
    final targetSpots = <FlSpot>[];
    
    for (int i = 0; i < trendPoints.length; i++) {
      final point = trendPoints[i];
      
      switch (kpiType) {
        case 'sales':
          if (point.salesActual != null) {
            actualSpots.add(FlSpot(i.toDouble(), point.salesActual!));
          }
          if (point.salesTarget != null) {
            targetSpots.add(FlSpot(i.toDouble(), point.salesTarget!));
          }
          break;
        case 'gem':
          if (point.gemScore != null) {
            actualSpots.add(FlSpot(i.toDouble(), point.gemScore!));
          }
          if (point.gemTarget != null) {
            targetSpots.add(FlSpot(i.toDouble(), point.gemTarget!));
          }
          break;
        case 'labor':
          if (point.laborUsedPercentage != null) {
            actualSpots.add(FlSpot(i.toDouble(), point.laborUsedPercentage!));
          }
          if (point.laborTarget != null) {
            targetSpots.add(FlSpot(i.toDouble(), point.laborTarget!));
          }
          break;
      }
    }
    
    // Calculate min/max for better scaling
    final allYValues = [
      ...actualSpots.map((s) => s.y),
      ...targetSpots.map((s) => s.y),
    ];
    
    final minY = allYValues.isEmpty ? 0.0 : allYValues.reduce((a, b) => a < b ? a : b) * 0.9;
    final maxY = allYValues.isEmpty ? 100.0 : allYValues.reduce((a, b) => a > b ? a : b) * 1.1;
    
    return LineChartData(
      minY: minY,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 5,
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
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < trendPoints.length) {
                // Show every nth label to avoid crowding
                final showInterval = (trendPoints.length / 6).ceil();
                if (index % showInterval == 0 || index == trendPoints.length - 1) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      trendPoints[index].periodLabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
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
      lineBarsData: [
        // Actual line
        if (actualSpots.isNotEmpty)
          LineChartBarData(
            spots: actualSpots,
            isCurved: true,
            color: actualColor,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: actualColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: actualColor.withValues(alpha: 0.1),
            ),
          ),
        // Target line
        if (targetSpots.isNotEmpty)
          LineChartBarData(
            spots: targetSpots,
            isCurved: true,
            color: targetColor,
            barWidth: 2,
            dashArray: [5, 5],
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: targetColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              if (index >= 0 && index < trendPoints.length) {
                final point = trendPoints[index];
                final isActual = spot.barIndex == 0;
                
                return LineTooltipItem(
                  '${point.periodLabel}\n',
                  AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '${isActual ? "Actual" : "Target"}: ${_formatTooltipValue(spot.y)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }
              return null;
            }).toList();
          },
        ),
      ),
    );
  }
  
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Actual', actualColor),
        const SizedBox(width: 24),
        _buildLegendItem('Target', targetColor, isDashed: true),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: isDashed ? Colors.transparent : color,
            border: isDashed ? Border.all(color: color, width: 2) : null,
          ),
          child: isDashed
              ? CustomPaint(
                  painter: _DashedLinePainter(color),
                )
              : null,
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
    if (kpiType == 'sales') {
      if (value >= 1000) {
        return '\$${(value / 1000).toStringAsFixed(0)}K';
      }
      return '\$${value.toStringAsFixed(0)}';
    } else if (kpiType == 'labor') {
      return '${value.toStringAsFixed(0)}%';
    } else {
      return value.toStringAsFixed(1);
    }
  }
  
  String _formatTooltipValue(double value) {
    if (kpiType == 'sales') {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(value);
    } else if (kpiType == 'labor') {
      return '${value.toStringAsFixed(1)}%';
    } else {
      return value.toStringAsFixed(1);
    }
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  
  _DashedLinePainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;
    
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
