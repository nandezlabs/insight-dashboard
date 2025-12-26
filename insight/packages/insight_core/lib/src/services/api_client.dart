import 'package:dio/dio.dart';

class ApiClient {
  static Dio? _dio;
  static String? _baseUrl;

  static void initialize({required String baseUrl}) {
    _baseUrl = baseUrl;
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add logging interceptor in debug mode
    _dio!.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  static Dio get client {
    if (_dio == null) {
      throw Exception('ApiClient not initialized. Call initialize() first.');
    }
    return _dio!;
  }

  static String get baseUrl {
    if (_baseUrl == null) {
      throw Exception('ApiClient not initialized. Call initialize() first.');
    }
    return _baseUrl!;
  }

  // Helper methods for common operations
  static Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) {
    return client.get(path, queryParameters: queryParameters);
  }

  static Future<Response> post(String path, {dynamic data}) {
    return client.post(path, data: data);
  }

  static Future<Response> put(String path, {dynamic data}) {
    return client.put(path, data: data);
  }

  static Future<Response> delete(String path) {
    return client.delete(path);
  }
}
