import 'dart:async';
import 'dart:convert';

import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor_codec.dart';
import 'package:catalyst_voices_services/src/storage/vault/vault.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyPrefix = 'SecureStorageVault';
const _lockFactorKey = 'LockFactorKey';
const _unlockFactorKey = 'UnlockFactorKey';

// TODO(damian): Logger
final class SecureStorageVault implements Vault {
  final FlutterSecureStorage _secureStorage;
  final LockFactorCodec _lockFactorCodec;

  SecureStorageVault({
    required FlutterSecureStorage secureStorage,
    LockFactorCodec lockFactorCodec = const DefaultLockFactorCodec(),
  })  : _secureStorage = secureStorage,
        _lockFactorCodec = lockFactorCodec;

  Future<LockFactor> get _lockFactor => _secureStorage
      .read(key: _lockFactorKey)
      .then((value) => value != null ? _lockFactorCodec.decode(value) : null)
      .then((value) => value ?? const VoidLockFactor());

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
    return _guardedWrite(
      null,
      key: _unlockFactorKey,
      requireUnlocked: false,
    );
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
  Future<int?> readInt({required String key}) async {
    final value = await _guardedRead(key: key);
    return value != null ? int.parse(value) : null;
  }

  @override
  Future<void> writeInt(
    int? value, {
    required String key,
  }) {
    return _guardedWrite(value?.toString(), key: key);
  }

  @override
  Future<bool?> readBool({required String key}) async {
    final value = await readInt(key: key);

    return switch (value) {
      0 => false,
      1 => true,
      _ => null,
    };
  }

  @override
  Future<void> writeBool(
    bool? value, {
    required String key,
  }) {
    final asInt = value != null
        ? value
            ? 1
            : 0
        : null;

    return writeInt(asInt, key: key);
  }

  @override
  Future<Uint8List?> readBytes({required String key}) async {
    final base64String = await _guardedRead(key: key);
    final bytes = base64String != null
        ? Uint8List.fromList(base64Decode(base64String))
        : null;

    return bytes;
  }

  @override
  Future<void> writeBytes(
    Uint8List? value, {
    required String key,
  }) {
    final base64String = value != null ? base64Encode(value) : null;

    return _guardedWrite(base64String, key: key);
  }

  @override
  Future<void> delete({required String key}) => _guardedWrite(null, key: key);

  @override
  Future<void> clear() async {
    final all = await _secureStorage.readAll();
    final vaultKeys = all.keys.where((e) => e.startsWith(_keyPrefix)).toList();

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
  Future<void> updateLockFactor(LockFactor lockFactor) {
    return _writeLockFactor(lockFactor, key: _lockFactorKey);
  }

  Future<void> _writeLockFactor(
    LockFactor lockFactor, {
    required String key,
  }) {
    final encodedLockFactor = _lockFactorCodec.encode(lockFactor);

    return _guardedWrite(
      encodedLockFactor,
      key: key,
      requireUnlocked: false,
    );
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
