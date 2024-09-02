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
    required this.inputs,
    required this.outputs,
    required this.fee,
    this.ttl,
    this.auxiliaryDataHash,
    this.validityStart,
    this.mint,
    this.scriptDataHash,
    this.collateralInputs,
    this.requiredSigners,
    this.networkId,
    this.collateralReturn,
    this.totalCollateral,
    this.referenceInputs,
  });

  /// Deserializes the type from cbor.
  factory TransactionBody.fromCbor(CborValue value) {
    try {
      final map = value as CborMap;

      return TransactionBody(
        inputs: _extractList(map, 0, TransactionInput.fromCbor)!.toSet(),
        outputs: _extractList(map, 1, TransactionOutput.fromCbor)!,
        fee: _extractValue(map, 2, Coin.fromCbor)!,
        ttl: _extractValue(map, 3, SlotBigNum.fromCbor),
        auxiliaryDataHash: _extractValue(map, 7, AuxiliaryDataHash.fromCbor),
        validityStart: _extractValue(map, 8, SlotBigNum.fromCbor),
        mint: _extractValue(map, 9, MultiAsset.fromCbor),
        scriptDataHash: _extractValue(map, 11, ScriptDataHash.fromCbor),
        collateralInputs:
            _extractList(map, 13, TransactionInput.fromCbor)?.toSet(),
        requiredSigners:
            _extractList(map, 14, Ed25519PublicKeyHash.fromCbor)?.toSet(),
        networkId: _extractValue(
          map,
          15,
          (value) => NetworkId.fromId((value as CborSmallInt).value),
        ),
        collateralReturn: _extractValue(map, 16, TransactionOutput.fromCbor),
        totalCollateral: _extractValue(map, 17, Coin.fromCbor),
        referenceInputs:
            _extractList(map, 18, TransactionInput.fromCbor)?.toSet(),
      );
    } catch (e) {
      throw ArgumentError('Invalid CBOR input: $e');
    }
  }

  static List<T>? _extractList<T>(
    CborMap map,
    int key,
    T Function(CborValue) fromCbor,
  ) {
    final list = map[CborSmallInt(key)] as CborList?;
    return list?.map(fromCbor).toList();
  }

  static T? _extractValue<T>(
    CborMap map,
    int key,
    T Function(CborValue) fromCbor,
  ) {
    final value = map[CborSmallInt(key)];
    return value != null ? fromCbor(value) : null;
  }

  /// Serializes the type as cbor.
  @override
  CborValue toCbor() {
    return CborMap({
      const CborSmallInt(0): _toCborList(inputs),
      const CborSmallInt(1): _toCborList(outputs),
      const CborSmallInt(2): fee.toCbor(),
      if (ttl != null) const CborSmallInt(3): ttl!.toCbor(),
      if (auxiliaryDataHash != null)
        const CborSmallInt(7): auxiliaryDataHash!.toCbor(),
      if (validityStart != null) const CborSmallInt(8): validityStart!.toCbor(),
      if (mint != null) const CborSmallInt(9): mint!.toCbor(),
      if (scriptDataHash != null)
        const CborSmallInt(11): scriptDataHash!.toCbor(),
      if (collateralInputs != null && collateralInputs!.isNotEmpty)
        const CborSmallInt(13): _toCborList(collateralInputs!),
      if (requiredSigners != null && requiredSigners!.isNotEmpty)
        const CborSmallInt(14): _toCborList(requiredSigners!),
      if (networkId != null)
        const CborSmallInt(15): CborSmallInt(networkId!.id),
      if (collateralReturn != null)
        const CborSmallInt(16): collateralReturn!.toCbor(),
      if (totalCollateral != null)
        const CborSmallInt(17): totalCollateral!.toCbor(),
      if (referenceInputs != null && referenceInputs!.isNotEmpty)
        const CborSmallInt(18): _toCborList(referenceInputs!),
    });
  }

  CborList _toCborList(Iterable<CborEncodable> iterable) {
    return CborList([
      for (final item in iterable) item.toCbor(),
    ]);
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
