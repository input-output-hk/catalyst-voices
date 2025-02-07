import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import '../test_factories.dart';

void main() {
  late DriftCatalystDatabase database;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DriftCatalystDatabase(inMemory);
  });

  tearDown(() async {
    await database.close();
  });

  group(DocumentsDao, () {
    group('save all', () {
      test('documents can be queried back correctly', () async {
        // Given
        final documentsWithMetadata = List<DocumentWithMetadata>.generate(
          10,
          (index) => DocumentWithMetadataFactory.build(),
        );
        final expectedDocuments = documentsWithMetadata.map((e) => e.document);

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final documents = await database.documentsDao.queryAll();

        expect(documents, expectedDocuments);
      });

      test('conflicting documents are ignored', () async {
        // Given
        final documentsWithMetadata = List<DocumentWithMetadata>.generate(
          20,
          (index) => DocumentWithMetadataFactory.build(),
        );

        final expectedDocuments = documentsWithMetadata.map((e) => e.document);

        // When
        final firstBatch = documentsWithMetadata.sublist(0, 10);
        final secondBatch = documentsWithMetadata.sublist(5);

        await database.documentsDao.saveAll(firstBatch);
        await database.documentsDao.saveAll(secondBatch);

        // Then
        final documents = await database.documentsDao.queryAll();

        expect(documents, expectedDocuments);
      });
    });

    group('watch all', () {
      test('emits data when new entities are saved', () async {
        // Given
        final documentsWithMetadata = List<DocumentWithMetadata>.generate(
          1,
          (index) => DocumentWithMetadataFactory.build(),
        );

        final expectedDocuments =
            documentsWithMetadata.map((e) => e.document).toList();

        // When
        final documentsStream = database.documentsDao.watchAll();

        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        expect(
          documentsStream,
          emitsInOrder([
            // later we inserting documents
            equals(expectedDocuments),
          ]),
        );
      });
    });

    group('count', () {
      test('document returns expected number', () async {
        // Given
        final documentsWithMetadata = List<DocumentWithMetadata>.generate(
          20,
          (index) => DocumentWithMetadataFactory.build(),
        );

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final count = await database.documentsDao.countDocuments();

        expect(count, documentsWithMetadata.length);
      });

      test('two versions of same document will be counted as one', () async {
        // Given
        final id = const Uuid().v7();
        final documentsWithMetadata = List<DocumentWithMetadata>.generate(
          2,
          (index) {
            final metadata = SignedDocumentMetadata(
              type: SignedDocumentType.proposalDocument,
              id: id,
              version: const Uuid().v7(),
            );
            return DocumentWithMetadataFactory.build(metadata: metadata);
          },
        );

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final count = await database.documentsDao.countDocuments();

        expect(count, 1);
      });
    });

    group('delete all', () {
      test('removes all documents', () async {
        // Given
        final documentsWithMetadata = List<DocumentWithMetadata>.generate(
          5,
          (index) => DocumentWithMetadataFactory.build(),
        );

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final countBefore = await database.documentsDao.countDocuments();
        expect(countBefore, isNonZero);

        await database.documentsDao.deleteAll();

        final countAfter = await database.documentsDao.countDocuments();
        expect(countAfter, isZero);
      });

      test('cascades metadata', () async {
        // Given
        final documentsWithMetadata = List<DocumentWithMetadata>.generate(
          5,
          (index) => DocumentWithMetadataFactory.build(),
        );

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final before = await database.documentsDao.countDocumentsMetadata();
        expect(before, isNonZero);

        await database.documentsDao.deleteAll();

        final after = await database.documentsDao.countDocumentsMetadata();
        expect(after, isZero);
      });
    });
  });
}
