import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// Represents the signed transaction with a list of witnesses
/// which are used to verify the validity of a transaction.
final class Transaction extends Equatable {
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
final class TransactionBody extends Equatable {
  /// The transaction inputs.
  final Set<TransactionInput> inputs;

  /// The transaction outputs.
  final List<TransactionOutput> outputs;

  /// The fee for the transaction.
  final Coin fee;

  /// The absolute slot value before the tx becomes invalid.
  final SlotBigNum? ttl;

  /// The hash of the optional [AuxiliaryData]
  /// which is the metadata of the transaction.
  final AuxiliaryDataHash? auxiliaryDataHash;

  /// Specifies on which network the code will run.
  final NetworkId? networkId;

  /// The default constructor for [TransactionBody].
  const TransactionBody({
    required this.inputs,
    required this.outputs,
    required this.fee,
    this.ttl,
    this.auxiliaryDataHash,
    this.networkId,
  });

  /// Deserializes the type from cbor.
  factory TransactionBody.fromCbor(CborValue value) {
    final map = value as CborMap;
    final inputs = map[const CborSmallInt(0)]! as CborList;
    final outputs = map[const CborSmallInt(1)]! as CborList;
    final fee = map[const CborSmallInt(2)]!;
    final ttl = map[const CborSmallInt(3)];
    final auxiliaryDataHash = map[const CborSmallInt(7)];
    final networkId = map[const CborSmallInt(15)] as CborSmallInt?;

    return TransactionBody(
      inputs: inputs.map(TransactionInput.fromCbor).toSet(),
      outputs: outputs.map(TransactionOutput.fromCbor).toList(),
      fee: Coin.fromCbor(fee),
      ttl: ttl != null ? SlotBigNum.fromCbor(ttl) : null,
      auxiliaryDataHash: auxiliaryDataHash != null
          ? AuxiliaryDataHash.fromCbor(auxiliaryDataHash)
          : null,
      networkId: networkId != null ? NetworkId.fromId(networkId.value) : null,
    );
  }

  /// Serializes the type as cbor.
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
      if (networkId != null)
        const CborSmallInt(15): CborSmallInt(networkId!.id),
    });
  }

  @override
  List<Object?> get props =>
      [inputs, outputs, fee, ttl, auxiliaryDataHash, networkId];
}

/// The transaction output of a previous transaction,
/// acts as input for the next transaction.
final class TransactionInput extends Equatable {
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
  CborValue toCbor() {
    return CborList([
      transactionId.toCbor(),
      CborSmallInt(index),
    ]);
  }

  @override
  List<Object?> get props => [transactionId, index];
}

/// The transaction output which describes which [address]
/// will receive what [amount] of [Coin].
final class TransactionOutput extends Equatable {
  /// The address associated with the transaction.
  final ShelleyAddress address;

  /// The leftover change from the previous transaction that can be spent.
  final Value amount;

  /// The default constructor for [TransactionOutput].
  const TransactionOutput({
    required this.address,
    required this.amount,
  });

  /// Deserializes the type from cbor.
  factory TransactionOutput.fromCbor(CborValue value) {
    final list = value as CborList;
    final address = list[0];
    final amount = list[1];

    return TransactionOutput(
      address: ShelleyAddress.fromCbor(address),
      amount: Value.fromCbor(amount),
    );
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      address.toCbor(),
      amount.toCbor(),
    ]);
  }

  /// Return a copy of this output with [address] and [amount] if present.
  TransactionOutput copyWith({
    ShelleyAddress? address,
    Value? amount,
  }) {
    return TransactionOutput(
      address: address ?? this.address,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [address, amount];
}

/// The UTXO that can be used as an input in a new transaction.
final class TransactionUnspentOutput extends Equatable {
  /// The transaction output of a previous transaction,
  /// acts as input for the next transaction.
  final TransactionInput input;

  /// The transaction output which assigns the owner of given address
  /// with leftover change from previous transaction.
  final TransactionOutput output;

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
final class AuxiliaryData extends Equatable {
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
  CborValue toCbor() {
    return CborMap(
      map,
      tags: map.isNotEmpty ? const [] : [CborCustomTags.map],
    );
  }

  @override
  List<Object?> get props => [map];
}
