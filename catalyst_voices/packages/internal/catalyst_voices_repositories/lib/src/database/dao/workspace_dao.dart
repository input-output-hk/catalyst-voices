//ignore_for_file: one_member_abstracts

import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/workspace_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:drift/drift.dart';

@DriftAccessor(
  tables: [
    DocumentsV2,
    LocalDocumentsDrafts,
    DocumentsLocalMetadata,
  ],
)
class DriftWorkspaceDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftWorkspaceDaoMixin
    implements WorkspaceDao {
  DriftWorkspaceDao(super.attachedDatabase);

  @override
  Future<int> deleteLocalDrafts() {
    final query = delete(localDocumentsDrafts);

    return query.go();
  }
}

abstract interface class WorkspaceDao {
  Future<int> deleteLocalDrafts();
}
