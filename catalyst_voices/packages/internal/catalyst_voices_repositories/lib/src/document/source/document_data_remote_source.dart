import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_list.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_query_filter.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_reference.dart';
import 'package:catalyst_voices_repositories/src/api/models/id_and_ver_ref.dart';
import 'package:catalyst_voices_repositories/src/api/models/id_selector.dart';
import 'package:catalyst_voices_repositories/src/common/future_response_mapper.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
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
        .getDocument(
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
          .documentIndex(
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
      final response = await _getDocumentIndexList(
        page: page,
        limit: maxPerPage,
        campaign: campaign,
      );

      allRefs.addAll(response.refs);

      remaining = response.page.remaining;
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
    final categoryIds = campaign.categories.map((e) => e.selfRef.id).toList();
    final categoryFilter = IdAndVerRef.idOnly(IdSelector.inside(categoryIds));
    final documentFilter = DocumentIndexQueryFilter(parameters: categoryFilter);

    return _api.gateway
        .documentIndex(
          filter: documentFilter,
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
                      ...ref.map(
                        (ref) => TypedDocumentRef(
                          ref: ref.toRef(),
                          type: DocumentType.unknown,
                        ),
                      ),
                    if (ver.reply case final reply?)
                      ...reply.map(
                        (reply) => TypedDocumentRef(
                          ref: reply.toRef(),
                          type: DocumentType.unknown,
                        ),
                      ),
                    if (ver.parameters case final parameters?)
                      ...parameters.map(
                        (parameters) => TypedDocumentRef(
                          ref: parameters.toRef(),
                          type: DocumentType.categoryParametersDocument,
                        ),
                      ),
                    if (ver.template case final template?)
                      ...template.map(
                        (template) => TypedDocumentRef(
                          ref: template.toRef(),
                          type: documentType.template ?? DocumentType.unknown,
                        ),
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
