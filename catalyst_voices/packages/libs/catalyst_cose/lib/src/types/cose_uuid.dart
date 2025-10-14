import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart' as uuid;

/// A reference to an entity represented by the [id].
/// Optionally the version of the entity may be specified by the [ver].
///
/// What this uuid means depends where and how the class is used.
/// In CDDL it is defined as (UUID / [UUID, UUID]).
///
// TODO(dt-iohk): the class should no longer be used.
// The fields which use this class should be migrated to "parameters"
final class CoseReferenceUuid extends Equatable {
  /// The referenced entity uuid.
  final CoseUuid id;

  /// The version of the referenced entity.
  final CoseUuid? ver;

  /// The default constructor for the [CoseReferenceUuid].
  const CoseReferenceUuid({
    required this.id,
    this.ver,
  });

  /// Deserializes the type from cbor.
  factory CoseReferenceUuid.fromCbor(CborValue value) {
    if (value is CborList) {
      return CoseReferenceUuid(
        id: CoseUuid.fromCbor(value[0]),
        ver: CoseUuid.fromCbor(value[1]),
      );
    } else {
      return CoseReferenceUuid(
        id: CoseUuid.fromCbor(value),
      );
    }
  }

  @override
  List<Object?> get props => [id, ver];

  /// Serializes the type as cbor.
  CborValue toCbor() {
    final ver = this.ver;
    if (ver != null) {
      return CborList([
        id.toCbor(),
        ver.toCbor(),
      ]);
    } else {
      return id.toCbor();
    }
  }
}

/// Represents the Uuid type.
///
/// Uuid v7 is preferred. The cbor representation
/// is tagged with a tag that defines the uuid type.
extension type const CoseUuid(String value) {
  /// Deserializes the type from cbor.
  factory CoseUuid.fromCbor(CborValue value) {
    if (value is CborBytes) {
      return CoseUuid(uuid.Uuid.unparse(value.bytes));
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
