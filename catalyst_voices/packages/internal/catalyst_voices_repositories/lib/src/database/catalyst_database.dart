import 'package:catalyst_voices_repositories/src/database/catalyst_database.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:drift/drift.dart';

@DriftDatabase(
  tables: [
    Documents,
    DocumentMetadata,
    Drafts,
  ],
  daos: [],
  queries: {},
  views: [],
  include: {},
)
class CatalystDatabase extends $CatalystDatabase {
  CatalystDatabase(super.connection);

  @override
  int get schemaVersion => 1;
}
