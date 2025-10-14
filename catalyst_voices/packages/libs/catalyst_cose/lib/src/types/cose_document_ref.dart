import 'dart:typed_data';

import 'package:catalyst_cose/src/types/cose_uuid.dart';
import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

final class CoseDocumentLocator extends Equatable {
  final Uint8List cid;

  const CoseDocumentLocator({required this.cid});

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

final class CoseDocumentRef extends Equatable {
  final CoseUuid documentId;
  final CoseUuid documentVer;
  final CoseDocumentLocator documentLocator;

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

final class CoseDocumentRefs extends Equatable {
  final List<CoseDocumentRef> refs;

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
