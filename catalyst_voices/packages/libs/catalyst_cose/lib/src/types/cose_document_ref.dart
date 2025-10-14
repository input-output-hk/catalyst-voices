import 'dart:typed_data';

import 'package:catalyst_cose/src/types/cose_uuid.dart';
import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

final class CoseDocumentLocator extends Equatable {
  final Uint8List cid;

  const CoseDocumentLocator({required this.cid});

  CoseDocumentLocator.fallback() : this(cid: Uint8List(0));

  factory CoseDocumentLocator.fromCbor(CborValue value) {
    final map = value as CborMap;
    final cid = map[CborString('cid')]! as CborBytes;

    return CoseDocumentLocator(cid: Uint8List.fromList(cid.bytes));
  }

  @override
  List<Object?> get props => [cid];

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

  factory CoseDocumentRef.fromCbor(CborValue value) {
    final list = value as CborList;

    return CoseDocumentRef.backwardCompatible(
      documentId: CoseUuid.fromCbor(list[0]),
      documentVer: CoseUuid.fromCbor(list[1]),
      documentLocator: CoseDocumentLocator.fromCbor(list[2]),
    );
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

  CborValue toCbor() {
    return CborList([
      documentId.toCbor(),
      if (documentVer case final documentVer?) documentVer.toCbor(),
      if (documentLocator case final documentLocator) documentLocator.toCbor(),
    ]);
  }
}

final class CoseDocumentRefs extends Equatable {
  final List<CoseDocumentRef> refs;

  CoseDocumentRefs(this.refs)
    : assert(
        refs.isNotEmpty,
        'refs must contain at least one item',
      );

  factory CoseDocumentRefs.fromCbor(CborValue value) {
    final list = value as CborList;

    return CoseDocumentRefs(list.map(CoseDocumentRef.fromCbor).toList());
  }

  @override
  List<Object?> get props => [refs];

  CborValue toCbor() {
    return CborList(refs.map((e) => e.toCbor()).toList());
  }
}
