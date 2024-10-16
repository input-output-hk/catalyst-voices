import 'dart:async';
import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/aes_crypto_service.dart';
import 'package:catalyst_voices_services/src/crypto/crypto_service.dart';
import 'package:catalyst_voices_services/src/storage/storage_string_mixin.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';
import 'package:catalyst_voices_services/src/storage/vault/vault.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyPrefix = 'SecureStorageVault';
const _lockKey = 'LockKey';

/// Implementation of [Vault] that uses [FlutterSecureStorage] as
/// facade for read/write operations.
base class SecureStorageVault with StorageAsStringMixin implements Vault {
  final FlutterSecureStorage _secureStorage;

  final CryptoService _cryptoService;

  bool _isUnlocked = false;

  SecureStorageVault({
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
    CryptoService? cryptoService,
  })  : _secureStorage = secureStorage,
        _cryptoService = cryptoService ?? AesCryptoService();

  Future<bool> get _hasLock {
    final effectiveKey = _buildVaultKey(_lockKey);
    return _secureStorage.containsKey(key: effectiveKey);
  }

  Future<Uint8List?> get _lock async {
    final effectiveKey = _buildVaultKey(_lockKey);
    final encodedLock = await _secureStorage.read(key: effectiveKey);
    return encodedLock != null ? base64.decode(encodedLock) : null;
  }

  Future<Uint8List> get _requireLock async {
    final lock = await _lock;
    if (lock == null) {
      throw const LockNotFoundException();
    }
    return lock;
  }

  @override
  Future<bool> get isUnlocked => SynchronousFuture(_isUnlocked);

  @override
  Future<void> lock() async {
    _isUnlocked = false;
  }

  @override
  Future<bool> unlock(LockFactor unlock) async {
    if (!await _hasLock) {
      throw const LockNotFoundException('Set lock before unlocking Vault');
    }

    final seed = unlock.seed;
    final lock = await _requireLock;

    _isUnlocked = await _cryptoService.verifyKey(seed, key: lock);

    return isUnlocked;
  }

  @override
  Future<void> setLock(LockFactor lock) async {
    if (await _hasLock && !await isUnlocked) {
      throw const VaultLockedException();
    }

    final seed = lock.seed;
    final key = await _cryptoService.deriveKey(seed);
    final encodedKey = base64.encode(key);

    final effectiveLockKey = _buildVaultKey(_lockKey);

    await _secureStorage.write(key: effectiveLockKey, value: encodedKey);
  }

  @override
  Future<bool> contains({required String key}) async {
    final effectiveKey = _buildVaultKey(key);
    return _secureStorage.containsKey(key: effectiveKey);
  }

  @override
  Future<String?> readString({required String key}) => _guardedRead(key: key);

  @override
  Future<void> writeString(
    String? value, {
    required String key,
  }) {
    return _guardedWrite(value, key: key);
  }

  @override
  Future<void> clear() async {
    final all = await _secureStorage.readAll();
    final vaultKeys = List.of(all.keys).where((e) => e.startsWith(_keyPrefix));

    for (final key in vaultKeys) {
      await _secureStorage.delete(key: key);
    }
  }

  /// Allows operation only when [isUnlocked] it true, otherwise returns null.
  ///
  /// Returns value assigned to [key]. May return null if not found for [key].
  Future<String?> _guardedRead({
    required String key,
  }) async {
    if (!await isUnlocked) {
      throw const VaultLockedException();
    }

    final effectiveKey = _buildVaultKey(key);
    final encryptedData = await _secureStorage.read(key: effectiveKey);
    if (encryptedData == null) {
      return null;
    }

    final lock = await _requireLock;

    return _decrypt(encryptedData, key: lock);
  }

  /// Allows operation only when [isUnlocked] it true, otherwise non op.
  ///
  ///   * When [value] is non null writes it to [key].
  ///   * When [value] is null then [key] value is deleted.
  Future<void> _guardedWrite(
    String? value, {
    required String key,
  }) async {
    if (!await isUnlocked) {
      throw const VaultLockedException();
    }

    final effectiveKey = _buildVaultKey(key);

    if (value == null) {
      await _secureStorage.delete(key: effectiveKey);
      return;
    }

    final lock = await _requireLock;
    final encryptedData = await _encrypt(value, key: lock);

    await _secureStorage.write(key: effectiveKey, value: encryptedData);
  }

  Future<String> _encrypt(
    String data, {
    required Uint8List key,
  }) async {
    final decodedData = base64.decode(data);
    final encryptedData = await _cryptoService.encrypt(decodedData, key: key);
    return base64.encode(encryptedData);
  }

  Future<String> _decrypt(
    String data, {
    required Uint8List key,
  }) async {
    final decodedData = base64.decode(data);
    final decryptedData = await _cryptoService.decrypt(decodedData, key: key);
    return base64.encode(decryptedData);
  }

  String _buildVaultKey(String key) {
    return '$_keyPrefix.$key';
  }
}
