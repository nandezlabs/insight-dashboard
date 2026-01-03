import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/providers/app_providers.dart';

/// Base widget for rendering form fields based on field type
class FormFieldWidget extends StatelessWidget {
  final Field field;
  final dynamic value;
  final Function(dynamic) onChanged;
  final String? errorText;

  const FormFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field label
          Row(
            children: [
              Text(
                field.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (field.isRequired)
                Text(
                  ' *',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
          if (field.helpText != null) ...[
            const SizedBox(height: 4),
            Text(
              field.helpText!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          // Field input
          _buildFieldInput(context),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldInput(BuildContext context) {
    switch (field.fieldType) {
      case FieldType.shortText:
        return ShortTextFieldWidget(
          field: field,
          value: value as String?,
          onChanged: onChanged,
        );

      case FieldType.longText:
        return LongTextFieldWidget(
          field: field,
          value: value as String?,
          onChanged: onChanged,
        );

      case FieldType.email:
        return EmailFieldWidget(
          field: field,
          value: value as String?,
          onChanged: onChanged,
        );

      case FieldType.phone:
        return PhoneFieldWidget(
          field: field,
          value: value as String?,
          onChanged: onChanged,
        );

      case FieldType.number:
        return NumberFieldWidget(
          field: field,
          value: value as num?,
          onChanged: onChanged,
        );

      case FieldType.date:
        return DateFieldWidget(
          field: field,
          value: value as DateTime?,
          onChanged: onChanged,
        );

      case FieldType.time:
        return TimeFieldWidget(
          field: field,
          value: value as TimeOfDay?,
          onChanged: onChanged,
        );

      case FieldType.dropdown:
        return DropdownFieldWidget(
          field: field,
          value: value as String?,
          onChanged: onChanged,
        );

      case FieldType.radio:
        return RadioFieldWidget(
          field: field,
          value: value as String?,
          onChanged: onChanged,
        );

      case FieldType.checkbox:
        return CheckboxFieldWidget(
          field: field,
          value: value as List<String>?,
          onChanged: onChanged,
        );

      case FieldType.file:
        return FileFieldWidget(
          field: field,
          value: value,
          onChanged: onChanged,
        );
    }
  }
}

// Short Text Field
class ShortTextFieldWidget extends StatelessWidget {
  final Field field;
  final String? value;
  final Function(String?) onChanged;

  const ShortTextFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value)
        ..selection = TextSelection.collapsed(offset: value?.length ?? 0),
      decoration: InputDecoration(
        hintText: field.placeholder ?? 'Enter text',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      maxLength: field.validationRules?['maxLength'] as int? ?? FormConstants.defaultMaxTextLength,
      onChanged: onChanged,
    );
  }
}

// Long Text Field
class LongTextFieldWidget extends StatelessWidget {
  final Field field;
  final String? value;
  final Function(String?) onChanged;

  const LongTextFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value)
        ..selection = TextSelection.collapsed(offset: value?.length ?? 0),
      decoration: InputDecoration(
        hintText: field.placeholder ?? 'Enter detailed text',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      maxLines: 5,
      maxLength: field.validationRules?['maxLength'] as int? ?? FormConstants.defaultMaxLongTextLength,
      onChanged: onChanged,
    );
  }
}

// Email Field
class EmailFieldWidget extends StatelessWidget {
  final Field field;
  final String? value;
  final Function(String?) onChanged;

  const EmailFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value)
        ..selection = TextSelection.collapsed(offset: value?.length ?? 0),
      decoration: InputDecoration(
        hintText: field.placeholder ?? 'email@example.com',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
    );
  }
}

// Phone Field
class PhoneFieldWidget extends StatelessWidget {
  final Field field;
  final String? value;
  final Function(String?) onChanged;

  const PhoneFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value)
        ..selection = TextSelection.collapsed(offset: value?.length ?? 0),
      decoration: InputDecoration(
        hintText: field.placeholder ?? '(555) 123-4567',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        prefixIcon: const Icon(Icons.phone_outlined),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      onChanged: onChanged,
    );
  }
}

// Number Field
class NumberFieldWidget extends StatelessWidget {
  final Field field;
  final num? value;
  final Function(num?) onChanged;

  const NumberFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value?.toString() ?? '')
        ..selection = TextSelection.collapsed(offset: value?.toString().length ?? 0),
      decoration: InputDecoration(
        hintText: field.placeholder ?? 'Enter number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: (text) {
        if (text.isEmpty) {
          onChanged(null);
        } else {
          final number = num.tryParse(text);
          onChanged(number);
        }
      },
    );
  }
}

// Date Field
class DateFieldWidget extends StatefulWidget {
  final Field field;
  final DateTime? value;
  final Function(DateTime?) onChanged;

  const DateFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  State<DateFieldWidget> createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: widget.value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          widget.onChanged(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.value != null
                    ? '${widget.value!.month}/${widget.value!.day}/${widget.value!.year}'
                    : widget.field.placeholder ?? 'Select date',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: widget.value != null ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Time Field
class TimeFieldWidget extends StatefulWidget {
  final Field field;
  final TimeOfDay? value;
  final Function(TimeOfDay?) onChanged;

  const TimeFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  State<TimeFieldWidget> createState() => _TimeFieldWidgetState();
}

class _TimeFieldWidgetState extends State<TimeFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: widget.value ?? TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.input,
        );
        if (time != null) {
          widget.onChanged(time);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.value != null
                    ? widget.value!.format(context)
                    : widget.field.placeholder ?? 'Select time',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: widget.value != null ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dropdown Field
class DropdownFieldWidget extends StatelessWidget {
  final Field field;
  final String? value;
  final Function(String?) onChanged;

  const DropdownFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  List<String> get _options {
    final rules = field.validationRules;
    if (rules != null && rules['options'] is List) {
      return (rules['options'] as List).cast<String>();
    }
    return ['Option 1', 'Option 2', 'Option 3'];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      hint: Text(field.placeholder ?? 'Select an option'),
      items: _options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

// Radio Field
class RadioFieldWidget extends StatelessWidget {
  final Field field;
  final String? value;
  final Function(String?) onChanged;

  const RadioFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  List<String> get _options {
    final rules = field.validationRules;
    if (rules != null && rules['options'] is List) {
      return (rules['options'] as List).cast<String>();
    }
    return ['Option 1', 'Option 2', 'Option 3'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _options
          .map((option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: value,
                onChanged: onChanged,
                contentPadding: EdgeInsets.zero,
              ))
          .toList(),
    );
  }
}

// Checkbox Field
class CheckboxFieldWidget extends StatelessWidget {
  final Field field;
  final List<String>? value;
  final Function(List<String>?) onChanged;

  const CheckboxFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  List<String> get _options {
    final rules = field.validationRules;
    if (rules != null && rules['options'] is List) {
      return (rules['options'] as List).cast<String>();
    }
    return ['Option 1', 'Option 2', 'Option 3'];
  }

  @override
  Widget build(BuildContext context) {
    final selectedValues = value ?? [];
    
    return Column(
      children: _options
          .map((option) => CheckboxListTile(
                title: Text(option),
                value: selectedValues.contains(option),
                onChanged: (checked) {
                  final newValues = List<String>.from(selectedValues);
                  if (checked == true) {
                    newValues.add(option);
                  } else {
                    newValues.remove(option);
                  }
                  onChanged(newValues.isEmpty ? null : newValues);
                },
                contentPadding: EdgeInsets.zero,
              ))
          .toList(),
    );
  }
}

// File Field
class FileFieldWidget extends ConsumerStatefulWidget {
  final Field field;
  final dynamic value;
  final Function(dynamic) onChanged;

  const FileFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  @override
  ConsumerState<FileFieldWidget> createState() => _FileFieldWidgetState();
}

class _FileFieldWidgetState extends ConsumerState<FileFieldWidget> {
  List<Map<String, dynamic>> _uploadedFiles = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingFiles();
  }

  void _loadExistingFiles() {
    if (widget.value is List) {
      // Load existing file URLs/metadata
      setState(() {
        _uploadedFiles = (widget.value as List).map((item) {
          if (item is Map<String, dynamic>) {
            return item;
          } else if (item is String) {
            // Legacy format: just file URLs
            return {'url': item, 'filename': item.split('/').last};
          }
          return <String, dynamic>{};
        }).toList();
      });
    }
  }

  Future<void> _pickAndUploadFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'xls', 'xlsx'],
      );

      if (result == null || result.files.isEmpty) return;

      setState(() => _isUploading = true);

      final fileRepository = ref.read(fileRepositoryProvider);
      final filesToUpload = result.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .toList();

      if (filesToUpload.isEmpty) {
        setState(() => _isUploading = false);
        return;
      }

      // Upload files to backend
      final response = await fileRepository.uploadFiles(filesToUpload);
      
      if (response['success'] == true && response['files'] is List) {
        final newFiles = (response['files'] as List).cast<Map<String, dynamic>>();
        setState(() {
          _uploadedFiles.addAll(newFiles);
          _isUploading = false;
        });
        
        // Store file metadata
        widget.onChanged(_uploadedFiles);
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading files: $e')),
        );
      }
    }
  }

  Future<void> _removeFile(int index) async {
    final file = _uploadedFiles[index];
    
    try {
      // Delete from backend if it has a stored_filename
      if (file['stored_filename'] != null) {
        final fileRepository = ref.read(fileRepositoryProvider);
        await fileRepository.deleteFile(file['stored_filename']);
      }
      
      setState(() {
        _uploadedFiles.removeAt(index);
      });
      
      widget.onChanged(_uploadedFiles.isEmpty ? null : _uploadedFiles);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting file: $e')),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _buildFilePreview(Map<String, dynamic> file, int index) {
    final filename = file['filename'] ?? 'Unknown';
    final extension = file['extension'] ?? '';
    final size = file['size'] ?? 0;
    final fileType = file['type'] ?? 'unknown';
    final isImage = fileType == 'image';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: isImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Icon(_getFileIcon(extension), size: 40),
                // TODO: Load actual image from URL when backend supports it
              )
            : Icon(_getFileIcon(extension), size: 40),
        title: Text(
          filename,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(_formatFileSize(size)),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _removeFile(index),
        ),
      ),
    );
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _isUploading ? null : _pickAndUploadFiles,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isUploading ? AppColors.textSecondary : AppColors.border,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _isUploading ? Icons.hourglass_empty : Icons.cloud_upload_outlined,
                  color: _isUploading ? AppColors.textSecondary : AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isUploading
                        ? 'Uploading...'
                        : widget.field.placeholder ?? 'Tap to upload files',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _isUploading ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.attach_file),
              ],
            ),
          ),
        ),
        if (_uploadedFiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            '${_uploadedFiles.length} file(s) uploaded',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ..._uploadedFiles.asMap().entries.map((entry) => _buildFilePreview(entry.value, entry.key)),
        ],
      ],
    );
  }
}
