import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';

/// UTF-8 Catalyst ID URI encoded as a bytes string.
extension type const CatalystIdKid(Uint8List bytes) {
  /// Deserializes the type from cbor.
  factory CatalystIdKid.fromCbor(CborValue value) {
    return CatalystIdKid(Uint8List.fromList((value as CborBytes).bytes));
  }

  /// Creates a new [CatalystIdKid] from [string].
  factory CatalystIdKid.fromString(String string) {
    return CatalystIdKid(utf8.encode(string));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborBytes(bytes);
  }
}
