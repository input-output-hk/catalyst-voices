import 'dart:async';
import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_shared/src/storage/storage_string_mixin.dart';
import 'package:catalyst_voices_shared/src/storage/vault/secure_storage_vault_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lockKey = 'LockKey';
const _createDateKey = 'CreateDate';

/// Implementation of [Vault] that uses [FlutterSecureStorage] as
/// facade for read/write operations.
base class SecureStorageVault with StorageAsStringMixin implements Vault {
  @override
  final String id;
  final String _key;
  final FlutterSecureStorage _secureStorage;
  final SecureStorageVaultCache _cache;
  final CryptoService _cryptoService;

  final _isUnlockedSC = StreamController<bool>.broadcast();
  final _initializationCompleter = Completer<void>();

  bool _isUnlocked = false;
  bool _isActive = false;

  /// Check if given [value] belongs to any [SecureStorageVault].
  static bool isStorageKey(
    String value, {
    String key = defaultKey,
  }) {
    try {
      getStorageId(value, key: key);
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
  static String getStorageId(
    String value, {
    String key = defaultKey,
  }) {
    final parts = value.split('.');
    if (parts.length != 3) {
      throw ArgumentError('Key sections count is invalid');
    }

    final prefix = parts[0];
    final id = parts[1];

    if (prefix != key) {
      throw ArgumentError('Key prefix does not match');
    }

    return id;
  }

  static const defaultKey = 'SecureStorageVault';

  SecureStorageVault({
    required this.id,
    String key = defaultKey,
    required FlutterSecureStorage secureStorage,
    required SharedPreferencesAsync sharedPreferences,
    Duration unlockTtl = const Duration(hours: 1),
    CryptoService? cryptoService,
  })  : _key = key,
        _secureStorage = secureStorage,
        _cache = SecureStorageVaultTtlCache(
          key: '$key.$id.Cache',
          sharedPreferences: sharedPreferences,
          defaultTtl: unlockTtl,
        ),
        _cryptoService = cryptoService ?? LocalCryptoService() {
    unawaited(_initialize());
  }

  String get _instanceKey => '$_key.$id';

  Future<Uint8List?> get _lock async {
    final effectiveKey = _buildKey(_lockKey);
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

  Future<bool> get _hasLock {
    final effectiveKey = _buildKey(_lockKey);
    return _secureStorage.containsKey(key: effectiveKey);
  }

  @override
  bool get lastIsUnlocked => _isUnlocked;

  @override
  Future<bool> get isUnlocked => _getIsUnlockedAndSync();

  @override
  Stream<bool> get watchIsUnlocked async* {
    yield await _getIsUnlockedAndSync();
    yield* _isUnlockedSC.stream;
  }

  @override
  bool get isActive => _isActive;

  @override
  set isActive(bool value) {
    if (_isActive != value) {
      _isActive = value;

      // When vault becomes inactive we should extend ttl for last unlock state.
      if (!value) {
        unawaited(_extendIsUnlockedExpirationDate());
      }
    }
  }

  @override
  Future<void> lock() => _updateUnlocked(false);

  @override
  Future<bool> unlock(LockFactor unlock) async {
    await _initializationCompleter.future;

    if (!await _hasLock) {
      throw const LockNotFoundException('Set lock before unlocking Vault');
    }

    final seed = unlock.seed;
    final lock = await _requireLock;

    final isVerified = await _cryptoService.verifyKey(seed, key: lock);
    await _updateUnlocked(isVerified);

    _erase(lock);

    return isUnlocked;
  }

  @override
  Future<void> setLock(LockFactor lock) async {
    await _initializationCompleter.future;

    if (await _hasLock && !await isUnlocked) {
      throw const VaultLockedException();
    }

    final seed = lock.seed;
    final key = await _cryptoService.deriveKey(seed);
    final encodedKey = base64.encode(key);

    final effectiveLockKey = _buildKey(_lockKey);

    await _secureStorage.write(key: effectiveLockKey, value: encodedKey);
  }

  @override
  Future<bool> contains({required String key}) async {
    await _initializationCompleter.future;

    final effectiveKey = _buildKey(key);
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
    await _initializationCompleter.future;

    final all = await _secureStorage.readAll();
    final vaultKeys =
        List.of(all.keys).where((key) => key.startsWith(_instanceKey));

    for (final key in vaultKeys) {
      await _secureStorage.delete(key: key);
    }

    await _cache.clear();
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
    await _initializationCompleter.future;
    await _ensureUnlocked();

    final effectiveKey = _buildKey(key);
    final encryptedData = await _secureStorage.read(key: effectiveKey);
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
    await _initializationCompleter.future;
    await _ensureUnlocked();

    final effectiveKey = _buildKey(key);

    if (value == null) {
      await _secureStorage.delete(key: effectiveKey);
      return;
    }

    final lock = await _requireLock;
    final encryptedData = await _encrypt(value, key: lock);

    _erase(lock);

    await _secureStorage.write(key: effectiveKey, value: encryptedData);
  }

  Future<void> _ensureUnlocked() async {
    final isUnlocked = await this.isUnlocked;
    if (!isUnlocked) {
      throw const VaultLockedException();
    }
  }

  Future<bool> _getIsUnlockedAndSync() async {
    final isUnlocked = await _getIsUnlocked();
    await _updateUnlocked(isUnlocked);
    return isUnlocked;
  }

  Future<bool> _getIsUnlocked() async {
    if (isActive) {
      await _extendIsUnlockedExpirationDate();
    }

    return _cache.getIsUnlocked();
  }

  Future<void> _extendIsUnlockedExpirationDate() async {
    if (await _cache.containsIsUnlocked()) {
      await _cache.extendIsUnlocked();
    }
  }

  Future<void> _updateUnlocked(bool value) async {
    if (_isUnlocked != value) {
      _isUnlocked = value;

      await _cache.setIsUnlocked(value: value);

      _isUnlockedSC.add(value);
    }
  }

  Future<void> _initialize() async {
    final effectiveKey = _buildKey(_createDateKey);
    final contains = await _secureStorage.containsKey(key: effectiveKey);
    if (!contains) {
      final now = DateTimeExt.now();
      final timestamp = now.toIso8601String();
      await _secureStorage.write(key: effectiveKey, value: timestamp);
    }

    _initializationCompleter.complete();
  }

  String _buildKey(String key) => '$_instanceKey.$key';

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
