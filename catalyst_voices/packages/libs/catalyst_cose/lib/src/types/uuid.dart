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
    if (value is CborBytes) {
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

/// A reference to an entity represented by the [uuid].
/// Optionally the version of the entity may be specified by the [ver].
///
/// What this uuid means depends where and how the class is used.
/// In CDDL it is defined as (UUID / [UUID, UUID]).
final class ReferenceUuid extends Equatable {
  /// The referenced entity uuid.
  final Uuid uuid;

  /// The version of the referenced entity.
  final Uuid? ver;

  /// The default constructor for the [ReferenceUuid].
  const ReferenceUuid({
    required this.uuid,
    this.ver,
  });

  /// Deserializes the type from cbor.
  factory ReferenceUuid.fromCbor(CborValue value) {
    if (value is CborList) {
      return ReferenceUuid(
        uuid: Uuid.fromCbor(value[0]),
        ver: Uuid.fromCbor(value[1]),
      );
    } else {
      return ReferenceUuid(
        uuid: Uuid.fromCbor(value),
      );
    }
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    final ver = this.ver;
    if (ver != null) {
      return CborList([
        uuid.toCbor(),
        ver.toCbor(),
      ]);
    } else {
      return uuid.toCbor();
    }
  }

  @override
  List<Object?> get props => [uuid, ver];
}
