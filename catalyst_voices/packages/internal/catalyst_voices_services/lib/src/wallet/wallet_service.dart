import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

// TODO(dtscalac): move most blockchain/wallet related code to here
// ignore: one_member_abstracts
abstract interface class WalletService {
  const factory WalletService(WalletRepository walletRepository) =
      WalletServiceImpl;

  Future<Coin> getWalletBalance({
    required ShelleyAddress stakeAddress,
    required NetworkId networkId,
    required RbacToken rbacToken,
  });
}

final class WalletServiceImpl implements WalletService {
  final WalletRepository _walletRepository;

  const WalletServiceImpl(this._walletRepository);

  @override
  Future<Coin> getWalletBalance({
    required ShelleyAddress stakeAddress,
    required NetworkId networkId,
    required RbacToken rbacToken,
  }) {
    return _walletRepository.getWalletBalance(
      stakeAddress: stakeAddress,
      networkId: networkId,
      rbacToken: rbacToken,
    );
  }
}
