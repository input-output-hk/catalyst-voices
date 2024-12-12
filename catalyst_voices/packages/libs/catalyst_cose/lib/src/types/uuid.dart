import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart' as uuid;

/// Represents the Uuid type.
///
/// Uuid v7 is preferred. The cbor representation
/// is tagged with a tag that defines the uuid type.
extension type const Uuid(String value) {
  /// Deserializes the type from cbor.
  factory Uuid.fromCbor(CborValue value) {
    if (value is CborBytes && value.tags.contains(CborUtils.uuidTag)) {
      return Uuid(uuid.Uuid.unparse(value.bytes));
    } else {
      throw FormatException('The $value is not a valid uuid!');
    }
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    final uuidBytes = uuid.Uuid.parse(value);
    return CborBytes(uuidBytes, tags: [CborUtils.uuidTag]);
  }
}

/// Either a single [Uuid] or two [Uuid]'s.
///
/// What this uuid means depends where and how the class is used.
/// In CDDL it is defined as (UUID / [UUID, UUID]).
sealed class ReferenceUuid extends Equatable {
  /// The default constructor for the [ReferenceUuid].
  const ReferenceUuid();

  /// Deserializes the type from cbor.
  factory ReferenceUuid.fromCbor(CborValue value) {
    if (value is CborList) {
      return DoubleReferenceUuid.fromCbor(value);
    } else {
      return SingleReferenceUuid.fromCbor(value);
    }
  }

  /// Serializes the type as cbor.
  CborValue toCbor();
}

/// A single [Uuid] reference.
final class SingleReferenceUuid extends ReferenceUuid {
  /// A single reference uuid.
  final Uuid uuid;

  /// A default constructor for the [SingleReferenceUuid].
  const SingleReferenceUuid(this.uuid);

  /// Deserializes the type from cbor.
  factory SingleReferenceUuid.fromCbor(CborValue value) {
    return SingleReferenceUuid(Uuid.fromCbor(value));
  }

  @override
  CborValue toCbor() {
    return uuid.toCbor();
  }

  @override
  List<Object?> get props => [uuid];
}

/// A single [Uuid] reference.
final class DoubleReferenceUuid extends ReferenceUuid {
  /// The first referenced uuid.
  final Uuid first;

  /// The second reference uuid.
  final Uuid second;

  /// A default constructor for the [DoubleReferenceUuid].
  const DoubleReferenceUuid(this.first, this.second);

  /// Deserializes the type from cbor.
  factory DoubleReferenceUuid.fromCbor(CborValue value) {
    if (value is! CborList || value.length != 2) {
      throw FormatException('Wrong format of the DoubleReferenceUuid: $value');
    }

    return DoubleReferenceUuid(
      Uuid.fromCbor(value[0]),
      Uuid.fromCbor(value[1]),
    );
  }

  @override
  CborValue toCbor() {
    return CborList([
      first.toCbor(),
      second.toCbor(),
    ]);
  }

  @override
  List<Object?> get props => [first, second];
}
