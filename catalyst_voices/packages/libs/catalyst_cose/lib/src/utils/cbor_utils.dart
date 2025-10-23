import 'dart:convert';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';

/// A set of utils around cbor encoding/decoding.
final class CborUtils {
  /// A cbor tag for the UUID type.
  static const int uuidTag = 37;

  /// A cbor tag for content identifiers (IPLD / IPFS).
  static const int cidTag = 42;

  const CborUtils._();

  /// Deserializes optional [CoseCollaborators] type.
  static CoseCollaborators? deserializeCollaborators(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseCollaborators.fromCbor(value);
  }

  /// Deserializes optional [CoseDocumentId] type.
  static CoseDocumentId? deserializeDocumentId(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseDocumentId.fromCbor(value);
  }

  /// Deserializes optional [CoseDocumentRefs] type.
  static CoseDocumentRefs? deserializeDocumentRefs(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseDocumentRefs.fromCbor(value);
  }

  /// Deserializes optional [CoseDocumentType] type.
  static CoseDocumentType? deserializeDocumentType(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseDocumentType.fromCbor(value);
  }

  /// Deserializes optional [CoseDocumentVer] type.
  static CoseDocumentVer? deserializeDocumentVer(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseDocumentVer.fromCbor(value);
  }

  /// Deserializes optional [CoseHttpContentEncoding] type.
  static CoseHttpContentEncoding? deserializeHttpContentEncoding(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseHttpContentEncoding.fromCbor(value);
  }

  /// Deserializes optional [CatalystIdKid] type.
  static CatalystIdKid? deserializeKid(CborValue? value) {
    if (value == null) {
      return null;
    }

    if (value is CborString) {
      return CatalystIdKid(utf8.encode(value.toString()));
    }

    return CatalystIdKid.fromCbor(value);
  }

  /// Deserializes optional [CoseMediaType] type.
  static CoseMediaType? deserializeMediaType(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseMediaType.fromCbor(value);
  }

  /// Deserializes optional [CoseSectionRef] type.
  static CoseSectionRef? deserializeSectionRef(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseSectionRef.fromCbor(value);
  }

  /// Deserializes optional [CoseStringOrInt] type.
  static CoseStringOrInt? deserializeStringOrInt(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseStringOrInt.fromCbor(value);
  }

  /// Deserializes optional [CoseUuidV4] type.
  static CoseUuidV4? deserializeUuidV4(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseUuidV4.fromCbor(value);
  }

  /// Deserializes optional [CoseUuidV7] type.
  static CoseUuidV7? deserializeUuidV7(CborValue? value) {
    if (value == null) {
      return null;
    }

    return CoseUuidV7.fromCbor(value);
  }
}
