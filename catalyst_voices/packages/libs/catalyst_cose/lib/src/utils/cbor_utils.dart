import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/src/types/cose_document_ref.dart';
import 'package:catalyst_cose/src/types/cose_uuid.dart';
import 'package:catalyst_cose/src/types/cose_string_or_int.dart';
import 'package:cbor/cbor.dart';

/// A set of utils around cbor encoding/decoding.
final class CborUtils {
  /// A cbor tag for the UUID type.
  static const int uuidTag = 37;

  /// A cbor tag for content identifiers (IPFS).
  static const int cidTag = 42;

  const CborUtils._();

  /// Deserializes optional [Uint8List] type.
  static Uint8List? deserializeBytes(CborValue? value) {
    if (value == null) {
      return null;
    }

    if (value is CborString) {
      return utf8.encode(value.toString());
    }

    return Uint8List.fromList((value as CborBytes).bytes);
  }

  static CoseDocumentRefs? deserializeDocumentRefs(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseDocumentRefs.fromCbor(value);
  }

  /// Deserialized optional [CoseReferenceUuid] type.
  static CoseReferenceUuid? deserializeReferenceUuid(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseReferenceUuid.fromCbor(value);
  }

  /// Deserializes optional [String] type.
  static String? deserializeString(CborValue? value) {
    if (value == null) {
      return null;
    }

    return (value as CborString).toString();
  }

  /// Deserializes optional `List<String>` type.
  static List<String>? deserializeStringList(CborValue? value) {
    if (value == null) {
      return null;
    }

    final list = value as CborList;
    return list.map((e) => (e as CborString).toString()).toList();
  }

  /// Deserializes optional [CoseStringOrInt] type.
  static CoseStringOrInt? deserializeStringOrInt(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseStringOrInt.fromCbor(value);
  }

  /// Deserializes optional [CoseUuid] type.
  static CoseUuid? deserializeUuid(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseUuid.fromCbor(value);
  }

  /// Serializes optional `List<String>` type.
  static CborValue serializeStringList(List<String>? values) {
    if (values == null) {
      return const CborNull();
    }

    return CborList([
      for (final value in values) CborString(value),
    ]);
  }
}
