import 'package:flutter/material.dart';

/// Reusable card widget for dashboard sections
class DashboardCard extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    this.title,
    this.titleWidget,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null || titleWidget != null) ...[
                titleWidget ??
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                const SizedBox(height: 16),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
