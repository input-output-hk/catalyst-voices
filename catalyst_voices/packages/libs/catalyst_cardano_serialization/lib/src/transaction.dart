import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/transaction_output.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [map];

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) {
    return CborMap(
      map,
      tags: map.isNotEmpty
          ? tags
          : [
              CborCustomTags.map,
              ...tags,
            ],
    );
  }
}

///
abstract base class BaseTransaction extends Equatable {
  ///
  const BaseTransaction();

  ///
  List<int> get bytes;

  ///
  Coin get fee;

  ///
  NetworkId? get networkId;

  ///
  BaseTransaction withWitnessSet(TransactionWitnessSet witnessSet);
}

/// Represents the signed transaction with a list of witnesses
/// which are used to verify the validity of a transaction.
final class Transaction extends BaseTransaction implements CborEncodable {
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

  @override
  List<int> get bytes => cbor.encode(toCbor());

  @override
  Coin get fee => body.fee;

  @override
  NetworkId? get networkId => body.networkId;

  @override
  List<Object?> get props => [body, isValid, witnessSet, auxiliaryData];

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) {
    return CborList(
      [
        body.toCbor(),
        witnessSet.toCbor(),
        CborBool(isValid),
        auxiliaryData?.toCbor() ?? const CborNull(),
      ],
      tags: tags,
    );
  }

  @override
  Transaction withWitnessSet(TransactionWitnessSet witnessSet) {
    return Transaction(
      body: body,
      isValid: isValid,
      witnessSet: witnessSet,
      auxiliaryData: auxiliaryData,
    );
  }
}

/// Represents the details of a transaction including inputs, outputs, fee, etc.
///
/// Does not contain the witnesses which are used to verify the transaction.
final class TransactionBody extends Equatable implements CborEncodable {
  static const inputsKey = CborSmallInt(0);

  static const outputsKey = CborSmallInt(1);

  static const feeKey = CborSmallInt(2);

  static const ttlKey = CborSmallInt(3);

  static const auxiliaryDataHashKey = CborSmallInt(7);

  static const validityStartKey = CborSmallInt(8);

  static const mintKey = CborSmallInt(9);

  static const scriptDataHashKey = CborSmallInt(11);

  static const collateralInputsKey = CborSmallInt(13);

  static const requiredSignersKey = CborSmallInt(14);

  static const networkIdKey = CborSmallInt(15);

  static const collateralReturnKey = CborSmallInt(16);

  static const totalCollateralKey = CborSmallInt(17);

  static const referenceInputsKey = CborSmallInt(18);

  /// The transaction inputs. tag: 0
  final Set<TransactionInput> inputs;

  /// The transaction outputs. tag: 1
  final List<ShelleyMultiAssetTransactionOutput> outputs;

  /// The fee for the transaction. tag: 2
  final Coin fee;

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
        inputs: _extractList(map, inputsKey, TransactionInput.fromCbor)!.toSet(),
        outputs: _extractList(map, outputsKey, TransactionOutput.fromCbor)!,
        fee: _extractValue(map, feeKey, Coin.fromCbor)!,
        ttl: _extractValue(map, ttlKey, SlotBigNum.fromCbor),
        auxiliaryDataHash: _extractValue(map, auxiliaryDataHashKey, AuxiliaryDataHash.fromCbor),
        validityStart: _extractValue(map, validityStartKey, SlotBigNum.fromCbor),
        mint: _extractValue(map, mintKey, MultiAsset.fromCbor),
        scriptDataHash: _extractValue(map, scriptDataHashKey, ScriptDataHash.fromCbor),
        collateralInputs: _extractList(
          map,
          collateralInputsKey,
          TransactionInput.fromCbor,
        )?.toSet(),
        requiredSigners: _extractList(
          map,
          requiredSignersKey,
          Ed25519PublicKeyHash.fromCbor,
        )?.toSet(),
        networkId: _extractValue(
          map,
          networkIdKey,
          (value) => NetworkId.fromId((value as CborSmallInt).value),
        ),
        collateralReturn: _extractValue(map, collateralReturnKey, TransactionOutput.fromCbor),
        totalCollateral: _extractValue(map, totalCollateralKey, Coin.fromCbor),
        referenceInputs: _extractList(map, referenceInputsKey, TransactionInput.fromCbor)?.toSet(),
      );
    } catch (e) {
      throw ArgumentError('Invalid CBOR input: $e');
    }
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

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) {
    final items = toCborValuesMap();

    return CborMap(
      items,
      tags: tags,
    );
  }

  ///
  Map<CborValue, CborValue> toCborValuesMap() {
    return <CborValue, CborValue>{
      inputsKey: _toCborList(inputs),
      outputsKey: _toCborList(outputs),
      feeKey: fee.toCbor(),
      if (ttl != null) ttlKey: ttl!.toCbor(),
      if (auxiliaryDataHash != null) auxiliaryDataHashKey: auxiliaryDataHash!.toCbor(),
      if (validityStart != null) validityStartKey: validityStart!.toCbor(),
      if (mint != null) mintKey: mint!.toCbor(),
      if (scriptDataHash != null) scriptDataHashKey: scriptDataHash!.toCbor(),
      if (collateralInputs != null && collateralInputs!.isNotEmpty)
        collateralInputsKey: _toCborList(collateralInputs!),
      if (requiredSigners != null && requiredSigners!.isNotEmpty)
        requiredSignersKey: _toCborList(requiredSigners!),
      if (networkId != null) networkIdKey: CborSmallInt(networkId!.id),
      if (collateralReturn != null) collateralReturnKey: collateralReturn!.toCbor(),
      if (totalCollateral != null) totalCollateralKey: totalCollateral!.toCbor(),
      if (referenceInputs != null && referenceInputs!.isNotEmpty)
        referenceInputsKey: _toCborList(referenceInputs!),
    };
  }

  CborList _toCborList(Iterable<CborEncodable> iterable) {
    return CborList([
      for (final item in iterable) item.toCbor(),
    ]);
  }

  static List<T>? _extractList<T>(
    CborMap map,
    CborSmallInt key,
    T Function(CborValue) fromCbor,
  ) {
    final list = map[key] as CborList?;
    return list?.map(fromCbor).toList();
  }

  static T? _extractValue<T>(
    CborMap map,
    CborSmallInt key,
    T Function(CborValue) fromCbor,
  ) {
    final value = map[key];
    return value != null ? fromCbor(value) : null;
  }
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

  @override
  List<Object?> get props => [transactionId, index];

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) {
    return CborList(
      [
        transactionId.toCbor(),
        CborSmallInt(index),
      ],
      tags: tags,
    );
  }
}

/// The UTXO that can be used as an input in a new transaction.
final class TransactionUnspentOutput extends Equatable implements CborEncodable {
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

  @override
  List<Object?> get props => [input, output];

  /// Serializes the type as cbor.
  @override
  CborValue toCbor({List<int> tags = const []}) {
    return CborList(
      [
        input.toCbor(),
        output.toCbor(),
      ],
      tags: tags,
    );
  }
}
