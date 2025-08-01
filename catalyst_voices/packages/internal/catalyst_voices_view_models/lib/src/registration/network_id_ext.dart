import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

/// Extension on [NetworkId] to provide utility methods:
///
/// - [localizedName]: Returns the localized name of the network.
extension NetworkIdExt on NetworkId {
  String localizedName(BuildContext context) {
    switch (this) {
      case NetworkId.mainnet:
        return context.l10n.mainnetNetworkId;
      case NetworkId.testnet:
        return context.l10n.preprodNetworkId;
    }
  }
}
