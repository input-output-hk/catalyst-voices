import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// The int value of [CoseStringOrInt].
final class CoseIntValue extends CoseStringOrInt {
  /// The int value of the [CoseStringOrInt] union.
  final int value;

  /// The default constructor for [CoseIntValue].
  const CoseIntValue(this.value);

  /// Deserializes the type from cbor.
  factory CoseIntValue.fromCbor(CborValue value) {
    return CoseIntValue((value as CborSmallInt).value);
  }

  @override
  List<Object?> get props => [value];

  @override
  CborValue toCbor() => CborSmallInt(value);
}

/// A union type for either a string or int.
///
/// In CDDL it's defined as (tstr/int) or (int/tstr).
sealed class CoseStringOrInt extends Equatable {
  const CoseStringOrInt();

  /// Deserializes the type from cbor.
  factory CoseStringOrInt.fromCbor(CborValue value) {
    if (value is CborString) {
      return CoseStringValue.fromCbor(value);
    } else {
      return CoseIntValue.fromCbor(value);
    }
  }

  /// Serializes the type as cbor.
  CborValue toCbor();
}

/// The string value of [CoseStringOrInt].
final class CoseStringValue extends CoseStringOrInt {
  /// The string value of the [CoseStringOrInt] union.
  final String value;

  /// The default constructor for [CoseStringValue].
  const CoseStringValue(this.value);

  /// Deserializes the type from cbor.
  factory CoseStringValue.fromCbor(CborValue value) {
    return CoseStringValue((value as CborString).toString());
  }

  @override
  List<Object?> get props => [value];

  @override
  CborValue toCbor() => CborString(value);
}
