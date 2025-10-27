import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/local_drafts_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:drift/drift.dart';

abstract interface class LocalDraftsV2Dao {
  //
}

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
