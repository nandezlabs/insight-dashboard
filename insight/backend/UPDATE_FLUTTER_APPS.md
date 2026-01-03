# Update Flutter Apps for Hostinger Backend

After deploying the backend to Hostinger, follow these steps to update your Flutter apps.

## Step 1: Update API Base URL

### Option A: Create API Constants File (Recommended)

If you don't have this file yet, create it:

**File**: `packages/insight_core/lib/src/constants/api_constants.dart`

```dart
/// API configuration constants
class ApiConstants {
  ApiConstants._();

  /// Base URL for API endpoints
  /// Development: http://localhost:8000/api/v1
  /// Production: https://yourdomain.com/api/v1
  static const String baseUrl = 'https://yourdomain.com/api/v1';

  /// API timeout duration
  static const Duration timeout = Duration(seconds: 30);

  /// Enable API logging
  static const bool enableLogging = false; // Set to false in production

  // Endpoints
  static const String authLogin = '/auth/login';
  static const String authLogout = '/auth/logout';
  static const String forms = '/forms';
  static const String submissions = '/submissions';
  static const String goals = '/goals';
  static const String kpis = '/kpis';
  static const String team = '/team';
  static const String files = '/files';
}
```

Export in `packages/insight_core/lib/src/constants/constants.dart`:
```dart
export 'api_constants.dart';
export 'app_constants.dart';
export 'form_constants.dart';
```

### Option B: Update Existing Configuration

Find where your base URL is currently defined and update it to:
```dart
static const String baseUrl = 'https://yourdomain.com/api/v1';
```

Common locations:
- `packages/insight_core/lib/src/repositories/*_repository.dart`
- `packages/insight_core/lib/src/services/*_service.dart`
- Environment configuration files

## Step 2: Update All Repositories

Ensure all repositories use the centralized base URL:

### Example: Auth Repository

```dart
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class AuthRepository {
  Future<AuthToken> login(String storeCode, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.authLogin}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'store_code': storeCode,
        'password': password,
      }),
    ).timeout(ApiConstants.timeout);
    
    // ... rest of implementation
  }
}
```

### Check These Files:

```bash
# Search for hardcoded URLs
cd /Users/nandez/Developer/insight
grep -r "localhost:8000" packages/insight_core/lib/src/
grep -r "http://" packages/insight_core/lib/src/repositories/
grep -r "http://" packages/insight_core/lib/src/services/
```

## Step 3: Update CORS Configuration

Ensure your backend `.env` file includes your app's domain:

```bash
# On your Hostinger VPS
cd /opt/insight/backend
nano .env

# Add (if serving a web version):
CORS_ORIGINS=https://yourdomain.com,https://www.yourdomain.com,https://app.yourdomain.com
```

For mobile apps, you may need:
```bash
CORS_ORIGINS=*
```

Or specific mobile schemes:
```bash
CORS_ORIGINS=capacitor://localhost,ionic://localhost
```

## Step 4: Handle SSL Certificates (iOS)

iOS requires valid SSL certificates. Your Hostinger deployment with Let's Encrypt handles this automatically, but ensure:

### Info.plist Configuration

**File**: `apps/store/ios/Runner/Info.plist`
**File**: `apps/store_manager/ios/Runner/Info.plist`

Remove any App Transport Security exceptions if they exist:
```xml
<!-- Remove this if present: -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Step 5: Environment-Based Configuration (Advanced)

For managing multiple environments:

```dart
enum Environment { development, staging, production }

class ApiConfig {
  static Environment _environment = Environment.production;
  
  static String get baseUrl {
    switch (_environment) {
      case Environment.development:
        return 'http://localhost:8000/api/v1';
      case Environment.staging:
        return 'https://staging.yourdomain.com/api/v1';
      case Environment.production:
        return 'https://yourdomain.com/api/v1';
    }
  }
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
}
```

## Step 6: Test Connection

### Create a Test Script

**File**: `packages/insight_core/test/api_connection_test.dart`

```dart
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:insight_core/insight_core.dart';

void main() {
  test('API health check', () async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl.replaceAll('/api/v1', '')}/health'),
    );
    
    expect(response.statusCode, 200);
    expect(response.body, contains('healthy'));
  });

  test('API endpoints accessible', () async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/forms'),
      headers: {'Authorization': 'Bearer test-token'},
    );
    
    // Should return 401 (unauthorized) or 200 (success)
    expect([200, 401].contains(response.statusCode), true);
  });
}
```

Run test:
```bash
cd packages/insight_core
flutter test test/api_connection_test.dart
```

## Step 7: Rebuild Apps

### Store Manager (macOS)

```bash
cd apps/store_manager

# Clean build
flutter clean
flutter pub get

# Build
flutter build macos --release

# Run to test
flutter run -d macos
```

### Store (iOS)

```bash
cd apps/store

# Clean build
flutter clean
flutter pub get

# Build for iOS
flutter build ios --release

# Or run on simulator to test
flutter run -d "iPhone 15"
```

### Store (Android)

```bash
cd apps/store

# Build APK
flutter build apk --release

# Or build App Bundle for Play Store
flutter build appbundle --release
```

## Step 8: Verify Deployment

### Test Checklist

- [ ] Apps can reach health endpoint
- [ ] Login works with real credentials
- [ ] Forms can be fetched from server
- [ ] Submissions can be synced
- [ ] File uploads work
- [ ] All API calls use HTTPS
- [ ] No SSL certificate warnings
- [ ] API responses are properly parsed

### Monitor in Production

```bash
# On Hostinger VPS
cd /opt/insight/backend

# Watch logs for incoming requests
docker compose logs -f backend

# Filter for errors
docker compose logs backend | grep ERROR

# Check connection counts
docker compose exec postgres psql -U insight_user insight_db -c "SELECT count(*) FROM pg_stat_activity;"
```

## Rollback Plan

If issues occur:

### Quick Rollback to localhost

```dart
// Temporarily revert to localhost for testing
class ApiConstants {
  static const String baseUrl = 'http://localhost:8000/api/v1';
}
```

### Use Backend Proxy (Development)

```bash
# On local machine, proxy to Hostinger
ssh -L 8000:localhost:8000 root@your-vps-ip

# Apps can use localhost:8000 which proxies to production
```

## Common Issues

### Issue: "Failed to connect"
**Solution**: Check firewall on Hostinger VPS
```bash
sudo ufw status
sudo ufw allow 443/tcp
```

### Issue: "SSL handshake failed"
**Solution**: Verify SSL certificate
```bash
curl -v https://yourdomain.com/health
```

### Issue: "CORS error"
**Solution**: Update CORS_ORIGINS in backend `.env`
```bash
CORS_ORIGINS=*
docker compose restart backend
```

### Issue: "Connection timeout"
**Solution**: Increase timeout in apps
```dart
static const Duration timeout = Duration(seconds: 60);
```

## Performance Optimization

### Enable HTTP/2
Already configured in Nginx setup ✓

### Add Response Caching
```dart
class ApiClient {
  final _cache = <String, dynamic>{};
  final _cacheExpiry = <String, DateTime>{};
  
  Future<dynamic> getCached(String endpoint, {Duration ttl = const Duration(minutes: 5)}) async {
    if (_cache.containsKey(endpoint) && 
        _cacheExpiry[endpoint]!.isAfter(DateTime.now())) {
      return _cache[endpoint];
    }
    
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}$endpoint'));
    _cache[endpoint] = jsonDecode(response.body);
    _cacheExpiry[endpoint] = DateTime.now().add(ttl);
    
    return _cache[endpoint];
  }
}
```

### Connection Pooling
Already handled by http package ✓

## Next Steps

1. ✅ Update API URLs in Flutter apps
2. ⬜ Set up automated testing against production
3. ⬜ Configure error reporting (Sentry, Firebase Crashlytics)
4. ⬜ Set up CI/CD for automated app deployment
5. ⬜ Monitor API performance and usage

---

**Updated**: January 2026  
**Backend URL**: https://yourdomain.com/api/v1  
**Estimated Update Time**: 10-15 minutes
