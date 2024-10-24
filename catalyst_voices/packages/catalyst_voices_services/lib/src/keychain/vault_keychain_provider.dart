import 'package:catalyst_voices_services/src/catalyst_voices_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

final _logger = Logger('VaultKeychainProvider');

final class VaultKeychainProvider implements KeychainProvider {
  final FlutterSecureStorage _secureStorage;

  VaultKeychainProvider({
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
  }) : _secureStorage = secureStorage;

  @override
  Future<Keychain> create(String id) async {
    try {
      final Keychain keychain = VaultKeychain(
        id: id,
        secureStorage: _secureStorage,
      );

      if (!await keychain.isEmpty) {
        _logger.warning('Overriding existing keychain[$id]');
        await keychain.clear();
      }

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
    return VaultKeychain(
      id: id,
      secureStorage: _secureStorage,
    );
  }

  @override
  Future<List<Keychain>> getAll() async {
    final keychainsIds = await _secureStorage
        .readAll()
        .then((value) => value.keys)
        .then((keys) => keys.where(VaultKeychain.isKeychainKey))
        .then((keys) => keys.map(VaultKeychain.getStorageId).toSet());

    final keychains = keychainsIds
        .map((id) => VaultKeychain(id: id, secureStorage: _secureStorage))
        .cast<Keychain>()
        .toList();

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
