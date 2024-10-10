import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/src/registration/registration_transaction_builder.dart';

/// Manages the user registration.
final class RegistrationService {
  final TransactionConfigRepository _configRepository;
  final CatalystCardano _cardano;

  const RegistrationService(this._configRepository, this._cardano);

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

      final registrationBuilder = RegistrationTransactionBuilder(
        transactionConfig: await _configRepository.fetch(networkId),
        networkId: networkId,
        seedPhrase: seedPhrase,
        roles: roles,
        changeAddress: await walletApi.getChangeAddress(),
        rewardAddresses: await walletApi.getRewardAddresses(),
        utxos: await walletApi.getUtxos(
          amount: Balance(
            coin: CardanoWalletDetails.minAdaForRegistration,
          ),
        ),
      );

      return registrationBuilder.build();
    } catch (error) {
      if (error is RegistrationException) {
        rethrow;
      }

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
    } catch (error) {
      if (error is RegistrationException) {
        rethrow;
      }

      throw const RegistrationTransactionException();
    }
  }
}
