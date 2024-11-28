import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_key_derivation/src/ed25519/ed25519_signature.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

/// The ED25519 public key that is 256 bits long.
extension type Ed25519PublicKey._(List<int> bytes) {
  /// The length of the [Ed25519PublicKey] in bytes.
  static const int length = 32;

  /// The default constructor for [Ed25519PublicKey].
  Ed25519PublicKey.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519PublicKey length does not match: ${bytes.length}',
      );
    }
  }

  /// Constructs [Ed25519PublicKey] from a hex [string].
  factory Ed25519PublicKey.fromHex(String string) {
    return Ed25519PublicKey.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519PublicKey] filled with [byte] that can be
  /// used to reserve size to calculate the final transaction bytes size.
  factory Ed25519PublicKey.seeded(int byte) =>
      Ed25519PublicKey.fromBytes(List.filled(length, byte));

  /// Deserializes the type from cbor.
  factory Ed25519PublicKey.fromCbor(CborValue value) {
    return Ed25519PublicKey.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor({List<int> tags = const []}) {
    return CborBytes(bytes, tags: tags);
  }

  /// Returns a hex representation of the [Ed25519PublicKey].
  String toHex() => hex.encode(bytes);

  /// Returns true if this [signature] belongs to this public key
  /// for given [message], false otherwise.
  Future<bool> verify(
    List<int> message, {
    required Ed25519Signature signature,
  }) async {
    final algorithm = Ed25519();
    return algorithm.verify(
      message,
      signature: Signature(
        signature.bytes,
        publicKey: SimplePublicKey(bytes, type: KeyPairType.ed25519),
      ),
    );
  }
}
