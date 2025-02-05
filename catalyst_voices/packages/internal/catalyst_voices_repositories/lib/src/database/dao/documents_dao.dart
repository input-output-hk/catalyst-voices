import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/database.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:drift/drift.dart';

abstract interface class DocumentsDao {
  Future<List<Document>> queryAll();

  Future<void> saveAll(List<Document> documents);
}

@DriftAccessor(
  tables: [
    Documents,
    DocumentsMetadata,
    Drafts,
  ],
)
class DriftDocumentsDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDocumentsDaoMixin
    implements DocumentsDao {
  DriftDocumentsDao(super.attachedDatabase);

  @override
  Future<List<Document>> queryAll() {
    return select(documents).get();
  }

  @override
  Future<void> saveAll(List<Document> documents) async {
    await batch((batch) {
      batch.insertAll(
        this.documents,
        documents,
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
