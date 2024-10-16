import 'dart:convert';
import 'dart:math';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/crypto_service.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

final class VaultCryptoService implements CryptoService {
  /// Salt length for Argon2 key derivation.
  static const int _saltLength = 16;

  /// Salt length for AesGcm data encryption.
  static const int _viLength = 12;

  /// Derived key hash length.
  static const int _keyLength = 16;

  /// Versioning for future improvements
  static const int _currentVersion = 1;

  /// Algorithm id for future improvements
  /// AES-GCM
  static const int _currentAlgorithmId = 1;

  final Random _random;

  VaultCryptoService({
    Random? random,
  }) : _random = random ?? Random.secure();

  /// 3-byte marker attached at the end of encrypted data.
  Uint8List get _checksum => utf8.encode('CHK');

  @override
  Future<Uint8List> deriveKey(
    Uint8List seed, {
    Uint8List? salt,
  }) async {
    final algorithm = Argon2id(
      parallelism: 2,
      memory: 10000, // 10 000 x 1kB block = 10 MB
      iterations: 1,
      hashLength: _keyLength,
    );

    salt ??= _generateRandomList(length: _saltLength);

    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(seed),
      nonce: salt,
    );

    final keyBytes = await secretKey.extractBytes().then(Uint8List.fromList);

    secretKey.destroy();

    // Combine salt and hashed password for storage
    return Uint8List.fromList([...salt, ...keyBytes]);
  }

  @override
  Future<bool> verifyKey(
    Uint8List seed, {
    required Uint8List key,
  }) async {
    final salt = key.sublist(0, _saltLength);
    if (salt.length < _saltLength) {
      return false;
    }

    final derivedKey = await deriveKey(seed, salt: salt);
    return listEquals(derivedKey, key);
  }

  @override
  Future<Uint8List> decrypt(
    Uint8List data, {
    required Uint8List key,
  }) async {
    if (data.length < 2) {
      throw const CryptoDataMalformed();
    }

    // Extract the version, algorithm ID
    final version = data[0];
    final algorithmId = data[1];

    if (version != _currentVersion) {
      throw CryptoVersionUnsupported('Version $version');
    }

    if (algorithmId != _currentAlgorithmId) {
      throw CryptoAlgorithmUnsupported('Algorithm $version');
    }

    final algorithm = AesGcm.with256bits(nonceLength: _viLength);
    final secretKey = SecretKey(key);

    final encryptedData = data.sublist(2);

    final secretBox = SecretBox.fromConcatenation(
      encryptedData,
      nonceLength: _viLength,
      macLength: algorithm.macAlgorithm.macLength,
    );

    final decryptedData = await algorithm
        .decrypt(secretBox, secretKey: secretKey)
        .then(Uint8List.fromList)
        .onError<SecretBoxAuthenticationError>(
          (_, __) => throw const CryptoAuthenticationException(),
        );

    // Verify checksum/marker
    final checksum = _checksum;
    if (decryptedData.length < checksum.length) {
      throw const CryptoDataMalformed('Data is too short');
    }
    final originalDataLength = decryptedData.length - checksum.length;
    final originalData = decryptedData.sublist(0, originalDataLength);
    final extractedChecksum = decryptedData.sublist(originalDataLength);

    if (!listEquals(checksum, extractedChecksum)) {
      throw const CryptoDataMalformed('Checksum mismatch');
    }

    return originalData;
  }

  @override
  Future<Uint8List> encrypt(
    Uint8List data, {
    required Uint8List key,
  }) async {
    final algorithm = AesGcm.with256bits(nonceLength: _viLength);
    final secretKey = SecretKey(key);

    final checksum = _checksum;
    final combinedData = Uint8List.fromList([...data, ...checksum]);

    final secretBox = await algorithm.encrypt(
      combinedData,
      secretKey: secretKey,
      nonce: null,
      aad: [],
      possibleBuffer: null,
    );

    final concatenation = secretBox.concatenation();

    final metadata = Uint8List.fromList([_currentVersion, _currentAlgorithmId]);

    final result = Uint8List.fromList([
      ...metadata,
      ...concatenation,
    ]);

    return result;
  }

  /// Builds list with [length] and random bytes in it.
  Uint8List _generateRandomList({
    required int length,
  }) {
    final list = Uint8List(length);

    for (var i = 0; i < length; i++) {
      list[i] = _random.nextInt(16);
    }

    return list;
  }
}
