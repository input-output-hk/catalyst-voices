import 'dart:typed_data';

import 'package:catalyst_cose/src/types/cose_uuid.dart';
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
  final CoseUuid documentId;

  /// A document version.
  ///
  /// If the document doesn't have any versions then [documentVer] == [documentId].
  final CoseUuid documentVer;

  /// Where a document can be located, must be a unique identifier.
  final CoseDocumentLocator documentLocator;

  /// A constructor for [CoseDocumentRef] which assigns default, backward compatible values.
  CoseDocumentRef.backwardCompatible({
    required CoseUuid documentId,
    CoseUuid? documentVer,
    CoseDocumentLocator? documentLocator,
  }) : this._(
         documentId: documentId,
         documentVer: documentVer ?? documentId,
         documentLocator: documentLocator ?? CoseDocumentLocator.fallback(),
       );

  /// Deserializes the type from cbor.
  factory CoseDocumentRef.fromCbor(CborValue value) {
    if (value is! CborList) {
      return CoseDocumentRef.backwardCompatible(
        documentId: CoseUuid.fromCbor(value),
      );
    } else {
      final documentId = value.elementAtOrNull(0)!;
      final documentVer = value.elementAtOrNull(1);
      final documentLocator = value.elementAtOrNull(2);

      return CoseDocumentRef.backwardCompatible(
        documentId: CoseUuid.fromCbor(documentId),
        documentVer: documentVer != null ? CoseUuid.fromCbor(documentVer) : null,
        documentLocator: documentLocator != null
            ? CoseDocumentLocator.fromCbor(documentLocator)
            : null,
      );
    }
  }

  /// A latest spec version of the [CoseDocumentRef] constructor.
  const CoseDocumentRef.latestSpec({
    required CoseUuid documentId,
    required CoseUuid documentVer,
    required CoseDocumentLocator documentLocator,
  }) : this._(
         documentId: documentId,
         documentVer: documentVer,
         documentLocator: documentLocator,
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
      if (documentVer case final documentVer?) documentVer.toCbor(),
      if (documentLocator case final documentLocator) documentLocator.toCbor(),
    ]);
  }

  /// Attemps to deserialize the type from cbor. Returns null if that fails.
  static CoseDocumentRef? tryFromCbor(CborValue value) {
    try {
      return CoseDocumentRef.fromCbor(value);
    } catch (_) {
      return null;
    }
  }
}

/// A reference to the Parameters Document this document lies under.
final class CoseDocumentRefs extends Equatable {
  /// References to documents that document is linked to, like brandId, categoryId or campaignId.
  final List<CoseDocumentRef> refs;

  /// The default constructor for the [CoseDocumentRefs].
  CoseDocumentRefs(this.refs)
    : assert(
        refs.isNotEmpty,
        'refs must contain at least one item',
      );

  /// Deserializes the type from cbor.
  factory CoseDocumentRefs.fromCbor(CborValue value) {
    final legacyRef = CoseDocumentRef.tryFromCbor(value);
    if (legacyRef != null) {
      return CoseDocumentRefs([legacyRef]);
    } else {
      final list = value as CborList;
      return CoseDocumentRefs(list.map(CoseDocumentRef.fromCbor).toList());
    }
  }

  @override
  List<Object?> get props => [refs];

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborList(refs.map((e) => e.toCbor()).toList());
  }
}
