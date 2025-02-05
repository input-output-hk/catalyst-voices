import 'package:catalyst_voices_repositories/src/database/catalyst_database.drift.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database_config.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.drift.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

/// Database interface which expose only publicly accessible functions and
/// classes.
///
/// Its implementation agnostic.
abstract interface class CatalystDatabase {
  /// Returns drift implementation of [CatalystDatabase]. Implementation
  /// itself is not public.
  factory CatalystDatabase.drift({
    required CatalystDriftDatabaseConfig config,
  }) = DriftCatalystDatabase;

  /// Contains all operations related to [Document] which is db specific.
  /// Do not confuse it with other documents.
  DocumentsDao get documentsDao;

  /// Contains all operations related to [Draft] which is db specific.
  /// Do not confuse it with other documents / drafts.
  DraftsDao get draftsDao;
}

@DriftDatabase(
  tables: [
    Documents,
    DocumentsMetadata,
    Drafts,
  ],
  daos: [
    DriftDocumentsDao,
    DriftDraftsDao,
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
  DraftsDao get draftsDao => driftDraftsDao;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => destructiveFallback;
}
