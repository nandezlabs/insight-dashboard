import '../models/form.dart';
import '../models/field.dart';
import '../services/api_client.dart';
import '../database/database.dart';
import 'auth_repository.dart';

class FormRepository {
  final AppDatabase? _database;
  
  FormRepository({AppDatabase? database}) : _database = database;
  
  // Test mode mock data
  static final List<FormModel> _mockForms = [
    FormModel(
      id: 'test-form-1',
      title: 'Daily Opening Checklist',
      description: 'Complete this form at store opening',
      tags: ['daily', 'operations'],
      scheduleType: FormScheduleType.tagBased,
      status: FormStatus.active,
      createdBy: 'test-user',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
    ),
    FormModel(
      id: 'test-form-2',
      title: 'Weekly Inventory Check',
      description: 'Weekly inventory verification form',
      tags: ['weekly', 'inventory'],
      scheduleType: FormScheduleType.tagBased,
      status: FormStatus.active,
      createdBy: 'test-user',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      updatedAt: DateTime.now(),
    ),
  ];

  static final List<Field> _mockFields = [
    // Daily Opening Checklist fields
    Field(
      id: 'field-1-1',
      formId: 'test-form-1',
      fieldType: FieldType.checkbox,
      label: 'Store entrance clean and welcoming',
      isRequired: true,
      order: 0,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-1-2',
      formId: 'test-form-1',
      fieldType: FieldType.checkbox,
      label: 'All lights working properly',
      isRequired: true,
      order: 1,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-1-3',
      formId: 'test-form-1',
      fieldType: FieldType.checkbox,
      label: 'Cash registers counted and balanced',
      isRequired: true,
      order: 2,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-1-4',
      formId: 'test-form-1',
      fieldType: FieldType.number,
      label: 'Opening float amount',
      placeholder: 'Enter amount',
      helpText: 'Starting cash in register',
      isRequired: true,
      order: 3,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-1-5',
      formId: 'test-form-1',
      fieldType: FieldType.time,
      label: 'Store opened at',
      isRequired: true,
      order: 4,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-1-6',
      formId: 'test-form-1',
      fieldType: FieldType.longText,
      label: 'Notes or issues to report',
      placeholder: 'Any problems or observations...',
      isRequired: false,
      order: 5,
      createdAt: DateTime.now(),
    ),
    
    // Weekly Inventory Check fields
    Field(
      id: 'field-2-1',
      formId: 'test-form-2',
      fieldType: FieldType.radio,
      label: 'Overall inventory status',
      isRequired: true,
      order: 0,
      validationRules: {
        'options': ['Fully Stocked', 'Needs Reorder', 'Critical Shortage']
      },
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-2-2',
      formId: 'test-form-2',
      fieldType: FieldType.number,
      label: 'Number of items below minimum stock',
      placeholder: 'Enter count',
      isRequired: true,
      order: 1,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-2-3',
      formId: 'test-form-2',
      fieldType: FieldType.longText,
      label: 'Items requiring immediate reorder',
      placeholder: 'List items separated by commas...',
      helpText: 'Include item names and approximate quantities needed',
      isRequired: false,
      order: 2,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-2-4',
      formId: 'test-form-2',
      fieldType: FieldType.checkbox,
      label: 'Checked all storage areas',
      isRequired: true,
      order: 3,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-2-5',
      formId: 'test-form-2',
      fieldType: FieldType.checkbox,
      label: 'Verified expiration dates on perishables',
      isRequired: true,
      order: 4,
      createdAt: DateTime.now(),
    ),
    Field(
      id: 'field-2-6',
      formId: 'test-form-2',
      fieldType: FieldType.date,
      label: 'Next recommended inventory check',
      isRequired: true,
      order: 5,
      createdAt: DateTime.now(),
    ),
  ];
  
  /// Get all forms (from local database if available, otherwise from API)
  Future<List<FormModel>> getAllForms() async {
    if (AuthRepository.testMode) {
      print('Test mode: Returning mock forms');
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockForms;
    }
    
    if (_database != null) {
      return await _getFormsFromDatabase();
    }
    return await getForms();
  }
  
  Future<List<FormModel>> _getFormsFromDatabase() async {
    // TODO: Implement conversion from database to models
    // For now, return empty list
    return [];
  }
  
  /// Get all forms from API
  Future<List<FormModel>> getForms() async {
    if (AuthRepository.testMode) {
      print('Test mode: Returning mock forms');
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockForms;
    }
    
    final response = await ApiClient.get('/api/v1/forms');
    return (response.data as List)
        .map((json) => FormModel.fromJson(json))
        .toList();
  }

  /// Get form by ID
  Future<FormModel?> getFormById(String id) async {
    if (AuthRepository.testMode) {
      print('Test mode: Getting mock form by ID: $id');
      await Future.delayed(const Duration(milliseconds: 200));
      try {
        return _mockForms.firstWhere((f) => f.id == id);
      } catch (e) {
        return null;
      }
    }
    
    try {
      final response = await ApiClient.get('/api/v1/forms/$id');
      return FormModel.fromJson(response.data);
    } on ApiException {
      return null;
    }
  }

  /// Create form
  Future<FormModel> createForm(FormModel form) async {
    final response = await ApiClient.post('/api/v1/forms', data: form.toJson());
    return FormModel.fromJson(response.data);
  }

  /// Update form
  Future<FormModel> updateForm(FormModel form) async {
    final response =
        await ApiClient.put('/api/v1/forms/${form.id}', data: form.toJson());
    return FormModel.fromJson(response.data);
  }

  /// Delete form
  Future<void> deleteForm(String id) async {
    await ApiClient.delete('/api/v1/forms/$id');
  }

  /// Get fields for a form
  Future<List<Field>> getFormFields(String formId) async {
    if (AuthRepository.testMode) {
      print('Test mode: Returning mock fields for form $formId');
      await Future.delayed(const Duration(milliseconds: 200));
      return _mockFields.where((f) => f.formId == formId).toList();
    }
    
    final response = await ApiClient.get('/api/v1/forms/$formId/fields');
    return (response.data as List).map((json) => Field.fromJson(json)).toList();
  }

  /// Create field
  Future<Field> createField(Field field) async {
    final response = await ApiClient.post(
      '/api/v1/forms/${field.formId}/fields',
      data: field.toJson(),
    );
    return Field.fromJson(response.data);
  }

  /// Update field
  Future<Field> updateField(Field field) async {
    final response = await ApiClient.put(
      '/api/v1/forms/fields/${field.id}',
      data: field.toJson(),
    );
    return Field.fromJson(response.data);
  }

  /// Delete field
  Future<void> deleteField(String id) async {
    await ApiClient.delete('/api/v1/forms/fields/$id');
  }

  /// Get field templates
  Future<List<FieldTemplate>> getFieldTemplates() async {
    final response = await ApiClient.get('/api/field-templates');
    return (response.data as List)
        .map((json) => FieldTemplate.fromJson(json))
        .toList();
  }

  /// Create field template
  Future<FieldTemplate> createFieldTemplate(FieldTemplate template) async {
    final response =
        await ApiClient.post('/api/field-templates', data: template.toJson());
    return FieldTemplate.fromJson(response.data);
  }
}
