import 'package:catalyst_key_derivation/src/ed25519_extended/ed25519_extended_private_key.dart';
import 'package:catalyst_key_derivation/src/rust/api/key_derivation.dart'
    as rust;
import 'package:catalyst_key_derivation/src/rust/frb_generated.dart'
    show RustLib, RustLibApi;

/// A Flutter plugin exposing brotli and zstd compression/decompression algorithms.
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
  Future<Ed25519ExtendedPrivateKey> deriveMasterKey({
    required String mnemonic,
  }) async {
    final key = await rust.mnemonicToXprv(mnemonic: mnemonic);
    return Ed25519ExtendedPrivateKey(key);
  }
}
