import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/wallet/wallet_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(WalletService, () {
    late WalletRepository walletRepository;
    late WalletService service;

    setUp(() {
      walletRepository = _FakeWalletRepository();
      service = WalletService(walletRepository);
    });

    test('getWalletBalance', () async {
      // Given
      final stakeAddress = ShelleyAddress.fromBech32(
        /* cSpell:disable */
        'addr_test1vzpwq95z3xyum8vqndgdd'
        '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
        /* cSpell:enable */
      );

      const networkId = NetworkId.testnet;
      const rbacToken = RbacToken('catid');

      // Then
      expect(
        await service.getWalletBalance(
          stakeAddress: stakeAddress,
          networkId: networkId,
          rbacToken: rbacToken,
        ),
        equals(const Coin(0)),
      );
    });
  });
}

class _FakeWalletRepository extends Fake implements WalletRepository {
  @override
  Future<Coin> getWalletBalance({
    required ShelleyAddress stakeAddress,
    required NetworkId networkId,
    required RbacToken rbacToken,
  }) async {
    return const Coin(0);
  }
}
