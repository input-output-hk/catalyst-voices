import 'package:catalyst_voices_repositories/src/database/catalyst_database.drift.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database_config.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.dart';
import 'package:catalyst_voices_repositories/src/database/migration/drift_migration_strategy.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.dart';
import 'package:catalyst_voices_repositories/src/database/table/drafts.drift.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

/// Database interface which expose only publicly accessible functions and
/// classes.
///
/// Its implementation agnostic.
abstract interface class CatalystDatabase {
  /// Returns drift implementation of [CatalystDatabase]. Implementation
  /// itself is not public.
  factory CatalystDatabase.drift({
    required CatalystDriftDatabaseConfig config,
  }) = DriftCatalystDatabase.withConfig;

  /// Contains all operations related to [DocumentEntity] which is db specific.
  /// Do not confuse it with other documents.
  DocumentsDao get documentsDao;

  /// Contains all operations related to [DocumentDraftEntity] which is db
  /// specific. Do not confuse it with other documents / drafts.
  DraftsDao get draftsDao;

  /// Removes all data from this db.
  Future<void> clear();
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
  final _clearLock = Lock();

  @visibleForTesting
  DriftCatalystDatabase(super.connection);

  DriftCatalystDatabase.withConfig({
    required CatalystDriftDatabaseConfig config,
  }) : this(
          driftDatabase(
            name: config.name,
            web: DriftWebOptions(
              sqlite3Wasm: config.web.sqlite3Wasm,
              driftWorker: config.web.driftWorker,
            ),

            // TODO(damian-molinski): Native not supported yet
            native: null,
          ),
        );

  @override
  DocumentsDao get documentsDao => driftDocumentsDao;

  @override
  DraftsDao get draftsDao => driftDraftsDao;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return DriftMigrationStrategy(
      database: this,
      destructiveFallback: destructiveFallback,
    );
  }

  @override
  Future<void> clear() {
    return _clearLock.synchronized(() async {
      try {
        await customStatement('PRAGMA foreign_keys = OFF');
        await transaction(() async {
          for (final table in allTables) {
            await delete(table).go();
          }
        });
      } finally {
        await customStatement('PRAGMA foreign_keys = ON');
      }
    });
  }
}
