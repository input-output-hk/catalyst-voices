import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_repositories/src/api/models/network.dart';

extension NetworkIdExt on NetworkId {
  Network toApiValue() {
    switch (this) {
      case NetworkId.mainnet:
        return Network.mainnet;
      case NetworkId.testnet:
        return Network.preprod;
    }
  }
}
