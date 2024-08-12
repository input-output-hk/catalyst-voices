import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class LocalStorageService {
  final FlutterSecureStorage _secureStorage;

  LocalStorageService() : _secureStorage = const FlutterSecureStorage();

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  Future<bool?> getBool(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null ? value.toLowerCase() == 'true' : null;
  }

  Future<Uint8List?> getBytes(String key) async {
    final String? base64String = await _secureStorage.read(key: key);
    if (base64String == null) return null;
    return Uint8List.fromList(base64Decode(base64String));
  }

  Future<int?> getInt(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null ? int.tryParse(value) : null;
  }

  Future<String?> getString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<void> saveBytes(String key, Uint8List bytes) async {
    final String base64String = base64Encode(bytes);
    await _secureStorage.write(key: key, value: base64String);
  }

  Future<void> saveInt(String key, int value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<void> saveString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }
}
