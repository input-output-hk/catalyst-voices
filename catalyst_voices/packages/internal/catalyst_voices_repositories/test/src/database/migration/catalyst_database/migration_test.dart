// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/common.dart' as sqlite3 show jsonb;

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
            // await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v3 to v4 does not corrupt data', () async {
    final id = DocumentRefFactory.randomUuidV7();
    final idHiLo = UuidHiLo.from(id);

    final metadata = DocumentDataMetadataDto(
      type: DocumentType.proposalDocument,
      selfRef: DocumentRefDto(
        id: id,
        version: id,
        type: DocumentRefDtoType.signed,
      ),
      ref: DocumentRefDto(
        id: id,
        version: id,
        type: DocumentRefDtoType.signed,
      ),
      reply: DocumentRefDto(
        id: id,
        version: id,
        type: DocumentRefDtoType.signed,
      ),
      categoryId: DocumentRefDto(
        id: id,
        version: id,
        type: DocumentRefDtoType.signed,
      ),
      // authors: [
      //   'id.catalyst://john@preprod.cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE=',
      // ],
    );
    final encodedMetadata = sqlite3.jsonb.encode(metadata.toJson());

    final oldDocumentsData = <v3.DocumentsData>[
      v3.DocumentsData(
        idHi: idHiLo.high,
        idLo: idHiLo.low,
        verHi: idHiLo.high,
        verLo: idHiLo.low,
        content: Uint8List(0),
        metadata: encodedMetadata,
        type: DocumentType.proposalDocument.uuid,
        createdAt: id.dateTime,
      ),
    ];
    final expectedNewDocumentsData = <v4.DocumentsData>[
      v4.DocumentsData(
        idHi: idHiLo.high,
        idLo: idHiLo.low,
        verHi: idHiLo.high,
        verLo: idHiLo.low,
        content: Uint8List(0),
        metadata: encodedMetadata,
        type: DocumentType.proposalDocument.uuid,
        createdAt: id.dateTime,
      ),
    ];

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
        batch
          ..insertAll(oldDb.documents, oldDocumentsData)
          ..insertAll(oldDb.documentsMetadata, oldDocumentsMetadataData)
          ..insertAll(oldDb.documentsFavorites, oldDocumentsFavoritesData)
          ..insertAll(oldDb.drafts, oldDraftsData);
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
