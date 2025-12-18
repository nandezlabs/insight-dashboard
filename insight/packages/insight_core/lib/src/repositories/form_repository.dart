import '../models/form.dart';
import '../models/field.dart';
import '../services/supabase_service.dart';

class FormRepository {
  final _supabase = SupabaseService.client;

  /// Get all forms
  Future<List<FormModel>> getForms() async {
    final response = await _supabase
        .from('forms')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => FormModel.fromJson(json))
        .toList();
  }

  /// Get form by ID
  Future<FormModel?> getFormById(String id) async {
    final response = await _supabase
        .from('forms')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? FormModel.fromJson(response) : null;
  }

  /// Create form
  Future<FormModel> createForm(FormModel form) async {
    final response = await _supabase
        .from('forms')
        .insert(form.toJson())
        .select()
        .single();

    return FormModel.fromJson(response);
  }

  /// Update form
  Future<FormModel> updateForm(FormModel form) async {
    final response = await _supabase
        .from('forms')
        .update(form.toJson())
        .eq('id', form.id)
        .select()
        .single();

    return FormModel.fromJson(response);
  }

  /// Delete form
  Future<void> deleteForm(String id) async {
    await _supabase.from('forms').delete().eq('id', id);
  }

  /// Get fields for a form
  Future<List<Field>> getFormFields(String formId) async {
    final response = await _supabase
        .from('fields')
        .select()
        .eq('form_id', formId)
        .order('order', ascending: true);

    return (response as List).map((json) => Field.fromJson(json)).toList();
  }

  /// Create field
  Future<Field> createField(Field field) async {
    final response = await _supabase
        .from('fields')
        .insert(field.toJson())
        .select()
        .single();

    return Field.fromJson(response);
  }

  /// Update field
  Future<Field> updateField(Field field) async {
    final response = await _supabase
        .from('fields')
        .update(field.toJson())
        .eq('id', field.id)
        .select()
        .single();

    return Field.fromJson(response);
  }

  /// Delete field
  Future<void> deleteField(String id) async {
    await _supabase.from('fields').delete().eq('id', id);
  }

  /// Get field templates
  Future<List<FieldTemplate>> getFieldTemplates() async {
    final response = await _supabase
        .from('field_templates')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => FieldTemplate.fromJson(json))
        .toList();
  }

  /// Create field template
  Future<FieldTemplate> createFieldTemplate(FieldTemplate template) async {
    final response = await _supabase
        .from('field_templates')
        .insert(template.toJson())
        .select()
        .single();

    return FieldTemplate.fromJson(response);
  }
}
