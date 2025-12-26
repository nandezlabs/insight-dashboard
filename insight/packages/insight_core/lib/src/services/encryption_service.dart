import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const String _keyStorageKey = 'encryption_key';
  static final _secureStorage = const FlutterSecureStorage();

  static encrypt.Key? _encryptionKey;
  static encrypt.IV? _iv;

  /// Initialize encryption service with a secure key
  static Future<void> initialize() async {
    // Try to get existing key
    String? keyString = await _secureStorage.read(key: _keyStorageKey);

    if (keyString == null) {
      // Generate new key if doesn't exist
      _encryptionKey = encrypt.Key.fromSecureRandom(32);
      await _secureStorage.write(
        key: _keyStorageKey,
        value: base64Encode(_encryptionKey!.bytes),
      );
    } else {
      // Use existing key
      _encryptionKey = encrypt.Key(base64Decode(keyString));
    }

    // Generate IV (can be stored with encrypted data)
    _iv = encrypt.IV.fromLength(16);
  }

  /// Encrypt sensitive data using AES-256
  static String encryptData(String plainText) {
    if (_encryptionKey == null || _iv == null) {
      throw Exception('EncryptionService not initialized');
    }

    final encrypter = encrypt.Encrypter(
      encrypt.AES(_encryptionKey!, mode: encrypt.AESMode.cbc),
    );

    final encrypted = encrypter.encrypt(plainText, iv: _iv);

    // Return combined IV and encrypted data
    return '${_iv!.base64}:${encrypted.base64}';
  }

  /// Decrypt data
  static String decryptData(String encryptedData) {
    if (_encryptionKey == null) {
      throw Exception('EncryptionService not initialized');
    }

    final parts = encryptedData.split(':');
    if (parts.length != 2) {
      throw Exception('Invalid encrypted data format');
    }

    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(_encryptionKey!, mode: encrypt.AESMode.cbc),
    );

    return encrypter.decrypt(encrypted, iv: iv);
  }

  /// Hash sensitive data (one-way)
  static String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Clear encryption key (for testing or reset)
  static Future<void> clearKey() async {
    await _secureStorage.delete(key: _keyStorageKey);
    _encryptionKey = null;
    _iv = null;
  }
}
