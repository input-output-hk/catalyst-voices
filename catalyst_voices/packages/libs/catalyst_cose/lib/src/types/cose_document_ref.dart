import 'dart:typed_data';

import 'package:catalyst_cose/src/exception/cose_format_exception.dart';
import 'package:catalyst_cose/src/types/cose_uuid.dart';
import 'package:catalyst_cose/src/utils/cbor_deterministic_utils.dart';
import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// Where a document can be located, must be a unique identifier.
final class CoseDocumentLocator extends Equatable {
  /// IPLD content identifier.
  final Uint8List cid;

  /// The default constructor for the [CoseDocumentLocator].
  const CoseDocumentLocator({required this.cid});

  /// A constructor with default values for [CoseDocumentLocator].
  CoseDocumentLocator.fallback() : this(cid: Uint8List(0));

  /// Deserializes the type from cbor.
  factory CoseDocumentLocator.fromCbor(CborValue value) {
    final map = value as CborMap;
    final cid = map[CborString('cid')]! as CborBytes;

    return CoseDocumentLocator(cid: Uint8List.fromList(cid.bytes));
  }

  @override
  List<Object?> get props => [cid];

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborMap({
      CborString('cid'): CborBytes(cid, tags: [CborUtils.cidTag]),
    });
  }
}

/// Reference to a single Signed Document.
final class CoseDocumentRef extends Equatable {
  /// A document id.
  final CoseUuidV7 documentId;

  /// A document version.
  ///
  /// If the document doesn't have any versions then [documentVer] == [documentId].
  final CoseUuidV7 documentVer;

  /// Where a document can be located, must be a unique identifier.
  final CoseDocumentLocator documentLocator;

  /// A latest spec version of the [CoseDocumentRef] constructor.
  const CoseDocumentRef({
    required CoseUuidV7 documentId,
    required CoseUuidV7 documentVer,
    required CoseDocumentLocator documentLocator,
  }) : this._(
         documentId: documentId,
         documentVer: documentVer,
         documentLocator: documentLocator,
       );

  /// Deserializes the type from cbor.
  factory CoseDocumentRef.fromCbor(CborValue value) {
    if (value is! CborList) {
      return CoseDocumentRef.optional(
        documentId: CoseUuidV7.fromCbor(value),
      );
    } else {
      final documentId = value.elementAtOrNull(0)!;
      final documentVer = value.elementAtOrNull(1);
      final documentLocator = value.elementAtOrNull(2);

      return CoseDocumentRef.optional(
        documentId: CoseUuidV7.fromCbor(documentId),
        documentVer: documentVer != null ? CoseUuidV7.fromCbor(documentVer) : null,
        documentLocator: documentLocator != null
            ? CoseDocumentLocator.fromCbor(documentLocator)
            : null,
      );
    }
  }

  /// A constructor for [CoseDocumentRef] which assigns default, backward compatible values.
  CoseDocumentRef.optional({
    required CoseUuidV7 documentId,
    CoseUuidV7? documentVer,
    CoseDocumentLocator? documentLocator,
  }) : this._(
         documentId: documentId,
         documentVer: documentVer ?? documentId,
         documentLocator: documentLocator ?? CoseDocumentLocator.fallback(),
       );

  const CoseDocumentRef._({
    required this.documentId,
    required this.documentVer,
    required this.documentLocator,
  });

  @override
  List<Object?> get props => [documentId, documentVer, documentLocator];

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList([
      documentId.toCbor(),
      documentVer.toCbor(),
      documentLocator.toCbor(),
    ]);
  }
}

/// A reference to the Parameters Document this document lies under.
extension type const CoseDocumentRefs._(List<CoseDocumentRef> refs) {
  /// The default constructor for the [CoseDocumentRefs].
  factory CoseDocumentRefs(List<CoseDocumentRef> refs) {
    if (refs.isEmpty) {
      throw const CoseFormatException('CoseDocumentRefs must contain at least one item');
    }

    return CoseDocumentRefs._(refs);
  }

  /// Deserializes the type from cbor.
  factory CoseDocumentRefs.fromCbor(CborValue value) {
    value = _migrateCbor1(value);
    value = _migrateCbor2(value);

    final list = value as CborList;
    return CoseDocumentRefs(list.map(CoseDocumentRef.fromCbor).toList());
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborDeterministicUtils.createList(
      refs.map((e) => e.toCbor()).toList(),
    );
  }

  /// Pre v0.0.1 spec, the document ref was just a string representing the documentId, not documented.
  static CborValue _migrateCbor1(CborValue value) {
    if (value is CborBytes) {
      final documentId = CoseUuidV7.fromCbor(value);

      return CoseDocumentRef.optional(documentId: documentId).toCbor();
    }

    return value;
  }

  /// v0.0.1 -> v0.0.4 spec: https://github.com/input-output-hk/catalyst-libs/pull/341/files#diff-2827956d681587dfd09dc733aca731165ff44812f8322792bf6c4a61cf2d3b85
  static CborValue _migrateCbor2(CborValue value) {
    if (value is CborList && value.firstOrNull is CborBytes) {
      final documentRef = CoseDocumentRef.fromCbor(value);
      return CoseDocumentRefs([documentRef]).toCbor();
    }

    return value;
  }
}
