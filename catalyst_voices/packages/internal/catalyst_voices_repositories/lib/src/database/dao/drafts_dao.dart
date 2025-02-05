import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:drift/drift.dart';

/// Exposes only public operation on drafts, and related, tables.
abstract interface class DraftsDao {}

@DriftAccessor(
  tables: [
    Drafts,
    DocumentsMetadata,
  ],
)
class DriftDraftsDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftDraftsDaoMixin
    implements DraftsDao {
  DriftDraftsDao(super.attachedDatabase);
}
