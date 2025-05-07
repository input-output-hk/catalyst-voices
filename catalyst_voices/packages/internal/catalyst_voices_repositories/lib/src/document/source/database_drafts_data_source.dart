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
  Future<bool> exists({required DocumentRef ref}) {
    return _database.draftsDao.count(ref: ref).then((count) => count > 0);
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
  Future<DocumentData?> getLatest({CatalystId? authorId}) {
    return _database.draftsDao
        .queryLatest(authorId: authorId)
        .then((value) => value?.toModel());
  }

  @override
  Future<List<TypedDocumentRef>> index() {
    return _database.draftsDao.queryAllTypedRefs();
  }

  @override
  Future<List<DocumentData>> queryVersionsOfId({required String id}) async {
    final documentEntities =
        await _database.draftsDao.queryVersionsOfId(id: id);
    return documentEntities.map((e) => e.toModel()).toList();
  }

  @override
  Future<void> save({required DocumentData data}) async {
    final idHiLo = UuidHiLo.from(data.metadata.id);
    final verHiLo = UuidHiLo.from(data.metadata.version);

    final draft = DocumentDraftEntity(
      idHi: idHiLo.high,
      idLo: idHiLo.low,
      verHi: verHiLo.high,
      verLo: verHiLo.low,
      type: data.metadata.type,
      content: data.content,
      metadata: data.metadata,
      title: data.content.title ?? '',
    );

    await _database.draftsDao.save(draft);
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
    return _database.draftsDao
        .watch(ref: ref)
        .map((entity) => entity?.toModel());
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
