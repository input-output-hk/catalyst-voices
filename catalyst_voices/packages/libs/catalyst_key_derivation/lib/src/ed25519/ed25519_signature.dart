import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/// The witness signature of the transaction.
extension type Ed25519Signature._(List<int> bytes) {
  /// The length of the [Ed25519Signature] in bytes.
  static const int length = 64;

  /// The default constructor for [Ed25519Signature].
  Ed25519Signature.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519Signature length does not match: ${bytes.length}',
      );
    }
  }

  /// Constructs [Ed25519Signature] from a hex [string].
  factory Ed25519Signature.fromHex(String string) {
    return Ed25519Signature.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519Signature] filled with [byte]
  /// that can be used to reserve size.
  factory Ed25519Signature.seeded(int byte) =>
      Ed25519Signature.fromBytes(List.filled(length, byte));

  /// Deserializes the type from cbor.
  factory Ed25519Signature.fromCbor(CborValue value) {
    return Ed25519Signature.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a hex representation of the [Ed25519Signature].
  String toHex() => hex.encode(bytes);
}
