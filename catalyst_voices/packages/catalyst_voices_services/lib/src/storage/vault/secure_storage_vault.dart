import 'dart:async';

import 'package:catalyst_voices_services/src/storage/storage_string_mixin.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor_codec.dart';
import 'package:catalyst_voices_services/src/storage/vault/vault.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyPrefix = 'SecureStorageVault';
const _lockKey = 'LockFactorKey';
const _unlockKey = 'UnlockFactorKey';

// TODO(damian-molinski): Maybe we'll need to encrypt data with LockFactor
/// Implementation of [Vault] that uses [FlutterSecureStorage] as
/// facade for read/write operations.
base class SecureStorageVault with StorageAsStringMixin implements Vault {
  final FlutterSecureStorage _secureStorage;
  final LockFactorCodec _lockCodec;

  const SecureStorageVault({
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
    LockFactorCodec lockCodec = const DefaultLockFactorCodec(),
  })  : _secureStorage = secureStorage,
        _lockCodec = lockCodec;

  /// If storage does not have [LockFactor] this getter will
  /// return [VoidLockFactor] as fallback.
  Future<LockFactor> get _lock => _readLock(_lockKey);

  /// If storage does not have [LockFactor] this getter will
  /// return [VoidLockFactor] as fallback.
  Future<LockFactor> get _unlock => _readLock(_unlockKey);

  @override
  Future<bool> get isUnlocked async {
    final lock = await _lock;
    final unlock = await _unlock;

    return unlock.unlocks(lock);
  }

  @override
  Future<void> lock() => _writeLock(null, key: _unlockKey);

  @override
  Future<bool> unlock(LockFactor unlock) async {
    await _writeLock(unlock, key: _unlockKey);

    return isUnlocked;
  }

  @override
  Future<void> setLock(LockFactor lock) {
    return _writeLock(lock, key: _lockKey);
  }

  @override
  Future<bool> containsString({required String key}) async {
    return await _guardedRead(key: key, requireUnlocked: false) != null;
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

  Future<LockFactor> _readLock(String key) async {
    final value = await _guardedRead(key: key, requireUnlocked: false);

    return value != null ? _lockCodec.decode(value) : const VoidLockFactor();
  }

  Future<void> _writeLock(
    LockFactor? lock, {
    required String key,
  }) {
    final encodedLock = lock != null ? _lockCodec.encode(lock) : null;

    return _guardedWrite(
      encodedLock,
      key: key,
      requireUnlocked: false,
    );
  }

  /// Allows operation only when [isUnlocked] it true, otherwise returns null.
  ///
  /// Returns value assigned to [key]. May return null if non found for [key].
  Future<String?> _guardedRead({
    required String key,
    bool requireUnlocked = true,
  }) async {
    final hasAccess = !requireUnlocked || await isUnlocked;
    if (!hasAccess) {
      return null;
    }

    final effectiveKey = _buildVaultKey(key);

    return _secureStorage.read(key: effectiveKey);
  }

  /// Allows operation only when [isUnlocked] it true, otherwise non op.
  ///
  ///   * When [value] is non null writes it to [key].
  ///   * When [value] is null then [key] value is deleted.
  Future<void> _guardedWrite(
    String? value, {
    required String key,
    bool requireUnlocked = true,
  }) async {
    final hasAccess = !requireUnlocked || await isUnlocked;
    if (!hasAccess) {
      return;
    }

    final effectiveKey = _buildVaultKey(key);

    if (value != null) {
      await _secureStorage.write(key: effectiveKey, value: value);
    } else {
      await _secureStorage.delete(key: effectiveKey);
    }
  }

  String _buildVaultKey(String key) {
    return '$_keyPrefix.$key';
  }
}
