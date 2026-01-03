import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_providers.dart';

enum FormFilter { all, pending, completed, overdue }

class FormsListScreen extends ConsumerStatefulWidget {
  const FormsListScreen({super.key});

  @override
  ConsumerState<FormsListScreen> createState() => _FormsListScreenState();
}

class _FormsListScreenState extends ConsumerState<FormsListScreen> {
  FormFilter _selectedFilter = FormFilter.pending;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final formsAsync = ref.watch(activeFormsProvider);
    final submissionsAsync = ref.watch(mySubmissionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checklists'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search checklists...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // Forms Grid
          Expanded(
            child: formsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text('Error loading checklists', style: AppTextStyles.bodyLarge),
                    const SizedBox(height: 8),
                    Text(error.toString(), style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              data: (forms) {
                return submissionsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => _buildFormsList(forms, []),
                  data: (submissions) => _buildFormsList(forms, submissions),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormsList(List<FormModel> forms, List<Submission> submissions) {
    // Filter and search
    var filteredForms = forms.where((form) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!form.title.toLowerCase().contains(query) &&
            !(form.description?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }
      return true;
    }).toList();

    if (filteredForms.isEmpty) {
      return EmptyState(
        icon: Icons.assignment_outlined,
        title: 'No Checklists Found',
        message: _searchQuery.isNotEmpty 
            ? 'No checklists match your search'
            : 'No checklists available',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(activeFormsProvider);
        ref.invalidate(mySubmissionsProvider);
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: filteredForms.length,
        itemBuilder: (context, index) {
          final form = filteredForms[index];
          final formSubmissions = submissions.where((s) => s.formId == form.id).toList();
          return _buildFormCard(form, formSubmissions);
        },
      ),
    );
  }

  Widget _buildFormCard(FormModel form, List<Submission> submissions) {
    final hasCompleted = submissions.any((s) => 
      s.status == SubmissionStatus.completed || 
      s.status == SubmissionStatus.autoSubmitted
    );
    final inProgress = submissions.where((s) => 
      s.status == SubmissionStatus.inProgress
    ).firstOrNull;
    
    // Calculate progress percentage
    final progress = inProgress?.completionPercentage ?? (hasCompleted ? 100.0 : 0.0);
    
    // Get primary tag (daily, weekly, period)
    final primaryTag = form.tags.firstWhere(
      (tag) => ['daily', 'weekly', 'period'].contains(tag.toLowerCase()),
      orElse: () => form.tags.isNotEmpty ? form.tags.first : 'form',
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => context.push('/forms/${form.id}', extra: form),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with tag and progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tag badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTagColor(primaryTag).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      primaryTag.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _getTagColor(primaryTag),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  
                  // Circular progress indicator
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress / 100,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getStatusColor(hasCompleted, inProgress != null),
                          ),
                        ),
                        Text(
                          '${progress.toInt()}%',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Form icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Form title
              Text(
                form.title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Status text
              Text(
                _getStatusText(hasCompleted, inProgress != null),
                style: AppTextStyles.bodySmall.copyWith(
                  color: _getStatusColor(hasCompleted, inProgress != null),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'daily':
        return Colors.blue;
      case 'weekly':
        return Colors.green;
      case 'period':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon(bool completed, bool inProgress) {
    if (completed) return Icons.check_circle;
    if (inProgress) return Icons.edit;
    return Icons.assignment;
  }

  Color _getStatusColor(bool completed, bool inProgress) {
    if (completed) return AppColors.success;
    if (inProgress) return AppColors.warning;
    return AppColors.textSecondary;
  }

  String _getStatusText(bool completed, bool inProgress) {
    if (completed) return 'Completed';
    if (inProgress) return 'In Progress';
    return 'Not Started';
  }
}
