import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Card widget for displaying statistics (KPIs)
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final String? trend;
  final bool? isTrendPositive;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.trend,
    this.isTrendPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.primary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyles.numberMedium,
            ),
            if (trend != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isTrendPositive == true
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 16,
                    color: isTrendPositive == true
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isTrendPositive == true
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
