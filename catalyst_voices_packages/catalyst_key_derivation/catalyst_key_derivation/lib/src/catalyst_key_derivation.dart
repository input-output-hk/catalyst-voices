import 'dart:typed_data';

/// A Flutter plugin exposing CIP-1852 Cardano HD Key Derivation.
final class CatalystKeyDerivation {
  /// The default instance of [CatalystKeyDerivation] to use.
  static final CatalystKeyDerivation instance = CatalystKeyDerivation._();

  CatalystKeyDerivation._();

  /// Derives a master key from the [mnemonic].
  Future<Uint8List> deriveMasterKey(String mnemonic) {
    throw UnimplementedError();
  }
}
