import 'dart:typed_data';

import 'package:catalyst_voices_models/src/crypto/catalyst_key_factory.dart';

abstract interface class CatalystSignature {
  /// A factory that creates instances of [CatalystSignature].
  static late CatalystSignatureFactory factory;

  /// Returns the signature bytes.
  Uint8List get bytes;
}
