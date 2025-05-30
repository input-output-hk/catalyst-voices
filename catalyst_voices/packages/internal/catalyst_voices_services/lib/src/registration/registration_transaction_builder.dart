import 'dart:math';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart' as cs
    show Ed25519PublicKey;
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart'
    hide Ed25519PublicKey;
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:catalyst_voices_services/src/registration/registration_transaction_role.dart';
import 'package:collection/collection.dart';

/// The transaction metadata used for registration.
typedef RegistrationMetadata = X509MetadataEnvelope<RegistrationData>;

/// A builder that builds a Catalyst user registration transaction
/// using RBAC specification.
final class RegistrationTransactionBuilder {
  /// The RBAC registration purpose for the Catalyst Project.
  static const _catalystUserRoleRegistrationPurpose = 'ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c';

  /// The transaction config with current network parameters.
  final TransactionBuilderConfig transactionConfig;

  /// The algorithm for deriving keys.
  final KeyDerivationService keyDerivationService;

  /// The master key derived from the seed phrase.
  final CatalystPrivateKey masterKey;

  /// The network ID where the transaction will be submitted.
  final NetworkId networkId;

  /// The ttl slot number after which the transaction is invalid.
  final SlotBigNum slotNumberTtl;

  /// The user selected roles for which the user is registering.
  final Set<RegistrationTransactionRole> roles;

  /// The change address where the change from the transaction should go.
  final ShelleyAddress changeAddress;

  /// The list of user-related stake addresses.
  ///
  /// The first one will be used to as subjectAltName
  /// in the certificate for the registration.
  final List<ShelleyAddress> rewardAddresses;

  /// The UTXOs that will be used as inputs for the transaction.
  final Set<TransactionUnspentOutput> utxos;

  /// If updating a registration the new registration must be
  /// linked via the transaction hash to the last one.
  final TransactionHash? previousTransactionId;

  RegistrationTransactionBuilder({
    required this.transactionConfig,
    required this.keyDerivationService,
    required this.masterKey,
    required this.networkId,
    required this.slotNumberTtl,
    required this.roles,
    required this.changeAddress,
    required this.rewardAddresses,
    required this.utxos,
    required this.previousTransactionId,
  })  : assert(
          masterKey.algorithm == CatalystSignatureAlgorithm.ed25519,
          'RegistrationTransaction requires Ed25519 signatures',
        ),
        assert(
          roles.isFirstRegistration || previousTransactionId != null,
          "When it's not a first registration then "
          'previousTransactionId must be provided',
        );

  ShelleyAddress get _stakeAddress => rewardAddresses.first;

  /// Builds the unsigned registration transaction.
  ///
  /// Throws [RegistrationInsufficientBalanceException] in case the
  /// user doesn't have enough balance to pay for the registration transaction.
  Future<Transaction> build() async {
    if (utxos.isEmpty) {
      throw const RegistrationInsufficientBalanceException();
    }

    final x509Envelope = await _buildMetadataEnvelope();

    return _buildUnsignedRbacTx(
      auxiliaryData: AuxiliaryData.fromCbor(
        await x509Envelope.toCbor(serializer: (e) => e.toCbor()),
      ),
    );
  }

  Future<RegistrationMetadata> _buildMetadataEnvelope() async {
    if (!roles.isFirstRegistration && previousTransactionId == null) {
      throw ArgumentError.notNull('previousTransactionId');
    }

    final rootKeyPair = keyDerivationService.deriveAccountRoleKeyPair(
      masterKey: masterKey,
      role: AccountRole.root,
    );

    return rootKeyPair.use((rootKeyPair) async {
      final derCert =
          roles.isFirstRegistration ? await _generateX509Certificate(keyPair: rootKeyPair) : null;
      final publicKeys = await _generatePublicKeysForAllRoles(rootKeyPair);

      final x509Envelope = X509MetadataEnvelope.unsigned(
        purpose: UuidV4.fromString(_catalystUserRoleRegistrationPurpose),
        txInputsHash: TransactionInputsHash.fromTransactionInputs(utxos),
        previousTransactionId: roles.isFirstRegistration ? null : previousTransactionId!,
        chunkedData: RegistrationData(
          derCerts: [
            if (derCert != null) RbacField.set(derCert),
          ],
          publicKeys: publicKeys,
          roleDataSet: {
            if (roles.any((element) => element.setVoter))
              RoleData(
                roleNumber: AccountRole.root.number,
                roleSigningKey: LocalKeyReference(
                  keyType: LocalKeyReferenceType.x509Certs,
                  offset: AccountRole.root.registrationOffset,
                ),
                // Refer to first key in transaction outputs,
                // in our case it's the change address
                // (which the user controls).
                paymentKey: 0,
              ),
            if (roles.any((element) => element.setProposer))
              RoleData(
                roleNumber: AccountRole.proposer.number,
                roleSigningKey: LocalKeyReference(
                  keyType: LocalKeyReferenceType.pubKeys,
                  offset: AccountRole.proposer.registrationOffset,
                ),
                // Refer to first key in transaction outputs, in our case
                // it's the change address (which the user controls).
                paymentKey: 0,
              ),
          },
        ),
      );

      final privateKey = Bip32Ed25519XPrivateKeyFactory.instance.fromBytes(
        rootKeyPair.privateKey.bytes,
      );

      return privateKey.use((privateKey) {
        return x509Envelope.sign(
          privateKey: privateKey,
          serializer: (e) => e.toCbor(),
        );
      });
    });
  }

  Future<cs.Ed25519PublicKey> _buildRolePublicKey(
    AccountRole role, {
    required CatalystKeyPair rootKeyPair,
  }) async {
    return switch (role) {
      AccountRole.voter => rootKeyPair.publicKey.toEd25519(),
      AccountRole.drep => await _deriveDrepPublicKey(),
      AccountRole.proposer => await _deriveProposerPublicKey(),
    };
  }

  Transaction _buildUnsignedRbacTx({required AuxiliaryData auxiliaryData}) {
    final txBuilder = TransactionBuilder(
      requiredSigners: {
        _stakeAddress.publicKeyHash,
      },
      config: transactionConfig,
      inputs: utxos,
      networkId: networkId,
      ttl: slotNumberTtl,
      auxiliaryData: auxiliaryData,
      witnessBuilder: const TransactionWitnessSetBuilder(
        vkeys: {},
        vkeysCount: 2,
      ),
      changeAddress: changeAddress,
    );

    // coin selection to minimize UTXOs
    final optimizedBuilder = txBuilder.applySelection();
    final txBody = optimizedBuilder.buildBody();

    return Transaction(
      body: txBody,
      isValid: true,
      witnessSet: const TransactionWitnessSet(),
      auxiliaryData: auxiliaryData,
    );
  }

  Future<cs.Ed25519PublicKey> _deriveDrepPublicKey() {
    final keyPair = keyDerivationService.deriveAccountRoleKeyPair(
      masterKey: masterKey,
      role: AccountRole.drep,
    );

    return keyPair.use((keyPair) => keyPair.publicKey.toEd25519());
  }

  Future<cs.Ed25519PublicKey> _deriveProposerPublicKey() {
    final keyPair = keyDerivationService.deriveAccountRoleKeyPair(
      masterKey: masterKey,
      role: AccountRole.proposer,
    );

    return keyPair.use((keyPair) => keyPair.publicKey.toEd25519());
  }

  Future<RbacField<cs.Ed25519PublicKey>> _generatePublicKeyForOffset(
    int registrationOffset,
    CatalystKeyPair rootKeyPair,
  ) async {
    final role = AccountRole.fromRegistrationOffset(registrationOffset);
    if (role == null) {
      return const RbacField.undefined();
    }

    final roleAction = _getPublicKeyRoleAction(role);
    switch (roleAction) {
      case RegistrationTransactionRoleAction.set:
        final publicKey = await _buildRolePublicKey(
          role,
          rootKeyPair: rootKeyPair,
        );
        return RbacField.set(publicKey);
      case RegistrationTransactionRoleAction.undefined:
        return const RbacField.undefined();
      case RegistrationTransactionRoleAction.unset:
        return const RbacField.unset();
    }
  }

  Future<List<RbacField<cs.Ed25519PublicKey>>> _generatePublicKeysForAllRoles(
    CatalystKeyPair rootKeyPair,
  ) async {
    final maxOffset = AccountRole.values.map((e) => e.registrationOffset).max;
    return [
      for (int i = 0; i <= maxOffset; i++) await _generatePublicKeyForOffset(i, rootKeyPair),
    ];
  }

  Future<X509DerCertificate> _generateX509Certificate({
    required CatalystKeyPair keyPair,
  }) async {
    const issuer = X509DistinguishedName();

    final tbs = X509TBSCertificate(
      serialNumber: _randomSerialNumber(),
      subjectPublicKey: keyPair.publicKey.toEd25519(),
      issuer: issuer,
      validityNotBefore: DateTime.now().toUtc(),
      validityNotAfter: X509TBSCertificate.foreverValid,
      subject: issuer,
      extensions: X509CertificateExtensions(
        subjectAltName: [
          X509String(
            CardanoAddressUri(_stakeAddress).toString(),
            tag: X509String.uriTag,
          ),
        ],
      ),
    );

    final privateKey = Bip32Ed25519XPrivateKeyFactory.instance.fromBytes(
      keyPair.privateKey.bytes,
    );

    final cert = await privateKey.use((privateKey) {
      return X509Certificate.generateSelfSigned(
        tbsCertificate: tbs,
        privateKey: privateKey,
      );
    });

    return cert.toDer();
  }

  RegistrationTransactionRoleAction _getPublicKeyRoleAction(AccountRole role) {
    if (role == AccountRole.voter) {
      // Voters must not register their own public keys,
      // they are only allowed to use der certs.
      return RegistrationTransactionRoleAction.undefined;
    }

    return roles
        .singleWhere(
          (element) => element.type == role,
          orElse: () => RegistrationTransactionRole.undefined(role),
        )
        .action;
  }

  int _randomSerialNumber() {
    const maxInt = 4294967296;
    return Random().nextInt(maxInt);
  }
}

extension on CatalystPublicKey {
  cs.Ed25519PublicKey toEd25519() {
    final publicKey = Bip32Ed25519XPublicKeyFactory.instance.fromBytes(bytes).toPublicKey().bytes;

    return cs.Ed25519PublicKey.fromBytes(publicKey);
  }
}
