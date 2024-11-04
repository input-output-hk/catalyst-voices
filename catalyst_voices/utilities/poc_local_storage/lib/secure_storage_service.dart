// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:poc_local_storage/crypto_service.dart';

/// A service for securely storing and retrieving data.
final class SecureStorageService {
  static final _instance = SecureStorageService._();

  static const String _passwordKey = 'user_password';
  final FlutterSecureStorage _secureStorage;

  final CryptoService _cryptoService;
  bool _isAuthenticated = false;

  factory SecureStorageService() => _instance;

  SecureStorageService._()
      : _secureStorage = const FlutterSecureStorage(),
        _cryptoService = CryptoService();

  Future<void> get deleteAll async {
    await _secureStorage.deleteAll();
  }

  Future<bool> get hasPassword async {
    final storedPassword = await _secureStorage.read(key: _passwordKey);
    return storedPassword != null;
  }

  bool get isAuthenticated => _isAuthenticated;

  void get logout => _isAuthenticated = false;

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deletePassword() async {
    await _secureStorage.delete(key: _passwordKey);
    _isAuthenticated = false;
  }

  Future<bool?> getBool(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null ? value.toLowerCase() == 'true' : null;
  }

  Future<Uint8List?> getBytes(String key) async {
    final base64String = await _secureStorage.read(key: key);
    if (base64String == null) return null;
    return Uint8List.fromList(base64Decode(base64String));
  }

  Future<int?> getInt(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null ? int.tryParse(value) : null;
  }

  Future<String?> getString(String key) async {
    return _secureStorage.read(key: key);
  }

  Future<bool> login(String password) async {
    final storedHashedPassword = await _secureStorage.read(key: _passwordKey);
    if (storedHashedPassword != null) {
      final storedHash = base64Decode(storedHashedPassword);
      final isValid = _cryptoService.verifyPassword(password, storedHash);
      if (isValid) {
        _isAuthenticated = true;
        return true;
      }
    }
    return false;
  }

  Future<void> saveBool(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<void> saveBytes(String key, Uint8List bytes) async {
    final base64String = base64Encode(bytes);
    await _secureStorage.write(key: key, value: base64String);
  }

  Future<void> saveInt(String key, int value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<void> saveString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> setPassword(String password) async {
    final hashedPassword = _cryptoService.hashPassword(password);
    await _secureStorage.write(
      key: _passwordKey,
      value: base64Encode(hashedPassword),
    );
  }
}
