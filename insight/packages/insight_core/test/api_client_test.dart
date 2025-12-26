import 'package:flutter_test/flutter_test.dart';
import 'package:insight_core/insight_core.dart';

void main() {
  group('API Client Configuration', () {
    test('ApiClient should initialize with correct base URL', () {
      // Initialize API client
      ApiClient.initialize(baseUrl: AppConstants.apiBaseUrl);

      // Verify base URL is set correctly
      expect(ApiClient.baseUrl, equals('http://100.112.230.47:8000'));
    });

    test('AppConstants should have API base URL defined', () {
      expect(AppConstants.apiBaseUrl, isNotEmpty);
      expect(AppConstants.apiBaseUrl, contains('http'));
    });
  });
}
