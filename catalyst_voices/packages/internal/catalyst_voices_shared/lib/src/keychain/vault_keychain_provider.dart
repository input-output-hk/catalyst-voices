import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _logger = Logger('VaultKeychainProvider');

final class VaultKeychainProvider implements KeychainProvider {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferencesAsync _sharedPreferences;
  final CacheConfig _cacheConfig;

  VaultKeychainProvider({
    required FlutterSecureStorage secureStorage,
    required SharedPreferencesAsync sharedPreferences,
    required CacheConfig cacheConfig,
  })  : _secureStorage = secureStorage,
        _sharedPreferences = sharedPreferences,
        _cacheConfig = cacheConfig;

  @override
  Future<Keychain> create(String id) async {
    try {
      return _buildKeychain(id);
    } catch (_) {
      await _deleteKeychain(id);
      rethrow;
    }
  }

  @override
  Future<bool> exists(String id) {
    return _secureStorage
        .readAll()
        .then((value) => value.keys)
        .then((keys) => keys.where(VaultKeychain.isKeychainKey))
        .then((keys) => keys.map(VaultKeychain.getStorageId).toSet())
        .then((ids) => ids.contains(id));
  }

  @override
  Future<Keychain> get(String id) async => _get(id);

  @override
  Future<List<Keychain>> getAll() async {
    final keychainsIds = await _secureStorage
        .readAll()
        .then((value) => value.keys)
        .then((keys) => keys.where(VaultKeychain.isKeychainKey))
        .then((keys) => keys.map(VaultKeychain.getStorageId).toSet());

    final keychains = keychainsIds.map(_get).cast<Keychain>().toList();

    return keychains;
  }

  Future<Keychain> _buildKeychain(String id) async {
    final keychain = _get(id);

    if (!await keychain.isEmpty) {
      _logger.warning('Overriding existing keychain[$id]');
      await keychain.erase();
      return _buildKeychain(id);
    }

    return keychain;
  }

  Future<void> _deleteKeychain(String id) async {
    final keys = await _secureStorage
        .readAll()
        .then((value) => value.keys)
        .then((keys) => keys.where(VaultKeychain.isKeychainKey))
        .then(
          (keys) => keys
              .where((key) => VaultKeychain.getStorageId(key) == id)
              .toList(),
        );

    for (final key in keys) {
      await _secureStorage.delete(key: key);
    }
  }

  Keychain _get(String id) {
    return VaultKeychain(
      id: id,
      secureStorage: _secureStorage,
      sharedPreferences: _sharedPreferences,
      unlockTtl: _cacheConfig.expiryDuration.keychainUnlock,
    );
  }
}
