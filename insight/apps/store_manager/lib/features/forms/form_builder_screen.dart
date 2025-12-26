import 'package:flutter/material.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    if (widget.existingForm != null) {
      _formTitleController.text = widget.existingForm!.title;
      _formDescriptionController.text = widget.existingForm!.description ?? '';
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
          ),
          const _SettingsView(),
          const _PreviewView(),
        ],
      ),
    );
  }
}

class _CreationView extends StatelessWidget {
  final TextEditingController descriptionController;

  const _CreationView({required this.descriptionController});

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
                      
                      // Drop zone
                      Container(
                        padding: const EdgeInsets.all(48),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.border,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Drag fields here or click to add',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
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
          child: ListView(
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
  const _PreviewView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Text(
          'Form preview will appear here',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
