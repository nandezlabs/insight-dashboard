import 'package:flutter/material.dart';
import 'package:insight_core/insight_core.dart';
import '../theme/app_colors.dart';

/// Card widget for displaying form information
class FormCard extends StatelessWidget {
  final String title;
  final String? description;
  final SubmissionStatus status;
  final double? progress;
  final VoidCallback? onTap;
  final List<String>? tags;

  const FormCard({
    super.key,
    required this.title,
    this.description,
    required this.status,
    this.progress,
    this.onTap,
    this.tags,
  });

  Color _getStatusColor() {
    switch (status) {
      case SubmissionStatus.inProgress:
        return AppColors.statusInProgress;
      case SubmissionStatus.completed:
        return AppColors.statusCompleted;
      case SubmissionStatus.autoSubmitted:
        return AppColors.statusAutoSubmitted;
    }
  }

  String _getStatusText() {
    switch (status) {
      case SubmissionStatus.inProgress:
        return 'In Progress';
      case SubmissionStatus.completed:
        return 'Completed';
      case SubmissionStatus.autoSubmitted:
        return 'Auto-Submitted';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (progress != null) ...[
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${(progress! * 100).toInt()}%',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              ],
              if (tags != null && tags!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags!.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
