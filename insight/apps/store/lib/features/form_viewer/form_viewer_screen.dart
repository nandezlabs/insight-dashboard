import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import '../../core/providers/app_providers.dart';

class FormViewerScreen extends ConsumerStatefulWidget {
  final String formId;
  final FormModel? form;

  const FormViewerScreen({
    super.key,
    required this.formId,
    this.form,
  });

  @override
  ConsumerState<FormViewerScreen> createState() => _FormViewerScreenState();
}

class _FormViewerScreenState extends ConsumerState<FormViewerScreen> {
  final Map<String, dynamic> _answers = {};
  bool _isSaving = false;
  DateTime? _lastSaveTime;

  @override
  void initState() {
    super.initState();
    // Load existing submission if any
    _loadExistingSubmission();
  }

  Future<void> _loadExistingSubmission() async {
    try {
      final repository = ref.read(submissionRepositoryProvider);
      final submissions = await repository.getFormSubmissions(widget.formId);
      
      if (submissions.isNotEmpty) {
        // Load the most recent in-progress submission
        final inProgress = submissions.where((s) => s.status == SubmissionStatus.inProgress).toList();
        if (inProgress.isNotEmpty) {
          final existingSubmission = inProgress.first;
          // Note: Submission model doesn't have answers field, need to load answers separately
          final answers = await repository.getSubmissionAnswers(existingSubmission.id);
          setState(() {
            for (var answer in answers) {
              if (answer.answerValue != null) {
                _answers[answer.fieldId] = answer.answerValue;
              }
            }
          });
        }
      }
    } catch (e) {
      // No existing submission found or error loading
      debugPrint('Error loading submission: $e');
    }
  }

  void _onAnswerChanged(String fieldId, dynamic value) {
    setState(() {
      _answers[fieldId] = value;
    });
    _autoSave();
  }

  Future<void> _autoSave() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    // Debounce auto-save
    await Future.delayed(const Duration(milliseconds: FormConstants.autoSaveDebounceMs));

    // Simple mock auto-save - in production, save to local database
    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      _isSaving = false;
      _lastSaveTime = DateTime.now();
    });
  }

  int _getTotalFieldsCount() {
    // In a real implementation, count fields from form sections
    // For now, return a mock count
    return 10;
  }

  Future<void> _submitForm() async {
    final form = widget.form;
    if (form == null) return;

    // Validate required fields
    final totalFields = _getTotalFieldsCount();
    final answeredFields = _answers.length;
    
    if (answeredFields < totalFields) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Submit form
    setState(() => _isSaving = true);

    try {
      // Mock submission - in production, save to backend
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting form: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.form;

    if (form == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Form'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // TODO: Load form sections and fields separately
    final totalFields = 10; // Mock for now
    final answeredFields = _answers.length;
    final progress = totalFields > 0 ? answeredFields / totalFields : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(form.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else if (_lastSaveTime != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Saved',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  color: AppColors.primary,
                  minHeight: 8,
                ),
              ],
            ),
          ),
          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (form.description != null && form.description!.isNotEmpty) ...[
                    Text(
                      form.description!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // TODO: Load form sections and fields from database
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('Form fields will be loaded here'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Submit button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _submitForm,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Form',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Re-enable when form sections are properly loaded
  /*
  Widget _buildSection(FormSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title.isNotEmpty) ...[
          Text(
            section.title,
            style: AppTextStyles.headingSmall,
          ),
          if (section.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              section.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
        ...section.fields.map((field) => _buildField(field)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildField(FormField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  field.label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (field.isRequired)
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
            ],
          ),
          if (field.helpText.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              field.helpText,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          _buildFieldInput(field),
        ],
      ),
    );
  }

  Widget _buildFieldInput(FormField field) {
    switch (field.fieldType) {
      case 'short_text':
      case 'email':
      case 'phone':
        return TextField(
          decoration: InputDecoration(
            hintText: field.placeholder,
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _onAnswerChanged(field.id, value),
        );

      case 'long_text':
        return TextField(
          decoration: InputDecoration(
            hintText: field.placeholder,
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          onChanged: (value) => _onAnswerChanged(field.id, value),
        );

      case 'number':
        return TextField(
          decoration: InputDecoration(
            hintText: field.placeholder,
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final numValue = double.tryParse(value);
            _onAnswerChanged(field.id, numValue);
          },
        );

      case 'date':
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              _onAnswerChanged(field.id, date.toIso8601String());
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: field.placeholder,
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              _answers[field.id]?.toString().split('T')[0] ?? '',
            ),
          ),
        );

      case 'dropdown':
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: field.placeholder,
            border: OutlineInputBorder(),
          ),
          items: field.options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _onAnswerChanged(field.id, value);
            }
          },
        );

      case 'radio':
        return Column(
          children: field.options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _answers[field.id] as String?,
              onChanged: (value) {
                if (value != null) {
                  _onAnswerChanged(field.id, value);
                }
              },
            );
          }).toList(),
        );

      case 'checkbox':
        return Column(
          children: field.options.map((option) {
            final selectedValues = (_answers[field.id] as List<String>?) ?? [];
            return CheckboxListTile(
              title: Text(option),
              value: selectedValues.contains(option),
              onChanged: (checked) {
                final newValues = List<String>.from(selectedValues);
                if (checked == true) {
                  newValues.add(option);
                } else {
                  newValues.remove(option);
                }
                _onAnswerChanged(field.id, newValues);
              },
            );
          }).toList(),
        );

      default:
        return Text('Unsupported field type: ${field.fieldType}');
    }
  }
  */
}
