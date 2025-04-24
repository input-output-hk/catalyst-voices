import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/common/rbac_token_ext.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/dto/blockchain/network_id_dto.dart';

// TODO(dtscalac): move wallet related repository code here
// ignore: one_member_abstracts
abstract interface class WalletRepository {
  const factory WalletRepository(ApiServices apiServices) =
      WalletRepositoryImpl;

  Future<Coin> getWalletBalance({
    required ShelleyAddress stakeAddress,
    required NetworkId networkId,
    RbacToken? rbacToken,
  });
}

final class WalletRepositoryImpl implements WalletRepository {
  final ApiServices _apiServices;

  const WalletRepositoryImpl(this._apiServices);

  @override
  Future<Coin> getWalletBalance({
    required ShelleyAddress stakeAddress,
    required NetworkId networkId,
    RbacToken? rbacToken,
  }) {
    return _apiServices.gateway
        .apiV1CardanoAssetsStakeAddressGet(
          stakeAddress: stakeAddress.toBech32(),
          network: networkId.toDto(),
          authorization: rbacToken?.authHeader(),
        )
        .successBodyOrThrow()
        // get volatile balance to reflect latest transactions
        .then((stakeInfo) => Coin(stakeInfo.volatile.adaAmount));
  }
}
