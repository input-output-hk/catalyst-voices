import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Creates dummy users and accounts.
// ignore: one_member_abstracts
abstract interface class DummyUserService {
  factory DummyUserService() {
    return DummyUserServiceImpl();
  }

  Account createDummyAccount();
}

final class DummyUserServiceImpl implements DummyUserService {
  @override
  Account createDummyAccount() {
    return Account(
      keychainId: 'TestKeychainId',
      roles: const {
        AccountRole.voter,
        AccountRole.proposer,
      },
      walletInfo: WalletInfo(
        metadata: const WalletMetadata(name: 'Dummy Wallet'),
        balance: Coin.fromAda(10),
        /* cSpell:disable */
        address: ShelleyAddress.fromBech32(
          'addr_test1vzpwq95z3xyum8vqndgdd'
          '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
        ),
        /* cSpell:enable */
      ),
    );
  }
}
