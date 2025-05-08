import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/blockchain/blockchain_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(BlockchainService, () {
    late BlockchainRepository walletRepository;
    late BlockchainService service;

    setUp(() {
      walletRepository = _FakeWalletRepository();
      service = BlockchainService(walletRepository);
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

    Future<void> testSlotNumber({
      required DateTime targetDateTime,
      required NetworkId networkId,
      required SlotBigNum expected,
    }) async {
      final actual = await service.calculateSlotNumber(
        targetDateTime: targetDateTime,
        networkId: networkId,
      );

      expect(actual, equals(expected));
    }

    group('calculateSlotNumberAtTargetDate on ${NetworkId.testnet}', () {
      test('https://preprod.cardanoscan.io/block/46', () async {
        await testSlotNumber(
          targetDateTime: DateTime.utc(2022, 6, 21, 0, 0, 0),
          networkId: NetworkId.testnet,
          expected: const SlotBigNum(86400),
        );
      });

      test('https://preprod.cardanoscan.io/block/2000000', () async {
        await testSlotNumber(
          targetDateTime: DateTime.utc(2024, 3, 4, 7, 17, 24),
          networkId: NetworkId.testnet,
          expected: const SlotBigNum(53853444),
        );
      });

      test('https://preprod.cardanoscan.io/block/3456000', () async {
        await testSlotNumber(
          targetDateTime: DateTime.utc(2025, 5, 8, 4, 54, 40),
          networkId: NetworkId.testnet,
          expected: const SlotBigNum(90996880),
        );
      });
    });

    group('calculateSlotNumberAtTargetDate on ${NetworkId.mainnet}', () {
      test('https://cardanoscan.io/block/4490511', () async {
        await testSlotNumber(
          targetDateTime: DateTime.utc(2020, 7, 29, 21, 44, 51),
          networkId: NetworkId.mainnet,
          expected: const SlotBigNum(4492800),
        );
      });

      test('https://cardanoscan.io/block/8547193', () async {
        await testSlotNumber(
          targetDateTime: DateTime.utc(2023, 3, 21, 21, 44, 34),
          networkId: NetworkId.mainnet,
          expected: const SlotBigNum(87868783),
        );
      });

      test('https://cardanoscan.io/block/10547193', () async {
        await testSlotNumber(
          targetDateTime: DateTime.utc(2024, 7, 8, 16, 57, 22),
          networkId: NetworkId.mainnet,
          expected: const SlotBigNum(128891551),
        );
      });

      test('https://cardanoscan.io/block/11837000', () async {
        await testSlotNumber(
          targetDateTime: DateTime.utc(2025, 5, 8, 9, 34, 28),
          networkId: NetworkId.mainnet,
          expected: const SlotBigNum(155130577),
        );
      });
    });
  });
}

class _FakeWalletRepository extends Fake implements BlockchainRepository {
  @override
  Future<Coin> getWalletBalance({
    required ShelleyAddress stakeAddress,
    required NetworkId networkId,
    RbacToken? rbacToken,
  }) async {
    return const Coin(0);
  }
}
