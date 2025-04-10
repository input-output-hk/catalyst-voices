import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';

final class DatabaseDocumentsDataSource
    implements SignedDocumentDataSource, ProposalDocumentDataLocalSource {
  final CatalystDatabase _database;

  DatabaseDocumentsDataSource(
    this._database,
  );

  @override
  Future<bool> exists({required DocumentRef ref}) {
    return _database.documentsDao.count(ref: ref).then((count) => count > 0);
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
  Future<Page<ProposalDocumentData>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  }) {
    return _database.proposalsDao
        .queryProposalsPage(request: request, filters: filters)
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
  Future<List<DocumentRef>> index() {
    return _database.documentsDao.queryAllRefs();
  }

  @override
  Future<List<DocumentData>> queryVersionsOfId({required String id}) async {
    final documentEntities =
        await _database.documentsDao.queryVersionsOfId(id: id);
    return documentEntities.map((e) => e.toModel()).toList();
  }

  @override
  Future<void> save({required DocumentData data}) async {
    final idHiLo = UuidHiLo.from(data.metadata.id);
    final verHiLo = UuidHiLo.from(data.metadata.version);

    final document = DocumentEntity(
      idHi: idHiLo.high,
      idLo: idHiLo.low,
      verHi: verHiLo.high,
      verLo: verHiLo.low,
      type: data.metadata.type,
      content: data.content,
      metadata: data.metadata,
      createdAt: DateTime.timestamp(),
    );

    // TODO(damian-molinski): Need to decide what goes into metadata table.
    final metadata = <DocumentMetadataEntity>[
      //
    ];

    final documentWithMetadata = (document: document, metadata: metadata);

    await _database.documentsDao.saveAll([documentWithMetadata]);
  }

  @override
  Stream<DocumentData?> watch({required DocumentRef ref}) {
    return _database.documentsDao
        .watch(ref: ref)
        .map((entity) => entity?.toModel());
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
  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  }) {
    return _database.proposalsDao.watchCount(filters: filters);
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
