import 'dart:typed_data';

import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';

abstract interface class CatalystPublicKey {
  /// A factory that creates instances of [CatalystPublicKey].
  static late CatalystPublicKeyFactory factory;

  /// Returns the public key bytes.
  Uint8List get bytes;

  /// Returns true if [signature] over [data] matches this public key.
  Future<bool> verify(
    Uint8List data, {
    required CatalystSignature signature,
  });
}
