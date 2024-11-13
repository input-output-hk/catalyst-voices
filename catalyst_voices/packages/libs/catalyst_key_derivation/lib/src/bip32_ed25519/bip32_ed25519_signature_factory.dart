import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_signature.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/// A factory that builds instances of [Bip32Ed25519XSignature].
///
/// It is recommended to use the factory instead of directly constructing
/// instances of [Bip32Ed25519XSignature] because the factory can be replaced
/// in tests to provide mocked private keys which don't need
/// to communicate with Rust.
abstract class Bip32Ed25519XSignatureFactory {
  static Bip32Ed25519XSignatureFactory _instance =
      const DefaultBip32Ed25519XSignatureFactory();

  const Bip32Ed25519XSignatureFactory();

  // ignore: unnecessary_getters_setters
  static Bip32Ed25519XSignatureFactory get instance => _instance;

  static set instance(Bip32Ed25519XSignatureFactory factory) {
    _instance = factory;
  }

  /// Constructs a [Bip32Ed25519XSignature] from a list of [bytes].
  Bip32Ed25519XSignature fromBytes(List<int> bytes);

  /// Constructs a [Bip32Ed25519XSignature] from a hex-encoded list of bytes.
  Bip32Ed25519XSignature fromHex(String string) {
    return fromBytes(hex.decode(string));
  }

  /// Creates a [Bip32Ed25519XSignature] initialized
  /// with a single repeated [byte].
  ///
  /// This is useful for generating a deterministic private key with a fixed
  /// pattern, primarily for testing or experimentation purposes.
  Bip32Ed25519XSignature seeded(int byte) {
    return fromBytes(List.filled(rust.U8Array64.arraySize, byte));
  }

  /// Deserializes the type from cbor.
  Bip32Ed25519XSignature fromCbor(CborValue value) {
    return fromBytes((value as CborBytes).bytes);
  }
}

/// The default implementation of [Bip32Ed25519XSignatureFactory]
/// that provides real instances of [Bip32Ed25519XSignature].
final class DefaultBip32Ed25519XSignatureFactory
    extends Bip32Ed25519XSignatureFactory {
  const DefaultBip32Ed25519XSignatureFactory();

  @override
  Bip32Ed25519XSignature fromBytes(List<int> bytes) {
    return Bip32Ed25519XSignature.fromBytes(bytes);
  }
}
