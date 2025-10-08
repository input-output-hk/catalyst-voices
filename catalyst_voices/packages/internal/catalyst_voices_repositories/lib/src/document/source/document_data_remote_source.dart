import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_list_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_query_filters_dto.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

final class CatGatewayDocumentDataSource implements DocumentDataRemoteSource {
  @visibleForTesting
  static const indexPageSize = 200;

  final ApiServices _api;
  final SignedDocumentManager _signedDocumentManager;

  CatGatewayDocumentDataSource(
    this._api,
    this._signedDocumentManager,
  );

  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    final bytes = await _api.gateway
        .apiV1DocumentDocumentIdGet(
          documentId: ref.id,
          version: ref.version,
        )
        .successBodyBytesOrThrow();

    final signedDocument = await _signedDocumentManager.parseDocument(bytes);
    return DocumentDataFactory.create(signedDocument);
  }

  @override
  Future<String?> getLatestVersion(String id) async {
    final constVersion = allConstantDocumentRefs
        .expand((element) => element.all)
        .firstWhereOrNull((element) => element.id == id)
        ?.version;

    if (constVersion != null) {
      return constVersion;
    }

    try {
      final index = await _api.gateway
          .apiV1DocumentIndexPost(
            body: DocumentIndexQueryFilter(id: IdSelectorDto.eq(id)),
            limit: 1,
          )
          .successBodyOrThrow()
          .then(_mapDynamicResponseValue);

      final docs = index.docs;
      if (docs.isEmpty) {
        return null;
      }

      return docs
          .sublist(0, 1)
          .cast<Map<String, dynamic>>()
          .map(DocumentIndexListDto.fromJson)
          .firstOrNull
          ?.ver
          .firstOrNull
          ?.ver;
    } on NotFoundException {
      return null;
    }
  }

  @override
  Future<List<TypedDocumentRef>> index({
    required Campaign campaign,
  }) async {
    final allRefs = <TypedDocumentRef>{};

    var page = 0;
    const maxPerPage = indexPageSize;
    var remaining = 0;

    do {
      final response =
          await _getDocumentIndexList(
            page: page,
            limit: maxPerPage,
            campaign: campaign,
          )
          // TODO(damian-molinski): Remove this workaround when migrated to V2 endpoint.
          // https://github.com/input-output-hk/catalyst-voices/issues/3199#issuecomment-3204803465
          .onError<NotFoundException>(
            (_, _) {
              return DocumentIndexList(
                docs: [],
                page: CurrentPage(page: page, limit: maxPerPage, remaining: 0),
              );
            },
          );

      allRefs.addAll(response.refs);

      // TODO(damian-molinski): Remove this workaround when migrated to V2 endpoint.
      // https://github.com/input-output-hk/catalyst-voices/issues/3199#issuecomment-3204803465
      remaining = response.docs.length < maxPerPage ? 0 : response.page.remaining;
      page = response.page.page + 1;
    } while (remaining > 0);

    return allRefs.toList();
  }

  @override
  Future<void> publish(SignedDocument document) async {
    final bytes = document.toBytes();
    await _api.gateway
        .apiV1DocumentPut(
          body: bytes,
          contentType: ContentTypes.applicationCbor,
        )
        .successOrThrow();
  }

  Future<DocumentIndexList> _getDocumentIndexList({
    required int page,
    required int limit,
    required Campaign campaign,
  }) async {
    final categoriesIds = campaign.categories.map((e) => e.selfRef.id).toList();

    return _api.gateway
        .apiV1DocumentIndexPost(
          body: DocumentIndexQueryFilter(
            parameters: IdSelectorDto.inside(categoriesIds).toJson(),
          ),
          limit: limit,
          page: page,
        )
        .successBodyOrThrow()
        .then(_mapDynamicResponseValue);
  }

  DocumentIndexList _mapDynamicResponseValue(dynamic value) {
    if (value is DocumentIndexList) {
      return value;
    }

    if (value is Map<String, dynamic>) {
      return DocumentIndexList.fromJson(value);
    }

    return const DocumentIndexList(docs: [], page: CurrentPage(page: 0, limit: 0, remaining: 0));
  }
}

abstract interface class DocumentDataRemoteSource implements DocumentDataSource {
  Future<String?> getLatestVersion(String id);

  Future<List<TypedDocumentRef>> index({required Campaign campaign});

  Future<void> publish(SignedDocument document);
}

extension on DocumentIndexList {
  List<TypedDocumentRef> get refs {
    return docs
        .cast<Map<String, dynamic>>()
        .map(DocumentIndexListDto.fromJson)
        .map((ref) {
          return <TypedDocumentRef>[
            ...ref.ver
                .map((ver) {
                  final documentType = DocumentType.fromJson(ver.type);

                  return <TypedDocumentRef>[
                    TypedDocumentRef(
                      ref: SignedDocumentRef(id: ref.id, version: ver.ver),
                      type: documentType,
                    ),
                    if (ver.ref != null)
                      TypedDocumentRef(
                        ref: ver.ref!.toRef(),
                        type: DocumentType.unknown,
                      ),
                    if (ver.reply != null)
                      TypedDocumentRef(
                        ref: ver.reply!.toRef(),
                        type: DocumentType.unknown,
                      ),
                    if (ver.template != null)
                      TypedDocumentRef(
                        ref: ver.template!.toRef(),
                        type: documentType.template ?? DocumentType.unknown,
                      ),
                    if (ver.brand != null)
                      TypedDocumentRef(
                        ref: ver.brand!.toRef(),
                        type: DocumentType.brandParametersDocument,
                      ),
                    if (ver.campaign != null)
                      TypedDocumentRef(
                        ref: ver.campaign!.toRef(),
                        type: DocumentType.campaignParametersDocument,
                      ),
                    if (ver.category != null)
                      TypedDocumentRef(
                        ref: ver.category!.toRef(),
                        type: DocumentType.categoryParametersDocument,
                      ),
                  ];
                })
                .expand((element) => element),
          ];
        })
        .expand((element) => element)
        .toList();
  }
}

extension on DocumentRefForFilteredDocuments {
  SignedDocumentRef toRef() => SignedDocumentRef(id: id, version: ver);
}
