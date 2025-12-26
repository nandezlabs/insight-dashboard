class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.isEmpty) return null;

    if (value.length < min) {
      return 'Must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(String? value, int max) {
    if (value == null || value.isEmpty) return null;

    if (value.length > max) {
      return 'Must be at most $max characters';
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? range(String? value, double min, double max) {
    if (value == null || value.isEmpty) return null;

    final num = double.tryParse(value);
    if (num == null) {
      return 'Please enter a valid number';
    }

    if (num < min || num > max) {
      return 'Must be between $min and $max';
    }
    return null;
  }
}
