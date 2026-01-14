import 'package:catalyst_voices_repositories/src/database/catalyst_database.drift.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database_config.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_local_metadata_dao.dart';
import 'package:catalyst_voices_repositories/src/database/dao/local_draft_documents_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/migration/drift_migration_strategy.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_artifacts.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_collaborators.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_parameters.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
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
    QueryInterceptor? interceptor,
  }) = DriftCatalystDatabase.withConfig;

  DocumentsV2Dao get documentsV2Dao;

  LocalDraftDocumentsV2Dao get localDocumentsV2Dao;

  DocumentsV2LocalMetadataDao get localMetadataDao;

  /// Allows to await completion of pending operations.
  ///
  /// Useful when tearing down integration tests.
  @visibleForTesting
  Future<void> get pendingOperations;

  ProposalsV2Dao get proposalsV2Dao;

  Future<void> analyze();

  /// Removes all data from this db.
  Future<void> clear();

  /// Only once instance is allowed.
  ///
  /// In tests it can happen that database was opened and disposed later.
  Future<void> close();
}

@DriftDatabase(
  tables: [
    DocumentsV2,
    DocumentAuthors,
    DocumentArtifacts,
    DocumentCollaborators,
    DocumentParameters,
    DocumentsLocalMetadata,
    LocalDocumentsDrafts,
  ],
  daos: [
    DriftDocumentsV2Dao,
    DriftProposalsV2Dao,
    DriftDocumentsV2LocalMetadataDao,
    DriftLocalDraftDocumentsV2Dao,
  ],
  queries: {},
  views: [],
  include: {},
)
class DriftCatalystDatabase extends $DriftCatalystDatabase implements CatalystDatabase {
  final _clearLock = Lock();

  @visibleForTesting
  DriftCatalystDatabase(super.connection);

  factory DriftCatalystDatabase.withConfig({
    required CatalystDriftDatabaseConfig config,
    QueryInterceptor? interceptor,
  }) {
    var connection = driftDatabase(
      name: config.name,
      web: DriftWebOptions(
        sqlite3Wasm: config.web.sqlite3Wasm,
        driftWorker: config.web.driftWorker,
      ),
      native: DriftNativeOptions(
        databaseDirectory: config.native.dbDir,
        tempDirectoryPath: config.native.dbTempDir,
      ),
    );

    if (interceptor != null) {
      connection = connection.interceptWith(interceptor);
    }

    return DriftCatalystDatabase(connection);
  }

  @override
  DocumentsV2Dao get documentsV2Dao => driftDocumentsV2Dao;

  @override
  LocalDraftDocumentsV2Dao get localDocumentsV2Dao => driftLocalDraftDocumentsV2Dao;

  @override
  DocumentsV2LocalMetadataDao get localMetadataDao => driftDocumentsV2LocalMetadataDao;

  @override
  MigrationStrategy get migration {
    return DriftMigrationStrategy(
      database: this,
      destructiveFallback: destructiveFallback,
    );
  }

  @override
  Future<void> get pendingOperations async {
    // Operations are queued so this will be executed after previous stack is cleared.
    await customSelect('select 1').get();
  }

  @override
  ProposalsV2Dao get proposalsV2Dao => driftProposalsV2Dao;

  @override
  int get schemaVersion => 4;

  @override
  Future<void> analyze() async {
    await customStatement('ANALYZE');
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
