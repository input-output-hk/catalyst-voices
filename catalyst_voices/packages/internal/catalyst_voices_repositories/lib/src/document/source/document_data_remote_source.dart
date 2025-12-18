import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/generated/api/cat_gateway.models.swagger.dart';
import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:catalyst_voices_repositories/src/common/response_mapper.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_list_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/api/document_index_query_filters_dto.dart';
import 'package:collection/collection.dart';

final class CatGatewayDocumentDataSource implements DocumentDataRemoteSource {
  final ApiServices _api;
  final SignedDocumentManager _signedDocumentManager;

  CatGatewayDocumentDataSource(
    this._api,
    this._signedDocumentManager,
  );

  @override
  Future<DocumentDataWithArtifact> get(DocumentRef ref) async {
    final artifact = await _api.gateway
        .apiV1DocumentDocumentIdGet(
          documentId: ref.id,
          version: ref.ver,
        )
        .successBodyBytesOrThrow()
        .then(DocumentArtifact.new);

    final signedDocument = await _signedDocumentManager.parseDocument(artifact);
    return DocumentDataFactory.create(signedDocument);
  }

  @override
  Future<DocumentRef?> getLatestRefOf(DocumentRef ref) async {
    final ver = await getLatestVersion(ref.id);
    if (ver == null) {
      return null;
    }

    return SignedDocumentRef(id: ref.id, ver: ver);
  }

  @override
  Future<String?> getLatestVersion(String id) {
    final ver = allConstantDocumentRefs
        .firstWhereOrNull((element) => element.hasId(id))
        ?.withId(id)
        ?.ver;

    if (ver != null) {
      return Future.value(ver);
    }

    return _getDocumentIndexList(
          page: 0,
          limit: 1,
          body: DocumentIndexQueryFilter(id: IdSelectorDto.eq(id)),
        )
        .then(_mapDynamicResponseValue)
        .then((response) => response._docs.firstOrNull?.ver.firstOrNull?.ver);
  }

  @override
  Future<DocumentIndex> index({
    int page = 0,
    int limit = 100,
    required DocumentIndexFilters filters,
  }) {
    final body = DocumentIndexQueryFilter(
      type: filters.type?.uuid,
      parameters: IdRefOnly(id: IdSelectorDto.inside(filters.categoriesIds)).toJson(),
    );

    return _getDocumentIndexList(
      page: page,
      limit: limit,
      body: body,
    ).then((value) => value.toModel());
  }

  @override
  Future<void> publish(DocumentArtifact artifact) async {
    await _api.gateway
        .apiV1DocumentPut(
          body: artifact.value,
          contentType: ContentTypes.applicationCbor,
        )
        .successOrThrow();
  }

  // TODO(damian-molinski): Remove this when backend can serve const documents
  DocumentIndexList _forConstRefs({
    required int page,
    required int limit,
    required Iterable<SignedDocumentRef> refs,
    required DocumentType type,
  }) {
    final skip = page * limit;

    final docs = refs
        .skip(skip)
        .take(limit)
        .map(
          (e) {
            return DocumentIndexListDto(
              id: e.id,
              ver: [
                IndividualDocumentVersion(ver: e.ver!, type: type.uuid),
              ],
            );
          },
        )
        .map((e) => e.toJson())
        .toList();

    final remaining = skip + docs.length - refs.length;

    return DocumentIndexList(
      docs: docs,
      page: CurrentPage(
        page: page,
        limit: limit,
        remaining: remaining,
      ),
    );
  }

  Future<DocumentIndexList> _getDocumentIndexList({
    required int page,
    required int limit,
    required DocumentIndexQueryFilter body,
  }) async {
    // TODO(damian-molinski): Remove this when backend can serve const documents
    if (body.type == DocumentType.proposalTemplate.uuid) {
      return _forConstRefs(
        page: page,
        limit: limit,
        refs: activeConstantDocumentRefs.map((e) => e.proposal),
        type: DocumentType.proposalTemplate,
      );
    }
    // TODO(damian-molinski): Remove this when backend can serve const documents
    if (body.type == DocumentType.commentTemplate.uuid) {
      return _forConstRefs(
        page: page,
        limit: limit,
        refs: activeConstantDocumentRefs.map((e) => e.comment),
        type: DocumentType.commentTemplate,
      );
    }

    return _api.gateway
        .apiV1DocumentIndexPost(
          body: body,
          limit: limit,
          page: page,
        )
        .successBodyOrThrow()
        .then(_mapDynamicResponseValue)
        .then(
          (response) {
            // TODO(damian-molinski): Remove this workaround when migrated to V2 endpoint.
            // https://github.com/input-output-hk/catalyst-voices/issues/3199#issuecomment-3204803465
            final remaining = response.docs.length < limit ? 0 : response.page.remaining;
            final page = response.page.copyWith(remaining: remaining);

            return response.copyWith(page: page);
          },
        )
        // TODO(damian-molinski): Remove this workaround when migrated to V2 endpoint.
        // https://github.com/input-output-hk/catalyst-voices/issues/3199#issuecomment-3204803465
        .onError<NotFoundException>(
          (_, _) {
            return DocumentIndexList(
              docs: [],
              page: CurrentPage(page: page, limit: limit, remaining: 0),
            );
          },
        );
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
  @override
  Future<DocumentDataWithArtifact?> get(DocumentRef ref);

  Future<String?> getLatestVersion(String id);

  Future<DocumentIndex> index({
    int page,
    int limit,
    required DocumentIndexFilters filters,
  });

  Future<void> publish(DocumentArtifact artifact);
}

extension on DocumentRefForFilteredDocuments {
  SignedDocumentRef toRef() => SignedDocumentRef(id: id, ver: ver);
}

extension on DocumentIndexList {
  Iterable<DocumentIndexListDto> get _docs {
    return docs.cast<Map<String, dynamic>>().map(DocumentIndexListDto.fromJson);
  }

  DocumentIndex toModel() {
    final docs = _docs.map((e) => e.toModel()).toList();
    final page = this.page.toModel();

    return DocumentIndex(docs: docs, page: page);
  }
}

extension on CurrentPage {
  DocumentIndexPage toModel() {
    return DocumentIndexPage(
      page: page,
      limit: limit,
      remaining: remaining,
    );
  }
}

extension on DocumentIndexListDto {
  DocumentIndexDoc toModel() {
    return DocumentIndexDoc(
      id: id,
      ver: ver.map(
        (e) {
          return DocumentIndexDocVersion(
            ver: e.ver,
            type: DocumentType.fromJson(e.type),
            ref: e.ref?.toRef(),
            reply: e.reply?.toRef(),
            parameters: [
              if (e.parameters case final value?) value.toRef(),
            ],
            template: e.template?.toRef(),
            brand: e.brand?.toRef(),
            campaign: e.campaign?.toRef(),
            category: e.category?.toRef(),
          );
        },
      ).toList(),
    );
  }
}
