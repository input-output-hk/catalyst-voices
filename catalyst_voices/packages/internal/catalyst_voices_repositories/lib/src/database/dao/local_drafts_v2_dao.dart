import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/local_drafts_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:drift/drift.dart';

@DriftAccessor(
  tables: [
    LocalDocumentsDrafts,
  ],
)
class DriftLocalDraftsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftLocalDraftsV2DaoMixin
    implements LocalDraftsV2Dao {
  DriftLocalDraftsV2Dao(super.attachedDatabase);
}

// TODO(damian-molinski): Implement local drafts dao
abstract interface class LocalDraftsV2Dao {
  //
}
