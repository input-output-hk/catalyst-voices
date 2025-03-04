import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

final class DatabaseDocumentsDataSource implements SignedDocumentDataSource {
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
      throw DocumentNotFound(ref: ref);
    }

    return entity.toModel();
  }

  @override
  Future<List<String>> queryVersionIds({required String id}) {
    return _database.documentsDao.queryVersionIds(id: id);
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
  }) {
    return _database.documentsDao
        .watchAll(limit: limit, unique: unique, type: type)
        .map((entities) => entities.map((e) => e.toModel()).toList());
  }

  @override
  Stream<int> watchCount({
    required DocumentRef ref,
    required DocumentType type,
  }) {
    return _database.documentsDao.watchCount(ref: ref, type: type);
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
