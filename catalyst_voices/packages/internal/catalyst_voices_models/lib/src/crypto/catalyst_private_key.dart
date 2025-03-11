import 'dart:typed_data';

import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';

abstract interface class CatalystPrivateKey {
  /// A factory that creates instances of [CatalystPrivateKey].
  static late CatalystPrivateKeyFactory factory;

  /// Returns the signature algorithm used by the private key.
  CatalystSignatureAlgorithm get algorithm;

  /// Returns the private key bytes.
  Uint8List get bytes;

  /// Derives a new private key matching the [path].
  Future<CatalystPrivateKey> derivePrivateKey({required String path});

  /// Derives the public key matching this private key.
  Future<CatalystPublicKey> derivePublicKey();

  /// Clears the private key [bytes].
  void drop();

  /// Signs a [data] message and returns the signature.
  Future<CatalystSignature> sign(Uint8List data);
}
