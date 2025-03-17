import 'dart:typed_data';

import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';

abstract interface class CatalystPublicKey {
  /// A factory that creates instances of [CatalystPublicKey].
  static late CatalystPublicKeyFactory factory;

  /// Returns the public key bytes + optionally chain code
  /// if the implementation chooses so.
  Uint8List get bytes;

  /// Returns just the public key bytes without any metadata (chain code).
  Uint8List get publicKeyBytes;

  /// Returns true if [signature] over [data] matches this public key.
  Future<bool> verify(
    Uint8List data, {
    required CatalystSignature signature,
  });
}
