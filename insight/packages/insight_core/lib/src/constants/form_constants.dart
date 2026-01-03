class FormConstants {
  // Tags
  static const String tagDaily = 'daily';
  static const String tagWeekly = 'weekly';
  static const String tagPeriod = 'period';
  static const String tagOperations = 'operations';
  static const String tagMain = 'main';

  // Field types
  static const List<String> basicFieldTypes = [
    'short_text',
    'long_text',
    'number',
    'date',
    'time',
  ];

  static const List<String> selectionFieldTypes = [
    'dropdown',
    'radio',
    'checkbox',
  ];

  static const List<String> advancedFieldTypes = [
    'email',
    'phone',
    'file',
  ];

  // Validation
  static const int defaultMaxTextLength = 500;
  static const int defaultMinTextLength = 1;
  static const int defaultMaxLongTextLength = 5000;

  // Submission
  static const int autoSaveDebounceMs = 500;
  static const Duration submissionTimeout = Duration(minutes: 30);

  // Standard field labels for common use cases
  static const String completedByLabel = 'Completed by';
  static const String completedByHint = 'Enter your name';
  static const String completedByDescription = 'Name of the employee completing this section';
}
