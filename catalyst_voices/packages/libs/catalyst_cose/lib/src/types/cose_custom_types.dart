import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/src/types/cose_uuid.dart';
import 'package:catalyst_cose/src/utils/cbor_deterministic_utils.dart';
import 'package:cbor/cbor.dart';

/// UTF-8 Catalyst ID URI encoded as a bytes string.
extension type const CatalystIdKid(Uint8List bytes) {
  /// Deserializes the type from cbor.
  factory CatalystIdKid.fromCbor(CborValue value) {
    return CatalystIdKid(Uint8List.fromList((value as CborBytes).bytes));
  }

  /// Creates a new [CatalystIdKid] from [string].
  factory CatalystIdKid.fromString(String string) {
    return CatalystIdKid(utf8.encode(string));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);
}

/// Allowed Collaborators on the next subsequent version of a document.
extension type const CoseCollaborators(List<CatalystIdKid> list) {
  /// Deserializes the type from cbor.
  factory CoseCollaborators.fromCbor(CborValue value) {
    final list = value as CborList;
    return CoseCollaborators(list.map(CatalystIdKid.fromCbor).toList());
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborDeterministicUtils.createList(
      list.map((e) => e.toCbor()).toList(),
    );
  }
}

/// Document ID.
extension type const CoseDocumentId(CoseUuidV7 value) {
  /// Deserializes the type from cbor.
  factory CoseDocumentId.fromCbor(CborValue value) {
    return CoseDocumentId(CoseUuidV7.fromCbor(value));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => value.toCbor();
}

/// Document Type.
extension type const CoseDocumentType(CoseUuidV4 value) {
  /// Deserializes the type from cbor.
  factory CoseDocumentType.fromCbor(CborValue value) {
    return CoseDocumentType(CoseUuidV4.fromCbor(value));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => value.toCbor();
}

/// Document Version.
extension type const CoseDocumentVer(CoseUuidV7 value) {
  /// Deserializes the type from cbor.
  factory CoseDocumentVer.fromCbor(CborValue value) {
    return CoseDocumentVer(CoseUuidV7.fromCbor(value));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return value.toCbor();
  }
}

/// RFC6901 Standard JSON Pointer
extension type const CoseJsonPointer(String text) {
  /// Deserializes the type from cbor.
  CoseJsonPointer.fromCbor(CborValue value) : this(((value as CborString).toString()));

  /// Serializes the type as cbor.
  CborValue toCbor() => CborString(text);
}

/// Reference to a section in a referenced document.
extension type const CoseSectionRef(CoseJsonPointer value) {
  /// Deserializes the type from cbor.
  CoseSectionRef.fromCbor(CborValue value) : this(CoseJsonPointer.fromCbor(value));

  /// Serializes the type as cbor.
  CborValue toCbor() => value.toCbor();
}
