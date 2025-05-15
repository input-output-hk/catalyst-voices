import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_private_key.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:catalyst_key_derivation/src/rust/frb_generated.dart'
    show RustLib;

/// A Flutter plugin for Cardano's SLIP-0023 hierarchical deterministic
/// key derivation.
///
/// This class provides methods to securely derive cryptographic keys from
/// a BIP-39 mnemonic phrase, leveraging Cardano's SLIP-0023 standard
/// for hierarchical deterministic (HD) key derivation with the ed25519
/// elliptic curve. It's particularly useful for developers building
/// applications that interact with the Cardano blockchain or need secure,
/// mnemonic-based cryptographic keys.
///
/// Usage:
/// ```dart
/// // Initialize the library (one-time setup).
/// await CatalystKeyDerivation.init();
///
/// // Derive a master key from a BIP-39 mnemonic phrase.
/// const keyDerivation = CatalystKeyDerivation();
/// final masterKey = await keyDerivation.deriveMasterKey(
///   mnemonic: 'your mnemonic phrase here',
/// );
/// ```
class CatalystKeyDerivation {
  const CatalystKeyDerivation();

  /// Initializes the `catalyst_key_derivation` package.
  ///
  /// This method should be called once at the start of your application
  /// to initialize the underlying Rust library that powers the key derivation
  /// functions. It is necessary to call this before attempting to derive
  /// any keys, as it ensures that the native Rust dependencies
  /// are properly set up.
  static Future<void> init() async {
    await RustLib.init();
  }

  /// Derives a master private key from a BIP-39 [mnemonic] phrase.
  ///
  /// This method takes a mnemonic phrase as input, validates it, and derives a
  /// `Bip32Ed25519XPrivateKey` following the Cardano SLIP-0023 standard.
  ///
  /// - [mnemonic]: A valid BIP-39 mnemonic phrase, consisting of a series
  ///   of words typically separated by spaces. The mnemonic must be valid
  ///   per BIP-39 standards.
  ///
  /// Returns a [Bip32Ed25519XPrivateKey] object representing the derived
  /// master private key.
  Future<Bip32Ed25519XPrivateKey> deriveMasterKey({
    required String mnemonic,
  }) async {
    final key = await rust.mnemonicToXprv(mnemonic: mnemonic);
    return Bip32Ed25519XPrivateKey(key);
  }
}
