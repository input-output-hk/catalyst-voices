import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/catalyst_voices_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

final _logger = Logger('VaultKeychainProvider');

final class VaultKeychainProvider implements KeychainProvider {
  final FlutterSecureStorage _secureStorage;
  final KeyDerivation _keyDerivation;

  VaultKeychainProvider({
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
    required KeyDerivation keyDerivation,
  })  : _secureStorage = secureStorage,
        _keyDerivation = keyDerivation;

  @override
  Future<Keychain> create(
    String id, {
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  }) async {
    try {
      final Keychain keychain = VaultKeychain(
        id: id,
        secureStorage: _secureStorage,
        keyDerivation: _keyDerivation,
      );

      if (await keychain.hasSeed) {
        _logger.warning('Overriding keychain[$id]');
        await keychain.clear();
      }

      await keychain.setLock(lockFactor);
      await keychain.unlock(lockFactor);
      await keychain.seed(seedPhrase);
      await keychain.lock();

      return keychain;
    } catch (_) {
      await _deleteKeychain(id);
      rethrow;
    }
  }

  @override
  Future<bool> exits(String id) {
    return _secureStorage
        .readAll()
        .then((value) => value.keys)
        .then((keys) => keys.any(VaultKeychain.isKeychainKey));
  }

  @override
  Future<Keychain> get(String id) async {
    final Keychain keychain = VaultKeychain(
      id: id,
      secureStorage: _secureStorage,
      keyDerivation: _keyDerivation,
    );

    if (!await keychain.hasSeed) {
      throw StateError('$keychain does not have a seed');
    }

    return keychain;
  }

  @override
  Future<List<Keychain>> findAll() async {
    final keychainsIds = await _secureStorage
        .readAll()
        .then((value) => value.keys)
        .then((keys) => keys.where(VaultKeychain.isKeychainKey))
        .then((keys) => keys.map(VaultKeychain.getStorageId).toSet());

    final keychains = keychainsIds.map((id) {
      return VaultKeychain(
        id: id,
        secureStorage: _secureStorage,
        keyDerivation: _keyDerivation,
      );
    }).toList();

    for (final keychain in keychains) {
      if (!await keychain.hasSeed) {
        throw StateError('$keychain does not have a seed');
      }
    }

    return keychains;
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
}
