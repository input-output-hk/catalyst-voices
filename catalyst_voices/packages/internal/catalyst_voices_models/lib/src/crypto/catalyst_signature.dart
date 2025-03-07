import 'dart:typed_data';

abstract interface class CatalystSignature {
  /// Returns the signature bytes.
  Uint8List get bytes;
}
