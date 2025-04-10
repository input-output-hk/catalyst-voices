import 'package:catalyst_voices_repositories/src/database/catalyst_database.drift.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database_config.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_dao.dart';
import 'package:catalyst_voices_repositories/src/database/dao/drafts_dao.dart';
import 'package:catalyst_voices_repositories/src/database/dao/favorites_dao.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_dao.dart';
import 'package:catalyst_voices_repositories/src/database/migration/drift_migration_strategy.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_favorite.dart';
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

  /// Contains all operations related to fav status of documents.
  FavoritesDao get favoritesDao;

  /// Specialized version of [DocumentsDao].
  ProposalsDao get proposalsDao;

  /// Removes all data from this db.
  Future<void> clear();

  /// Only once instance is allowed.
  ///
  /// In tests it can happen that database was opened and disposed later.
  Future<void> close();
}

@DriftDatabase(
  tables: [
    Documents,
    DocumentsMetadata,
    DocumentsFavorites,
    Drafts,
  ],
  daos: [
    DriftDocumentsDao,
    DriftFavoritesDao,
    DriftDraftsDao,
    DriftProposalsDao,
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
  FavoritesDao get favoritesDao => driftFavoritesDao;

  @override
  MigrationStrategy get migration {
    return DriftMigrationStrategy(
      database: this,
      destructiveFallback: destructiveFallback,
    );
  }

  @override
  ProposalsDao get proposalsDao => driftProposalsDao;

  @override
  int get schemaVersion => 3;

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
