import 'dart:typed_data';
import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/scripts.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';
import 'package:pinenacl/api.dart';

/// Enum representing the type of a datum option in Cardano.
/// A DatumOption can either be a datum hash or inline Plutus data.
enum DatumOptionType {
  /// [datumHash]: Represents a hash of the datum, typically used to refer to
  /// data that exists off-chain.
  datumHash(0),

  /// [data]: Represents actual inline datum stored on-chain.
  data(1);

  /// The value of the enum.
  final int value;

  const DatumOptionType(this.value);
}

/// Abstract base class representing a datum in a Cardano transaction output.
/// A datum is a piece of data that can be either a hash or inline plutus data.
///
/// Implementations of this class must provide a way to encode the datum into
/// a CBOR.
sealed class Datum extends Equatable implements CborEncodable {
  const Datum();
}

/// Class representing an optional datum in a Cardano transaction output.
/// A [DatumOption] wraps a [Datum], which can either be a datum hash or direct
/// data as inline datum.
///
/// This class is used to support additional features in transaction outputs
/// that were introduced in Cardano after the Alonzo hard fork.
final class DatumOption extends Datum {
  /// The actual datum wrapped by this [DatumOption].
  final Datum datum;

  /// Constructor for the [DatumOption] class, which requires a [Datum].
  const DatumOption(this.datum);

  /// Factory constructor to create a [DatumOption] from a CBOR-encoded value.
  /// The CBOR value is expected to be a list where the first element is the
  /// type (either datum hash or data) and the second element is the actual
  /// encoded datum.
  factory DatumOption.fromCbor(CborValue value) {
    if (value is CborList) {
      final type = DatumOptionType.values[(value[0] as CborSmallInt).toInt()];
      final datum = switch (type) {
        DatumOptionType.datumHash => DatumHash.fromCbor(value[1]),
        DatumOptionType.data => Data.fromCbor(value[1]),
      };
      return DatumOption(datum);
    } else {
      throw ArgumentError.value(
        value,
        'value',
        'Expected DatumOption as CborList',
      );
    }
  }

  /// Converts the [DatumOption] to a CBOR-encoded value.
  /// The CBOR list contains an index indicating the type and the encoded datum.
  @override
  CborValue toCbor() {
    final index = switch (datum) {
      DatumHash _ => DatumOptionType.datumHash,
      Data _ => DatumOptionType.data,
      _ => throw ArgumentError.value(datum, 'datum', 'Invalid datum type'),
    };
    return CborList([CborSmallInt(index.value), datum.toCbor()]);
  }

  @override
  List<Object?> get props => [datum];
}

/// Class representing a datum hash in Cardano.
/// A [DatumHash] is a type of [Datum] that contains a cryptographic hash, which
/// refers to data stored off-chain.
///
/// This is useful when you need to reference data without including the actual
/// data in the transaction output.
final class DatumHash extends Datum {
  // TODO(ilap): Add length constraint and/or implement proper hash type.
  /// Byte array representing the cryptographic hash.
  final Uint8List hash;

  /// Constructor for the [DatumHash] class, which requires a hash.
  const DatumHash(this.hash);

  /// Converts the [DatumHash] to a CBOR-encoded value.
  /// The CBOR value is a byte string representing the hash.
  @override
  CborValue toCbor() => CborBytes(hash);

  @override
  List<Object?> get props => [hash];

  /// Factory constructor to create a [DatumHash] from a CBOR-encoded value.
  /// The CBOR value is expected to be a byte string.
  factory DatumHash.fromCbor(CborValue value) {
    if (value is CborBytes) {
      return DatumHash(Uint8List.fromList(value.bytes));
    }
    throw ArgumentError.value(value, 'value', 'Expected valid CborBytes');
  }
}

/// Class representing data in a Cardano transaction output.
/// The [Data] class is a type of [Datum] that contains actual data stored
/// on-chain.
///
/// This is useful when you want to include data directly in the transaction
/// output.
final class Data extends Datum {
  // TODO(ilap): Requires a proper plutus data type implementation.
  /// CBOR-encoded data associated with this [Data] object.
  final CborValue data;

  /// Constructor for the [Data] class, which requires CBOR-encoded data.
  const Data(this.data);

  /// Override of the [Equatable] properties for value comparison.
  /// This allows comparing [Data] instances based on their [data] values.
  @override
  List<Object?> get props => [data];

  /// The CBOR value represents the actual data.
  @override
  CborValue toCbor() => data;

  /// Factory constructor to create a [Data] from a CBOR-encoded value.
  factory Data.fromCbor(CborValue value) => Data(value);
}

/// Abstract base class representing a transaction output in Cardano.
/// A [ShelleyMultiAssetTransactionOutput] defines the destination address
/// and the amount of cryptocurrency being sent to that address.
///
/// There are different implementations of Cardano's
/// TransactionOutputs depending on the era.
/// This class provides common functionality for both types.
///
/// > Note: It does not support pure Shelley era outputs i.e. output with only
/// pure coin (int) type as amount.
sealed class ShelleyMultiAssetTransactionOutput extends Equatable
    implements CborEncodable {
  /// The destination address for the output.
  final ShelleyAddress address;

  /// The amount of cryptocurrency being sent to the address.
  final Balance amount;

  /// Constructor for the [ShelleyMultiAssetTransactionOutput] class, requiring
  /// an address and amount.
  const ShelleyMultiAssetTransactionOutput({
    required this.address,
    required this.amount,
  });

  @override
  List<Object?> get props => [address, amount];

  /// Abstract method for copying a transaction output with optional new values.
  /// Subclasses must implement this method to allow for creating modified
  /// copies of existing transaction outputs.
  ShelleyMultiAssetTransactionOutput copyWith({
    ShelleyAddress? address,
    Balance? amount,
  });
}

/// Class representing a transaction output from the Pre-Babbage era in Cardano.
/// A [PreBabbageTransactionOutput] contains a datum hash, which refers to data
/// stored off-chain. This type of transaction output is used in Cardano before
/// the Babbage era.
///
/// This class is primarily used for basic transaction outputs that do not
/// include advanced features like script references or inline data.
final class PreBabbageTransactionOutput
    extends ShelleyMultiAssetTransactionOutput {
  /// Optional datum hash associated with the transaction output.
  /// The datum hash is a cryptographic hash that refers to off-chain data.
  final DatumHash? datumHash;

  /// Constructor for the [PreBabbageTransactionOutput] class.
  /// Requires an address, amount, and optionally a datum hash.
  const PreBabbageTransactionOutput({
    required super.address,
    required super.amount,
    this.datumHash,
  });

  /// Factory constructor to create a [PreBabbageTransactionOutput] from a CBOR
  /// encoded list.
  /// The CBOR list should contain the address, amount, and optionally the datum
  /// hash.
  factory PreBabbageTransactionOutput._fromCborList(CborList list) {
    final address = ShelleyAddress.fromCbor(list[0]);
    final amount = Balance.fromCbor(list[1]);
    final datumHash = list.length > 2
        ? DatumHash(Uint8List.fromList((list[2] as CborBytes).bytes))
        : null;

    return PreBabbageTransactionOutput(
      address: address,
      amount: amount,
      datumHash: datumHash,
    );
  }

  /// Converts the [PreBabbageTransactionOutput] to a CBOR-encoded value.
  /// The CBOR list contains the address, amount, and optionally the datum hash.
  @override
  CborValue toCbor() {
    final list = CborList([
      address.toCbor(),
      amount.toCbor(),
      if (datumHash != null) datumHash!.toCbor(),
    ]);
    return list;
  }

  /// Method for creating a copy of the [PreBabbageTransactionOutput] with
  /// optional new values.
  /// This is useful for modifying existing transaction outputs without creating
  /// a new instance from scratch.
  @override
  PreBabbageTransactionOutput copyWith({
    ShelleyAddress? address,
    Balance? amount,
    DatumHash? datumHash,
  }) {
    return PreBabbageTransactionOutput(
      address: address ?? this.address,
      amount: amount ?? this.amount,
      datumHash: datumHash ?? this.datumHash,
    );
  }

  /// Override of the [Equatable] properties for value comparison.
  /// This allows comparing [PreBabbageTransactionOutput] instances based on
  /// their address, amount, and optional datum hash.
  @override
  List<Object?> get props => [address, amount, datumHash];
}

/// Class representing a transaction output from the Post-Alonzo era in Cardano.
/// A [TransactionOutput] can include additional fields like a datum option
/// and a script reference, supporting advanced features introduced after the
/// Alonzo hard fork.
///
/// This class is used for creating transaction outputs with inline data or
/// references to
/// on-chain scripts.
/// > **Note**: In default, the latest era's transaction output is the
/// > [TransactionOutput] class.
final class TransactionOutput extends ShelleyMultiAssetTransactionOutput {
  /// Optional datum option associated with the transaction output.
  /// This can be either a datum hash (referencing off-chain data) or inline
  /// data (stored on-chain).
  final DatumOption? datumOption;

  /// Optional script reference associated with the transaction output.
  /// The script reference allows for including a reference to a script in the
  /// transaction output.
  final ScriptRef? scriptRef;

  /// Constructor for the [TransactionOutput] class.
  /// Requires an address, amount, and optionally a datum option and script
  /// reference.
  const TransactionOutput({
    required super.address,
    required super.amount,
    this.datumOption,
    this.scriptRef,
  });

  /// Factory constructor to create a [ShelleyMultiAssetTransactionOutput]
  /// from a CBOR-encoded value.
  /// Depending on the structure of the CBOR value, it returns either a
  /// [PreBabbageTransactionOutput] or [TransactionOutput].
  static ShelleyMultiAssetTransactionOutput fromCbor(CborValue value) {
    try {
      return switch (value) {
        CborList _ => PreBabbageTransactionOutput._fromCborList(value),
        CborMap _ => TransactionOutput._fromCborMap(value),
        _ => throw ArgumentError('Invalid CBOR value for TransactionOutput'),
      };
    } catch (e) {
      throw ArgumentError(
        'Failed to decode ShelleyMultiAssetTransactionOutput: $e',
      );
    }
  }

  /// Factory constructor to create a [TransactionOutput] from a CBOR map.
  /// The CBOR map should contain the address, amount, and optionally the datum
  /// option and script reference.
  factory TransactionOutput._fromCborMap(CborMap map) {
    final address = ShelleyAddress.fromCbor(map[const CborSmallInt(0)]!);
    final amount = Balance.fromCbor(map[const CborSmallInt(1)]!);
    final datumOption = map[const CborSmallInt(2)] != null
        ? DatumOption.fromCbor(map[const CborSmallInt(2)]!)
        : null;
    final scriptRef = map[const CborSmallInt(3)] != null
        ? ScriptRef.fromCbor(map[const CborSmallInt(3)]!)
        : null;

    return TransactionOutput(
      address: address,
      amount: amount,
      datumOption: datumOption,
      scriptRef: scriptRef,
    );
  }

  /// Converts the [TransactionOutput] to a CBOR-encoded value.
  /// The CBOR map contains the address, amount, and optionally the datum option
  /// and script reference.
  @override
  CborValue toCbor() {
    final map = CborMap({
      const CborSmallInt(0): address.toCbor(),
      const CborSmallInt(1): amount.toCbor(),
    });

    if (datumOption != null) {
      map[const CborSmallInt(2)] = datumOption!.toCbor();
    }

    if (scriptRef != null) {
      map[const CborSmallInt(3)] = scriptRef!.toCbor();
    }

    return map;
  }

  @override
  TransactionOutput copyWith({
    ShelleyAddress? address,
    Balance? amount,
    DatumOption? datumOption,
    ScriptRef? scriptRef,
  }) {
    return TransactionOutput(
      address: address ?? this.address,
      amount: amount ?? this.amount,
      datumOption: datumOption ?? this.datumOption,
      scriptRef: scriptRef ?? this.scriptRef,
    );
  }

  @override
  List<Object?> get props => [address, amount, datumOption, scriptRef];
}
