import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Creates dummy users and accounts.
// ignore: one_member_abstracts
abstract interface class DummyUserService {
  static const String dummyKeychainId = 'TestUserKeychainID';
  factory DummyUserService() {
    return const DummyUserServiceImpl();
  }

  User getDummyUser({String keychainId = dummyKeychainId});

  Account getDummyAccount({String keychainId = dummyKeychainId});
}

final class DummyUserServiceImpl implements DummyUserService {
  const DummyUserServiceImpl();

  @override
  User getDummyUser({String keychainId = DummyUserService.dummyKeychainId}) {
    return User(
      accounts: [
        getDummyAccount(keychainId: keychainId),
      ],
    );
  }

  @override
  Account getDummyAccount({
    String keychainId = DummyUserService.dummyKeychainId,
  }) {
    return Account(
      keychainId: keychainId,
      roles: const {
        AccountRole.voter,
        AccountRole.proposer,
      },
      walletInfo: WalletInfo(
        metadata: const WalletMetadata(
          name: 'Dummy Wallet',
          icon: null,
        ),
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