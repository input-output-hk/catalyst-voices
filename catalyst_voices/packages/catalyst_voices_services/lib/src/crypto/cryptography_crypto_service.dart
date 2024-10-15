import 'dart:math';

import 'package:catalyst_voices_services/src/crypto/crypto_service.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

final class CryptographyCryptoService implements CryptoService {
  /// Salt length for Argon2 key derivation
  static const int _saltLength = 16;

  final Random _random;

  CryptographyCryptoService({
    Random? secureRandom,
  }) : _random = secureRandom ?? Random.secure();

  @override
  Future<Uint8List> deriveKey(Uint8List data) async {
    final algorithm = Argon2id(
      parallelism: 4,
      memory: 10000, // 10 000 x 1kB block = 10 MB
      iterations: 3,
      hashLength: 32,
    );

    final salt = _generateRandomList(length: _saltLength);
    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(data),
      nonce: salt,
    );

    final keyBytes = await secretKey.extractBytes().then(Uint8List.fromList);

    // Combine salt and hashed password for storage
    return Uint8List.fromList([...salt, ...keyBytes]);
  }

  @override
  Future<Uint8List> decrypt(
    Uint8List data, {
    required Uint8List key,
  }) {
    // TODO: implement decrypt
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> encrypt(
    Uint8List data, {
    required Uint8List key,
  }) {
    // TODO: implement encrypt
    throw UnimplementedError();
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
