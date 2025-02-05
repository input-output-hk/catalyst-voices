import 'package:catalyst_voices_repositories/src/database/catalyst_database.drift.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database_config.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

abstract interface class CatalystDatabase {
  factory CatalystDatabase.drift({
    required CatalystDriftDatabaseConfig config,
  }) = DriftCatalystDatabase;

  DocumentsDao get documentsDao;
}

@DriftDatabase(
  tables: [
    Documents,
    DocumentsMetadata,
    Drafts,
  ],
  daos: [
    DriftDocumentsDao,
  ],
  queries: {},
  views: [],
  include: {},
)
class DriftCatalystDatabase extends $DriftCatalystDatabase
    implements CatalystDatabase {
  DriftCatalystDatabase({
    required CatalystDriftDatabaseConfig config,
  }) : this._(
          driftDatabase(
            name: config.name,
            web: DriftWebOptions(
              sqlite3Wasm: config.web.sqlite3Wasm,
              driftWorker: config.web.driftWorker,
            ),

            /// Native not yet(!) supported.
            native: null,
          ),
        );

  DriftCatalystDatabase._(super.connection);

  @visibleForTesting
  DriftCatalystDatabase.fromExecutor(QueryExecutor executor) : this._(executor);

  @override
  DocumentsDao get documentsDao => driftDocumentsDao;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => destructiveFallback;
}
