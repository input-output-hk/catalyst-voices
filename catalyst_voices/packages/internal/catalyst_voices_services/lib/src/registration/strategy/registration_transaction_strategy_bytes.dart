import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart'
    as cs
    show Ed25519PublicKey;
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/registration/registration_transaction_role.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy.dart';
import 'package:cbor/cbor.dart';
import 'package:flutter/foundation.dart';

@visibleForTesting
ValueGetter<RawTransaction>? testRegTxGetter;

@visibleForTesting
ValueGetter<RegistrationMetadata>? testRegTxMetadataGetter;

final class RegistrationTransactionStrategyBytes implements RegistrationTransactionStrategy {
  final TransactionBuilderConfig transactionConfig;
  final NetworkId networkId;
  final SlotBigNum slotNumberTtl;
  final Set<RegistrationTransactionRole> roles;
  final ShelleyAddress changeAddress;
  final Set<TransactionUnspentOutput> utxos;
  final TransactionHash? previousTransactionId;

  RegistrationTransactionStrategyBytes({
    required this.transactionConfig,
    required this.networkId,
    required this.slotNumberTtl,
    required this.roles,
    required this.changeAddress,
    required this.utxos,
    required this.previousTransactionId,
  });

  @override
  Future<RawTransaction> build({
    required String purpose,
    required CatalystKeyPair rootKeyPair,
    required X509DerCertificate? derCert,
    required List<RbacField<cs.Ed25519PublicKey>> publicKeys,
    required Set<Ed25519PublicKeyHash> requiredSigners,
  }) async {
    final dummyTxInputsHashBytes = List.filled(TransactionInputsHash.hashLength, 0);
    final dummyTxInputsHash = TransactionInputsHash.fromBytes(bytes: dummyTxInputsHashBytes);

    final unsignedMetadata = _buildUnsignedMetadata(
      purpose: purpose,
      txInputsHash: dummyTxInputsHash,
      derCert: derCert,
      publicKeys: publicKeys,
    );

    _validateMetadataCertFields(unsignedMetadata);

    final dummyMetadataCbor = await unsignedMetadata.toCbor(serializer: (e) => e.toCbor());
    final dummyAuxiliaryData = AuxiliaryData.fromCbor(dummyMetadataCbor);

    final txBuilder = TransactionBuilder(
      requiredSigners: requiredSigners,
      config: transactionConfig,
      inputs: utxos,
      networkId: networkId,
      ttl: slotNumberTtl,
      auxiliaryData: dummyAuxiliaryData,
      changeAddress: changeAddress,
    );

    final (selectedUtxos, changes, totalFee) = txBuilder.selectInputs(
      changeOutputStrategy: ChangeOutputAdaStrategy.mustInclude,
    );

    final txBody = txBuilder
        .copyWith(
          inputs: selectedUtxos,
          outputs: changes,
          fee: totalFee,
        )
        .buildBody();

    // Only one encoding here.
    var rawTx = RawTransaction.from(
      body: txBody,
      witnessSet: const TransactionWitnessSet(),
      isValid: true,
      auxiliaryData: dummyAuxiliaryData,
    );

    final txSizeBeforePatching = rawTx.bytes.length;
    final auxiliaryDataSizeBeforePatching = rawTx.auxiliaryData.length;

    // 1. txInputsHash
    final txInputsHash = TransactionInputsHash.blake2b(rawTx.inputs);
    rawTx.patchTxInputsHash(txInputsHash.bytes);

    // 2. signature
    final auxData = rawTx.auxiliaryData;
    final signature = await Bip32Ed25519XPrivateKeyFactory.instance
        .fromBytes(rootKeyPair.privateKey.bytes)
        .use((privateKey) => privateKey.sign(auxData));

    final isVerified = await Bip32Ed25519XPrivateKeyFactory.instance
        .fromBytes(rootKeyPair.privateKey.bytes)
        .use((privateKey) => privateKey.verify(auxData, signature: signature))
        .onError((_, __) => false);

    if (!isVerified) {
      throw const SignatureNotVerifiedException();
    }

    rawTx.patchSignature(signature.bytes);

    // 3. auxiliaryData
    final auxiliaryDataHash = AuxiliaryDataHash.blake2b(rawTx.auxiliaryData);
    rawTx.patchAuxiliaryDataHash(auxiliaryDataHash.bytes);

    if (testRegTxGetter != null) {
      rawTx = testRegTxGetter!();
    }

    // 4. validate
    _validateRawTxStructure(rawTx);
    _validateTransactionSize(rawTx, expectedSize: txSizeBeforePatching);
    _validateAuxiliaryDataSize(rawTx, expectedSize: auxiliaryDataSizeBeforePatching);
    _validateTransactionHasChangeOutputs(rawTx);
    _validateRequiredSigners(rawTx);

    return rawTx;
  }

  RegistrationMetadata _buildUnsignedMetadata({
    required String purpose,
    required TransactionInputsHash txInputsHash,
    required X509DerCertificate? derCert,
    required List<RbacField<cs.Ed25519PublicKey>> publicKeys,
  }) {
    if (testRegTxMetadataGetter != null) {
      return testRegTxMetadataGetter!();
    }

    if (!roles.isFirstRegistration && previousTransactionId == null) {
      throw ArgumentError.notNull('previousTransactionId');
    }

    return X509MetadataEnvelope.unsigned(
      purpose: UuidV4.fromString(purpose),
      txInputsHash: txInputsHash,
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
              // Refer to first key in transaction outputs, in our case
              // it's the change address (which the user controls).
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
          if (roles.any((element) => element.setDrep))
            RoleData(
              roleNumber: AccountRole.drep.number,
              roleSigningKey: LocalKeyReference(
                keyType: LocalKeyReferenceType.pubKeys,
                offset: AccountRole.drep.registrationOffset,
              ),
              // Refer to first key in transaction outputs, in our case
              // it's the change address (which the user controls).
              paymentKey: 0,
            ),
        },
      ),
    );
  }

  void _validateAuxiliaryDataSize(
    RawTransaction rawTx, {
    required int expectedSize,
  }) {
    final actualSize = rawTx.auxiliaryData.length;

    if (actualSize != expectedSize) {
      throw RawTransactionSizeChangedException(
        expectedSize: expectedSize,
        actualSize: actualSize,
        aspect: 'AuxiliaryData',
      );
    }
  }

  void _validateMetadataCertFields(RegistrationMetadata metadata) {
    final invalidationReasons = <String>[];
    if (roles.isFirstRegistration && (metadata.chunkedData?.derCerts ?? const []).isEmpty) {
      invalidationReasons.add('missing derCerts');
    }

    if (roles.isFirstRegistration && metadata.chunkedData?.publicKeys == null) {
      invalidationReasons.add('missing publicKeys is null');
    }

    if (roles.containsProposer && (metadata.chunkedData?.publicKeys ?? const []).isEmpty) {
      invalidationReasons.add('missing proposer publicKeys');
    }

    if (metadata.chunkedData?.roleDataSet == null) {
      invalidationReasons.add('missing roleDataSet');
    }

    if (invalidationReasons.isNotEmpty) {
      throw RegistrationTxCertValidationException(reasons: invalidationReasons);
    }
  }

  void _validateRawTxStructure(RawTransaction rawTx) {
    try {
      rawTx.validate();

      final bytes = rawTx.bytes;
      final cborValue = cbor.decode(bytes);
      Transaction.fromCbor(cborValue);
    } on FormatException catch (_) {
      throw const RawTransactionMalformedException();
    }
  }

  void _validateRequiredSigners(RawTransaction rawTx) {
    final outputsPublicKeysHashes = (cborDecode(rawTx.outputs) as CborList)
        .map(TransactionOutput.fromCbor)
        .map((e) => e.address.publicKeyHash)
        .toSet();

    final requiredSigners = (cborDecode(rawTx.requiredSigners) as CborList)
        .map(Ed25519PublicKeyHash.fromCbor)
        .toSet();

    final missingSigners = <Ed25519PublicKeyHash>[];

    for (final outputPublicKeyHash in outputsPublicKeysHashes) {
      if (!requiredSigners.contains(outputPublicKeyHash)) {
        missingSigners.add(outputPublicKeyHash);
      }
    }

    if (missingSigners.isNotEmpty) {
      throw OutputPublicKeyHashNotInRequiredSignerException(
        outputsPublicKeysHashes: outputsPublicKeysHashes,
        requiredSigners: requiredSigners,
      );
    }
  }

  void _validateTransactionHasChangeOutputs(RawTransaction rawTx) {
    final outputs = (cborDecode(rawTx.outputs) as CborList).map(TransactionOutput.fromCbor).toSet();

    final hasChangeOutputs = outputs.any((e) => e.address == changeAddress);
    if (!hasChangeOutputs) {
      throw const TransactionMissingChangeOutputsException();
    }
  }

  void _validateTransactionSize(
    RawTransaction rawTx, {
    required int expectedSize,
  }) {
    final actualSize = rawTx.bytes.length;

    if (actualSize != expectedSize) {
      throw RawTransactionSizeChangedException(
        expectedSize: expectedSize,
        actualSize: actualSize,
        aspect: 'Transaction',
      );
    }
  }
}
