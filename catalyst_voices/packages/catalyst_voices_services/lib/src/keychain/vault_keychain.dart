import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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

  VaultKeychain({
    required super.id,
    super.secureStorage,
  }) {
    unawaited(_ensureHasMetadata());
  }

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
  Future<KeychainMetadata> get metadata {
    return _readMetadata().then((metadata) => metadata ?? _newMetadata());
  }

  @override
  Future<void> writeString(
    String? value, {
    required String key,
  }) {
    return super.writeString(value, key: key).whenComplete(_updateUpdateAt);
  }

  @override
  Future<Uint8List?> getRootKey() async {
    return await readBytes(key: _rootKey);
  }

  @override
  Future<void> setRootKey(Uint8List data) async {
    await writeBytes(data, key: _rootKey);
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
      createAt: DateTime.timestamp(),
      updatedAt: DateTime.timestamp(),
    );
  }

  @override
  String toString() => 'VaultKeychain[$id]';

  @override
  List<Object?> get props => [id];
}
