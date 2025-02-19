import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

/// Encryption will be added later here as drafts are not public
final class DatabaseDraftsDataSource implements DraftDataSource {
  final CatalystDatabase _database;

  DatabaseDraftsDataSource(
    this._database,
  );

  @override
  Future<List<DraftRef>> index() {
    return _database.draftsDao.queryAllRefs();
  }

  @override
  Future<bool> exists({required DocumentRef ref}) {
    return _database.draftsDao.count(ref: ref).then((count) => count > 0);
  }

  @override
  Future<DocumentData> get({required DocumentRef ref}) async {
    final entity = await _database.draftsDao.query(ref: ref);
    if (entity == null) {
      throw DraftNotFound(ref: ref);
    }

    return entity.toModel();
  }

  @override
  Stream<DocumentData?> watch({required DocumentRef ref}) {
    return _database.draftsDao
        .watch(ref: ref)
        .map((entity) => entity?.toModel());
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
    required DocumentRef ref,
    required DocumentDataContent content,
  }) async {
    await _database.draftsDao.updateContent(ref: ref, content: content);
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
