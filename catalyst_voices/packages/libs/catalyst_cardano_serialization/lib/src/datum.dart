import 'dart:typed_data';
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

  /// Factory constructor to create a [DatumHash] from a CBOR-encoded value.
  /// The CBOR value is expected to be a byte string.
  factory DatumHash.fromCbor(CborValue value) {
    if (value is CborBytes) {
      return DatumHash(Uint8List.fromList(value.bytes));
    }
    throw ArgumentError.value(value, 'value', 'Expected valid CborBytes');
  }

  /// Converts the [DatumHash] to a CBOR-encoded value.
  /// The CBOR value is a byte string representing the hash.
  @override
  CborValue toCbor() => CborBytes(hash);

  @override
  List<Object?> get props => [hash];
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

  /// Factory constructor to create a [Data] from a CBOR-encoded value.
  factory Data.fromCbor(CborValue value) => Data(value);

  /// The CBOR value represents the actual data.
  @override
  CborValue toCbor() => data;

  /// Override of the [Equatable] properties for value comparison.
  /// This allows comparing [Data] instances based on their [data] values.
  @override
  List<Object?> get props => [data];
}
