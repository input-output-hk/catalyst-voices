import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';

/// A Flutter plugin exposing the [CIP-30](https://cips.cardano.org/cip/CIP-30)
/// and [CIP-95](https://cips.cardano.org/cip/CIP-95) APIs.
final class CatalystCardano {
  /// The default instance of [CatalystCardano] to use.
  static final CatalystCardano instance = CatalystCardano._();

  CatalystCardano._();

  /// Returns available wallet extensions exposed under
  /// cardano.{walletName} according to CIP-30 standard.
  Future<List<CardanoWallet>> getWallets() async {
    return CatalystCardanoPlatform.instance.getWallets();
  }
}
