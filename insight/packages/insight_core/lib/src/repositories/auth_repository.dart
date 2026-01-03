import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_client.dart';

class AuthRepository {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  
  // Test mode - set to true to bypass backend and auto-login
  static const bool testMode = true;
  
  // Mock user for testing
  static final _testUser = User(
    id: 'test-user-id',
    username: 'PX0000',
    fullName: 'Test Manager',
    email: 'test@example.com',
    isActive: true,
    isSuperuser: false,
    createdAt: DateTime.now(),
  );
  
  static final _testAuthToken = AuthToken(
    accessToken: 'test-token-12345',
    tokenType: 'bearer',
    user: _testUser,
  );

  /// Login with store code and password
  Future<AuthToken> login(String storeCode, String password) async {
    if (testMode) {
      // Test mode: return mock auth token without storage
      print('Test mode: Logging in with store code $storeCode');
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      // Don't store in test mode to avoid issues
      // await _storage.write(key: _tokenKey, value: _testAuthToken.accessToken);
      // await _storage.write(key: _userKey, value: jsonEncode(_testAuthToken.user.toJson()));
      // ApiClient.setAuthToken(_testAuthToken.accessToken);
      print('Test mode: Login successful');
      return _testAuthToken;
    }
    
    final response = await ApiClient.post(
      '/api/v1/auth/login/json',
      data: {
        'username': storeCode.toUpperCase(),
        'password': password,
      },
    );

    final authToken = AuthToken.fromJson(response.data);
    
    // Store token and user
    await _storage.write(key: _tokenKey, value: authToken.accessToken);
    await _storage.write(key: _userKey, value: jsonEncode(authToken.user.toJson()));
    
    // Set token in API client
    ApiClient.setAuthToken(authToken.accessToken);
    
    return authToken;
  }

  /// Create account for first-time login (store code + password)
  Future<AuthToken> createAccount(String storeCode, String password) async {
    if (testMode) {
      // Test mode: return mock auth token without storage
      print('Test mode: Creating account for store code $storeCode');
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      print('Test mode: Account created successfully');
      return _testAuthToken;
    }
    
    final response = await ApiClient.post(
      '/api/v1/auth/create-account',
      data: {
        'username': storeCode.toUpperCase(),
        'password': password,
      },
    );

    final authToken = AuthToken.fromJson(response.data);
    
    // Store token and user
    await _storage.write(key: _tokenKey, value: authToken.accessToken);
    await _storage.write(key: _userKey, value: jsonEncode(authToken.user.toJson()));
    
    // Set token in API client
    ApiClient.setAuthToken(authToken.accessToken);
    
    return authToken;
  }

  /// Get current user from API
  Future<User> getCurrentUser() async {
    final response = await ApiClient.get('/api/v1/auth/me');
    return User.fromJson(response.data);
  }

  /// Logout
  Future<void> logout() async {
    try {
      await ApiClient.post('/api/v1/auth/logout');
    } catch (e) {
      // Ignore errors during logout
    }
    
    // Clear stored data
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    
    // Clear token from API client
    ApiClient.clearAuthToken();
  }

  /// Get stored token
  Future<String?> getStoredToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Get stored user
  Future<User?> getStoredUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null;
    
    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null;
  }

  /// Restore session from stored credentials
  Future<User?> restoreSession() async {
    final token = await getStoredToken();
    final user = await getStoredUser();
    
    if (token != null && user != null) {
      ApiClient.setAuthToken(token);
      return user;
    }
    
    return null;
  }
}
