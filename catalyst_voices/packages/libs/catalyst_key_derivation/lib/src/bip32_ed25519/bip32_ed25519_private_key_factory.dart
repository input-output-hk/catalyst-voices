import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_private_key.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/// A factory that builds instances of [Bip32Ed25519XPrivateKey].
///
/// It is recommended to use the factory instead of directly constructing
/// instances of [Bip32Ed25519XPrivateKey] because the factory can be replaced
/// in tests to provide mocked private keys which don't need
/// to communicate with Rust.
abstract class Bip32Ed25519XPrivateKeyFactory {
  static Bip32Ed25519XPrivateKeyFactory _instance =
      const DefaultBip32Ed25519XPrivateKeyFactory();

  const Bip32Ed25519XPrivateKeyFactory();

  // ignore: unnecessary_getters_setters
  static Bip32Ed25519XPrivateKeyFactory get instance => _instance;

  static set instance(Bip32Ed25519XPrivateKeyFactory factory) {
    _instance = factory;
  }

  /// Constructs a [Bip32Ed25519XPrivateKey] from a list of [bytes].
  Bip32Ed25519XPrivateKey fromBytes(List<int> bytes);

  /// Constructs a [Bip32Ed25519XPrivateKey] from a hex-encoded list of bytes.
  Bip32Ed25519XPrivateKey fromHex(String string) {
    return fromBytes(hex.decode(string));
  }

  /// Creates a [Bip32Ed25519XPrivateKey] initialized
  /// with a single repeated [byte].
  ///
  /// This is useful for generating a deterministic private key with a fixed
  /// pattern, primarily for testing or experimentation purposes.
  Bip32Ed25519XPrivateKey seeded(int byte) {
    return fromBytes(List.filled(rust.U8Array96.arraySize, byte));
  }

  /// Deserializes the type from cbor.
  Bip32Ed25519XPrivateKey fromCbor(CborValue value) {
    return fromBytes((value as CborBytes).bytes);
  }
}

/// The default implementation of [Bip32Ed25519XPrivateKeyFactory]
/// that provides real instances of [Bip32Ed25519XPrivateKey].
final class DefaultBip32Ed25519XPrivateKeyFactory
    extends Bip32Ed25519XPrivateKeyFactory {
  const DefaultBip32Ed25519XPrivateKeyFactory();

  @override
  Bip32Ed25519XPrivateKey fromBytes(List<int> bytes) {
    return Bip32Ed25519XPrivateKey.fromBytes(bytes);
  }
}
