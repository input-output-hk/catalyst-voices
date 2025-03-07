import 'dart:typed_data';

import 'package:catalyst_voices_models/src/crypto/catalyst_signature.dart';

abstract interface class CatalystPublicKey {
  /// Returns the public key bytes.
  Uint8List get bytes;

  /// Returns true if [signature] over [data] matches this public key.
  Future<bool> verify(
    Uint8List data, {
    required CatalystSignature signature,
  });
}
