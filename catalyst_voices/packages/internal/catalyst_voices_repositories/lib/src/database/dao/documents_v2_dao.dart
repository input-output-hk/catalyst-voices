import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:drift/drift.dart';

abstract interface class DocumentsV2Dao {
  //
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
}
