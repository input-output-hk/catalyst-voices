import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_local_metadata_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../connection/test_connection.dart';
import '../drift_test_platforms.dart';

void main() {
  group(
    DriftDocumentsV2LocalMetadataDao,
    () {
      late DriftCatalystDatabase db;
      late DocumentsV2LocalMetadataDao dao;

      setUp(() async {
        final connection = await buildTestConnection();
        db = DriftCatalystDatabase(connection);
        dao = db.driftDocumentsV2LocalMetadataDao;
      });

      tearDown(() async {
        await db.close();
      });

      group('deleteWhere', () {
        test('returns zero when database is empty', () async {
          // Given: An empty database

          // When
          final result = await dao.deleteWhere();

          // Then
          expect(result, 0);
        });

        test('deletes single record and returns count', () async {
          // Given
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-1',
                  isFavorite: true,
                ),
              );

          // When
          final result = await dao.deleteWhere();

          // Then
          expect(result, 1);
        });

        test('deletes all records and returns total count', () async {
          // Given
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-1',
                  isFavorite: true,
                ),
              );
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-2',
                  isFavorite: false,
                ),
              );
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-3',
                  isFavorite: true,
                ),
              );

          // When
          final result = await dao.deleteWhere();

          // Then
          expect(result, 3);
        });

        test('table is empty after deletion', () async {
          // Given
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-1',
                  isFavorite: true,
                ),
              );
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-2',
                  isFavorite: true,
                ),
              );

          // When
          await dao.deleteWhere();

          // Then
          final remaining = await db.select(db.documentsLocalMetadata).get();
          expect(remaining, isEmpty);
        });

        test('subsequent delete returns zero', () async {
          // Given
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-1',
                  isFavorite: true,
                ),
              );
          await dao.deleteWhere();

          // When
          final result = await dao.deleteWhere();

          // Then
          expect(result, 0);
        });
      });

      group('isFavorite', () {
        test('returns false when document does not exist', () async {
          // Given: An empty database

          // When
          final result = await dao.isFavorite('non-existent-id');

          // Then
          expect(result, isFalse);
        });

        test('returns false when document exists but is not favorite', () async {
          // Given
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-1',
                  isFavorite: false,
                ),
              );

          // When
          final result = await dao.isFavorite('doc-1');

          // Then
          expect(result, isFalse);
        });

        test('returns true when document is marked as favorite', () async {
          // Given
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-1',
                  isFavorite: true,
                ),
              );

          // When
          final result = await dao.isFavorite('doc-1');

          // Then
          expect(result, isTrue);
        });

        test('returns correct value for specific document among multiple', () async {
          // Given
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-1',
                  isFavorite: true,
                ),
              );
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-2',
                  isFavorite: false,
                ),
              );
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-3',
                  isFavorite: true,
                ),
              );

          // When & Then
          expect(await dao.isFavorite('doc-1'), isTrue);
          expect(await dao.isFavorite('doc-2'), isFalse);
          expect(await dao.isFavorite('doc-3'), isTrue);
        });

        test('returns false for non-existent id among existing records', () async {
          // Given
          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'doc-1',
                  isFavorite: true,
                ),
              );

          // When
          final result = await dao.isFavorite('doc-2');

          // Then
          expect(result, isFalse);
        });
      });
    },
    skip: driftSkip,
  );
}
