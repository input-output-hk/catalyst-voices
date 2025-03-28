import 'dart:math';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart'
    hide Ed25519PublicKey;
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart'
as cs showhide Ed25519PublicKey;
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:collection/collection.dart';

/// The transaction metadata used for registration.
typedef RegistrationMetadata = X509MetadataEnvelope<RegistrationData>;

/// A builder that builds a Catalyst user registration transaction
/// using RBAC specification.
final class RegistrationTransactionBuilder {
  /// The RBAC registration purpose for the Catalyst Project.
  static const _catalystUserRoleRegistrationPurpose =
      'ca7a1457-ef9f-4c7f-9c74-7f8c4a4cfa6c';

  /// The transaction config with current network parameters.
  final TransactionBuilderConfig transactionConfig;

  /// The algorithm for deriving keys.
  final KeyDerivationService keyDerivationService;

  /// The master key derived from the seed phrase.
  final CatalystPrivateKey masterKey;

  /// The network ID where the transaction will be submitted.
  final NetworkId networkId;

  /// The user selected roles for which the user is registering.
  final Set<AccountRole> roles;

  /// The change address where the change from the transaction should go.
  final ShelleyAddress changeAddress;

  /// The list of user-related stake addresses.
  ///
  /// The first one will be used to as subjectAltName
  /// in the certificate for the registration.
  final List<ShelleyAddress> rewardAddresses;

  /// The UTXOs that will be used as inputs for the transaction.
  final Set<TransactionUnspentOutput> utxos;

  RegistrationTransactionBuilder({
    required this.transactionConfig,
    required this.keyDerivationService,
    required this.masterKey,
    required this.networkId,
    required this.roles,
    required this.changeAddress,
    required this.rewardAddresses,
    required this.utxos,
  }) : assert(
          masterKey.algorithm == CatalystSignatureAlgorithm.ed25519,
          'RegistrationTransaction requires Ed25519 signatures',
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
    final rootKeyPair = keyDerivationService.deriveAccountRoleKeyPair(
      masterKey: masterKey,
      role: AccountRole.root,
    );

    return rootKeyPair.use((rootKeyPair) async {
      final derCert = await _generateX509Certificate(keyPair: rootKeyPair);
      final publicKeys = await _generatePublicKeysForAllRoles(rootKeyPair);

      final x509Envelope = X509MetadataEnvelope.unsigned(
        purpose: UuidV4.fromString(_catalystUserRoleRegistrationPurpose),
        txInputsHash: TransactionInputsHash.fromTransactionInputs(utxos),
        chunkedData: RegistrationData(
          derCerts: [RbacField.set(derCert)],
          publicKeys: publicKeys,
          roleDataSet: {
            if (roles.contains(AccountRole.voter))
              RoleData(
                roleNumber: AccountRole.root.number,
                roleSigningKey: LocalKeyReference(
                  keyType: LocalKeyReferenceType.x509Certs,
                  offset: AccountRole.root.registrationOffset,
                ),
                // Refer to first key in transaction outputs,
                // in our case it's the change address (which the user controls).
                paymentKey: -1,
              ),
            if (roles.contains(AccountRole.proposer))
              RoleData(
                roleNumber: AccountRole.proposer.number,
                roleSigningKey: LocalKeyReference(
                  keyType: LocalKeyReferenceType.pubKeys,
                  offset: AccountRole.proposer.registrationOffset,
                ),
                // Refer to first key in transaction outputs, in our case
                // it's the change address (which the user controls).
                paymentKey: -1,
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

  Transaction _buildUnsignedRbacTx({required AuxiliaryData auxiliaryData}) {
    final txBuilder = TransactionBuilder(
      requiredSigners: {
        _stakeAddress.publicKeyHash,
      },
      config: transactionConfig,
      inputs: utxos,
      networkId: networkId,
      auxiliaryData: auxiliaryData,
      witnessBuilder: const TransactionWitnessSetBuilder(
        vkeys: {},
        vkeysCount: 2,
      ),
    );

    final txBody =
        txBuilder.withChangeAddressIfNeeded(changeAddress).buildBody();

    return Transaction(
      body: txBody,
      isValid: true,
      witnessSet: const TransactionWitnessSet(),
      auxiliaryData: auxiliaryData,
    );
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
    switch (role) {
      case AccountRole.voter:
        if (roles.contains(AccountRole.voter)) {
          return RbacField.set(rootKeyPair.publicKey.toEd25519());
        } else {
          return const RbacField.undefined();
        }
      case AccountRole.drep:
        return const RbacField.undefined();
      case AccountRole.proposer:
        if (roles.contains(AccountRole.proposer)) {
          return RbacField.set(await _deriveProposerPublicKey());
        } else {
          return const RbacField.undefined();
        }
      case null:
        return const RbacField.undefined();
    }
  }

  Future<List<RbacField<cs.Ed25519PublicKey>>> _generatePublicKeysForAllRoles(
    CatalystKeyPair rootKeyPair,
  ) async {
    final maxOffset = AccountRole.values.map((e) => e.registrationOffset).max;
    return [
      for (int i = 0; i <= maxOffset; i++)
        await _generatePublicKeyForOffset(i, rootKeyPair),
    ];
  }

  Future<X509DerCertificate> _generateX509Certificate({
    required CatalystKeyPair keyPair,
  }) async {
    // TODO(dtscalac): once serial number generation is defined come up with
    // a better solution than assigning a random number
    // as certificate serial number
    const maxInt = 4294967296;

    // TODO(dtscalac): define the issuer, since the cert is self signed this
    // should represent the user that is about to register

    /* cSpell:disable */
    const issuer = X509DistinguishedName(
      countryName: '',
      stateOrProvinceName: '',
      localityName: '',
      organizationName: '',
      organizationalUnitName: '',
      commonName: '',
    );

    final tbs = X509TBSCertificate(
      serialNumber: Random().nextInt(maxInt),
      subjectPublicKey: Bip32Ed25519XPublicKeyFactory.instance.fromBytes(
        keyPair.publicKey.bytes,
      ),
      issuer: issuer,
      validityNotBefore: DateTime.now().toUtc(),
      validityNotAfter: X509TBSCertificate.foreverValid,
      subject: issuer,
      extensions: X509CertificateExtensions(
        subjectAltName: [
          X509String(
            'web+cardano://addr/${_stakeAddress.toBech32()}',
            tag: X509String.uriTag,
          ),
        ],
      ),
    );
    /* cSpell:enable */

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
}

extension on CatalystPublicKey {
  cs.Ed25519PublicKey toEd25519() {
    final publicKey = Bip32Ed25519XPublicKeyFactory.instance
        .fromBytes(bytes)
        .toPublicKey()
        .bytes;

    return cs.Ed25519PublicKey.fromBytes(publicKey);
  }
}
