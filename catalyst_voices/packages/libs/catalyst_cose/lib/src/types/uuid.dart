import 'dart:typed_data';

import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart' as uuid;

/// A reference to an entity represented by the [id].
/// Optionally the version of the entity may be specified by the [ver].
///
/// What this uuid means depends where and how the class is used.
/// In CDDL it is defined as (UUID / [UUID, UUID]).
final class ReferenceUuid extends Equatable {
  /// The referenced entity uuid.
  final Uuid id;

  /// The version of the referenced entity.
  final Uuid? ver;

  /// The default constructor for the [ReferenceUuid].
  const ReferenceUuid({
    required this.id,
    this.ver,
  });

  /// Deserializes the type from cbor.
  factory ReferenceUuid.fromCbor(CborValue value) {
    if (value is CborList) {
      return ReferenceUuid(
        id: Uuid.fromCbor(value[0]),
        ver: Uuid.fromCbor(value[1]),
      );
    } else {
      return ReferenceUuid(
        id: Uuid.fromCbor(value),
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

/// A reference to an entity represented by the [ref].
/// Optionally the version of the entity may be specified by the [hash].
///
/// What this uuid means depends where and how the class is used.
/// In CDDL it is defined as (UUID / [UUID, UUID]).
final class ReferenceUuidHash extends Equatable {
  /// The referenced entity uuid.
  final ReferenceUuid ref;

  /// The version of the referenced entity.
  final Uint8List hash;

  /// The default constructor for the [ReferenceUuidHash].
  const ReferenceUuidHash({
    required this.ref,
    required this.hash,
  });

  /// Deserializes the type from cbor.
  factory ReferenceUuidHash.fromCbor(CborValue value) {
    final list = value as CborList;

    return ReferenceUuidHash(
      ref: ReferenceUuid.fromCbor(list[0]),
      hash: Uint8List.fromList((list[1] as CborBytes).bytes),
    );
  }

  @override
  List<Object?> get props => [ref, hash];

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      ref.toCbor(),
      CborBytes(hash),
    ]);
  }
}

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
