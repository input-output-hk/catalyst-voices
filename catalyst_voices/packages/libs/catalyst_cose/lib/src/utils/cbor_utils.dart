import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/src/types/string_or_int.dart';
import 'package:catalyst_cose/src/types/uuid.dart';
import 'package:cbor/cbor.dart';

/// A set of utils around cbor encoding/decoding.
final class CborUtils {
  const CborUtils._();

  /// A cbor tag for the UUID type.
  static const int uuidTag = 37;

  /// Deserializes optional [StringOrInt] type.
  static StringOrInt? deserializeStringOrInt(CborValue? value) {
    if (value == null) {
      return null;
    }

    return StringOrInt.fromCbor(value);
  }

  /// Deserializes optional [Uuid] type.
  static Uuid? deserializeUuid(CborValue? value) {
    if (value == null) {
      return null;
    }

    return Uuid.fromCbor(value);
  }

  /// Deserialized optional [ReferenceUuid] type.
  static ReferenceUuid? deserializeReferenceUuid(CborValue? value) {
    if (value == null) {
      return null;
    }

    return ReferenceUuid.fromCbor(value);
  }

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
