import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart'
    as cs
    show Ed25519PublicKey;
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/registration/registration_transaction_role.dart';
import 'package:catalyst_voices_services/src/registration/strategy/registration_transaction_strategy.dart';

final class RegistrationTransactionStrategyModels implements RegistrationTransactionStrategy {
  final TransactionBuilderConfig transactionConfig;
  final NetworkId networkId;
  final SlotBigNum slotNumberTtl;
  final Set<RegistrationTransactionRole> roles;
  final ShelleyAddress changeAddress;
  final Set<TransactionUnspentOutput> utxos;
  final TransactionHash? previousTransactionId;

  RegistrationTransactionStrategyModels({
    required this.transactionConfig,
    required this.networkId,
    required this.slotNumberTtl,
    required this.roles,
    required this.changeAddress,
    required this.utxos,
    required this.previousTransactionId,
  });

  @override
  Future<Transaction> build({
    required String purpose,
    required CatalystKeyPair rootKeyPair,
    required X509DerCertificate? derCert,
    required List<RbacField<cs.Ed25519PublicKey>> publicKeys,
    required Set<Ed25519PublicKeyHash> requiredSigners,
  }) async {
    final dummyTxInputsHashBytes = List.filled(TransactionInputsHash.hashLength, 0);
    final dummyTxInputsHash = TransactionInputsHash.fromBytes(bytes: dummyTxInputsHashBytes);
    final dummyX509Envelope = await _buildMetadataEnvelope(
      purpose: purpose,
      rootKeyPair: rootKeyPair,
      txInputsHash: dummyTxInputsHash,
      derCert: derCert,
      publicKeys: publicKeys,
    );
    final dummyAuxiliaryData = await dummyX509Envelope.toAuxiliaryData();

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

    final realTxInputHash = TransactionInputsHash.fromTransactionInputs(selectedUtxos);
    final realTxX509Envelope = await _buildMetadataEnvelope(
      purpose: purpose,
      rootKeyPair: rootKeyPair,
      txInputsHash: realTxInputHash,
      derCert: derCert,
      publicKeys: publicKeys,
    );
    final realAuxiliaryData = await realTxX509Envelope.toAuxiliaryData();
    final realTxBuilder = txBuilder.copyWith(
      inputs: selectedUtxos,
      outputs: changes,
      fee: totalFee,
      auxiliaryData: realAuxiliaryData,
    );

    _validateSameUtxo(selectedUtxos, realTxBuilder.inputs);

    final txBody = realTxBuilder.buildBody();

    _validateUtxoAndTxBodyInputs(selectedUtxos, txBody.inputs);

    return Transaction(
      body: txBody,
      isValid: true,
      witnessSet: const TransactionWitnessSet(),
      auxiliaryData: realAuxiliaryData,
    );
  }

  Future<RegistrationMetadata> _buildMetadataEnvelope({
    required String purpose,
    required CatalystKeyPair rootKeyPair,
    required TransactionInputsHash txInputsHash,
    required X509DerCertificate? derCert,
    required List<RbacField<cs.Ed25519PublicKey>> publicKeys,
  }) async {
    if (!roles.isFirstRegistration && previousTransactionId == null) {
      throw ArgumentError.notNull('previousTransactionId');
    }

    final x509Envelope = X509MetadataEnvelope.unsigned(
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

    final privateKey = Bip32Ed25519XPrivateKeyFactory.instance.fromBytes(
      rootKeyPair.privateKey.bytes,
    );

    return privateKey.use((privateKey) {
      return x509Envelope.sign(
        privateKey: privateKey,
        serializer: (e) => e.toCbor(),
      );
    });
  }

  void _validateSameUtxo(
    Set<TransactionUnspentOutput> first,
    Set<TransactionUnspentOutput> second,
  ) {
    if (first.length != second.length) {
      throw ArgumentError('Different length of utxos');
    }

    for (var i = 0; i < first.length; i++) {
      if (first.elementAt(i) != second.elementAt(i)) {
        throw ArgumentError('Utxo at index [$i] is different');
      }
    }
  }

  void _validateUtxoAndTxBodyInputs(
    Set<TransactionUnspentOutput> utxos,
    Set<TransactionInput> inputs,
  ) {
    if (utxos.length != inputs.length) {
      throw ArgumentError('Different length of utxos and inputs');
    }

    for (var i = 0; i < inputs.length; i++) {
      if (inputs.elementAt(i) != utxos.elementAt(i).input) {
        throw ArgumentError('Utxo at index [$i] is different in txBody and selectedUtxo');
      }
    }
  }
}

extension on RegistrationMetadata {
  Future<AuxiliaryData> toAuxiliaryData() async {
    return AuxiliaryData.fromCbor(
      await toCbor(serializer: (e) => e.toCbor()),
    );
  }
}
