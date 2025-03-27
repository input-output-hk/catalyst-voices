import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// The field is absent, meaning the field should be unset (deleted).
final class AbsentRbacField<T extends CborEncodable> extends RbacField<T> {
  /// The default constructor for the [AbsentRbacField].
  const AbsentRbacField();

  @override
  List<Object?> get props => [];

  @override
  CborValue toCbor({List<int> tags = const []}) => const CborUndefined(
        tags: [CborCustomTags.absent],
      );
}

/// The field is defined, meaning it should be updated to the [value].
final class DefinedRbacField<T extends CborEncodable> extends RbacField<T> {
  /// The value to which the field will be updated.
  final T value;

  /// The default constructor for the [DefinedRbacField].
  const DefinedRbacField(this.value);

  @override
  List<Object?> get props => [value];

  @override
  CborValue toCbor({List<int> tags = const []}) => value.toCbor(tags: tags);
}

/// Represents a field which may have three states:
/// - [AbsentRbacField] - when the field should be unset (deleted).
/// - [UndefinedRbacField] - when the field should not be modified.
/// - [DefinedRbacField] - when the field should be updated with the
/// given value.
sealed class RbacField<T extends CborEncodable> extends Equatable
    implements CborEncodable {
  /// The default constructor for the [RbacField].
  const RbacField();

  /// Deserializes the type from cbor.
  factory RbacField.fromCbor(
    CborValue value, {
    required T Function(CborValue value) fromCbor,
  }) {
    if (value is CborUndefined) {
      if (value.tags.contains(CborCustomTags.absent)) {
        return const AbsentRbacField();
      } else {
        return const UndefinedRbacField();
      }
    }

    return DefinedRbacField(fromCbor(value));
  }

  /// See [DefinedRbacField].
  const factory RbacField.set(T value) = DefinedRbacField;

  /// See [UndefinedRbacField].
  const factory RbacField.undefined() = UndefinedRbacField;

  /// See [AbsentRbacField].
  const factory RbacField.unset() = AbsentRbacField;

  /// Serializes the type as cbor.
  /// The [tags] are only used for [DefinedRbacField].
  @override
  CborValue toCbor({List<int> tags = const []});
}

/// The field is undefined, meaning it should not be modified.
final class UndefinedRbacField<T extends CborEncodable> extends RbacField<T> {
  /// The default constructor for the [UndefinedRbacField].
  const UndefinedRbacField();

  @override
  List<Object?> get props => [];

  @override
  CborValue toCbor({List<int> tags = const []}) => const CborUndefined();
}
