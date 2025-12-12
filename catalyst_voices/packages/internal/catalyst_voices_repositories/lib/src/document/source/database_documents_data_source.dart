import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_composite_entity.dart';
import 'package:catalyst_voices_repositories/src/database/model/signed_document_or_local_draft.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_collaborators.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_parameters.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

final class DatabaseDocumentsDataSource
    implements SignedDocumentDataSource, ProposalDocumentDataLocalSource {
  final CatalystDatabase _database;
  final CatalystProfiler _profiler;

  DatabaseDocumentsDataSource(
    this._database,
    this._profiler,
  );

  @override
  Future<int> count({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  }) {
    return _database.documentsV2Dao.count(type: type, id: id, referencing: referencing);
  }

  @override
  Future<int> delete({
    List<DocumentType>? excludeTypes,
  }) {
    return _database.documentsV2Dao.deleteWhere(excludeTypes: excludeTypes);
  }

  @override
  Future<bool> exists({required DocumentRef id}) {
    return _database.documentsV2Dao.exists(id);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> ids) {
    return _database.documentsV2Dao.filterExisting(ids);
  }

  @override
  Future<List<DocumentData>> findAll({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    bool latestOnly = false,
    int limit = 200,
    int offset = 0,
  }) {
    return _database.documentsV2Dao
        .getDocuments(
          type: type,
          id: id,
          referencing: referencing,
          latestOnly: latestOnly,
          limit: limit,
          offset: offset,
        )
        .then((value) => value.map((e) => e.toModel()).toList());
  }

  @override
  Future<DocumentData?> findFirst({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CatalystId? originalAuthorId,
  }) {
    return _database.documentsV2Dao
        .getDocument(type: type, id: id, referencing: referencing, originalAuthor: originalAuthorId)
        .then((value) => value?.toModel());
  }

  @override
  Future<DocumentData?> get(DocumentRef ref) => findFirst(id: ref);

  @override
  Future<Map<String, RawProposalCollaboratorsActions>> getCollaboratorsActions({
    required List<DocumentRef> proposalsRefs,
  }) {
    return _database.proposalsV2Dao.getCollaboratorsActions(proposalsRefs: proposalsRefs);
  }

  @override
  Future<DocumentRef?> getLatestRefOf(DocumentRef ref) {
    return _database.documentsV2Dao.getLatestOf(ref);
  }

  @override
  Future<ProposalsTotalAsk> getProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  }) {
    return _database.proposalsV2Dao.getProposalsTotalTask(filters: filters, nodeId: nodeId);
  }

  @override
  Future<void> save({required DocumentData data}) => saveAll([data]);

  @override
  Future<void> saveAll(Iterable<DocumentData> data) async {
    final entries = data
        .map(
          (e) => DocumentCompositeEntity(
            e.toDocEntity(),
            authors: e.toAuthorEntities(),
            parameters: e.toParameterEntities(),
            collaborators: e.toCollaboratorEntities(),
          ),
        )
        .toList();

    await _database.documentsV2Dao.saveAll(entries);
  }

  @override
  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  }) async {
    await _database.proposalsV2Dao.updateProposalFavorite(id: id, isFavorite: isFavorite);
  }

  @override
  Stream<DocumentData?> watch({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  }) {
    return _database.documentsV2Dao
        .watchDocument(type: type, id: id, referencing: referencing)
        .distinct()
        .map((value) => value?.toModel());
  }

  @override
  Stream<List<DocumentData>> watchAll({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    CatalystId? originalAuthorId,
    bool latestOnly = false,
    int limit = 200,
    int offset = 0,
  }) {
    return _database.documentsV2Dao
        .watchDocuments(
          type: type,
          id: id,
          referencing: referencing,
          latestOnly: latestOnly,
          limit: limit,
          offset: offset,
        )
        .distinct(listEquals)
        .map((value) => value.map((e) => e.toModel()).toList());
  }

  @override
  Stream<int> watchCount({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  }) {
    return _database.documentsV2Dao
        .watchCount(
          type: type,
          id: id,
          referencing: referencing,
        )
        .distinct();
  }

  @override
  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    final tr = _profiler.startTransaction('Query proposals count: $filters');

    return _database.proposalsV2Dao.watchVisibleProposalsCount(filters: filters).doOnData(
      (_) {
        if (!tr.finished) unawaited(tr.finish());
      },
    ).distinct();
  }

  @override
  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  }) {
    return _database.proposalsV2Dao
        .watchProposalsTotalTask(filters: filters, nodeId: nodeId)
        .distinct();
  }

  @override
  Stream<List<DocumentData>> watchProposalTemplates({
    required CampaignFilters campaign,
  }) {
    return _database.documentsV2Dao
        .watchDocuments(type: DocumentType.proposalTemplate, campaign: campaign)
        .distinct(listEquals)
        .map((event) => event.map((e) => e.toModel()).toList());
  }

  @override
  Stream<List<RawProposalBrief>> watchRawLocalDraftsProposalsBrief({
    required CatalystId author,
  }) {
    return _database.proposalsV2Dao
        .watchLocalDraftsProposalsBrief(author: author)
        .distinct(listEquals)
        .map((event) => event.map((e) => e.toModel()).toList());
  }

  @override
  Stream<Page<RawProposalBrief>> watchRawProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order = const UpdateDate.desc(),
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    final tr = _profiler.startTransaction('Query proposals: $request:$order:$filters');

    return _database.proposalsV2Dao
        .watchProposalsBriefPage(request: request, order: order, filters: filters)
        .doOnData(
          (_) {
            if (!tr.finished) unawaited(tr.finish());
          },
        )
        .distinct()
        .map((page) => page.map((data) => data.toModel()));
  }
}

extension on DocumentData {
  List<DocumentAuthorEntity> toAuthorEntities() {
    return (metadata.authors ?? const []).map((catId) {
      return DocumentAuthorEntity(
        documentId: metadata.id.id,
        documentVer: metadata.id.ver!,
        accountId: catId.toUri().toString(),
        accountSignificantId: catId.toSignificant().toUri().toString(),
        username: catId.username,
      );
    }).toList();
  }

  List<DocumentCollaboratorEntity> toCollaboratorEntities() {
    return (metadata.collaborators ?? const []).map((catId) {
      return DocumentCollaboratorEntity(
        documentId: metadata.id.id,
        documentVer: metadata.id.ver!,
        accountId: catId.toUri().toString(),
        accountSignificantId: catId.toSignificant().toUri().toString(),
        username: catId.username,
      );
    }).toList();
  }

  DocumentEntityV2 toDocEntity() {
    return DocumentEntityV2(
      content: content,
      contentType: metadata.contentType.value,
      id: metadata.id.id,
      ver: metadata.id.ver!,
      type: metadata.type,
      refId: metadata.ref?.id,
      refVer: metadata.ref?.ver,
      replyId: metadata.reply?.id,
      replyVer: metadata.reply?.ver,
      section: metadata.section,
      templateId: metadata.template?.id,
      templateVer: metadata.template?.ver,
      collaborators: metadata.collaborators ?? [],
      parameters: metadata.parameters,
      authors: metadata.authors ?? [],
      createdAt: metadata.id.ver!.dateTime,
    );
  }

  List<DocumentParameterEntity> toParameterEntities() {
    return metadata.parameters.set.map((ref) {
      return DocumentParameterEntity(
        id: ref.id,
        ver: ref.ver!,
        documentId: metadata.id.id,
        documentVer: metadata.id.ver!,
      );
    }).toList();
  }
}
