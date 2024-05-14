import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';

/// Represents the signed transaction with a list of witnesses
/// which are used to verify the validity of a transaction.
final class Transaction {
  /// The transaction body containing the inputs, outputs, fees, etc.
  final TransactionBody body;

  /// True if the transaction is valid, false otherwise.
  final bool isValid;

  /// The optional transaction metadata.
  final AuxiliaryData? auxiliaryData;

  /// The default constructor for the [Transaction].
  const Transaction({
    required this.body,
    required this.isValid,
    this.auxiliaryData,
  });

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      body.toCbor(),
      // TODO(dtscalac): implement witnesses
      CborMap({}),
      CborBool(isValid),
      (auxiliaryData ?? const AuxiliaryData()).toCbor(),
    ]);
  }
}

/// Represents the details of a transaction including inputs, outputs, fee, etc.
///
/// Does not contain the witnesses which are used to verify the transaction.
final class TransactionBody {
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
    });
  }
}

/// The transaction output of a previous transaction,
/// acts as input for the next transaction.
final class TransactionInput {
  /// The hash of the given transaction.
  final TransactionHash transactionId;

  /// The index of the utxo in the given transaction.
  final int index;

  /// The default constructor for [TransactionInput].
  const TransactionInput({
    required this.transactionId,
    required this.index,
  });

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      transactionId.toCbor(),
      CborSmallInt(index),
    ]);
  }
}

/// The transaction output which assigns the owner of given address
/// with leftover change from previous transaction.
final class TransactionOutput {
  /// The address associated with the transaction.
  final ShelleyAddress address;

  /// The leftover change from the previous transaction that can be spent.
  final Coin amount;

  /// The default constructor for the [TransactionOutput].
  const TransactionOutput({
    required this.address,
    required this.amount,
  });

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      address.toCbor(),
      amount.toCbor(),
    ]);
  }
}

/// The UTXO that can be used as an input in a new transaction.
final class TransactionUnspentOutput {
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

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      input.toCbor(),
      output.toCbor(),
    ]);
  }
}

/// The transaction metadata as a list of key-value pairs (a map).
final class AuxiliaryData {
  /// The transaction metadata map.
  final Map<CborSmallInt, CborValue> map;

  /// The default constructor for the [AuxiliaryData].
  const AuxiliaryData({this.map = const {}});

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborMap(
      map,
      tags: map.isNotEmpty ? const [] : [CborCustomTags.map],
    );
  }
}
