import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:drift/drift.dart';

abstract interface class ProposalsV2Dao {
  //
}

@DriftAccessor(
  tables: [
    DocumentsV2,
    LocalDocumentsDrafts,
    DocumentsLocalMetadata,
  ],
)
class DriftProposalsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftProposalsV2DaoMixin
    implements ProposalsV2Dao {
  DriftProposalsV2Dao(super.attachedDatabase);
}
