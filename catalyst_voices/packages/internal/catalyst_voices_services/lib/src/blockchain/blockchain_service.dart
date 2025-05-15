import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

// TODO(dtscalac): move most blockchain/wallet related code to here
abstract interface class BlockchainService {
  const factory BlockchainService(BlockchainRepository blockchainRepository) =
      BlockchainServiceImpl;

  Future<SlotBigNum> calculateSlotNumber({
    required DateTime targetDateTime,
    required NetworkId networkId,
  });

  Future<Coin> getWalletBalance({
    required ShelleyAddress stakeAddress,
    required NetworkId networkId,
    RbacToken? rbacToken,
  });
}

final class BlockchainServiceImpl implements BlockchainService {
  final BlockchainRepository _blockchainRepository;

  const BlockchainServiceImpl(this._blockchainRepository);

  @override
  Future<SlotBigNum> calculateSlotNumber({
    required DateTime targetDateTime,
    required NetworkId networkId,
  }) async {
    final config = switch (networkId) {
      NetworkId.mainnet => BlockchainSlotNumberConfig.mainnet(),
      NetworkId.testnet => BlockchainSlotNumberConfig.testnet(),
    };

    final diff =
        targetDateTime.millisecondsSinceEpoch - config.systemStartTimestamp.millisecondsSinceEpoch;

    final slotNum = diff / config.slotLength.inMilliseconds + config.systemStartSlot.value;

    return SlotBigNum(slotNum.floor());
  }

  @override
  Future<Coin> getWalletBalance({
    required ShelleyAddress stakeAddress,
    required NetworkId networkId,
    RbacToken? rbacToken,
  }) {
    return _blockchainRepository.getWalletBalance(
      stakeAddress: stakeAddress,
      networkId: networkId,
      rbacToken: rbacToken,
    );
  }
}
