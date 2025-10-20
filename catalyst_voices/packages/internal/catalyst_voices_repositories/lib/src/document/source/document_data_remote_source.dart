import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/common/future_response_mapper.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
import 'package:catalyst_voices_repositories/src/models/current_page.dart';
import 'package:catalyst_voices_repositories/src/models/document_index_list.dart';
import 'package:catalyst_voices_repositories/src/models/document_index_query_filter.dart';
import 'package:catalyst_voices_repositories/src/models/document_reference.dart';
import 'package:catalyst_voices_repositories/src/models/id_and_ver_ref.dart';
import 'package:catalyst_voices_repositories/src/models/id_selector.dart';
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
        .downloadDocument(
          documentId: ref.id,
          version: ref.version,
        )
        .successBodyOrThrow();

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
          .searchDocuments(
            filter: DocumentIndexQueryFilter(id: IdSelector.eq(id)),
            limit: 1,
          )
          .successBodyOrThrow();

      final docs = index.docs;
      if (docs.isEmpty) {
        return null;
      }

      return docs.sublist(0, 1).firstOrNull?.ver.firstOrNull?.ver;
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
    await _api.gateway.uploadDocument(body: bytes).successBodyOrThrow();
  }

  Future<DocumentIndexList> _getDocumentIndexList({
    required int page,
    required int limit,
    required Campaign campaign,
  }) async {
    final categoriesIds = campaign.categories.map((e) => e.selfRef.id).toList();

    return _api.gateway
        .searchDocuments(
          filter: DocumentIndexQueryFilter(
            parameters: IdAndVerRef.idOnly(
              IdSelector.inside(categoriesIds),
            ),
          ),
          limit: limit,
          page: page,
        )
        .successBodyOrThrow();
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
                    if (ver.ref case final ref?)
                      TypedDocumentRef(
                        ref: ref.toRef(),
                        type: DocumentType.unknown,
                      ),
                    if (ver.reply case final reply?)
                      TypedDocumentRef(
                        ref: reply.toRef(),
                        type: DocumentType.unknown,
                      ),
                    if (ver.parameters case final parameters?)
                      TypedDocumentRef(
                        ref: parameters.toRef(),
                        type: DocumentType.categoryParametersDocument,
                      ),
                    if (ver.template case final template?)
                      TypedDocumentRef(
                        ref: template.toRef(),
                        type: documentType.template ?? DocumentType.unknown,
                      ),
                    if (ver.brand case final brand?)
                      TypedDocumentRef(
                        ref: brand.toRef(),
                        type: DocumentType.brandParametersDocument,
                      ),
                    if (ver.campaign case final campaign?)
                      TypedDocumentRef(
                        ref: campaign.toRef(),
                        type: DocumentType.campaignParametersDocument,
                      ),
                    if (ver.category case final category?)
                      TypedDocumentRef(
                        ref: category.toRef(),
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

extension on DocumentReference {
  SignedDocumentRef toRef() => SignedDocumentRef(id: id, version: ver);
}
