import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class DatabaseDocumentsDataSource
    implements SignedDocumentDataSource, ProposalDocumentDataLocalSource {
  final CatalystDatabase _database;

  DatabaseDocumentsDataSource(
    this._database,
  );

  @override
  Future<int> deleteAll() {
    return _database.documentsDao.deleteAll();
  }

  @override
  Future<int> deleteAllRespectingLocalDrafts() {
    return _database.documentsDao.deleteAll(keepTemplatesForLocalDrafts: true);
  }

  @override
  Future<bool> exists({required DocumentRef ref}) {
    return _database.documentsDao.count(ref: ref).then((count) => count > 0);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs) {
    return _database.documentsV2Dao.filterExisting(refs);
  }

  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    final entity = await _database.documentsDao.query(ref: ref);
    if (entity == null) {
      throw DocumentNotFoundException(ref: ref);
    }

    return entity.toModel();
  }

  @override
  Future<List<DocumentData>> getAll({required DocumentRef ref}) {
    return _database.documentsDao
        .queryAll(ref: ref)
        .then((value) => value.map((e) => e.toModel()).toList());
  }

  @override
  Future<DocumentData?> getLatest({
    CatalystId? authorId,
  }) {
    return _database.documentsDao
        .queryLatestDocumentData(authorId: authorId)
        .then((value) => value?.toModel());
  }

  @override
  Future<List<ProposalDocumentData>> getProposals({
    SignedDocumentRef? categoryRef,
    required ProposalsFilterType type,
  }) {
    return _database.proposalsDao
        .queryProposals(
          categoryRef: categoryRef,
          filters: ProposalsFilters.forActiveCampaign(type: type),
        )
        .then((value) => value.map((e) => e.toModel()).toList());
  }

  @override
  Future<Page<ProposalDocumentData>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) {
    return _database.proposalsDao
        .queryProposalsPage(request: request, filters: filters, order: order)
        .then((page) => page.map((e) => e.toModel()));
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
    final entries = data.map((e) => e.toEntity()).toList();

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
  Stream<Page<JoinedProposalBriefData>> watchProposalsBriefPage(PageRequest request) {
    return _database.proposalsV2Dao
        .watchProposalsBriefPage(request)
        .map((page) => page.map((data) => data.toModel()));
  }

  @override
  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  }) {
    return _database.proposalsDao.watchCount(filters: filters);
  }

  @override
  Stream<Page<ProposalDocumentData>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) {
    return _database.proposalsDao
        .watchProposalsPage(request: request, filters: filters, order: order)
        .map((page) => page.map((e) => e.toModel()));
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

extension on DocumentEntity {
  DocumentData toModel() {
    return DocumentData(
      metadata: metadata,
      content: content,
    );
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
        authors: authors.split(',').map((e) => CatalystId.fromUri(e.getUri())).toList(),
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
  DocumentEntityV2 toEntity() {
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
      authors: metadata.authors?.map((e) => e.toUri().toString()).join(',') ?? '',
      createdAt: metadata.version.dateTime,
    );
  }
}

extension on JoinedProposalEntity {
  ProposalDocumentData toModel() {
    return ProposalDocumentData(
      proposal: proposal.toModel(),
      template: template.toModel(),
      action: action?.toModel(),
      commentsCount: commentsCount,
      versions: versions,
    );
  }
}

extension on JoinedProposalBriefEntity {
  JoinedProposalBriefData toModel() {
    return JoinedProposalBriefData(
      proposal: proposal.toModel(),
      template: template?.toModel(),
      actionType: actionType,
      versionIds: versionIds,
      commentsCount: commentsCount,
      isFavorite: isFavorite,
    );
  }
}
