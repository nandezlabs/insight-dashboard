import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import '../../core/providers/app_providers.dart';

class FormsLibraryScreen extends ConsumerStatefulWidget {
  const FormsLibraryScreen({super.key});

  @override
  ConsumerState<FormsLibraryScreen> createState() => _FormsLibraryScreenState();
}

class _FormsLibraryScreenState extends ConsumerState<FormsLibraryScreen> {
  String _searchQuery = '';
  FormStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final formsAsync = ref.watch(formsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search forms...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                PopupMenuButton<FormStatus?>(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          _filterStatus == null ? 'All' : _filterStatus!.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All'),
                    ),
                    PopupMenuItem(
                      value: FormStatus.active,
                      child: Text(FormStatus.active.name),
                    ),
                    PopupMenuItem(
                      value: FormStatus.draft,
                      child: Text(FormStatus.draft.name),
                    ),
                    PopupMenuItem(
                      value: FormStatus.archived,
                      child: Text(FormStatus.archived.name),
                    ),
                  ],
                  onSelected: (value) {
                    setState(() {
                      _filterStatus = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Forms Grid
          Expanded(
            child: formsAsync.when(
              data: (forms) {
                final filteredForms = forms.where((form) {
                  final matchesSearch = _searchQuery.isEmpty ||
                      form.title.toLowerCase().contains(_searchQuery) ||
                      (form.description != null && form.description!.toLowerCase().contains(_searchQuery));
                  final matchesStatus = _filterStatus == null ||
                      form.status == _filterStatus;
                  return matchesSearch && matchesStatus;
                }).toList();

                if (filteredForms.isEmpty) {
                  return Center(
                    child: EmptyState(
                      icon: Icons.description_outlined,
                      title: 'No forms found',
                      message: 'Create your first form to get started',
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredForms.length,
                  itemBuilder: (context, index) {
                    final form = filteredForms[index];
                    return FormCard(
                      title: form.title,
                      description: form.description,
                      status: form.status == FormStatus.active 
                          ? SubmissionStatus.inProgress 
                          : SubmissionStatus.completed,
                      progress: 0.0, // Forms don't have progress
                      tags: form.tags,
                      onTap: () {
                        context.push(
                          '/forms/${form.id}/edit',
                          extra: form,
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => Center(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Error loading forms',
                  message: error.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/forms/create');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Create Form'),
      ),
    );
  }
}
