import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/registration/registration_transaction_role.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:uuid_plus/uuid_plus.dart';

final _logger = Logger('RegistrationService');

/* cSpell:disable */
final _testNetAddress = ShelleyAddress.fromBech32(
  'addr_test1vzpwq95z3xyum8vqndgdd'
  '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
);
/* cSpell:enable */

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
    required CatalystPrivateKey masterKey,
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

  Future<Account> registerTestAccount({
    required String keychainId,
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
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
    required CatalystPrivateKey masterKey,
    required Set<RegistrationTransactionRole> roles,
  }) async {
    try {
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
        keyDerivationService: _keyDerivationService,
        masterKey: masterKey,
        networkId: _blockchainConfig.networkId,
        slotNumberTtl: slotNumber,
        roles: roles,
        changeAddress: changeAddress,
        rewardAddresses: rewardAddresses,
        utxos: utxos,
        previousTransactionId: previousTransactionId,
      );

      return await registrationBuilder.build();
    } on RegistrationException {
      rethrow;
    } catch (error, stackTrace) {
      _logger.severe('Registration error', error, stackTrace);
      throw const RegistrationUnknownException();
    }
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

        final recovered = await _userService.recoverAccount(
          catalystId: catalystId,
          rbacToken: rbacToken,
        );

        final keychainId = const Uuid().v4();
        final keychain = await _keychainProvider.create(keychainId);

        return Account(
          catalystId: catalystId.copyWith(
            username: Optional(recovered.username),
          ),
          email: recovered.email,
          keychain: keychain,
          roles: recovered.roles,
          address: recovered.stakeAddress,
          publicStatus: recovered.publicStatus,
        );
      });
    });
  }

  @override
  Future<Account> register({
    required AccountSubmitFullData data,
  }) async {
    try {
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
            publicStatus:
                data.email != null ? AccountPublicStatus.verifying : AccountPublicStatus.notSetup,
          );
        });
      });
    } on RegistrationException {
      rethrow;
    } catch (error, stackTrace) {
      _logger.severe('RegistrationTransaction: ', error, stackTrace);
      throw const RegistrationTransactionException();
    }
  }

  @override
  Future<Account> registerTestAccount({
    required String keychainId,
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  }) async {
    final roles = {AccountRole.voter, AccountRole.proposer};
    final masterKey = await _keyDerivationService.deriveMasterKey(
      seedPhrase: seedPhrase,
    );

    final keychain = await _keychainProvider.create(keychainId);
    await keychain.setLock(lockFactor);
    await keychain.unlock(lockFactor);
    await keychain.setMasterKey(masterKey);

    final keyPair = _keyDerivationService.deriveAccountRoleKeyPair(
      masterKey: masterKey,
      role: AccountRole.root,
    );

    return keyPair.use((keyPair) {
      final role0key = keyPair.publicKey;

      final catalystId = CatalystId(
        host: _blockchainConfig.host.host,
        username: 'Dummy',
        role0Key: role0key.publicKeyBytes,
      );

      return Account(
        catalystId: catalystId,
        keychain: keychain,
        roles: roles,
        address: _testNetAddress,
        publicStatus: AccountPublicStatus.notSetup,
      );
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
