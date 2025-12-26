import '../models/form.dart';
import '../models/field.dart';
import '../services/api_client.dart';
import '../database/database.dart';

class FormRepository {
  final AppDatabase? _database;
  
  FormRepository({AppDatabase? database}) : _database = database;
  
  /// Get all forms (from local database if available, otherwise from API)
  Future<List<FormModel>> getAllForms() async {
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
    final response = await ApiClient.get('/api/forms');
    return (response.data as List)
        .map((json) => FormModel.fromJson(json))
        .toList();
  }

  /// Get form by ID
  Future<FormModel?> getFormById(String id) async {
    try {
      final response = await ApiClient.get('/api/forms/$id');
      return FormModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// Create form
  Future<FormModel> createForm(FormModel form) async {
    final response = await ApiClient.post('/api/forms', data: form.toJson());
    return FormModel.fromJson(response.data);
  }

  /// Update form
  Future<FormModel> updateForm(FormModel form) async {
    final response =
        await ApiClient.put('/api/forms/${form.id}', data: form.toJson());
    return FormModel.fromJson(response.data);
  }

  /// Delete form
  Future<void> deleteForm(String id) async {
    await ApiClient.delete('/api/forms/$id');
  }

  /// Get fields for a form
  Future<List<Field>> getFormFields(String formId) async {
    final response = await ApiClient.get('/api/forms/$formId/fields');
    return (response.data as List).map((json) => Field.fromJson(json)).toList();
  }

  /// Create field
  Future<Field> createField(Field field) async {
    final response = await ApiClient.post('/api/fields', data: field.toJson());
    return Field.fromJson(response.data);
  }

  /// Update field
  Future<Field> updateField(Field field) async {
    final response =
        await ApiClient.put('/api/fields/${field.id}', data: field.toJson());
    return Field.fromJson(response.data);
  }

  /// Delete field
  Future<void> deleteField(String id) async {
    await ApiClient.delete('/api/fields/$id');
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
