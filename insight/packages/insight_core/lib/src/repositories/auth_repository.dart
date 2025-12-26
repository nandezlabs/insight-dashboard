import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_client.dart';

class AuthRepository {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  /// Login with email and password
  Future<AuthToken> login(String email, String password) async {
    final response = await ApiClient.post(
      '/api/v1/auth/login/json',
      data: {
        'email': email,
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

  /// Sign up with email, password, and full name
  Future<User> signup(String email, String password, String fullName) async {
    final response = await ApiClient.post(
      '/api/v1/auth/signup',
      data: {
        'email': email,
        'password': password,
        'full_name': fullName,
      },
    );

    return User.fromJson(response.data);
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
