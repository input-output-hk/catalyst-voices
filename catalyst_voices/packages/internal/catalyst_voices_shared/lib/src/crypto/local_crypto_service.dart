import 'dart:convert';
import 'dart:math';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('LocalCryptoService');

/// [CryptoService] implementation used by default in [Vault].
///
/// It uses Pbkdf2 for key derivation as well as
/// AesGcm for encryption/decryption.
///
/// Only keys build by [LocalCryptoService.deriveKey] should be used
/// for crypto operations are we're adding [LocalCryptoService] specific
/// metadata to them.
///
/// Supports version for future changes.
final class LocalCryptoService implements CryptoService {
  /// Salt length for key derivation.
  static const int _saltLength = 16;

  /// Salt length for AesGcm data encryption.
  static const int _viLength = 12;

  /// Versioning for future improvements.
  static const int _currentVersion = 1;

  /// Algorithm id for future improvements.
  /// AES-GCM
  static const int _currentAlgorithmId = 1;

  final Random _random;

  LocalCryptoService({
    Random? random,
  }) : _random = random ?? Random.secure();

  /// 3-byte marker attached at the end of encrypted data.
  Uint8List get _checksum => utf8.encode('CHK');

  // Note. Argon2id has no native browser implementation and dart one is
  // slow > 1s. That's why Pbkdf2 is used.
  @override
  Future<Uint8List> deriveKey(
    Uint8List seed, {
    Uint8List? salt,
  }) {
    Future<Uint8List> run() async {
      final algorithm = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 10000, // 20k iterations
        bits: 256, // 256 bits = 32 bytes output
      );

      final keySalt = salt ?? _generateRandomList(length: _saltLength);

      final secretKey = await algorithm.deriveKey(
        secretKey: SecretKey(seed),
        nonce: keySalt,
      );

      final keyBytes = await secretKey.extractBytes().then(Uint8List.fromList);

      secretKey.destroy();

      // Combine salt and hashed password for storage
      return Uint8List.fromList([...keySalt, ...keyBytes]);
    }

    if (kDebugMode) {
      return _benchmark(run(), debugLabel: 'DeriveKey');
    } else {
      return run();
    }
  }

  @override
  Future<bool> verifyKey(
    Uint8List seed, {
    required Uint8List key,
  }) {
    Future<bool> run() async {
      final salt = key.sublist(0, _saltLength);
      if (salt.length < _saltLength) {
        return false;
      }

      final derivedKey = await deriveKey(seed, salt: salt);
      return listEquals(derivedKey, key);
    }

    if (kDebugMode) {
      return _benchmark(run(), debugLabel: 'VerifyKey');
    } else {
      return run();
    }
  }

  @override
  Future<Uint8List> decrypt(
    Uint8List data, {
    required Uint8List key,
  }) {
    Future<Uint8List> run() async {
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
      final secretKey = SecretKey(key.sublist(_saltLength));

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

    if (kDebugMode) {
      return _benchmark(run(), debugLabel: 'Decrypt');
    } else {
      return run();
    }
  }

  @override
  Future<Uint8List> encrypt(
    Uint8List data, {
    required Uint8List key,
  }) {
    Future<Uint8List> run() async {
      final algorithm = AesGcm.with256bits(nonceLength: _viLength);
      final secretKey = SecretKey(key.sublist(_saltLength));

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

      final metadata =
          Uint8List.fromList([_currentVersion, _currentAlgorithmId]);

      final result = Uint8List.fromList([
        ...metadata,
        ...concatenation,
      ]);

      return result;
    }

    if (kDebugMode) {
      return _benchmark(run(), debugLabel: 'Encrypt');
    } else {
      return run();
    }
  }

  /// Builds list with [length] and random bytes in it.
  Uint8List _generateRandomList({
    required int length,
  }) {
    final list = Uint8List(length);

    for (var i = 0; i < length; i++) {
      list[i] = _random.nextInt(255);
    }

    return list;
  }

  Future<T> _benchmark<T>(
    Future<T> future, {
    required String debugLabel,
  }) {
    final stopwatch = Stopwatch()..start();

    return future.whenComplete(
      () {
        stopwatch.stop();
        _logger.finer('Took[$debugLabel] ${stopwatch.elapsed}');
      },
    );
  }
}
