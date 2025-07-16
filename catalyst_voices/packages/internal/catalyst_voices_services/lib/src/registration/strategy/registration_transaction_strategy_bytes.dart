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

    final dummyMetadata = await unsignedMetadata.toAuxiliaryData();
    final dummyMetadataBytes = cbor.encode(dummyMetadata.toCbor());

    final dummyTxInputsHashCborBytes = cbor.encode(dummyTxInputsHash.toCbor());
    final dummySignatureBytes = cbor.encode(unsignedMetadata.validationSignature.toCbor());

    // Keep indexes of txInputsHash, signature and metadataSize as they don't change now.
    final metadataTxInputsHashIndex = _indexOfSubList(
      dummyMetadataBytes,
      dummyTxInputsHashCborBytes,
    );
    final metadataSignatureIndex = _indexOfSubList(dummyMetadataBytes, dummySignatureBytes);
    final metadataSize = dummyMetadataBytes.length;

    final txBuilder = TransactionBuilder(
      requiredSigners: requiredSigners,
      config: transactionConfig,
      inputs: utxos,
      networkId: networkId,
      ttl: slotNumberTtl,
      auxiliaryData: dummyMetadata,
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

    final tx = Transaction(
      body: txBody,
      isValid: true,
      witnessSet: const TransactionWitnessSet(),
      auxiliaryData: dummyMetadata,
    );

    final txCbor = tx.toCbor() as CborList;

    // Encoded transaction with padding values (00's)
    final txBytes = cbor.encode(txCbor);
    final txMetadataIndex = _indexOfSubList(txBytes, dummyMetadataBytes);

    final txBodyBytes = cbor.encode(txCbor[0]);
    final txBodyIndex = _indexOfSubList(txBytes, txBodyBytes);
    final txBodyLength = txBodyBytes.length;

    final txMetadataHash = (txCbor[0] as CborMap)[const CborSmallInt(7)];
    final txMetadataHashBytes = cbor.encode(txMetadataHash!);
    final txMetadataHashIndex = _indexOfSubList(txBytes, txMetadataHashBytes);

    final txInputs = (txCbor[0] as CborMap)[const CborSmallInt(0)];
    final txInputsBytesReEncoded = cbor.encode(txInputs!);
    final txInputsIndex = _indexOfSubList(txBytes, txInputsBytesReEncoded);

    final txWitnessSet = txCbor[1];
    final txWitnessSetReEncoded = cbor.encode(txWitnessSet);
    final txWitnessSetIndex = _indexOfSubList(
      txBytes,
      txWitnessSetReEncoded,
      txBodyIndex + txBodyLength,
    );
    final txWitnessSetSize = txWitnessSetReEncoded.length;

    // Selected inputs bytes from txBytes
    final txInputsBytes = txBytes.sublist(
      txInputsIndex,
      txInputsIndex + txInputsBytesReEncoded.length,
    );

    // Final hash of selected inputs
    final txInputHash = TransactionInputsHash.fromHashedBytes(txInputsBytes);
    final txInputHashBytes = cbor.encode(txInputHash.toCbor());

    // Patch txInputHash
    final startInputHash = txMetadataIndex + metadataTxInputsHashIndex;
    final endInputHash = startInputHash + txInputHashBytes.length;
    txBytes.replaceRange(startInputHash, endInputHash, txInputHashBytes);

    // Create signature over metadata
    final metadataBytes = txBytes.sublist(txMetadataIndex, txMetadataIndex + metadataSize);

    final privateKey = Bip32Ed25519XPrivateKeyFactory.instance.fromBytes(
      rootKeyPair.privateKey.bytes,
    );

    final signature = await privateKey.use((privateKey) => privateKey.sign(metadataBytes));
    final signatureBytes = cbor.encode(signature.toCbor());

    // Patch metadata signature
    final startSignature = txMetadataIndex + metadataSignatureIndex;
    final endSignature = startSignature + signatureBytes.length;
    txBytes.replaceRange(startSignature, endSignature, signatureBytes);

    // Create final metadata hash
    final finalMetadataBytes = txBytes.sublist(txMetadataIndex, txMetadataIndex + metadataSize);
    final finalMetadataHash = AuxiliaryDataHash.fromHashedBytes(finalMetadataBytes);
    final finalMetadataHashBytes = cbor.encode(finalMetadataHash.toCbor());

    // Patch metadata hash
    final startMetadataHash = txMetadataHashIndex;
    final endMetadataHash = startMetadataHash + finalMetadataHashBytes.length;
    txBytes.replaceRange(startMetadataHash, endMetadataHash, finalMetadataHashBytes);

    return RawTransaction(
      txBytes,
      txWitnessSetIndex: txWitnessSetIndex,
      txWitnessSetSize: txWitnessSetSize,
    );
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

  int _indexOfSubList(List<int> list, List<int> sublist, [int start = 0]) {
    for (var i = start; i <= list.length - sublist.length; i++) {
      var found = true;
      for (var j = 0; j < sublist.length; j++) {
        if (list[i + j] != sublist[j]) {
          found = false;
          break;
        }
      }
      if (found) return i;
    }
    return -1;
  }
}

extension on RegistrationMetadata {
  Future<AuxiliaryData> toAuxiliaryData() async {
    return AuxiliaryData.fromCbor(
      await toCbor(serializer: (e) => e.toCbor()),
    );
  }
}
