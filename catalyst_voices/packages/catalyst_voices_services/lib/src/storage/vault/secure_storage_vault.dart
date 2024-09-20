import 'dart:async';

import 'package:catalyst_voices_services/src/storage/storage_string_mixin.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor_codec.dart';
import 'package:catalyst_voices_services/src/storage/vault/vault.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyPrefix = 'SecureStorageVault';
const _lockFactorKey = 'LockFactorKey';
const _unlockFactorKey = 'UnlockFactorKey';

// TODO(damian): Logger
/// Implementation of [Vault] that uses [FlutterSecureStorage] as
/// facade for read/write operations.
final class SecureStorageVault with StorageStringMixin implements Vault {
  final FlutterSecureStorage _secureStorage;
  final LockFactorCodec _lockFactorCodec;

  SecureStorageVault({
    required FlutterSecureStorage secureStorage,
    LockFactorCodec lockFactorCodec = const DefaultLockFactorCodec(),
  })  : _secureStorage = secureStorage,
        _lockFactorCodec = lockFactorCodec;

  /// If storage does not have [LockFactor] this getter will
  /// return [VoidLockFactor] as fallback.
  Future<LockFactor> get _lockFactor => _readLockFactor(_lockFactorKey);

  /// If storage does not have [LockFactor] this getter will
  /// return [VoidLockFactor] as fallback.
  Future<LockFactor> get _unlockFactor => _readLockFactor(_unlockFactorKey);

  @override
  Future<bool> get isUnlocked async {
    final lockFactor = await _lockFactor;
    final unlockFactor = await _unlockFactor;

    return unlockFactor.unlocks(lockFactor);
  }

  @override
  Future<void> lock() => _writeLockFactor(null, key: _unlockFactorKey);

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
    final vaultKeys = all.keys.where((e) => e.startsWith(_keyPrefix));

    for (final key in vaultKeys) {
      await _guardedWrite(
        null,
        key: key,
        requireUnlocked: false,
      );
    }
  }

  @override
  Future<bool> unlock(LockFactor lockFactor) async {
    await _writeLockFactor(lockFactor, key: _unlockFactorKey);

    return isUnlocked;
  }

  @override
  Future<void> setLockFactor(LockFactor lockFactor) {
    return _writeLockFactor(lockFactor, key: _lockFactorKey);
  }

  Future<void> _writeLockFactor(
    LockFactor? lockFactor, {
    required String key,
  }) {
    final encodedLockFactor =
        lockFactor != null ? _lockFactorCodec.encode(lockFactor) : null;

    return _guardedWrite(
      encodedLockFactor,
      key: key,
      requireUnlocked: false,
    );
  }

  Future<LockFactor> _readLockFactor(String key) async {
    final value = await _guardedRead(key: key, requireUnlocked: false);

    return value != null
        ? _lockFactorCodec.decode(value)
        : const VoidLockFactor();
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

  String _buildVaultKey(String key) {
    return '$_keyPrefix.$key';
  }
}
