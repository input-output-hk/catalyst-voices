import 'dart:async';
import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/crypto/crypto_service.dart';
import 'package:catalyst_voices_services/src/crypto/vault_crypto_service.dart';
import 'package:catalyst_voices_services/src/vault/vault.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _lockKey = 'LockKey';

/// Implementation of [Vault] that uses [FlutterSecureStorage] as
/// facade for read/write operations.
base class SecureStorageVault with StorageAsStringMixin implements Vault {
  @override
  final String id;
  @protected
  final FlutterSecureStorage secureStorage;
  final CryptoService _cryptoService;

  final _isUnlockedSC = StreamController<bool>.broadcast();
  bool __isUnlocked = false;

  /// Check if given [value] belongs to any [SecureStorageVault].
  static bool isStorageKey(String value) {
    try {
      getStorageId(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check [value] against value key pattern for this storage.
  ///
  /// Throws [ArgumentError] if [value] does not match.
  ///
  /// See [isStorageKey] to make sure key is valid before
  /// calling [getStorageId].
  static String getStorageId(String value) {
    final parts = value.split('.');
    if (parts.length != 3) {
      throw ArgumentError('Key sections count is invalid');
    }

    final prefix = parts[0];
    final id = parts[1];

    if (prefix != _keyPrefix) {
      throw ArgumentError('Key prefix does not match');
    }

    return id;
  }

  static const _keyPrefix = 'SecureStorageVault';

  SecureStorageVault({
    required this.id,
    this.secureStorage = const FlutterSecureStorage(),
    CryptoService? cryptoService,
  }) : _cryptoService = cryptoService ?? VaultCryptoService();

  String get _instanceKeyPrefix => '$_keyPrefix.$id';

  bool get _isUnlocked => __isUnlocked;

  set _isUnlocked(bool value) {
    if (__isUnlocked != value) {
      __isUnlocked = value;
      _isUnlockedSC.add(value);
    }
  }

  Future<Uint8List?> get _lock async {
    final effectiveKey = buildKey(_lockKey);
    final encodedLock = await secureStorage.read(key: effectiveKey);
    return encodedLock != null ? base64.decode(encodedLock) : null;
  }

  Future<Uint8List> get _requireLock async {
    final lock = await _lock;
    if (lock == null) {
      throw const LockNotFoundException();
    }
    return lock;
  }

  Future<bool> get _hasLock {
    final effectiveKey = buildKey(_lockKey);
    return secureStorage.containsKey(key: effectiveKey);
  }

  @override
  Future<bool> get isUnlocked => Future(() => _isUnlocked);

  @override
  Stream<bool> get watchIsUnlocked async* {
    yield _isUnlocked;
    yield* _isUnlockedSC.stream;
  }

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

    _erase(lock);

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

    final effectiveLockKey = buildKey(_lockKey);

    await secureStorage.write(key: effectiveLockKey, value: encodedKey);
  }

  @protected
  String buildKey(String key) => '$_instanceKeyPrefix.$key';

  @override
  Future<bool> contains({required String key}) async {
    final effectiveKey = buildKey(key);
    return secureStorage.containsKey(key: effectiveKey);
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
    final all = await secureStorage.readAll();
    final vaultKeys =
        List.of(all.keys).where((key) => key.startsWith(_instanceKeyPrefix));

    for (final key in vaultKeys) {
      await secureStorage.delete(key: key);
    }
  }

  @override
  String toString() {
    return 'SecureStorageVault{id: $id}';
  }

  /// Allows operation only when [isUnlocked] it true, otherwise returns null.
  ///
  /// Returns value assigned to [key]. May return null if not found for [key].
  Future<String?> _guardedRead({
    required String key,
  }) async {
    await _ensureUnlocked();

    final effectiveKey = buildKey(key);
    final encryptedData = await secureStorage.read(key: effectiveKey);
    if (encryptedData == null) {
      return null;
    }

    final lock = await _requireLock;
    final decrypted = await _decrypt(encryptedData, key: lock);

    _erase(lock);

    return decrypted;
  }

  /// Allows operation only when [isUnlocked] it true, otherwise non op.
  ///
  ///   * When [value] is non null writes it to [key].
  ///   * When [value] is null then [key] value is deleted.
  Future<void> _guardedWrite(
    String? value, {
    required String key,
  }) async {
    await _ensureUnlocked();

    final effectiveKey = buildKey(key);

    if (value == null) {
      await secureStorage.delete(key: effectiveKey);
      return;
    }

    final lock = await _requireLock;
    final encryptedData = await _encrypt(value, key: lock);

    _erase(lock);

    await secureStorage.write(key: effectiveKey, value: encryptedData);
  }

  Future<void> _ensureUnlocked() async {
    final isUnlocked = await this.isUnlocked;
    if (!isUnlocked) {
      throw const VaultLockedException();
    }
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

  void _erase(Uint8List list) {
    list.fillRange(0, list.length, 0);
  }
}
