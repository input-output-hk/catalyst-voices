import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

// TODO(ilap): implement proper redeemer class, this is just a placeholder.
/// Class representing a redeemer in Cardano.
/// A Redeemer is a piece of data that is used to validate a plutus script in a
/// transaction.
final class Redeemer extends Equatable implements CborEncodable {
  /// redeemer placeholder,
  final CborValue redeemer;

  /// The default constructor for [Redeemer].
  const Redeemer({required this.redeemer});

  /// Factory constructor to create a [Redeemer] from a CBOR-encoded value.
  /// The CBOR value is expected to be a list or a map.
  factory Redeemer.fromCbor(CborValue value) => Redeemer(redeemer: value);

  /// Converts the [Redeemer] to a CBOR-encoded value.
  @override
  CborValue toCbor() => redeemer;

  @override
  List<Object?> get props => [redeemer];
}

// TODO(ilap): implement proper plutus data class, this is just a placeholder.
/// Class representing a script data in Cardano.
class ScriptData extends Equatable implements CborEncodable {
  /// script data placeholder,
  final CborValue data;

  /// The default constructor for [ScriptData].
  const ScriptData({required this.data});

  /// Factory constructor to create a [Redeemer] from a CBOR-encoded value.
  /// The CBOR value is expected to be a list or a map.
  factory ScriptData.fromCbor(CborValue data) => ScriptData(data: data);

  /// Converts the [ScriptData] to a CBOR-encoded value.
  @override
  CborValue toCbor() => data;

  @override
  List<Object?> get props => [data];
}
