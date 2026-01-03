import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/auth_provider.dart';
import 'form_field_widgets.dart';

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
  final Map<String, String> _fieldErrors = {};
  List<Field> _fields = [];
  bool _isLoadingFields = true;
  bool _isSaving = false;
  DateTime? _lastSaveTime;

  @override
  void initState() {
    super.initState();
    _loadFormFields();
    _loadExistingSubmission();
  }
  
  Future<void> _loadFormFields() async {
    try {
      final repository = ref.read(formRepositoryProvider);
      final fields = await repository.getFormFields(widget.formId);
      setState(() {
        _fields = fields..sort((a, b) => a.order.compareTo(b.order));
        _isLoadingFields = false;
      });
    } catch (e) {
      debugPrint('Error loading fields: $e');
      setState(() => _isLoadingFields = false);
    }
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
      // Clear error when user starts typing
      _fieldErrors.remove(fieldId);
    });
    _autoSave();
  }
  
  bool _validateField(Field field) {
    final value = _answers[field.id];
    
    // Check required
    if (field.isRequired) {
      if (value == null || 
          (value is String && value.trim().isEmpty) ||
          (value is List && value.isEmpty)) {
        _fieldErrors[field.id] = 'This field is required';
        return false;
      }
    }
    
    // Field-specific validation
    if (value != null) {
      switch (field.fieldType) {
        case FieldType.email:
          if (value is String) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              _fieldErrors[field.id] = 'Please enter a valid email';
              return false;
            }
          }
          break;
          
        case FieldType.phone:
          if (value is String && value.length < 10) {
            _fieldErrors[field.id] = 'Please enter a valid phone number';
            return false;
          }
          break;
          
        case FieldType.number:
          final rules = field.validationRules;
          if (rules != null && value is num) {
            if (rules['min'] != null && value < rules['min']) {
              _fieldErrors[field.id] = 'Value must be at least ${rules["min"]}';
              return false;
            }
            if (rules['max'] != null && value > rules['max']) {
              _fieldErrors[field.id] = 'Value must be at most ${rules["max"]}';
              return false;
            }
          }
          break;
          
        default:
          break;
      }
    }
    
    _fieldErrors.remove(field.id);
    return true;
  }
  
  bool _validateAllFields() {
    bool isValid = true;
    _fieldErrors.clear();
    
    for (final field in _fields) {
      if (!_validateField(field)) {
        isValid = false;
      }
    }
    
    setState(() {}); // Trigger rebuild to show errors
    return isValid;
  }

  Future<void> _autoSave() async {
    if (_isSaving || _fields.isEmpty) return;

    setState(() => _isSaving = true);

    // Debounce auto-save
    await Future.delayed(const Duration(milliseconds: FormConstants.autoSaveDebounceMs));

    try {
      final repository = ref.read(submissionRepositoryProvider);
      
      // Check if we have an existing in-progress submission
      final submissions = await repository.getFormSubmissions(widget.formId);
      final inProgress = submissions.where((s) => s.status == SubmissionStatus.inProgress).toList();
      
      Submission submission;
      if (inProgress.isNotEmpty) {
        // Update existing
        submission = inProgress.first.copyWith(updatedAt: DateTime.now());
        await repository.updateSubmission(submission);
      } else {
        // Create new in-progress submission
        final authState = ref.read(authProvider);
        final storeCode = authState.user?.username ?? 'unknown';
        
        submission = Submission(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          formId: widget.formId,
          submittedBy: storeCode,
          submissionDate: DateTime.now(),
          submissionTime: DateTime.now(),
          status: SubmissionStatus.inProgress,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await repository.createSubmission(submission);
      }
      
      // Save/update answers
      for (final field in _fields) {
        final value = _answers[field.id];
        if (value != null) {
          final serialized = _serializeValue(value);
          final answer = SubmissionAnswer(
            id: '${submission.id}_${field.id}',
            submissionId: submission.id,
            fieldId: field.id,
            fieldLabel: field.label,
            answerValue: serialized,
            value: serialized,
            answeredAt: DateTime.now(),
          );
          
          // Use saveAnswer which handles create/update
          await repository.saveAnswer(answer);
        }
      }

      setState(() {
        _isSaving = false;
        _lastSaveTime = DateTime.now();
      });
    } catch (e) {
      debugPrint('Auto-save error: $e');
      setState(() => _isSaving = false);
    }
  }

  int _getTotalFieldsCount() {
    return _fields.length;
  }
  
  int _getAnsweredFieldsCount() {
    int count = 0;
    for (final field in _fields) {
      final value = _answers[field.id];
      if (value != null && 
          (value is! String || value.trim().isNotEmpty) &&
          (value is! List || value.isNotEmpty)) {
        count++;
      }
    }
    return count;
  }

  Future<void> _submitForm() async {
    final form = widget.form;
    if (form == null) return;

    // Validate all fields
    if (!_validateAllFields()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please ensure all questions are answered'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Submit form
    setState(() => _isSaving = true);

    try {
      final repository = ref.read(submissionRepositoryProvider);
      
      // Create submission
      final now = DateTime.now();
      final authState = ref.read(authProvider);
      final storeCode = authState.user?.username ?? 'unknown';
      
      final submission = Submission(
        id: now.millisecondsSinceEpoch.toString(),
        formId: widget.formId,
        submittedBy: storeCode,
        submissionDate: now,
        submissionTime: now,
        status: SubmissionStatus.completed,
        completionPercentage: 100.0,
        createdAt: now,
        updatedAt: now,
      );
      
      // Create submission with answers
      await repository.createSubmission(submission);
      
      // Create answer records for each field
      for (final field in _fields) {
        final value = _answers[field.id];
        if (value != null) {
          final serialized = _serializeValue(value);
          final answer = SubmissionAnswer(
            id: '${submission.id}_${field.id}',
            submissionId: submission.id,
            fieldId: field.id,
            fieldLabel: field.label,
            answerValue: serialized,
            value: serialized,
            answeredAt: now,
          );
          
          await repository.saveAnswer(answer);
        }
      }

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Form Submitted!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your response has been recorded successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
        
        // Auto-dismiss and navigate back after 3 seconds
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          Navigator.of(context).pop(); // Close dialog
          context.pop(); // Navigate back to previous screen
        }
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
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
  
  String _serializeValue(dynamic value) {
    if (value is DateTime) {
      return value.toIso8601String();
    } else if (value is TimeOfDay) {
      return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    } else if (value is List) {
      return value.join(',');
    } else {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.form;

    if (form == null || _isLoadingFields) {
      return Scaffold(
        appBar: AppBar(
          title: Text(form?.title ?? 'Form'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final totalFields = _getTotalFieldsCount();
    final answeredFields = _getAnsweredFieldsCount();
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
                  // Render form fields
                  if (_fields.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No fields found for this form',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ..._fields.map((field) => FormFieldWidget(
                      field: field,
                      value: _answers[field.id],
                      onChanged: (value) => _onAnswerChanged(field.id, value),
                      errorText: _fieldErrors[field.id],
                    )),
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
