import 'package:flutter/foundation.dart';

abstract interface class CryptoService {
  Future<Uint8List> deriveKey(
    Uint8List seed, {
    Uint8List? salt,
  });

  Future<bool> verifyKey(
    Uint8List seed, {
    required Uint8List key,
  });

  Future<Uint8List> decrypt(
    Uint8List data, {
    required Uint8List key,
  });

  Future<Uint8List> encrypt(
    Uint8List data, {
    required Uint8List key,
  });
}
