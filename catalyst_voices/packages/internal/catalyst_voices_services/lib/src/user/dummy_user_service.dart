import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Creates dummy users and accounts.
abstract interface class DummyUserFactory {
  static const dummyKeychainId = 'TestUserKeychainID';
  static const dummyUnlockFactor = PasswordLockFactor('Test1234');
  static final dummySeedPhrase = SeedPhrase.fromMnemonic(
    'few loyal swift champion rug peace dinosaur '
    'erase bacon tone install universe',
  );

  factory DummyUserFactory() {
    return const DummyUserFactoryImpl();
  }

  User buildDummyUser({String keychainId = dummyKeychainId});

  Account buildDummyAccount({String keychainId = dummyKeychainId});
}

final class DummyUserFactoryImpl implements DummyUserFactory {
  const DummyUserFactoryImpl();

  @override
  User buildDummyUser({String keychainId = DummyUserFactory.dummyKeychainId}) {
    return User(
      accounts: [
        buildDummyAccount(keychainId: keychainId),
      ],
    );
  }

  @override
  Account buildDummyAccount({
    String keychainId = DummyUserFactory.dummyKeychainId,
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
