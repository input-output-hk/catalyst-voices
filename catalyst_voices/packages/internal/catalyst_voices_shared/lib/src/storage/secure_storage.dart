import 'dart:async';

import 'package:catalyst_voices_shared/src/storage/storage.dart';
import 'package:catalyst_voices_shared/src/storage/storage_string_mixin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract base class SecureStorage with StorageAsStringMixin implements Storage {
  final String key;
  final int version;
  final FlutterSecureStorage _secureStorage;

  SecureStorage({
    this.key = 'SecureStorage',
    this.version = 1,
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
  }) : _secureStorage = secureStorage;

  @override
  Future<bool> contains({required String key}) async {
    return await readString(key: key) != null;
  }

  @override
  Future<String?> readString({required String key}) {
    final effectiveKey = _effectiveKey(key);

    return _secureStorage.read(key: effectiveKey);
  }

  @override
  Future<void> writeString(
    String? value, {
    required String key,
  }) async {
    final effectiveKey = _effectiveKey(key);

    if (value != null) {
      await _secureStorage.write(key: effectiveKey, value: value);
    } else {
      await _secureStorage.delete(key: effectiveKey);
    }
  }

  @override
  Future<void> clear() async {
    final prefix = _buildVersionedPrefix(version);

    final all = await _secureStorage.readAll();
    final vaultKeys = List.of(all.keys).where((e) => e.startsWith(prefix));

    for (final key in vaultKeys) {
      await _secureStorage.delete(key: key);
    }
  }

  String _effectiveKey(String value) {
    return _buildVersionedKey(value, version: version);
  }

  String _buildVersionedKey(
    String value, {
    required int version,
  }) {
    final prefix = _buildVersionedPrefix(version);

    return '$prefix.$value';
  }

  String _buildVersionedPrefix(int version) => '$key.v$version';
}
