import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:drift/drift.dart';

abstract interface class DocumentsV2Dao {
  Future<void> saveAll(List<DocumentEntityV2> entries);
}

@DriftAccessor(
  tables: [
    DocumentsV2,
  ],
)
class DriftDocumentsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDocumentsV2DaoMixin
    implements DocumentsV2Dao {
  DriftDocumentsV2Dao(super.attachedDatabase);

  @override
  Future<void> saveAll(List<DocumentEntityV2> entries) async {
    if (entries.isEmpty) return;

    await batch((batch) {
      batch.insertAll(
        documentsV2,
        entries,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }
}
