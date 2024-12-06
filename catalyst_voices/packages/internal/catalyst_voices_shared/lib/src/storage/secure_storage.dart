import 'dart:async';

import 'package:catalyst_voices_shared/src/storage/storage.dart';
import 'package:catalyst_voices_shared/src/storage/storage_string_mixin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyPrefix = 'SecureStorage';

base class SecureStorage with StorageAsStringMixin implements Storage {
  final FlutterSecureStorage _secureStorage;

  const SecureStorage({
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
  }) : _secureStorage = secureStorage;

  @override
  Future<bool> contains({required String key}) async {
    return await readString(key: key) != null;
  }

  @override
  Future<String?> readString({required String key}) {
    final effectiveKey = _buildVaultKey(key);

    return _secureStorage.read(key: effectiveKey);
  }

  @override
  Future<void> writeString(
    String? value, {
    required String key,
  }) async {
    final effectiveKey = _buildVaultKey(key);

    if (value != null) {
      await _secureStorage.write(key: effectiveKey, value: value);
    } else {
      await _secureStorage.delete(key: effectiveKey);
    }
  }

  @override
  FutureOr<void> clear() async {
    final all = await _secureStorage.readAll();
    final vaultKeys = List.of(all.keys).where((e) => e.startsWith(_keyPrefix));

    for (final key in vaultKeys) {
      await _secureStorage.delete(key: key);
    }
  }

  String _buildVaultKey(String key) {
    return '$_keyPrefix.$key';
  }
}
