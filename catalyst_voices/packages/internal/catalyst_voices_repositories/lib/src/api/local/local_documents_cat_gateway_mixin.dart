import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/api/local/fixture/fixtures.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_list_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_query_filters_dto.dart';
import 'package:cbor/cbor.dart';
import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:uuid_plus/uuid_plus.dart' as u;

String _v7() {
  return const u.Uuid().v7();
}

mixin LocalDocumentsCatGatewayMixin implements CatGateway {
  final _cache = <String, List<SignedDocumentMetadata>>{};

  @override
  Future<Response<String>> apiGatewayV1DocumentDocumentIdGet({
    required String? documentId,
    String? version,
    dynamic authorization,
    dynamic contentType,
  }) async {
    if (documentId == null || !_cache.containsKey(documentId)) {
      return Response(http.Response.bytes([], 404), '');
    }

    final versions = _cache[documentId]!;
    final metadata = version != null
        ? versions.firstWhereOrNull((e) => e.ver == version)
        : versions.last;
    if (metadata == null) {
      return Response(http.Response.bytes([], 404), '');
    }

    final protectedHeaders = CoseHeaders.protected(
      contentType: const IntValue(CoseValues.jsonContentType),
      contentEncoding: const StringValue(CoseValues.brotliContentEncoding),
      type: metadata.documentType.uuid.asCose,
      id: metadata.id!.asCose,
      ver: metadata.ver!.asCose,
      ref: metadata.ref?.asCose,
      template: metadata.template?.asCose,
      reply: metadata.reply?.asCose,
      categoryId: metadata.categoryId?.asCose,
    );

    final payload = switch (metadata.documentType) {
      DocumentType.proposalDocument => compressedProposalPayload,
      DocumentType.proposalTemplate => compressedProposalTemplatePayload,
      DocumentType.commentDocument => compressedCommentPayload,
      DocumentType.commentTemplate => compressedCommentTemplatePayload,
      DocumentType.proposalActionDocument => compressedProposalActionFinalPayload,
      DocumentType.reviewDocument ||
      DocumentType.reviewTemplate ||
      DocumentType.categoryParametersDocument ||
      DocumentType.categoryParametersTemplate ||
      DocumentType.campaignParametersDocument ||
      DocumentType.campaignParametersTemplate ||
      DocumentType.brandParametersDocument ||
      DocumentType.brandParametersTemplate ||
      DocumentType.unknown => throw UnimplementedError(),
    };

    final coseSign = CoseSign(
      protectedHeaders: protectedHeaders,
      unprotectedHeaders: const CoseHeaders.unprotected(),
      payload: payload,
      signatures: [
        CoseSignature(
          protectedHeaders: CoseHeaders.protected(
            kid: utf8.encode(
              'id.catalyst://john@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
            ),
          ),
          unprotectedHeaders: const CoseHeaders.unprotected(),
          signature: Uint8List.fromList([]),
        ),
      ],
    );

    final bytes = Uint8List.fromList(cbor.encode(coseSign.toCbor(tagged: false)));

    return Response(http.Response.bytes(bytes, 200), '');
  }

  @override
  Future<Response<DocumentIndexList>> apiGatewayV1DocumentIndexPost({
    int? page,
    int? limit,
    dynamic authorization,
    dynamic contentType,
    required DocumentIndexQueryFilter? body,
  }) async {
    page ??= 0;
    limit ??= 10;

    if (_cache.isEmpty) {
      await _populate();
    }

    final id = body?.id as EqOrRangedIdDto?;
    final eq = id?.eq;
    if (eq != null) {
      final versions = _cache[eq] ?? [];
      return Response(
        http.Response('{}', 200),
        DocumentIndexList(
          docs: [versions.asIndex(eq)],
          page: CurrentPage(
            page: page,
            limit: limit,
            remaining: 0,
          ),
        ),
      );
    }

    final docs = _cache.entries
        .skip(page * limit)
        .take(limit)
        .map((e) => e.value.asIndex(e.key))
        .map((e) => e.toJson())
        .toList();

    final currentPage = CurrentPage(
      page: page,
      limit: limit,
      remaining: _cache.length - (page * limit + docs.length),
    );

    final rBody = DocumentIndexList(
      docs: docs,
      page: currentPage,
    );
    return Response(http.Response('{}', 200), rBody);
  }

  @override
  Future<Response<dynamic>> apiGatewayV1DocumentPut({
    dynamic authorization,
    dynamic contentType,
    required Object? body,
  }) async {
    return Response(http.Response('{}', 200), 'ok');
  }

  Future<void> _populate() async {
    for (final constRefs in constantDocumentsRefs) {
      _cache[constRefs.proposal.id] = [
        SignedDocumentMetadata(
          contentType: SignedDocumentContentType.json,
          documentType: DocumentType.proposalTemplate,
          id: constRefs.proposal.id,
          ver: constRefs.proposal.version,
          categoryId: constRefs.category.asMetadataRef,
        ),
      ];

      _cache[constRefs.comment.id] = [
        SignedDocumentMetadata(
          contentType: SignedDocumentContentType.json,
          documentType: DocumentType.commentTemplate,
          id: constRefs.comment.id,
          ver: constRefs.comment.version,
          categoryId: constRefs.category.asMetadataRef,
        ),
      ];
    }

    for (var i = 0; i < 10; i++) {
      final id = _v7();
      _cache[id] = [
        SignedDocumentMetadata(
          contentType: SignedDocumentContentType.json,
          documentType: DocumentType.proposalDocument,
          id: id,
          ver: id,
          template: constantDocumentsRefs.first.proposal.asMetadataRef,
          categoryId: constantDocumentsRefs.first.category.asMetadataRef,
        ),
      ];
    }
  }
}

extension on SignedDocumentMetadataRef {
  ReferenceUuid get asCose => ReferenceUuid(
    id: id.asCose,
    ver: ver?.asCose,
  );

  DocumentRefForFilteredDocuments get asIndex {
    return DocumentRefForFilteredDocuments(id: id, ver: ver);
  }
}

extension on String {
  Uuid get asCose => Uuid(this);
}

extension on SignedDocumentMetadata {
  IndividualDocumentVersion get asIndex {
    return IndividualDocumentVersion(
      ver: ver!,
      type: documentType.uuid,
      ref: ref?.asIndex,
      reply: reply?.asIndex,
      template: template?.asIndex,
      category: categoryId?.asIndex,
    );
  }
}

extension on List<SignedDocumentMetadata> {
  DocumentIndexListDto asIndex(String id) {
    return DocumentIndexListDto(
      id: id,
      ver: map((e) => e.asIndex).toList(),
    );
  }
}

extension on SignedDocumentRef {
  SignedDocumentMetadataRef get asMetadataRef {
    return SignedDocumentMetadataRef(id: id, ver: version);
  }
}
