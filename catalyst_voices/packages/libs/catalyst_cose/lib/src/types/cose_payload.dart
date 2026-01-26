import 'dart:typed_data';

import 'package:catalyst_cose/src/cose_sign.dart';
import 'package:catalyst_cose/src/cose_sign1.dart';
import 'package:cbor/cbor.dart';

/// The binary payload of the [CoseSign.payload] or [CoseSign1.payload].
extension type const CosePayload(Uint8List bytes) {
  /// Deserializes the type from cbor.
  factory CosePayload.fromCbor(CborValue value) {
    return CosePayload(Uint8List.fromList((value as CborBytes).bytes));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);
}
