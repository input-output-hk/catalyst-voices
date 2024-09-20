import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor_codec.dart';
import 'package:catalyst_voices_services/src/storage/vault/vault.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyPrefix = 'SecureStorageVault';
const _lockFactorKey = '${_keyPrefix}LockFactorKey';
const _unlockFactorKey = '${_keyPrefix}UnlockFactorKey';

// TODO(damian): Logger
// TODO(damian): VersionedKeys
final class SecureStorageVault implements Vault {
  final FlutterSecureStorage _secureStorage;
  final LockFactorCodec _lockFactorCodec;

  SecureStorageVault({
    required FlutterSecureStorage secureStorage,
    LockFactorCodec lockFactorCodec = const DefaultLockFactorCodec(),
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
  Future<bool> get isUnlocked async {
    final lockFactor = await _lockFactor;
    final unlockFactor = await _unlockFactor;

    return unlockFactor.unlocks(lockFactor);
  }

  @override
  Future<void> lock() {
    return _secureStorage.delete(key: _unlockFactorKey);
  }

  @override
  Future<String?> readString(String key) => _guardedRead(key: key);

  @override
  Future<bool> unlock(LockFactor lockFactor) async {
    await _writeLockFactor(lockFactor, key: _unlockFactorKey);

    return isUnlocked;
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

  ///
  Future<void> _guardedWrite(
    String? value, {
    required String key,
  }) async {
    final isUnlocked = await this.isUnlocked;
    if (!isUnlocked) {
      return;
    }

    if (value != null) {
      await _secureStorage.write(key: key, value: value);
    } else {
      await _secureStorage.delete(key: key);
    }
  }

  ///
  Future<String?> _guardedRead({
    required String key,
  }) async {
    final isUnlocked = await this.isUnlocked;
    if (!isUnlocked) {
      return null;
    }

    return _secureStorage.read(key: key);
  }
}
