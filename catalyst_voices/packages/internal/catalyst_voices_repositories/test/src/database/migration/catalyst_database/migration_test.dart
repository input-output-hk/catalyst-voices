// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = DriftCatalystDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v3 to v4 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldDocumentsData = <v3.DocumentsData>[];
    final expectedNewDocumentsData = <v4.DocumentsData>[];

    final oldDocumentsMetadataData = <v3.DocumentsMetadataData>[];
    final expectedNewDocumentsMetadataData = <v4.DocumentsMetadataData>[];

    final oldDocumentsFavoritesData = <v3.DocumentsFavoritesData>[];
    final expectedNewDocumentsFavoritesData = <v4.DocumentsFavoritesData>[];

    final oldDraftsData = <v3.DraftsData>[];
    final expectedNewDraftsData = <v4.DraftsData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 3,
      newVersion: 4,
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: DriftCatalystDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.documents, oldDocumentsData);
        batch.insertAll(oldDb.documentsMetadata, oldDocumentsMetadataData);
        batch.insertAll(oldDb.documentsFavorites, oldDocumentsFavoritesData);
        batch.insertAll(oldDb.drafts, oldDraftsData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewDocumentsData,
          await newDb.select(newDb.documents).get(),
        );
        expect(
          expectedNewDocumentsMetadataData,
          await newDb.select(newDb.documentsMetadata).get(),
        );
        expect(
          expectedNewDocumentsFavoritesData,
          await newDb.select(newDb.documentsFavorites).get(),
        );
        expect(expectedNewDraftsData, await newDb.select(newDb.drafts).get());
      },
    );
  });
}
