import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  SecureStorageService();

  Future<void> get deleteAll async => _storage.deleteAll();

  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  Future<String?> get(String key) async {
    final value = await _storage.read(key: key);
    return value;
  }

  Future<void> set(String key, String value) async {
    return _storage.write(key: key, value: value);
  }
}
