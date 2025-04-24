import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.enums.swagger.dart';

extension NetworkIdDto on NetworkId {
  Network toDto() {
    switch (this) {
      case NetworkId.mainnet:
        return Network.mainnet;
      case NetworkId.testnet:
        return Network.preprod;
    }
  }
}
