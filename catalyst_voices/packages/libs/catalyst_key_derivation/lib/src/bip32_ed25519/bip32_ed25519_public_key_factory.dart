import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_public_key.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/// A factory that builds instances of [Bip32Ed25519XPublicKey].
///
/// It is recommended to use the factory instead of directly constructing
/// instances of [Bip32Ed25519XPublicKey] because the factory can be replaced
/// in tests to provide mocked private keys which don't need
/// to communicate with Rust.
abstract class Bip32Ed25519XPublicKeyFactory {
  static Bip32Ed25519XPublicKeyFactory _instance =
      const DefaultBip32Ed25519XPublicKeyFactory();

  const Bip32Ed25519XPublicKeyFactory();

  // ignore: unnecessary_getters_setters
  static Bip32Ed25519XPublicKeyFactory get instance => _instance;

  static set instance(Bip32Ed25519XPublicKeyFactory factory) {
    _instance = factory;
  }

  /// Constructs a [Bip32Ed25519XPublicKey] from a list of [bytes].
  Bip32Ed25519XPublicKey fromBytes(List<int> bytes);

  /// Constructs a [Bip32Ed25519XPublicKey] from a hex-encoded list of bytes.
  Bip32Ed25519XPublicKey fromHex(String string) {
    return fromBytes(hex.decode(string));
  }

  /// Creates a [Bip32Ed25519XPublicKey] initialized
  /// with a single repeated [byte].
  ///
  /// This is useful for generating a deterministic private key with a fixed
  /// pattern, primarily for testing or experimentation purposes.
  Bip32Ed25519XPublicKey seeded(int byte) {
    return fromBytes(List.filled(rust.U8Array64.arraySize, byte));
  }

  /// Deserializes the type from cbor.
  Bip32Ed25519XPublicKey fromCbor(CborValue value) {
    return fromBytes((value as CborBytes).bytes);
  }
}

/// The default implementation of [Bip32Ed25519XPublicKeyFactory]
/// that provides real instances of [Bip32Ed25519XPublicKey].
final class DefaultBip32Ed25519XPublicKeyFactory
    extends Bip32Ed25519XPublicKeyFactory {
  const DefaultBip32Ed25519XPublicKeyFactory();

  @override
  Bip32Ed25519XPublicKey fromBytes(List<int> bytes) {
    return Bip32Ed25519XPublicKey.fromBytes(bytes);
  }
}
