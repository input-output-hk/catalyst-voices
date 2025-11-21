import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';

/// Encryption will be added later here as drafts are not public
final class DatabaseDraftsDataSource implements DraftDataSource {
  final CatalystDatabase _database;

  DatabaseDraftsDataSource(
    this._database,
  );

  @override
  Future<int> count({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? referencing,
  }) {
    return _database.localDocumentsV2Dao.count(type: type, ref: ref, referencing: referencing);
  }

  @override
  Future<int> delete({
    DocumentRef? ref,
    List<DocumentType>? excludeTypes,
  }) {
    return _database.localDocumentsV2Dao.deleteWhere(ref: ref, excludeTypes: excludeTypes);
  }

  @override
  Future<bool> exists({required DocumentRef ref}) {
    return _database.localDocumentsV2Dao.exists(ref);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> refs) {
    return _database.localDocumentsV2Dao.filterExisting(refs);
  }

  @override
  Future<List<DocumentData>> findAll({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? referencing,
    bool latestOnly = false,
    int limit = 100,
    int offset = 0,
  }) {
    return _database.localDocumentsV2Dao
        .getDocuments(
          type: type,
          ref: ref,
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
    DocumentRef? ref,
    DocumentRef? referencing,
  }) {
    return _database.localDocumentsV2Dao
        .getDocument(type: type, ref: ref, referencing: referencing)
        .then((value) => value?.toModel());
  }

  @override
  Future<DocumentData?> get(DocumentRef ref) => findFirst(ref: ref);

  @override
  Future<DocumentRef?> getLatestRefOf(DocumentRef ref) async {
    return _database.localDocumentsV2Dao.getLatestOf(ref);
  }

  @override
  Future<void> save({required DocumentData data}) => saveAll([data]);

  @override
  Future<void> saveAll(Iterable<DocumentData> data) async {
    final entries = data.map((e) => e.toEntity()).toList();

    await _database.localDocumentsV2Dao.saveAll(entries);
  }

  @override
  Future<void> updateContent({
    required DraftRef ref,
    required DocumentDataContent content,
  }) async {
    await _database.localDocumentsV2Dao.updateContent(ref: ref, content: content);
  }

  @override
  Stream<DocumentData?> watch({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? referencing,
  }) {
    return _database.localDocumentsV2Dao
        .watchDocument(type: type, ref: ref, referencing: referencing)
        .distinct()
        .map((value) => value?.toModel());
  }

  @override
  Stream<List<DocumentData>> watchAll({
    DocumentType? type,
    DocumentRef? ref,
    DocumentRef? referencing,
    bool latestOnly = false,
    int limit = 100,
    int offset = 0,
  }) {
    return _database.localDocumentsV2Dao
        .watchDocuments(
          type: type,
          ref: ref,
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
    DocumentRef? ref,
    DocumentRef? referencing,
  }) {
    return _database.localDocumentsV2Dao
        .watchCount(
          type: type,
          ref: ref,
          referencing: referencing,
        )
        .distinct();
  }
}

extension on LocalDocumentDraftEntity {
  DocumentData toModel() {
    return DocumentData(
      metadata: DocumentDataMetadata(
        type: type,
        selfRef: DraftRef(id: id, version: ver),
        ref: refId.toRef(refVer),
        template: templateId.toRef(templateVer),
        reply: replyId.toRef(replyVer),
        section: section,
        categoryId: categoryId.toRef(categoryVer),
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
  LocalDocumentDraftEntity toEntity() {
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
  }
}
