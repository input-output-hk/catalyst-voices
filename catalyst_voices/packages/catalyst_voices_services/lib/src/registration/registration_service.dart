import 'dart:math';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

// TODO(damian-molinski): remove once recover account is implemented
/* cSpell:disable */
final _testNetAddress = ShelleyAddress.fromBech32(
  'addr_test1vzpwq95z3xyum8vqndgdd'
  '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
);
/* cSpell:enable */

/// Manages the user registration.
final class RegistrationService {
  final TransactionConfigRepository _transactionConfigRepository;
  final Keychain _keychain;
  final KeyDerivation _keyDerivation;
  final CatalystCardano _cardano;

  const RegistrationService(
    this._transactionConfigRepository,
    this._keychain,
    this._keyDerivation,
    this._cardano,
  );

  /// Initializes the keychain to store user registration data.
  Future<void> createKeychain({
    required SeedPhrase seedPhrase,
    required String unlockPassword,
  }) async {
    await _keychain.init(
      seedPhrase: seedPhrase,
      unlockFactor: PasswordLockFactor(unlockPassword),
    );
  }

  /// Returns the available cardano wallet extensions.
  Future<List<CardanoWallet>> getCardanoWallets() {
    return _cardano.getWallets();
  }

  /// Returns the details of a [wallet].
  ///
  /// This will trigger a permission popup from the wallet extension.
  /// Afterwards the user must grant a permission inside the wallet extension.
  Future<CardanoWalletDetails> getCardanoWalletDetails(
    CardanoWallet wallet,
  ) async {
    final enabledWallet = await wallet.enable();
    final balance = await enabledWallet.getBalance();
    final address = await enabledWallet.getChangeAddress();

    return CardanoWalletDetails(
      wallet: wallet,
      balance: balance.coin,
      address: address,
    );
  }

  // TODO(damian-molinski): to be implemented
  // Note. Returned type will be changed because we'll not be able to
  // get a wallet from backend just from seed phrase.
  // To be decided what data can we get from backend.
  Future<CardanoWalletDetails> recoverCardanoWalletDetails(
    SeedPhrase seedPhrase,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final isSuccess = Random().nextBool();
    if (!isSuccess) {
      throw const RegistrationUnknownException();
    }

    final wallet = DummyCardanoWallet(
      name: 'Dummy Wallet',
      icon: '',
    );
    final balance = Coin.fromAda(10);
    final address = _testNetAddress;

    return CardanoWalletDetails(
      wallet: wallet,
      balance: balance,
      address: address,
    );
  }

  /// Builds an unsigned registration transaction from given parameters.
  ///
  /// Throws a subclass of [RegistrationException] in case of a failure.
  Future<Transaction> prepareRegistration({
    required CardanoWallet wallet,
    required NetworkId networkId,
    required SeedPhrase seedPhrase,
    required Set<AccountRole> roles,
  }) async {
    try {
      final walletApi = await wallet.enable();

      final keyPair = await _keyDerivation.deriveAccountRoleKeyPair(
        seedPhrase: seedPhrase,
        role: AccountRole.root,
      );

      final registrationBuilder = RegistrationTransactionBuilder(
        transactionConfig: await _transactionConfigRepository.fetch(networkId),
        keyPair: keyPair,
        networkId: networkId,
        roles: roles,
        changeAddress: await walletApi.getChangeAddress(),
        rewardAddresses: await walletApi.getRewardAddresses(),
        utxos: await walletApi.getUtxos(
          amount: Balance(
            coin: CardanoWalletDetails.minAdaForRegistration,
          ),
        ),
      );

      return await registrationBuilder.build();
    } on RegistrationException {
      rethrow;
    } catch (error) {
      throw const RegistrationUnknownException();
    }
  }

  /// Requests the user to sign the registration transaction
  /// and submits it to the blockchain.
  ///
  /// This triggers the permission popup from the wallet extension,
  /// the user must agree to sign the transaction.
  ///
  /// The transaction must be prepared earlier via [prepareRegistration].
  ///
  /// Throws a subclass of [RegistrationException] in case of a failure.
  Future<Transaction> submitRegistration({
    required CardanoWallet wallet,
    required Transaction unsignedTx,
  }) async {
    try {
      final walletApi = await wallet.enable();
      final witnessSet = await walletApi.signTx(transaction: unsignedTx);

      final signedTx = Transaction(
        body: unsignedTx.body,
        isValid: true,
        witnessSet: witnessSet,
        auxiliaryData: unsignedTx.auxiliaryData,
      );

      await walletApi.submitTx(transaction: signedTx);

      return signedTx;
    } on RegistrationException {
      rethrow;
    } catch (error) {
      throw const RegistrationTransactionException();
    }
  }
}
