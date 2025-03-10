import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:convert/convert.dart';

const _allKeys = [
  _rootKey,
];

const _rootKey = 'rootKey';

final class VaultKeychain extends SecureStorageVault implements Keychain {
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
  Future<void> erase() => clear();

  @override
  Future<CatalystPrivateKey?> getMasterKey() async {
    final masterKeyHex = await readString(key: _rootKey);
    if (masterKeyHex == null) {
      return null;
    }

    final masterKeyBytes = Uint8List.fromList(hex.decode(masterKeyHex));
    return CatalystPrivateKey.factory.createPrivateKey(masterKeyBytes);
  }

  @override
  Future<void> setMasterKey(CatalystPrivateKey data) async {
    await writeString(hex.encode(data.bytes), key: _rootKey);
  }

  @override
  String toString() => 'VaultKeychain[$id]';

  /// See [SecureStorageVault.getStorageId].
  static String getStorageId(
    String value, {
    String key = SecureStorageVault.defaultKey,
  }) {
    return SecureStorageVault.getStorageId(value, key: key);
  }

  /// See [SecureStorageVault.isStorageKey].
  static bool isKeychainKey(
    String value, {
    String key = SecureStorageVault.defaultKey,
  }) {
    return SecureStorageVault.isStorageKey(value, key: key);
  }
}
