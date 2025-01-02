import 'dart:async';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _rootKey = 'rootKey';

const _allKeys = [
  _rootKey,
];

final class VaultKeychain extends SecureStorageVault implements Keychain {
  /// See [SecureStorageVault.isStorageKey].
  static bool isKeychainKey(
    String value, {
    String key = SecureStorageVault.defaultKey,
  }) {
    return SecureStorageVault.isStorageKey(value, key: key);
  }

  /// See [SecureStorageVault.getStorageId].
  static String getStorageId(
    String value, {
    String key = SecureStorageVault.defaultKey,
  }) {
    return SecureStorageVault.getStorageId(value, key: key);
  }

  VaultKeychain({
    required super.id,
    super.key,
    required super.secureStorage,
    required super.sharedPreferences,
    super.unlockTtl,
    super.cryptoService,
  });

  @override
  Future<bool> get isEmpty async {
    for (final key in _allKeys) {
      if (await contains(key: key)) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<Bip32Ed25519XPrivateKey?> getMasterKey() async {
    final encodedMasterKey = await readString(key: _rootKey);
    return encodedMasterKey != null
        ? Bip32Ed25519XPrivateKeyFactory.instance.fromHex(encodedMasterKey)
        : null;
  }

  @override
  Future<void> setMasterKey(Bip32Ed25519XPrivateKey data) async {
    await writeString(data.toHex(), key: _rootKey);
  }

  @override
  Future<void> erase() => clear();

  @override
  String toString() => 'VaultKeychain[$id]';
}
