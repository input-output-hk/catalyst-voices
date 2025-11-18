import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_with_authors_entity.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:catalyst_voices_repositories/src/proposal/proposal_document_factory.dart';
import 'package:catalyst_voices_repositories/src/proposal/proposal_template_factory.dart';
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
  Future<int> deleteAll({
    List<DocumentType>? notInType,
  }) {
    return _database.documentsV2Dao.deleteWhere(notInType: notInType);
  }

  @override
  Future<bool> exists({required DocumentRef ref}) {
    return _database.documentsV2Dao.exists(ref);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs) {
    return _database.documentsV2Dao.filterExisting(refs);
  }

  @override
  Future<List<DocumentData>> findAllVersions({required DocumentRef ref}) {
    return _database.documentsV2Dao
        .getDocuments(id: ref.id)
        .then((value) => value.map((e) => e.toModel()).toList());
  }

  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    final entity = await _database.documentsV2Dao.getDocument(ref: ref);
    if (entity == null) {
      throw DocumentNotFoundException(ref: ref);
    }

    return entity.toModel();
  }

  @override
  Future<DocumentData?> getLatest({
    CatalystId? authorId,
  }) {
    return _database.documentsV2Dao.getDocument(author: authorId).then((value) => value?.toModel());
  }

  @override
  Future<DocumentRef?> getLatestOf({required DocumentRef ref}) {
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
  Future<int> getRefCount({
    required DocumentRef ref,
    required DocumentType type,
  }) {
    return _database.documentsDao.countRefDocumentByType(ref: ref, type: type);
  }

  @override
  Future<DocumentData?> getRefToDocumentData({
    required DocumentRef refTo,
    DocumentType? type,
  }) {
    return _database.documentsDao
        .queryRefToDocumentData(refTo: refTo, type: type)
        .then((e) => e?.toModel());
  }

  @override
  Future<List<DocumentData>> queryVersionsOfId({required String id}) async {
    final documentEntities = await _database.documentsDao.queryVersionsOfId(id: id);
    return documentEntities.map((e) => e.toModel()).toList();
  }

  @override
  Future<void> save({required DocumentData data}) => saveAll([data]);

  @override
  Future<void> saveAll(Iterable<DocumentData> data) async {
    final entries = data
        .map((e) => DocumentWithAuthorsEntity(e.toDocEntity(), e.toAuthorEntities()))
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
  Stream<DocumentData?> watch({required DocumentRef ref}) {
    return _database.documentsDao.watch(ref: ref).map((entity) => entity?.toModel());
  }

  @override
  Stream<List<DocumentData>> watchAll({
    int? limit,
    required bool unique,
    DocumentType? type,
    CatalystId? authorId,
    DocumentRef? refTo,
  }) {
    return _database.documentsDao
        .watchAll(
          limit: limit,
          unique: unique,
          type: type,
          authorId: authorId,
          refTo: refTo,
        )
        .map((entities) {
          return List<DocumentData>.from(entities.map((e) => e.toModel()));
        });
  }

  @override
  Stream<int> watchCount({
    DocumentRef? refTo,
    DocumentType? type,
  }) {
    return _database.documentsDao.watchCount(
      refTo: refTo,
      type: type,
    );
  }

  @override
  Stream<Page<JoinedProposalBriefData>> watchProposalsBriefPage({
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
        .map((page) => page.map((data) => data.toModel()));
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
    );
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
    required CampaignFilters filters,
  }) {
    return _database.documentsV2Dao
        .watchDocuments(type: DocumentType.proposalTemplate, filters: filters)
        .distinct(listEquals)
        .map((event) => event.map((e) => e.toModel()).toList());
  }

  @override
  Stream<DocumentData?> watchRefToDocumentData({
    required DocumentRef refTo,
    required DocumentType type,
  }) {
    return _database.documentsDao
        .watchRefToDocumentData(refTo: refTo, type: type)
        .map((e) => e?.toModel());
  }
}

extension on DocumentEntityV2 {
  DocumentData toModel() {
    return DocumentData(
      metadata: DocumentDataMetadata(
        type: type,
        selfRef: SignedDocumentRef(id: id, version: ver),
        ref: refId.toRef(refVer),
        template: templateId.toRef(templateVer),
        reply: replyId.toRef(replyVer),
        section: section,
        categoryId: categoryId.toRef(categoryVer),
        // TODO(damian-molinski): Make sure to add unit tests
        authors: authors.isEmpty ? null : authors.split(',').map(CatalystId.parse).toList(),
      ),
      content: content,
    );
  }
}

extension on String? {
  SignedDocumentRef? toRef([String? ver]) {
    final id = this;
    if (id == null) {
      return null;
    }

    return SignedDocumentRef(id: id, version: ver);
  }
}

extension on DocumentData {
  List<DocumentAuthorEntity> toAuthorEntities() {
    return (metadata.authors ?? const []).map((catId) {
      return DocumentAuthorEntity(
        documentId: metadata.id,
        documentVer: metadata.version,
        authorId: catId.toUri().toString(),
        authorIdSignificant: catId.toSignificant().toUri().toString(),
        authorUsername: catId.username,
      );
    }).toList();
  }

  DocumentEntityV2 toDocEntity() {
    return DocumentEntityV2(
      content: content,
      id: metadata.id,
      ver: metadata.version,
      type: metadata.type,
      refId: metadata.ref?.id,
      refVer: metadata.ref?.version,
      replyId: metadata.reply?.id,
      replyVer: metadata.reply?.version,
      section: metadata.section,
      categoryId: metadata.categoryId?.id,
      categoryVer: metadata.categoryId?.version,
      templateId: metadata.template?.id,
      templateVer: metadata.template?.version,
      authors: metadata.authors?.map((e) => e.toString()).join(',') ?? '',
      createdAt: metadata.version.dateTime,
    );
  }
}

extension on JoinedProposalBriefEntity {
  JoinedProposalBriefData toModel() {
    final proposalDocumentData = proposal.toModel();
    final templateDocumentData = template?.toModel();

    final proposalOrDocument = templateDocumentData == null
        ? ProposalOrDocument.data(proposalDocumentData)
        : () {
            final template = ProposalTemplateFactory.create(templateDocumentData);
            final proposal = ProposalDocumentFactory.create(
              proposalDocumentData,
              template: template,
            );

            return ProposalOrDocument.proposal(proposal);
          }();

    return JoinedProposalBriefData(
      proposal: proposalOrDocument,
      actionType: actionType,
      versionIds: versionIds,
      commentsCount: commentsCount,
      isFavorite: isFavorite,
    );
  }
}
