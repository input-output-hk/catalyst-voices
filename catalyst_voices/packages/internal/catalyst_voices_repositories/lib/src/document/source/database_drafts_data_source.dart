import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/model/signed_document_or_local_draft.dart';
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
    DocumentRef? id,
    DocumentRef? referencing,
  }) {
    return _database.localDocumentsV2Dao.count(type: type, id: id, referencing: referencing);
  }

  @override
  Future<int> delete({
    DocumentRef? ref,
    List<DocumentType>? excludeTypes,
  }) {
    return _database.localDocumentsV2Dao.deleteWhere(id: ref, excludeTypes: excludeTypes);
  }

  @override
  Future<bool> exists({required DocumentRef id}) {
    return _database.localDocumentsV2Dao.exists(id);
  }

  @override
  Future<List<DocumentRef>> filterExisting(List<DocumentRef> ids) {
    return _database.localDocumentsV2Dao.filterExisting(ids);
  }

  @override
  Future<List<DocumentData>> findAll({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    bool latestOnly = false,
    int limit = 100,
    int offset = 0,
  }) {
    return _database.localDocumentsV2Dao
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
  }) {
    return _database.localDocumentsV2Dao
        .getDocument(type: type, id: id, referencing: referencing)
        .then((value) => value?.toModel());
  }

  @override
  Future<DocumentData?> get(DocumentRef ref) => findFirst(id: ref);

  @override
  Future<DocumentRef?> getLatestRefOf(DocumentRef ref) async {
    return _database.localDocumentsV2Dao.getLatestOf(ref);
  }

  @override
  Future<DocumentDataMetadata?> getMetadata(DocumentRef ref) {
    return _database.localDocumentsV2Dao
        .getDocumentMetadata(id: ref)
        .then((value) => value?.toModel());
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
    await _database.localDocumentsV2Dao.updateContent(id: ref, content: content);
  }

  @override
  Stream<DocumentData?> watch({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
  }) {
    return _database.localDocumentsV2Dao
        .watchDocument(type: type, id: id, referencing: referencing)
        .distinct()
        .map((value) => value?.toModel());
  }

  @override
  Stream<List<DocumentData>> watchAll({
    DocumentType? type,
    DocumentRef? id,
    DocumentRef? referencing,
    bool latestOnly = false,
    int limit = 100,
    int offset = 0,
  }) {
    return _database.localDocumentsV2Dao
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
    return _database.localDocumentsV2Dao
        .watchCount(
          type: type,
          id: id,
          referencing: referencing,
        )
        .distinct();
  }
}

extension on DocumentData {
  LocalDocumentDraftEntity toEntity() {
    final authors = metadata.authors ?? <CatalystId>[];
    final authorsNames = authors.map((e) => e.username).toList();
    final authorsSignificant = authors.map((e) => e.toSignificant()).toList();

    return LocalDocumentDraftEntity(
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
      authors: authors,
      authorsNames: authorsNames,
      authorsSignificant: authorsSignificant,
      createdAt: metadata.id.ver!.dateTime,
    );
  }
}
