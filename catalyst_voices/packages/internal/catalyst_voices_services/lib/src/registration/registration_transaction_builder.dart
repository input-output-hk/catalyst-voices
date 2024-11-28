import 'dart:math';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

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

  /// The key pair used to sign the user registration certificate.
  final Bip32Ed25519XKeyPair keyPair;

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

  const RegistrationTransactionBuilder({
    required this.transactionConfig,
    required this.keyPair,
    required this.networkId,
    required this.roles,
    required this.changeAddress,
    required this.rewardAddresses,
    required this.utxos,
  });

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
    final cert = await _generateX509Certificate(keyPair: keyPair);
    final derCert = cert.toDer();

    final x509Envelope = X509MetadataEnvelope.unsigned(
      purpose: UuidV4.fromString(_catalystUserRoleRegistrationPurpose),
      txInputsHash: TransactionInputsHash.fromTransactionInputs(utxos),
      chunkedData: RegistrationData(
        derCerts: [derCert],
        publicKeys: [keyPair.publicKey],
        roleDataSet: {
          // TODO(dtscalac): currently we only support the voter account role,
          // regardless of selected roles
          // TODO(dtscalac): when RBAC specification will define other roles
          // they should be registered here
          RoleData(
            roleNumber: AccountRole.root.roleNumber,
            roleSigningKey: const LocalKeyReference(
              keyType: LocalKeyReferenceType.x509Certs,
              offset: 0,
            ),
            // Refer to first key in transaction outputs,
            // in our case it's the change address (which the user controls).
            paymentKey: -1,
          ),
        },
      ),
    );

    return x509Envelope.sign(
      privateKey: keyPair.privateKey,
      serializer: (e) => e.toCbor(),
    );
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

  Future<X509Certificate> _generateX509Certificate({
    required Bip32Ed25519XKeyPair keyPair,
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
      subjectPublicKey: keyPair.publicKey,
      issuer: issuer,
      validityNotBefore: DateTime.now().toUtc(),
      validityNotAfter: X509TBSCertificate.foreverValid,
      subject: issuer,
      extensions: X509CertificateExtensions(
        subjectAltName: [
          'web+cardano://addr/${_stakeAddress.toBech32()}',
        ],
      ),
    );
    /* cSpell:enable */

    return X509Certificate.generateSelfSigned(
      tbsCertificate: tbs,
      privateKey: keyPair.privateKey,
    );
  }

  ShelleyAddress get _stakeAddress => rewardAddresses.first;
}
