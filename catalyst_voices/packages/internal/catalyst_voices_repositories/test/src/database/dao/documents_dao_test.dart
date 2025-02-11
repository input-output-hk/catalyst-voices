import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/database.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/data.dart';
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
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
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
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
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

    group('query', () {
      test('stream emits data when new entities are saved', () async {
        // Given
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
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

      test('returns specific version matching exact ref', () async {
        // Given
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
          2,
          (index) => DocumentWithMetadataFactory.build(),
        );
        final document = documentsWithMetadata.first.document;
        final ref = DocumentRef(
          id: document.metadata.id,
          version: document.metadata.version,
        );

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final entity = await database.documentsDao.query(ref: ref);

        expect(entity, isNotNull);

        final id = UuidHiLo(high: entity!.idHi, low: entity.idLo);
        final ver = UuidHiLo(high: entity.verHi, low: entity.verLo);

        expect(id.uuid, ref.id);
        expect(ver.uuid, ref.version);
      });

      test('returns newest version when ver is not specified', () async {
        // Given
        final id = const Uuid().v7();
        final firstVersionId = const Uuid().v7(
          config: V7Options(
            DateTime(2025, 2, 10).millisecondsSinceEpoch,
            null,
          ),
        );
        final secondVersionId = const Uuid().v7(
          config: V7Options(
            DateTime(2025, 2, 11).millisecondsSinceEpoch,
            null,
          ),
        );

        const secondContent = DocumentDataContent({'title': 'Dev'});
        final documentsWithMetadata = <DocumentEntityWithMetadata>[
          DocumentWithMetadataFactory.build(
            content: const DocumentDataContent({'title': 'D'}),
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              id: id,
              version: firstVersionId,
            ),
          ),
          DocumentWithMetadataFactory.build(
            content: secondContent,
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              id: id,
              version: secondVersionId,
            ),
          ),
        ];
        final document = documentsWithMetadata.first.document;
        final ref = DocumentRef(id: document.metadata.id);

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final entity = await database.documentsDao.query(ref: ref);

        expect(entity, isNotNull);

        expect(entity!.metadata.id, id);
        expect(entity.metadata.version, secondVersionId);
        expect(entity.content, secondContent);
      });

      test('returns null when id does not match any id', () async {
        // Given
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
          2,
          (index) => DocumentWithMetadataFactory.build(),
        );
        final ref = DocumentRef(id: const Uuid().v7());

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final entity = await database.documentsDao.query(ref: ref);

        expect(entity, isNull);
      });
    });

    group('count', () {
      test('document returns expected number', () async {
        // Given
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
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
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
          2,
          (index) {
            final metadata = DocumentDataMetadata(
              type: DocumentType.proposalDocument,
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

      test('where without ver counts all versions', () async {
        // Given
        final id = const Uuid().v7();
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
          2,
          (index) {
            final metadata = DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              id: id,
              version: const Uuid().v7(),
            );
            return DocumentWithMetadataFactory.build(metadata: metadata);
          },
        );

        final expectedCount = documentsWithMetadata.length;
        final ref = DocumentRef(id: id);

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final count = await database.documentsDao.count(ref: ref);

        expect(count, expectedCount);
      });

      test('where with ver counts only matching results', () async {
        // Given
        final id = const Uuid().v7();
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
          2,
          (index) {
            final metadata = DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              id: id,
              version: const Uuid().v7(),
            );
            return DocumentWithMetadataFactory.build(metadata: metadata);
          },
        );
        final version = documentsWithMetadata.first.document.metadata.version;
        final ref = DocumentRef(id: id, version: version);

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final count = await database.documentsDao.count(ref: ref);

        expect(count, 1);
      });

      test(
          'where returns correct value when '
          'many different documents are found', () async {
        // Given
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
          10,
          (index) {
            final metadata = DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              id: const Uuid().v7(),
              version: const Uuid().v7(),
            );
            return DocumentWithMetadataFactory.build(metadata: metadata);
          },
        );
        final document = documentsWithMetadata.last.document;
        final id = document.metadata.id;
        final version = document.metadata.version;
        final ref = DocumentRef(id: id, version: version);

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final count = await database.documentsDao.count(ref: ref);

        expect(count, 1);
      });
    });

    group('delete all', () {
      test('removes all documents', () async {
        // Given
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
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
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
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
