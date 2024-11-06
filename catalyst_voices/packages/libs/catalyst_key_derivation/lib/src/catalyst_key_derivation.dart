import 'package:catalyst_key_derivation/src/bip32_ed25519/bip32_ed25519_private_key.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:catalyst_key_derivation/src/rust/frb_generated.dart'
    show RustLib, RustLibApi;

/// A Flutter plugin exposing Cardano SLIP-0023
/// hierarchical deterministic key derivation.
class CatalystKeyDerivation {
  const CatalystKeyDerivation();

  /// Initializes the catalyst_key_derivation package.
  static Future<void> init() async {
    await RustLib.init();
  }

  /// Initializes the catalyst_key_derivation in a test mode.
  static void initMock({required RustLibApi api}) {
    RustLib.initMock(api: api);
  }

  /// Derives a master key from a [mnemonic].
  ///
  /// The mnemonic needs to be a valid BIP-39 string of words.
  Future<Bip32Ed25519XPrivateKey> deriveMasterKey({
    required String mnemonic,
  }) async {
    final key = await rust.mnemonicToXprv(mnemonic: mnemonic);
    return Bip32Ed25519XPrivateKey(key);
  }
}
