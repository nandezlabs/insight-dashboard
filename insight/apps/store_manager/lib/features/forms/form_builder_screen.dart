import 'package:flutter/material.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';

// Local class for managing field state during form building
class FormFieldState {
  final String id;
  final FieldType type;
  final String label;
  final String? placeholder;
  final bool required;
  final List<String>? options;

  FormFieldState({
    required this.id,
    required this.type,
    required this.label,
    this.placeholder,
    required this.required,
    this.options,
  });

  FormFieldState copyWith({
    String? id,
    FieldType? type,
    String? label,
    String? placeholder,
    bool? required,
    List<String>? options,
  }) {
    return FormFieldState(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      placeholder: placeholder ?? this.placeholder,
      required: required ?? this.required,
      options: options ?? this.options,
    );
  }
}

class FormBuilderScreen extends StatefulWidget {
  final String? formId;
  final FormModel? existingForm;

  const FormBuilderScreen({
    super.key,
    this.formId,
    this.existingForm,
  });

  @override
  State<FormBuilderScreen> createState() => _FormBuilderScreenState();
}

class _FormBuilderScreenState extends State<FormBuilderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final _formTitleController = TextEditingController();
  final _formDescriptionController = TextEditingController();
  
  // Form fields state
  final List<FormFieldState> _fields = [];
  FormFieldState? _selectedField;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    if (widget.existingForm != null) {
      _formTitleController.text = widget.existingForm!.title;
      _formDescriptionController.text = widget.existingForm!.description ?? '';
      // Note: Load fields from FormRepository when implementing save/load
    }
  }
  
  void _addField(FieldType fieldType) {
    setState(() {
      final field = FormFieldState(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: fieldType,
        label: _getDefaultLabel(fieldType),
        required: false,
      );
      _fields.add(field);
      _selectedField = field;
    });
  }
  
  void _updateField(FormFieldState updatedField) {
    setState(() {
      final index = _fields.indexWhere((f) => f.id == updatedField.id);
      if (index != -1) {
        _fields[index] = updatedField;
        _selectedField = updatedField;
      }
    });
  }
  
  void _deleteField(String fieldId) {
    setState(() {
      _fields.removeWhere((f) => f.id == fieldId);
      if (_selectedField?.id == fieldId) {
        _selectedField = null;
      }
    });
  }
  
  void _selectField(FormFieldState? field) {
    setState(() {
      _selectedField = field;
    });
  }
  
  void _reorderFields(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final field = _fields.removeAt(oldIndex);
      _fields.insert(newIndex, field);
    });
  }
  
  String _getDefaultLabel(FieldType type) {
    switch (type) {
      case FieldType.shortText:
        return 'Short Text Field';
      case FieldType.longText:
        return 'Long Text Field';
      case FieldType.number:
        return 'Number Field';
      case FieldType.date:
        return 'Date Field';
      case FieldType.time:
        return 'Time Field';
      case FieldType.dropdown:
        return 'Dropdown Field';
      case FieldType.radio:
        return 'Radio Field';
      case FieldType.checkbox:
        return 'Checkbox Field';
      case FieldType.email:
        return 'Email Field';
      case FieldType.phone:
        return 'Phone Field';
      case FieldType.file:
        return 'File Upload Field';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _formTitleController.dispose();
    _formDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _formTitleController,
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Form Title',
            border: InputBorder.none,
            hintStyle: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: Save form
            },
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Creation'),
            Tab(text: 'Settings'),
            Tab(text: 'Preview'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CreationView(
            descriptionController: _formDescriptionController,
            fields: _fields,
            selectedField: _selectedField,
            onAddField: _addField,
            onUpdateField: _updateField,
            onDeleteField: _deleteField,
            onSelectField: _selectField,
            onReorderFields: _reorderFields,
          ),
          const _SettingsView(),
          _PreviewView(fields: _fields),
        ],
      ),
    );
  }
}

class _CreationView extends StatelessWidget {
  final TextEditingController descriptionController;
  final List<FormFieldState> fields;
  final FormFieldState? selectedField;
  final Function(FieldType) onAddField;
  final Function(FormFieldState) onUpdateField;
  final Function(String) onDeleteField;
  final Function(FormFieldState?) onSelectField;
  final Function(int, int) onReorderFields;

  const _CreationView({
    required this.descriptionController,
    required this.fields,
    required this.selectedField,
    required this.onAddField,
    required this.onUpdateField,
    required this.onDeleteField,
    required this.onSelectField,
    required this.onReorderFields,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Field Palette
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: AppColors.border),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Fields',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Basic Fields
              _FieldCategoryHeader(title: 'Basic'),
              _FieldPaletteItem(
                icon: Icons.short_text,
                label: 'Short Text',
                fieldType: FieldType.shortText,
              ),
              _FieldPaletteItem(
                icon: Icons.notes,
                label: 'Long Text',
                fieldType: FieldType.longText,
              ),
              _FieldPaletteItem(
                icon: Icons.numbers,
                label: 'Number',
                fieldType: FieldType.number,
              ),
              _FieldPaletteItem(
                icon: Icons.calendar_today,
                label: 'Date',
                fieldType: FieldType.date,
              ),
              _FieldPaletteItem(
                icon: Icons.access_time,
                label: 'Time',
                fieldType: FieldType.time,
              ),
              
              const SizedBox(height: 16),
              
              // Selection Fields
              _FieldCategoryHeader(title: 'Selection'),
              _FieldPaletteItem(
                icon: Icons.arrow_drop_down_circle,
                label: 'Dropdown',
                fieldType: FieldType.dropdown,
              ),
              _FieldPaletteItem(
                icon: Icons.radio_button_checked,
                label: 'Radio',
                fieldType: FieldType.radio,
              ),
              _FieldPaletteItem(
                icon: Icons.check_box,
                label: 'Checkbox',
                fieldType: FieldType.checkbox,
              ),
              
              const SizedBox(height: 16),
              
              // Advanced Fields
              _FieldCategoryHeader(title: 'Advanced'),
              _FieldPaletteItem(
                icon: Icons.email,
                label: 'Email',
                fieldType: FieldType.email,
              ),
              _FieldPaletteItem(
                icon: Icons.phone,
                label: 'Phone',
                fieldType: FieldType.phone,
              ),
              _FieldPaletteItem(
                icon: Icons.attach_file,
                label: 'File Upload',
                fieldType: FieldType.file,
              ),
            ],
          ),
        ),
        
        // Form Canvas
        Expanded(
          child: Container(
            color: AppColors.background,
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Add a description for this form...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Form fields
                      if (fields.isEmpty)
                        DragTarget<FieldType>(
                          onAcceptWithDetails: (details) => onAddField(details.data),
                          builder: (context, candidateData, rejectedData) {
                            final isDragging = candidateData.isNotEmpty;
                            return Container(
                              padding: const EdgeInsets.all(48),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDragging ? AppColors.primary : AppColors.border,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isDragging ? AppColors.primary.withValues(alpha: 0.05) : null,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      size: 48,
                                      color: isDragging ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Drag fields here to start building',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: isDragging ? AppColors.primary : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      else
                        ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          onReorder: onReorderFields,
                          itemCount: fields.length,
                          itemBuilder: (context, index) {
                            final field = fields[index];
                            final isSelected = selectedField?.id == field.id;
                            
                            return _FormFieldItem(
                              key: ValueKey(field.id),
                              field: field,
                              isSelected: isSelected,
                              onTap: () => onSelectField(field),
                              onDelete: () => onDeleteField(field.id),
                            );
                          },
                          footer: DragTarget<FieldType>(
                            onAcceptWithDetails: (details) => onAddField(details.data),
                            builder: (context, candidateData, rejectedData) {
                              final isDragging = candidateData.isNotEmpty;
                              return Container(
                                key: const ValueKey('footer'),
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDragging ? AppColors.primary : AppColors.border,
                                    width: 2,
                                    style: isDragging ? BorderStyle.solid : BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: isDragging ? AppColors.primary.withValues(alpha: 0.05) : null,
                                ),
                                child: Center(
                                  child: Text(
                                    isDragging ? 'Drop to add field' : 'Drag more fields here',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: isDragging ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Properties Panel
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: AppColors.border),
            ),
          ),
          child: selectedField == null
              ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Field Properties',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Select a field to edit its properties',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              : _FieldPropertiesPanel(
                  field: selectedField!,
                  onUpdate: onUpdateField,
                ),
        ),
      ],
    );
  }
}

class _FieldCategoryHeader extends StatelessWidget {
  final String title;

  const _FieldCategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _FieldPaletteItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final FieldType fieldType;

  const _FieldPaletteItem({
    required this.icon,
    required this.label,
    required this.fieldType,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<FieldType>(
      data: fieldType,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule Configuration',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Schedule type and frequency settings will be implemented here',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewView extends StatelessWidget {
  final List<FormFieldState> fields;
  
  const _PreviewView({required this.fields});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: fields.isEmpty
          ? Center(
              child: Text(
                'Add fields to see the form preview',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Form Preview',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...fields.map((field) => _PreviewFieldWidget(field: field)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _FormFieldItem extends StatelessWidget {
  final FormFieldState field;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FormFieldItem({
    super.key,
    required this.field,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  IconData _getFieldIcon() {
    switch (field.type) {
      case FieldType.shortText:
        return Icons.short_text;
      case FieldType.longText:
        return Icons.notes;
      case FieldType.number:
        return Icons.numbers;
      case FieldType.date:
        return Icons.calendar_today;
      case FieldType.time:
        return Icons.access_time;
      case FieldType.dropdown:
        return Icons.arrow_drop_down_circle;
      case FieldType.radio:
        return Icons.radio_button_checked;
      case FieldType.checkbox:
        return Icons.check_box;
      case FieldType.email:
        return Icons.email;
      case FieldType.phone:
        return Icons.phone;
      case FieldType.file:
        return Icons.attach_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.drag_indicator,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Icon(
              _getFieldIcon(),
              color: AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (field.required)
                    Text(
                      'Required',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              color: AppColors.error,
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldPropertiesPanel extends StatefulWidget {
  final FormFieldState field;
  final Function(FormFieldState) onUpdate;

  const _FieldPropertiesPanel({
    required this.field,
    required this.onUpdate,
  });

  @override
  State<_FieldPropertiesPanel> createState() => _FieldPropertiesPanelState();
}

class _FieldPropertiesPanelState extends State<_FieldPropertiesPanel> {
  late TextEditingController _labelController;
  late TextEditingController _placeholderController;
  late TextEditingController _optionsController;
  late bool _required;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(_FieldPropertiesPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field.id != widget.field.id) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _labelController = TextEditingController(text: widget.field.label);
    _placeholderController = TextEditingController(text: widget.field.placeholder);
    _optionsController = TextEditingController(
      text: widget.field.options?.join(', ') ?? '',
    );
    _required = widget.field.required;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _placeholderController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  void _updateField() {
    final options = _optionsController.text.isEmpty
        ? null
        : _optionsController.text.split(',').map((e) => e.trim()).toList();

    widget.onUpdate(
      widget.field.copyWith(
        label: _labelController.text,
        placeholder: _placeholderController.text.isEmpty ? null : _placeholderController.text,
        required: _required,
        options: options,
      ),
    );
  }

  bool _needsOptions() {
    return widget.field.type == FieldType.dropdown ||
        widget.field.type == FieldType.radio ||
        widget.field.type == FieldType.checkbox;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Field Properties',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        
        // Label
        Text(
          'Label',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _labelController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (_) => _updateField(),
        ),
        const SizedBox(height: 16),
        
        // Placeholder
        Text(
          'Placeholder',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _placeholderController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (_) => _updateField(),
        ),
        const SizedBox(height: 16),
        
        // Required toggle
        SwitchListTile(
          title: Text(
            'Required',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          value: _required,
          onChanged: (value) {
            setState(() {
              _required = value;
              _updateField();
            });
          },
          activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
          contentPadding: EdgeInsets.zero,
        ),
        
        // Options for dropdown/radio/checkbox
        if (_needsOptions()) ...[
          const SizedBox(height: 16),
          Text(
            'Options (comma-separated)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _optionsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Option 1, Option 2, Option 3',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: (_) => _updateField(),
          ),
        ],
      ],
    );
  }
}

class _PreviewFieldWidget extends StatelessWidget {
  final FormFieldState field;

  const _PreviewFieldWidget({required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                field.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (field.required)
                Text(
                  ' *',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFieldInput(),
        ],
      ),
    );
  }

  Widget _buildFieldInput() {
    switch (field.type) {
      case FieldType.shortText:
      case FieldType.email:
      case FieldType.phone:
        return TextField(
          decoration: InputDecoration(
            hintText: field.placeholder ?? 'Enter ${field.label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        );
        
      case FieldType.longText:
        return TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: field.placeholder ?? 'Enter ${field.label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        );
        
      case FieldType.number:
        return TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: field.placeholder ?? 'Enter a number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        );
        
      case FieldType.date:
        return TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Select date',
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        );
        
      case FieldType.time:
        return TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Select time',
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        );
        
      case FieldType.dropdown:
        return DropdownButtonFormField<String>(
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
          items: (field.options ?? ['Option 1', 'Option 2', 'Option 3'])
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (_) {},
        );
        
      case FieldType.radio:
        return Column(
          children: (field.options ?? ['Option 1', 'Option 2', 'Option 3'])
              .map((option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: null,
                    onChanged: (_) {},
                    contentPadding: EdgeInsets.zero,
                  ))
              .toList(),
        );
        
      case FieldType.checkbox:
        return Column(
          children: (field.options ?? ['Option 1', 'Option 2', 'Option 3'])
              .map((option) => CheckboxListTile(
                    title: Text(option),
                    value: false,
                    onChanged: (_) {},
                    contentPadding: EdgeInsets.zero,
                  ))
              .toList(),
        );
        
      case FieldType.file:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.cloud_upload_outlined),
              const SizedBox(width: 12),
              Text(
                'Click to upload or drag file here',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
    }
  }
}
