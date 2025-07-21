import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart' as cs
    show Ed25519PublicKey;
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/registration/registration_transaction_role.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy.dart';
import 'package:cbor/cbor.dart';

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
      changeOutputStrategy: ChangeOutputAdaStrategy.noBurn,
    );

    final txBody = txBuilder
        .copyWith(
          inputs: selectedUtxos,
          outputs: changes,
          fee: totalFee,
        )
        .buildBody();

    // Only one encoding here.
    final rawTx = RawTransaction.from(
      body: txBody,
      witnessSet: const TransactionWitnessSet(),
      isValid: true,
      auxiliaryData: dummyAuxiliaryData,
    );

    final auxiliaryDataSizeBeforePatching = rawTx.auxiliaryData.length;

    // 1. txInputsHash
    final txInputsHash = TransactionInputsHash.fromHashedBytes(rawTx.inputs);
    rawTx.patchTxInputsHash(txInputsHash.bytes);

    // 2. signature
    final privateKey = Bip32Ed25519XPrivateKeyFactory.instance.fromBytes(
      rootKeyPair.privateKey.bytes,
    );
    final signature = await privateKey.use((privateKey) => privateKey.sign(rawTx.auxiliaryData));
    rawTx.patchSignature(signature.bytes);

    // 3. auxiliaryData
    final auxiliaryDataHash = AuxiliaryDataHash.fromHashedBytes(rawTx.auxiliaryData);
    rawTx.patchAuxiliaryDataHash(auxiliaryDataHash.bytes);

    // 4. validate
    _validateCborFormat(rawTx);
    _validateAuxiliaryDataSize(rawTx, expectedSize: auxiliaryDataSizeBeforePatching);

    return rawTx;
  }

  RegistrationMetadata _buildUnsignedMetadata({
    required String purpose,
    required TransactionInputsHash txInputsHash,
    required X509DerCertificate? derCert,
    required List<RbacField<cs.Ed25519PublicKey>> publicKeys,
  }) {
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
  }

  void _validateAuxiliaryDataSize(
    RawTransaction rawTx, {
    required int expectedSize,
  }) {
    final actualSize = rawTx.auxiliaryData.length;

    if (actualSize != expectedSize) {
      throw RawTransactionAuxiliaryDataSizeChanged(
        expectedSize: expectedSize,
        actualSize: actualSize,
      );
    }
  }

  void _validateCborFormat(RawTransaction rawTx) {
    try {
      final bytes = rawTx.bytes;
      final cborValue = cbor.decode(bytes);
      Transaction.fromCbor(cborValue);
    } on FormatException catch (_) {
      throw const RawTransactionMalformed();
    }
  }
}
