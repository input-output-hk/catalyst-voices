import 'dart:async';
import 'dart:convert';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

const _metadataKey = 'metadata';
const _rootKey = 'rootKey';

const _allKeys = [
  _rootKey,
];

final class VaultKeychain extends SecureStorageVault implements Keychain {
  /// See [SecureStorageVault.isStorageKey].
  static bool isKeychainKey(String value) {
    return SecureStorageVault.isStorageKey(value);
  }

  /// See [SecureStorageVault.getStorageId].
  static String getStorageId(String value) {
    return SecureStorageVault.getStorageId(value);
  }

  final _initializationCompleter = Completer<void>();

  VaultKeychain({
    required super.id,
    super.secureStorage,
  }) {
    unawaited(_initialize());
  }

  @override
  Future<bool> get isEmpty async {
    await _initializationCompleter.future;
    for (final key in _allKeys) {
      if (await contains(key: key)) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<KeychainMetadata> get metadata async {
    await _initializationCompleter.future;
    final metadata = await _readMetadata();
    assert(metadata != null, 'Keychain was not initialized correctly');
    return metadata!;
  }

  @override
  Future<void> writeString(
    String? value, {
    required String key,
  }) async {
    await _initializationCompleter.future;
    return super.writeString(value, key: key).whenComplete(_updateUpdateAt);
  }

  @override
  Future<String?> readString({required String key}) async {
    await _initializationCompleter.future;
    return super.readString(key: key);
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

  Future<void> _initialize() async {
    await _ensureHasMetadata();

    _initializationCompleter.complete();
  }

  Future<void> _ensureHasMetadata() async {
    if (await _readMetadata() == null) {
      await _writeMetadata(_newMetadata());
    }
  }

  Future<void> _updateUpdateAt() async {
    final metadata = await this.metadata;
    final updated = metadata.copyWith(updatedAt: DateTime.timestamp());

    await _writeMetadata(updated);
  }

  Future<KeychainMetadata?> _readMetadata() async {
    final key = buildKey(_metadataKey);
    final encoded = await secureStorage.read(key: key);
    if (encoded == null) {
      return null;
    }

    final decoded = json.decode(encoded) as Map<String, dynamic>;
    return KeychainMetadata.fromJson(decoded);
  }

  Future<void> _writeMetadata(KeychainMetadata value) async {
    final key = buildKey(_metadataKey);
    final decoded = value.toJson();
    final encoded = json.encode(decoded);

    await secureStorage.write(key: key, value: encoded);
  }

  KeychainMetadata _newMetadata() {
    return KeychainMetadata(
      createdAt: DateTime.timestamp(),
      updatedAt: DateTime.timestamp(),
    );
  }

  @override
  String toString() => 'VaultKeychain[$id]';
}
