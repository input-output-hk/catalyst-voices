import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/registration/registration_transaction_role.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid_plus/uuid_plus.dart';

final _logger = Logger('RegistrationService');

// TODO(damian-molinski): Merge it with UserService
abstract interface class RegistrationService {
  factory RegistrationService(
    UserService userService,
    BlockchainService blockchainService,
    KeychainProvider keychainProvider,
    CatalystCardano cardano,
    AuthTokenGenerator authTokenGenerator,
    KeyDerivationService keyDerivationService,
    BlockchainConfig blockchainConfig,
  ) = RegistrationServiceImpl;

  /// For testing only. Low level function with max control over [Account] creation.
  @visibleForTesting
  Future<Account> createAccount({
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
    String? email,
    String? username,
    String? keychainId,
    Set<AccountRole>? roles,
    ShelleyAddress? address,
    AccountPublicStatus? publicStatus,
    bool isActive,
    bool unlocked,
    AccountRegistrationStatus registrationStatus,
  });

  /// Creates a dummy [Account] using [Account.dummySeedPhrase] and other
  /// dummy properties.
  Future<Account> createDummyAccount();

  /// Creates new unlocked [Keychain] and populates it with master key from
  /// [seedPhrase].
  Future<Keychain> createKeychain({
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  });

  /// Returns the details of a [wallet].
  ///
  /// This will trigger a permission popup from the wallet extension.
  /// Afterwards the user must grant a permission inside the wallet extension.
  Future<WalletInfo> getCardanoWalletInfo(CardanoWallet wallet);

  /// Returns the available cardano wallet extensions.
  Future<List<CardanoWallet>> getCardanoWallets();

  /// Tries to find keychain with matching [id] and return it.
  ///
  /// Throws error if not found.
  Future<Keychain> getKeychain(String id);

  /// Loads the wallet balance for given [address].
  Future<Coin> getWalletBalance({
    required SeedPhrase seedPhrase,
    required ShelleyAddress address,
  });

  /// Builds an unsigned registration transaction from given parameters.
  ///
  /// Throws a subclass of [RegistrationException] in case of a failure.
  Future<BaseTransaction> prepareRegistration({
    required CardanoWallet wallet,
    required Keychain keychain,
    required Set<RegistrationTransactionRole> roles,
  });

  /// Loads account related to this [seedPhrase]. Throws exception if not found.
  Future<Account> recoverAccount({
    required SeedPhrase seedPhrase,
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
    required AccountSubmitFullData data,
  });

  /// Sends [unsignedTx] via [wallet] in to the blockchain.
  Future<WalletInfo> submitTransaction({
    required CardanoWallet wallet,
    required BaseTransaction unsignedTx,
  });
}

/// Manages the user registration.
final class RegistrationServiceImpl implements RegistrationService {
  final UserService _userService;
  final BlockchainService _blockchainService;
  final KeychainProvider _keychainProvider;
  final CatalystCardano _cardano;
  final AuthTokenGenerator _authTokenGenerator;
  final KeyDerivationService _keyDerivationService;
  final BlockchainConfig _blockchainConfig;

  const RegistrationServiceImpl(
    this._userService,
    this._blockchainService,
    this._keychainProvider,
    this._cardano,
    this._authTokenGenerator,
    this._keyDerivationService,
    this._blockchainConfig,
  );

  @override
  @visibleForTesting
  Future<Account> createAccount({
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
    String? email,
    String? username,
    String? keychainId,
    Set<AccountRole>? roles,
    ShelleyAddress? address,
    AccountPublicStatus? publicStatus,
    bool isActive = false,
    bool unlocked = true,
    AccountRegistrationStatus registrationStatus = const AccountRegistrationStatus.indexed(
      isPersistent: true,
    ),
  }) async {
    return _keyDerivationService.deriveMasterKey(seedPhrase: seedPhrase).use((masterKey) async {
      final keychain = await _keychainProvider.create(keychainId ?? const Uuid().v4());
      await keychain.setLock(lockFactor);
      await keychain.unlock(lockFactor);
      await keychain.setMasterKey(masterKey);

      if (!unlocked) {
        await keychain.lock();
      }

      final keyPair = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: AccountRole.root,
      );

      return keyPair.use((keyPair) {
        final role0key = keyPair.publicKey;

        final catalystId = CatalystId(
          host: _blockchainConfig.host.host,
          username: username,
          role0Key: role0key.publicKeyBytes,
        );

        return Account(
          catalystId: catalystId,
          email: email,
          keychain: keychain,
          roles: roles ?? {AccountRole.voter, AccountRole.proposer},
          address: address,
          publicStatus: publicStatus ?? AccountPublicStatus.notSetup,
          isActive: isActive,
          registrationStatus: registrationStatus,
        );
      });
    });
  }

  @override
  Future<Account> createDummyAccount() {
    return createAccount(
      seedPhrase: Account.dummySeedPhrase,
      lockFactor: Account.dummyUnlockFactor,
      keychainId: Account.dummyKeychainId,
      address: Account.dummyTestNetAddress,
    );
  }

  @override
  Future<Keychain> createKeychain({
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  }) async {
    final masterKey = await _keyDerivationService.deriveMasterKey(
      seedPhrase: seedPhrase,
    );

    final keychainId = const Uuid().v4();
    final keychain = await _keychainProvider.create(keychainId);
    await keychain.setLock(lockFactor);
    await keychain.unlock(lockFactor);
    await keychain.setMasterKey(masterKey);

    return keychain;
  }

  @override
  Future<WalletInfo> getCardanoWalletInfo(CardanoWallet wallet) async {
    final enabledWallet = await wallet.enable();
    final balance = await enabledWallet.getBalance();
    final addresses = await enabledWallet.getRewardAddresses();

    return WalletInfo(
      metadata: WalletMetadata.fromCardanoWallet(wallet),
      balance: balance.coin,
      address: addresses.first,
    );
  }

  @override
  Future<List<CardanoWallet>> getCardanoWallets() {
    return _cardano.getWallets();
  }

  @override
  Future<Keychain> getKeychain(String id) async {
    final exists = await _keychainProvider.exists(id);

    if (!exists) {
      throw const RegistrationRecoverKeychainNotFoundException();
    }

    return _keychainProvider.get(id);
  }

  @override
  Future<Coin> getWalletBalance({
    required SeedPhrase seedPhrase,
    required ShelleyAddress address,
  }) async {
    final rbacToken = await _deriveRbacToken(seedPhrase);

    return _blockchainService.getWalletBalance(
      stakeAddress: address,
      networkId: _blockchainConfig.networkId,
      rbacToken: rbacToken,
    );
  }

  @override
  Future<BaseTransaction> prepareRegistration({
    required CardanoWallet wallet,
    required Keychain keychain,
    required Set<RegistrationTransactionRole> roles,
  }) async {
    final config = _blockchainConfig.transactionBuilderConfig;
    final enabledWallet = await wallet.enable();
    final walletNetworkId = await enabledWallet.getNetworkId();
    if (walletNetworkId != _blockchainConfig.networkId) {
      throw RegistrationNetworkIdMismatchException(
        targetNetworkId: _blockchainConfig.networkId,
      );
    }

    final changeAddress = await enabledWallet.getChangeAddress();
    final rewardAddresses = await enabledWallet.getRewardAddresses();
    final utxos = await enabledWallet.getUtxos();

    final slotNumber = await _getRegistrationSlotNumberTtl();

    final previousTransactionId = await _fetchPreviousTransactionId(
      isFirstRegistration: roles.isFirstRegistration,
    );

    final registrationBuilder = RegistrationTransactionBuilder(
      transactionConfig: config,
      keychain: keychain,
      networkId: _blockchainConfig.networkId,
      slotNumberTtl: slotNumber,
      roles: roles,
      changeAddress: changeAddress,
      rewardAddresses: rewardAddresses,
      utxos: utxos,
      previousTransactionId: previousTransactionId,
    );

    return registrationBuilder.build();
  }

  @override
  Future<Account> recoverAccount({
    required SeedPhrase seedPhrase,
  }) async {
    final masterKey = _keyDerivationService.deriveMasterKey(
      seedPhrase: seedPhrase,
    );

    return masterKey.use((masterKey) async {
      final role0Key = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: AccountRole.root,
      );

      return role0Key.use((role0Key) async {
        final catalystId = CatalystId(
          host: _blockchainConfig.host.host,
          role0Key: role0Key.publicKey.publicKeyBytes,
        );

        final rbacToken = await _authTokenGenerator.generate(
          masterKey: masterKey,
          catalystId: catalystId,
        );

        final recoverable = await _userService.getRecoverableAccount(
          catalystId: catalystId,
          rbacToken: rbacToken,
        );

        final keychainId = const Uuid().v4();
        final keychain = await _keychainProvider.create(keychainId);

        final registrationStatus = AccountRegistrationStatus.indexed(
          isPersistent: recoverable.isPersistent,
        );

        return Account(
          catalystId: catalystId.copyWith(
            username: Optional(recoverable.username),
          ),
          email: recoverable.email,
          keychain: keychain,
          roles: recoverable.roles,
          address: recoverable.stakeAddress,
          publicStatus: recoverable.publicStatus,
          registrationStatus: registrationStatus,
        );
      });
    });
  }

  @override
  Future<Account> register({
    required AccountSubmitFullData data,
  }) async {
    final walletInfo = await submitTransaction(
      wallet: data.metadata.wallet,
      unsignedTx: data.metadata.transaction,
    );

    final keychain = data.keychain;
    return keychain.getMasterKey().use((masterKey) {
      final role0KeyPair = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: AccountRole.root,
      );

      return role0KeyPair.use((keyPair) {
        final role0key = keyPair.publicKey;

        final catalystId = CatalystId(
          host: _blockchainConfig.host.host,
          username: data.username,
          role0Key: role0key.publicKeyBytes,
        );

        return Account(
          catalystId: catalystId,
          email: data.email,
          keychain: keychain,
          roles: data.roles,
          address: walletInfo.address,
          publicStatus: data.email != null
              ? AccountPublicStatus.verifying
              : AccountPublicStatus.notSetup,
          registrationStatus: const AccountRegistrationStatus.notIndexed(),
        );
      });
    });
  }

  @override
  Future<WalletInfo> submitTransaction({
    required CardanoWallet wallet,
    required BaseTransaction unsignedTx,
  }) async {
    final enabledWallet = await wallet.enable();
    final walletNetworkId = await enabledWallet.getNetworkId();
    final targetNetworkId = unsignedTx.networkId;

    if (targetNetworkId != null && walletNetworkId != targetNetworkId) {
      throw RegistrationNetworkIdMismatchException(
        targetNetworkId: targetNetworkId,
      );
    }

    final witnessSet = await enabledWallet.signTx(transaction: unsignedTx);

    final signedTx = unsignedTx.withWitnessSet(witnessSet);

    final txHash = await enabledWallet.submitTx(transaction: signedTx);

    _logger.info('Registration transaction submitted [$txHash]');

    final balance = await enabledWallet.getBalance();
    final addresses = await enabledWallet.getRewardAddresses();

    return WalletInfo(
      metadata: WalletMetadata.fromCardanoWallet(wallet),
      balance: balance.coin,
      address: addresses.first,
    );
  }

  Future<RbacToken> _deriveRbacToken(SeedPhrase seedPhrase) {
    final masterKey = _keyDerivationService.deriveMasterKey(
      seedPhrase: seedPhrase,
    );

    return masterKey.use((masterKey) async {
      final role0Key = _keyDerivationService.deriveAccountRoleKeyPair(
        masterKey: masterKey,
        role: AccountRole.root,
      );

      return role0Key.use((role0Key) async {
        final catalystId = CatalystId(
          host: _blockchainConfig.host.host,
          role0Key: role0Key.publicKey.publicKeyBytes,
        );

        return _authTokenGenerator.generate(
          masterKey: masterKey,
          catalystId: catalystId,
        );
      });
    });
  }

  Future<TransactionHash?> _fetchPreviousTransactionId({
    required bool isFirstRegistration,
  }) async {
    if (isFirstRegistration) {
      // for first registration there is no previous transaction id
      return null;
    }

    return _userService.getPreviousRegistrationTransactionId();
  }

  /// The timestamp when a registration transaction expires.
  ///
  /// If transaction is generated and signed but never expires
  /// then anybody could submit it at any time, even without
  /// the knowledge of the wallet owner.
  ///
  /// It's a common security practice to configure transactions
  /// to expire after a certain duration.
  Future<SlotBigNum> _getRegistrationSlotNumberTtl() async {
    final registrationTransactionExpiration = DateTimeExt.now().add(const Duration(hours: 3));

    final config = _blockchainConfig.slotNumberConfig;

    return _blockchainService.calculateSlotNumber(
      targetDateTime: registrationTransactionExpiration,
      config: config,
    );
  }
}
