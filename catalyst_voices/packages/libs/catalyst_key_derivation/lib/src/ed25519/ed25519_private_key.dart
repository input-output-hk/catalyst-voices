import 'package:catalyst_key_derivation/src/ed25519/ed25519_public_key.dart';
import 'package:catalyst_key_derivation/src/ed25519/ed25519_signature.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

/// The Ed25519 private key that is 256 bits long.
///
/// The [bytes] are the seed required by the Ed25519 algorithm.
extension type Ed25519PrivateKey._(List<int> bytes) {
  /// The length of the [Ed25519PrivateKey] in bytes.
  static const int length = 32;

  /// The default constructor for [Ed25519PrivateKey].
  Ed25519PrivateKey.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'Ed25519PrivateKey length does not match: ${bytes.length}',
      );
    }
  }

  /// Constructs [Ed25519PrivateKey] from a hex [string].
  factory Ed25519PrivateKey.fromHex(String string) {
    return Ed25519PrivateKey.fromBytes(hex.decode(string));
  }

  /// Returns the [Ed25519PrivateKey] filled with [byte] that can be
  /// used to reserve size to calculate the final transaction bytes size.
  factory Ed25519PrivateKey.seeded(int byte) =>
      Ed25519PrivateKey.fromBytes(List.filled(length, byte));

  /// Deserializes the type from cbor.
  factory Ed25519PrivateKey.fromCbor(CborValue value) {
    return Ed25519PrivateKey.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a hex representation of the [Ed25519PrivateKey].
  String toHex() => hex.encode(bytes);

  /// Signs the [message] with the private key and returns the signature.
  Future<Ed25519Signature> sign(List<int> message) async {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(bytes);
    final signature = await algorithm.sign(message, keyPair: keyPair);
    return Ed25519Signature.fromBytes(signature.bytes);
  }

  /// Returns a [Ed25519PublicKey] derived from this private key.
  Future<Ed25519PublicKey> derivePublicKey() async {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(bytes);
    final publicKey = await keyPair.extractPublicKey();
    return Ed25519PublicKey.fromBytes(publicKey.bytes);
  }
}
