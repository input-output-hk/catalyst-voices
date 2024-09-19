import 'dart:convert';

import 'package:catalyst_voices_shared/src/storage/lock_factor.dart';
import 'package:catalyst_voices_shared/src/storage/vault.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyPrefix = 'SecureStorageVault';
const _lockFactorKey = '${_keyPrefix}LockFactorKey';
const _unlockFactorKey = '${_keyPrefix}UnlockFactorKey';

final class SecureStorageVault implements Vault {
  final FlutterSecureStorage _secureStorage;
  final Codec<LockFactor, String> _lockFactorCodec;

  SecureStorageVault({
    required FlutterSecureStorage secureStorage,
    // TODO(damian): provide default implementation
    required Codec<LockFactor, String> lockFactorCodec,
  })  : _secureStorage = secureStorage,
        _lockFactorCodec = lockFactorCodec;

  // TODO(damian): maybe cache it
  Future<LockFactor> get _lockFactor => _secureStorage
      .read(key: _lockFactorKey)
      .then((value) => value != null ? _lockFactorCodec.decode(value) : null)
      .then((value) => value ?? const VoidLockFactor());

  // TODO(damian): maybe cache it
  Future<LockFactor> get _unlockFactor => _secureStorage
      .read(key: _unlockFactorKey)
      .then((value) => value != null ? _lockFactorCodec.decode(value) : null)
      .then((value) => value ?? const VoidLockFactor());

  @override
  Future<bool> get isLocked async {
    final lockFactor = await _lockFactor;
    final unlockFactor = await _unlockFactor;

    return unlockFactor.unlocks(lockFactor);
  }

  @override
  Future<void> lock() {
    return _secureStorage.delete(key: _unlockFactorKey);
  }

  @override
  Future<String?> readString(String key) {
    return isLocked
        .then((isLocked) => isLocked ? null : _secureStorage.read(key: key));
  }

  @override
  Future<bool> unlock(LockFactor lockFactor) async {
    await _writeLockFactor(lockFactor, key: _unlockFactorKey);

    return isLocked.then((isLocked) => !isLocked);
  }

  @override
  Future<void> updateLockFactor(LockFactor lockFactor) {
    return _writeLockFactor(lockFactor, key: _lockFactorKey);
  }

  Future<void> _writeLockFactor(
    LockFactor lockFactor, {
    required String key,
  }) {
    final encodedLockFactor = _lockFactorCodec.encode(lockFactor);
    return _secureStorage.write(key: key, value: encodedLockFactor);
  }
}
