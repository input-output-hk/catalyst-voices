import 'dart:math';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

// TODO(damian-molinski): remove once recover account is implemented
/* cSpell:disable */
final _testNetAddress = ShelleyAddress.fromBech32(
  'addr_test1vzpwq95z3xyum8vqndgdd'
  '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
);
/* cSpell:enable */

final _logger = Logger('RegistrationService');

abstract interface class RegistrationService {
  factory RegistrationService({
    required TransactionConfigRepository transactionConfigRepository,
    required KeychainProvider keychainProvider,
    required CatalystCardano cardano,
    required KeyDerivation keyDerivation,
  }) {
    return RegistrationServiceImpl(
      transactionConfigRepository,
      keychainProvider,
      cardano,
      keyDerivation,
    );
  }

  /// Returns the available cardano wallet extensions.
  Future<List<CardanoWallet>> getCardanoWallets();

  /// Returns the details of a [wallet].
  ///
  /// This will trigger a permission popup from the wallet extension.
  /// Afterwards the user must grant a permission inside the wallet extension.
  Future<WalletInfo> getCardanoWalletInfo(CardanoWallet wallet);

  /// See [KeyDerivation.deriveAccountRoleKeyPair].
  Future<Ed25519KeyPair> deriveAccountRoleKeyPair({
    required SeedPhrase seedPhrase,
    required Set<AccountRole> roles,
  });

  /// Loads account related to this [seedPhrase]. Throws exception if non found.
  Future<Account> recoverAccount({
    required SeedPhrase seedPhrase,
  });

  /// Creates [Keychain] for given [account] with [lockFactor].
  Future<Keychain> createKeychainFor({
    required Account account,
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  });

  /// Builds an unsigned registration transaction from given parameters.
  ///
  /// Throws a subclass of [RegistrationException] in case of a failure.
  Future<Transaction> prepareRegistration({
    required CardanoWallet wallet,
    required NetworkId networkId,
    required Ed25519KeyPair keyPair,
    required Set<AccountRole> roles,
  });

  /// Requests the user to sign the registration transaction
  /// and submits it to the blockchain.
  ///
  /// This triggers the permission popup from the wallet extension,
  /// the user must agree to sign the transaction.
  ///
  /// The transaction must be prepared earlier via [prepareRegistration].
  ///
  /// Throws a subclass of [RegistrationException] in case of a failure.
  Future<Account> register({
    required CardanoWallet wallet,
    required Transaction unsignedTx,
    required Set<AccountRole> roles,
    required LockFactor lockFactor,
    required Ed25519KeyPair keyPair,
  });

  Future<Account> registerTestAccount({
    required String keychainId,
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  });
}

/// Manages the user registration.
final class RegistrationServiceImpl implements RegistrationService {
  final TransactionConfigRepository _transactionConfigRepository;
  final KeychainProvider _keychainProvider;
  final CatalystCardano _cardano;
  final KeyDerivation _keyDerivation;

  const RegistrationServiceImpl(
    this._transactionConfigRepository,
    this._keychainProvider,
    this._cardano,
    this._keyDerivation,
  );

  @override
  Future<List<CardanoWallet>> getCardanoWallets() {
    return _cardano.getWallets();
  }

  @override
  Future<WalletInfo> getCardanoWalletInfo(CardanoWallet wallet) async {
    final enabledWallet = await wallet.enable();
    final balance = await enabledWallet.getBalance();
    final address = await enabledWallet.getChangeAddress();

    return WalletInfo(
      metadata: WalletMetadata.fromCardanoWallet(wallet),
      balance: balance.coin,
      address: address,
    );
  }

  @override
  Future<Ed25519KeyPair> deriveAccountRoleKeyPair({
    required SeedPhrase seedPhrase,
    required Set<AccountRole> roles,
  }) {
    return _keyDerivation.deriveAccountRoleKeyPair(
      seedPhrase: seedPhrase,
      // TODO(dtscalac): Only one roles is supported atm.
      role: AccountRole.root,
    );
  }

  // TODO(damian-molinski): to be implemented
  // Note. Returned type will be changed because we'll not be able to
  // get a wallet from backend just from seed phrase.
  // To be decided what data can we get from backend.
  @override
  Future<Account> recoverAccount({
    required SeedPhrase seedPhrase,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final isSuccess = Random().nextBool();
    if (!isSuccess) {
      throw const RegistrationUnknownException();
    }

    final roles = {AccountRole.root};
    final keychainId = const Uuid().v4();

    // Note. with rootKey query backend for account details.
    return Account(
      keychainId: keychainId,
      roles: roles,
      walletInfo: WalletInfo(
        metadata: const WalletMetadata(name: 'Dummy Wallet'),
        balance: Coin.fromAda(10),
        address: _testNetAddress,
      ),
    );
  }

  @override
  Future<Keychain> createKeychainFor({
    required Account account,
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  }) async {
    final keychainId = account.keychainId;

    final keyPair = await deriveAccountRoleKeyPair(
      seedPhrase: seedPhrase,
      roles: account.roles,
    );

    final keychain = await _keychainProvider.create(keychainId);
    await keychain.setLock(lockFactor);
    await keychain.unlock(lockFactor);
    await keychain.setMasterKey(keyPair.privateKey);

    return keychain;
  }

  @override
  Future<Transaction> prepareRegistration({
    required CardanoWallet wallet,
    required NetworkId networkId,
    required Ed25519KeyPair keyPair,
    required Set<AccountRole> roles,
  }) async {
    try {
      final config = await _transactionConfigRepository.fetch(networkId);

      final enabledWallet = await wallet.enable();
      final changeAddress = await enabledWallet.getChangeAddress();
      final rewardAddresses = await enabledWallet.getRewardAddresses();
      final utxos = await enabledWallet.getUtxos(
        amount: Balance(
          coin: CardanoWalletDetails.minAdaForRegistration,
        ),
      );

      final registrationBuilder = RegistrationTransactionBuilder(
        transactionConfig: config,
        keyPair: keyPair,
        networkId: networkId,
        roles: roles,
        changeAddress: changeAddress,
        rewardAddresses: rewardAddresses,
        utxos: utxos,
      );

      return await registrationBuilder.build();
    } on RegistrationException {
      rethrow;
    } catch (error) {
      throw const RegistrationUnknownException();
    }
  }

  @override
  Future<Account> register({
    required CardanoWallet wallet,
    required Transaction unsignedTx,
    required Set<AccountRole> roles,
    required LockFactor lockFactor,
    required Ed25519KeyPair keyPair,
  }) async {
    try {
      final enabledWallet = await wallet.enable();
      final witnessSet = await enabledWallet.signTx(transaction: unsignedTx);

      final signedTx = Transaction(
        body: unsignedTx.body,
        isValid: true,
        witnessSet: witnessSet,
        auxiliaryData: unsignedTx.auxiliaryData,
      );

      final txHash = await enabledWallet.submitTx(transaction: signedTx);

      _logger.info('Registration transaction submitted [$txHash]');

      final keychainId = const Uuid().v4();
      final keychain = await _keychainProvider.create(keychainId);
      await keychain.setLock(lockFactor);
      await keychain.unlock(lockFactor);
      await keychain.setMasterKey(keyPair.privateKey);

      final balance = await enabledWallet.getBalance();
      final address = await enabledWallet.getChangeAddress();

      return Account(
        keychainId: keychainId,
        roles: roles,
        walletInfo: WalletInfo(
          metadata: WalletMetadata.fromCardanoWallet(wallet),
          balance: balance.coin,
          address: address,
        ),
      );
    } on RegistrationException {
      rethrow;
    } catch (error) {
      throw const RegistrationTransactionException();
    }
  }

  @override
  Future<Account> registerTestAccount({
    required String keychainId,
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  }) async {
    final roles = {AccountRole.root};
    // TODO(dtscalac): Update key value when derivation is final.
    final keyPair = await deriveAccountRoleKeyPair(
      seedPhrase: seedPhrase,
      roles: roles,
    );

    final keychain = await _keychainProvider.create(keychainId);
    await keychain.setLock(lockFactor);
    await keychain.unlock(lockFactor);
    await keychain.setMasterKey(keyPair.privateKey);

    return Account(
      keychainId: keychainId,
      roles: roles,
      walletInfo: WalletInfo(
        metadata: const WalletMetadata(name: 'Dummy Wallet'),
        balance: Coin.fromAda(10),
        address: _testNetAddress,
      ),
    );
  }
}
