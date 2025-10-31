import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Encryption will be added later here as drafts are not public
final class DatabaseDraftsDataSource implements DraftDataSource {
  final CatalystDatabase _database;

  DatabaseDraftsDataSource(
    this._database,
  );

  @override
  Future<void> delete({required DraftRef ref}) async {
    await _database.draftsDao.deleteWhere(ref: ref);
  }

  @override
  Future<int> deleteAll() => _database.draftsDao.deleteAll();

  @override
  Future<bool> exists({required DocumentRef ref}) {
    return _database.draftsDao.count(ref: ref).then((count) => count > 0);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs) {
    // TODO(damian-molinski): not implemented
    return Future(() => []);
  }

  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    final entity = await _database.draftsDao.query(ref: ref);
    if (entity == null) {
      throw DraftNotFoundException(ref: ref);
    }

    return entity.toModel();
  }

  @override
  Future<List<DocumentData>> getAll({required DocumentRef ref}) {
    return _database.draftsDao
        .queryAll(ref: ref)
        .then((value) => value.map((e) => e.toModel()).toList());
  }

  @override
  Future<DocumentData?> getLatest({CatalystId? authorId}) {
    return _database.draftsDao.queryLatest(authorId: authorId).then((value) => value?.toModel());
  }

  @override
  Future<List<DocumentData>> queryVersionsOfId({required String id}) async {
    final documentEntities = await _database.draftsDao.queryVersionsOfId(id: id);
    return documentEntities.map((e) => e.toModel()).toList();
  }

  @override
  Future<void> save({required DocumentData data}) => saveAll([data]);

  @override
  Future<void> saveAll(Iterable<DocumentData> data) async {
    // TODO(damian-molinski): migrate to V2
    /*final entries = data.map((e) => e.toEntity()).toList();

    await _database.localDraftsV2Dao.saveAll(entries);*/
  }

  @override
  Future<void> update({
    required DraftRef ref,
    required DocumentDataContent content,
  }) async {
    await _database.draftsDao.updateContent(ref: ref, content: content);
  }

  @override
  Stream<DocumentData?> watch({required DocumentRef ref}) {
    return _database.draftsDao.watch(ref: ref).map((entity) => entity?.toModel());
  }

  @override
  Stream<List<DocumentData>> watchAll({
    int? limit,
    DocumentType? type,
    CatalystId? authorId,
  }) {
    return _database.draftsDao
        .watchAll(
          limit: limit,
          type: type,
          authorId: authorId,
        )
        .map((event) {
          final list = List<DocumentData>.from(event.map((e) => e.toModel()));
          return list;
        });
  }
}

extension on DocumentDraftEntity {
  DocumentData toModel() {
    return DocumentData(
      metadata: metadata,
      content: content,
    );
  }
}

extension on DocumentData {
  /*LocalDocumentDraftEntity toEntity() {
    return LocalDocumentDraftEntity(
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
  }*/
}
