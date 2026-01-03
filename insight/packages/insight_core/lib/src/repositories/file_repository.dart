import 'dart:io';
import 'package:dio/dio.dart';
import '../services/api_client.dart';

/// Repository for file upload and management operations
class FileRepository {
  FileRepository();

  /// Upload one or more files
  /// 
  /// Returns a list of file metadata including URLs
  Future<Map<String, dynamic>> uploadFiles(List<File> files) async {
    try {
      final formData = FormData();
      
      for (final file in files) {
        final fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
            ),
          ),
        );
      }

      final response = await ApiClient.client.post(
        '/files/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to upload files: $e');
    }
  }

  /// Get file URL for download
  String getFileUrl(String filename) {
    return '${ApiClient.baseUrl}/files/$filename';
  }

  /// Delete a file
  Future<void> deleteFile(String filename) async {
    try {
      await ApiClient.client.delete('/files/$filename');
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
}
