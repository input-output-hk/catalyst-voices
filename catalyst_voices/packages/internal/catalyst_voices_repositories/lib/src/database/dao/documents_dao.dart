import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/typedefs.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

/// Exposes only public operation on documents, and related, tables.
abstract interface class DocumentsDao {
  /// Similar to [queryAll] but emits when new records are inserted or deleted.
  Stream<List<DocumentEntity>> watchAll();

  /// Returns all entities. If same document have different versions
  /// all will be returned.
  Future<List<DocumentEntity>> queryAll();

  /// Counts all documents.
  Future<int> countAll();

  /// Counts unique documents. All versions of same document are counted as 1.
  Future<int> countDocuments();

  @visibleForTesting
  Future<int> countDocumentsMetadata();

  /// Inserts all documents and metadata. On conflicts ignores duplicates.
  Future<void> saveAll(
    Iterable<DocumentEntityWithMetadata> documentsWithMetadata,
  );

  /// Deletes all documents. Cascades to metadata.
  Future<void> deleteAll();
}

@DriftAccessor(
  tables: [
    Documents,
    DocumentsMetadata,
  ],
)
class DriftDocumentsDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDocumentsDaoMixin
    implements DocumentsDao {
  DriftDocumentsDao(super.attachedDatabase);

  @override
  Stream<List<DocumentEntity>> watchAll() {
    return select(documents).watch();
  }

  @override
  Future<List<DocumentEntity>> queryAll() {
    return select(documents).get();
  }

  @override
  Future<int> countAll() {
    return documents.count().getSingle();
  }

  @override
  Future<int> countDocuments() {
    final count = documents.idHi.count(distinct: true);

    final select = selectOnly(documents)
      ..addColumns([
        documents.idHi,
        documents.idLo,
        count,
      ]);

    return select
        .map((row) => row.read(count))
        .get()
        .then((count) => count.firstOrNull ?? 0);
  }

  @override
  Future<int> countDocumentsMetadata() {
    final count = documentsMetadata.verHi.count(distinct: true);

    final select = selectOnly(documentsMetadata)
      ..addColumns([
        documentsMetadata.verHi,
        documentsMetadata.verLo,
        count,
      ]);

    return select
        .map((row) => row.read(count))
        .get()
        .then((count) => count.firstOrNull ?? 0);
  }

  @override
  Future<void> saveAll(
    Iterable<DocumentEntityWithMetadata> documentsWithMetadata,
  ) async {
    final documents = documentsWithMetadata.map((e) => e.document);
    final metadata = documentsWithMetadata.expand((e) => e.metadata);

    await batch((batch) {
      batch
        ..insertAll(
          this.documents,
          documents,
          mode: InsertMode.insertOrIgnore,
        )
        ..insertAll(
          documentsMetadata,
          metadata,
          mode: InsertMode.insertOrIgnore,
        );
    });
  }

  @override
  Future<void> deleteAll() async {
    final count = await delete(documents).go();

    if (kDebugMode) {
      debugPrint('DocumentsDao: Deleted $count rows');
    }
  }
}
