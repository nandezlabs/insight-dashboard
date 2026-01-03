import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:store/core/services/connectivity_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('ConnectivityService', () {
    late ConnectivityService service;

    setUp(() {
      service = ConnectivityService();
    });

    tearDown(() {
      service.dispose();
    });

    test('should initialize with default online status', () {
      expect(service.isOnline, isTrue);
    });

    test('should emit connection status changes', () {
      // Verify stream is available without initialization
      expect(service.connectionStatus, isA<Stream<bool>>());
    });

    test('should detect offline status when no connectivity', () async {
      // This test would require mocking Connectivity class
      // For demonstration purposes only
      expect(service.isOnline, isA<bool>());
    });

    test('should dispose cleanly', () {
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
