import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// A union type for either a string or int.
///
/// In CDDL it's defined as (tstr/int) or (int/tstr).
sealed class StringOrInt extends Equatable {
  const StringOrInt();

  /// Deserializes the type from cbor.
  factory StringOrInt.fromCbor(CborValue value) {
    if (value is CborString) {
      return StringValue.fromCbor(value);
    } else {
      return IntValue.fromCbor(value);
    }
  }

  /// Serializes the type as cbor.
  CborValue toCbor();
}

/// The int value of [StringOrInt].
final class IntValue extends StringOrInt {
  /// The int value of the [StringOrInt] union.
  final int value;

  /// The default constructor for [IntValue].
  const IntValue(this.value);

  /// Deserializes the type from cbor.
  factory IntValue.fromCbor(CborValue value) {
    return IntValue((value as CborSmallInt).value);
  }

  @override
  CborValue toCbor() => CborSmallInt(value);

  @override
  List<Object?> get props => [value];
}

/// The string value of [StringOrInt].
final class StringValue extends StringOrInt {
  /// The string value of the [StringOrInt] union.
  final String value;

  /// The default constructor for [StringValue].
  const StringValue(this.value);

  /// Deserializes the type from cbor.
  factory StringValue.fromCbor(CborValue value) {
    return StringValue((value as CborString).toString());
  }

  @override
  CborValue toCbor() => CborString(value);

  @override
  List<Object?> get props => [value];
}
