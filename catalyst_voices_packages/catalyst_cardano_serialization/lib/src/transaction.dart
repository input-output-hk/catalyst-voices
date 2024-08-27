import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/transaction_output.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// Represents the signed transaction with a list of witnesses
/// which are used to verify the validity of a transaction.
final class Transaction extends Equatable implements CborEncodable {
  /// The transaction body containing the inputs, outputs, fees, etc.
  final TransactionBody body;

  /// The set of witnesses that have signed given transaction.
  final TransactionWitnessSet witnessSet;

  /// True if the transaction is valid, false otherwise.
  final bool isValid;

  /// The optional transaction metadata.
  final AuxiliaryData? auxiliaryData;

  /// The default constructor for [Transaction].
  const Transaction({
    required this.body,
    required this.isValid,
    required this.witnessSet,
    this.auxiliaryData,
  });

  /// Deserializes the type from cbor.
  factory Transaction.fromCbor(CborValue value) {
    final list = value as CborList;
    final body = list[0];
    final witnessSet = list[1];
    final isValid = list[2];
    final auxiliaryData = list.length >= 4 ? list[3] : null;

    return Transaction(
      body: TransactionBody.fromCbor(body),
      isValid: (isValid as CborBool).value,
      witnessSet: TransactionWitnessSet.fromCbor(witnessSet),
      auxiliaryData: (auxiliaryData != null && auxiliaryData is! CborNull)
          ? AuxiliaryData.fromCbor(auxiliaryData)
          : null,
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborList([
      body.toCbor(),
      witnessSet.toCbor(),
      CborBool(isValid),
      auxiliaryData?.toCbor() ?? const CborNull(),
    ]);
  }

  @override
  List<Object?> get props => [body, isValid, witnessSet, auxiliaryData];
}

/// Represents the details of a transaction including inputs, outputs, fee, etc.
///
/// Does not contain the witnesses which are used to verify the transaction.
final class TransactionBody extends Equatable implements CborEncodable {
  /// The transaction inputs. tag: 0
  final Set<TransactionInput> inputs;

  /// The transaction outputs. tag: 1
  final List<ShelleyMultiAssetTransactionOutput> outputs;

  /// The fee for the transaction. tag: 2
  final Coin fee;

  // > Note: All properties below are optional.
  /// The absolute slot value before the tx becomes invalid. tag: 3
  final SlotBigNum? ttl;

  /// Certificates in an ordered set. tag: 4
  /// Withdrawals map of stake address, coin. tag: 5

  /// The hash of the optional [AuxiliaryData]
  /// which is the metadata of the transaction. tag: 7
  final AuxiliaryDataHash? auxiliaryDataHash;

  /// Validity interval start as integer. tag: 8
  final SlotBigNum? validityStart;

  /// Mint as a non-zero uint64 multiasset. tag: 9
  final MultiAsset? mint;

  /// Tag 10 is unimplemented.
  /// Script data hash28. tag: 11
  final ScriptDataHash? scriptDataHash;

  /// Tag 12 is unimplemented.
  /// Collateral inputs as nonempty set. tag: 13
  final Set<TransactionInput>? collateralInputs;

  /// The list of public key hashes of addresses
  /// that are required to sign the transaction.
  /// Nonempty set of addr keyhash. tag: 14
  final Set<Ed25519PublicKeyHash>? requiredSigners;

  /// Specifies on which network the code will run. Network ID 0/1. tag: 15
  final NetworkId? networkId;

  /// Collateral return's transaction output. tag: 16
  final ShelleyMultiAssetTransactionOutput? collateralReturn;

  /// Total collateral as coin (uint64). tag: 17
  final Coin? totalCollateral;

  /// Reference inputs as nonempty set of transaction inputs. tag: 18
  final Set<TransactionInput>? referenceInputs;

  /// The default constructor for [TransactionBody].
  const TransactionBody({
    required this.inputs, // tag: 0
    required this.outputs, // tag: 1
    required this.fee, // tag: 2
    this.ttl, // tag: 3
    this.auxiliaryDataHash, // tag: 7
    this.validityStart, // tag: 8
    this.mint, // tag: 9
    this.scriptDataHash, // tag: 11
    this.collateralInputs, // tag: 13
    this.requiredSigners, // tag: 14
    this.networkId, // tag: 15
    this.collateralReturn, // tag: 16
    this.totalCollateral, // tag: 17
    this.referenceInputs, // tag: 18
  });

  /// Deserializes the type from cbor.
  factory TransactionBody.fromCbor(CborValue value) {
    final map = value as CborMap;
    final inputs = map[const CborSmallInt(0)]! as CborList;
    final outputs = map[const CborSmallInt(1)]! as CborList;
    final fee = map[const CborSmallInt(2)]!;
    final ttl = map[const CborSmallInt(3)];
    final auxiliaryDataHash = map[const CborSmallInt(7)];
    final validityStart = map[const CborSmallInt(8)];
    final mint = map[const CborSmallInt(9)];
    final scriptDataHash = map[const CborSmallInt(11)];
    final collateralInputs = map[const CborSmallInt(13)] as CborList?;
    final requiredSigners = map[const CborSmallInt(14)] as CborList?;
    final networkId = map[const CborSmallInt(15)] as CborSmallInt?;
    final collateralReturn = map[const CborSmallInt(16)] as CborList?;
    final totalCollateral = map[const CborSmallInt(17)];
    final referenceInputs = map[const CborSmallInt(18)] as CborList?;

    return TransactionBody(
      inputs: inputs.map(TransactionInput.fromCbor).toSet(),
      outputs: outputs.map(TransactionOutput.fromCbor).toList(),
      fee: Coin.fromCbor(fee),
      ttl: ttl != null ? SlotBigNum.fromCbor(ttl) : null,
      auxiliaryDataHash: auxiliaryDataHash != null
          ? AuxiliaryDataHash.fromCbor(auxiliaryDataHash)
          : null,
      validityStart:
          validityStart != null ? SlotBigNum.fromCbor(validityStart) : null,
      mint: mint != null ? MultiAsset.fromCbor(mint) : null,
      scriptDataHash: scriptDataHash != null
          ? ScriptDataHash.fromCbor(scriptDataHash)
          : null,
      collateralInputs:
          collateralInputs?.map(TransactionInput.fromCbor).toSet(),
      requiredSigners:
          requiredSigners?.map(Ed25519PublicKeyHash.fromCbor).toSet(),
      networkId: networkId != null ? NetworkId.fromId(networkId.value) : null,
      collateralReturn: collateralReturn != null
          ? TransactionOutput.fromCbor(collateralReturn)
          : null,
      totalCollateral:
          totalCollateral != null ? Coin.fromCbor(totalCollateral) : null,
      referenceInputs: referenceInputs?.map(TransactionInput.fromCbor).toSet(),
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborMap({
      const CborSmallInt(0): CborList([
        for (final input in inputs) input.toCbor(),
      ]),
      const CborSmallInt(1): CborList([
        for (final output in outputs) output.toCbor(),
      ]),
      const CborSmallInt(2): fee.toCbor(),
      if (ttl != null) const CborSmallInt(3): ttl!.toCbor(),
      if (auxiliaryDataHash != null)
        const CborSmallInt(7): auxiliaryDataHash!.toCbor(),
      if (validityStart != null) const CborSmallInt(8): validityStart!.toCbor(),
      if (mint != null) const CborSmallInt(9): mint!.toCbor(),
      if (scriptDataHash != null)
        const CborSmallInt(11): scriptDataHash!.toCbor(),
      if (collateralInputs != null && collateralInputs!.isNotEmpty)
        const CborSmallInt(13): CborList([
          for (final input in collateralInputs!) input.toCbor(),
        ]),
      if (requiredSigners != null && requiredSigners!.isNotEmpty)
        const CborSmallInt(14): CborList([
          for (final signer in requiredSigners!) signer.toCbor(),
        ]),
      if (networkId != null)
        const CborSmallInt(15): CborSmallInt(networkId!.id),
      if (collateralReturn != null)
        const CborSmallInt(16): collateralReturn!.toCbor(),
      if (totalCollateral != null)
        const CborSmallInt(17): totalCollateral!.toCbor(),
      if (referenceInputs != null && referenceInputs!.isNotEmpty)
        const CborSmallInt(18): CborList([
          for (final input in referenceInputs!) input.toCbor(),
        ]),
    });
  }

  @override
  List<Object?> get props => [
        inputs,
        outputs,
        fee,
        ttl,
        auxiliaryDataHash,
        validityStart,
        mint,
        scriptDataHash,
        collateralInputs,
        requiredSigners,
        networkId,
        collateralReturn,
        totalCollateral,
        referenceInputs,
      ];
}

/// The transaction output of a previous transaction,
/// acts as input for the next transaction.
final class TransactionInput extends Equatable implements CborEncodable {
  /// The hash of the given transaction.
  final TransactionHash transactionId;

  /// The index of the utxo in the given transaction.
  final int index;

  /// The default constructor for [TransactionInput].
  const TransactionInput({
    required this.transactionId,
    required this.index,
  });

  /// Deserializes the type from cbor.
  factory TransactionInput.fromCbor(CborValue value) {
    final list = value as CborList;
    final transactionId = list[0];
    final index = list[1];

    return TransactionInput(
      transactionId: TransactionHash.fromCbor(transactionId),
      index: (index as CborSmallInt).value,
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborList([
      transactionId.toCbor(),
      CborSmallInt(index),
    ]);
  }

  @override
  List<Object?> get props => [transactionId, index];
}

/// The UTXO that can be used as an input in a new transaction.
final class TransactionUnspentOutput extends Equatable
    implements CborEncodable {
  /// The transaction output of a previous transaction,
  /// acts as input for the next transaction.
  final TransactionInput input;

  /// The transaction output which assigns the owner of given address
  /// with leftover change from previous transaction.
  final ShelleyMultiAssetTransactionOutput output;

  /// The default constructor for [TransactionUnspentOutput].
  const TransactionUnspentOutput({
    required this.input,
    required this.output,
  });

  /// Deserializes the type from cbor.
  factory TransactionUnspentOutput.fromCbor(CborValue value) {
    final list = value as CborList;
    final input = list[0];
    final output = list[1];

    return TransactionUnspentOutput(
      input: TransactionInput.fromCbor(input),
      output: TransactionOutput.fromCbor(output),
    );
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborList([
      input.toCbor(),
      output.toCbor(),
    ]);
  }

  @override
  List<Object?> get props => [input, output];
}

/// The transaction metadata as a list of key-value pairs (a map).
final class AuxiliaryData extends Equatable implements CborEncodable {
  /// The transaction metadata map.
  final Map<CborValue, CborValue> map;

  /// The default constructor for [AuxiliaryData].
  const AuxiliaryData({this.map = const {}});

  /// Deserializes the type from cbor.
  factory AuxiliaryData.fromCbor(CborValue value) {
    final map = value as CborMap;
    return AuxiliaryData(map: Map.fromEntries(map.entries));
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborMap(
      map,
      tags: map.isNotEmpty ? const [] : [CborCustomTags.map],
    );
  }

  @override
  List<Object?> get props => [map];
}
