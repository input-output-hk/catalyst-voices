import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/api/models/current_page.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_list.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_query_filter.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_reference.dart';
import 'package:catalyst_voices_repositories/src/api/models/id_and_ver_ref.dart';
import 'package:catalyst_voices_repositories/src/api/models/id_selector.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document.dart';
import 'package:catalyst_voices_repositories/src/api/models/indexed_document_version.dart';
import 'package:catalyst_voices_repositories/src/api/models/ver_selector.dart';
import 'package:catalyst_voices_repositories/src/common/future_response_mapper.dart';
import 'package:catalyst_voices_repositories/src/document/document_data_factory.dart';
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
        .getDocument(documentId: ref.id, version: ref.ver)
        .successBodyOrThrow()
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
          filter: DocumentIndexQueryFilter(id: IdSelector.eq(id)),
        )
        .then(_mapDynamicResponseValue)
        .then((response) => response.docs.firstOrNull?.ver.firstOrNull?.ver);
  }

  @override
  Future<DocumentIndex> index({
    int page = 0,
    int limit = 100,
    required DocumentIndexFilters filters,
  }) {
    final id = filters.id?.id;
    final ver = filters.id?.ver;
    final parameters = filters.parameters;

    final filter = DocumentIndexQueryFilter(
      type: filters.type?.map((e) => e.uuid).toList(),
      id: id != null ? IdSelector.eq(id) : null,
      ver: ver != null ? VerSelector.eq(ver) : null,
      parameters: parameters != null ? IdAndVerRef.idOnly(IdSelector.inside(parameters)) : null,
    );

    return _getDocumentIndexList(
      page: page,
      limit: limit,
      filter: filter,
    ).then((value) => value.toModel());
  }

  @override
  Future<void> publish(DocumentArtifact artifact) async {
    await _api.gateway.uploadDocument(body: artifact.value).successBodyOrThrow();
  }

  // TODO(damian-molinski): Remove this when backend can serve const documents
  DocumentIndexList _forConstRefs({
    required int page,
    required int limit,
    required Iterable<SignedDocumentRef> refs,
    required DocumentType type,
  }) {
    final skip = page * limit;

    final docs = refs.skip(skip).take(limit).map(
      (e) {
        return IndexedDocument(
          id: e.id,
          ver: [
            IndexedDocumentVersion(ver: e.ver!, type: type.uuid, id: e.id),
          ],
        );
      },
    ).toList();

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
    required DocumentIndexQueryFilter filter,
  }) async {
    // TODO(damian-molinski): Remove this when backend can serve const documents
    if ((filter.type ?? const []).contains(DocumentType.proposalTemplate.uuid)) {
      return _forConstRefs(
        page: page,
        limit: limit,
        refs: constantDocumentRefsPerCampaign(activeCampaignRef).map((e) => e.proposal).nonNulls,
        type: DocumentType.proposalTemplate,
      );
    }
    // TODO(damian-molinski): Remove this when backend can serve const documents
    if ((filter.type ?? const []).contains(DocumentType.commentTemplate.uuid)) {
      return _forConstRefs(
        page: page,
        limit: limit,
        refs: constantDocumentRefsPerCampaign(activeCampaignRef).map((e) => e.comment).nonNulls,
        type: DocumentType.commentTemplate,
      );
    }

    return _api.gateway
        .documentIndex(
          filter: filter,
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
  /// Looks up matching signed document according to [ref].
  @override
  Future<DocumentDataWithArtifact?> get(DocumentRef ref);

  Future<String?> getLatestVersion(String id);

  /// Looks up all signed document refs according to [filters].
  ///
  /// Response is paginated using [page] and [limit].
  Future<DocumentIndex> index({
    int page,
    int limit,
    required DocumentIndexFilters filters,
  });

  Future<void> publish(DocumentArtifact artifact);
}

extension on DocumentReference {
  SignedDocumentRef toRef() => SignedDocumentRef(id: id, ver: ver);
}

extension on DocumentIndexList {
  DocumentIndex toModel() {
    final docs = this.docs.map((e) => e.toModel()).toList();
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

extension on IndexedDocument {
  DocumentIndexDoc toModel() {
    return DocumentIndexDoc(
      id: id,
      ver: ver.map(
        (e) {
          return DocumentIndexDocVersion(
            ver: e.ver,
            type: DocumentType.fromJson(e.type),
            ref: e.ref?.map((e) => e.toRef()).toList(),
            reply: e.reply?.map((e) => e.toRef()).toList(),
            template: e.template?.map((e) => e.toRef()).toList(),
            parameters: e.parameters?.map((e) => e.toRef()).toList(),
          );
        },
      ).toList(),
    );
  }
}
