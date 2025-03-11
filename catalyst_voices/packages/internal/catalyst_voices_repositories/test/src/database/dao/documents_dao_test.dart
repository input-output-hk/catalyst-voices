import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/database.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

import '../../utils/test_factories.dart';

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
        final ref = SignedDocumentRef(
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
              selfRef: DocumentRefFactory.buildSigned(
                id: id,
                version: firstVersionId,
              ),
            ),
          ),
          DocumentWithMetadataFactory.build(
            content: secondContent,
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              selfRef: DocumentRefFactory.buildSigned(
                id: id,
                version: secondVersionId,
              ),
            ),
          ),
        ];
        final document = documentsWithMetadata.first.document;
        final ref = SignedDocumentRef(id: document.metadata.id);

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
        final ref = SignedDocumentRef(id: const Uuid().v7());

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final entity = await database.documentsDao.query(ref: ref);

        expect(entity, isNull);
      });

      test('all refs return as expected', () async {
        // Given
        final refs = List.generate(10, (_) => DocumentRefFactory.buildSigned());
        final documentsWithMetadata = refs.map((ref) {
          return DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              selfRef: ref,
            ),
          );
        });

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final allRefs = await database.documentsDao.queryAllRefs();

        expect(
          allRefs,
          allOf(hasLength(refs.length), containsAll(refs)),
        );
      });

      test('Return latest unique documents', () async {
        final id = const Uuid().v7();
        final version = const Uuid().v7();
        await Future<void>.delayed(const Duration(milliseconds: 1));
        final version2 = const Uuid().v7();
        final document = DocumentWithMetadataFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: SignedDocumentRef(id: id, version: version),
          ),
        );
        final document2 = DocumentWithMetadataFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: SignedDocumentRef(id: id, version: version2),
          ),
        );
        final documentsStream =
            database.documentsDao.watchAll(unique: true).asBroadcastStream();

        await database.documentsDao.saveAll([document]);
        final firstEmission = await documentsStream.first;
        await database.documentsDao.saveAll([document2]);
        final secondEmission = await documentsStream.first;

        expect(firstEmission, equals([document.document]));
        expect(secondEmission, equals([document2.document]));
        expect(secondEmission.length, equals(1));
        expect(secondEmission.first.metadata.selfRef.version, equals(version2));
      });

      test('Returns latest document limited by quantity if provided', () async {
        // Given
        final documentsWithMetadata = List<DocumentEntityWithMetadata>.generate(
          20,
          (index) => DocumentWithMetadataFactory.build(),
        );

        final expectedDocuments = documentsWithMetadata
            .map((e) => e.document)
            .groupListsBy((doc) => '${doc.idHi}-${doc.idLo}')
            .values
            .map(
              (versions) => versions.reduce((a, b) {
                // Compare versions (higher version wins)
                final compareHi = b.verHi.compareTo(a.verHi);
                if (compareHi != 0) return compareHi > 0 ? b : a;
                return b.verLo.compareTo(a.verLo) > 0 ? b : a;
              }),
            )
            .toList()
          ..sort((a, b) {
            // Sort by version descending
            final compareHi = b.verHi.compareTo(a.verHi);
            if (compareHi != 0) return compareHi;
            return b.verLo.compareTo(a.verLo);
          });

        final limitedExpectedDocuments = expectedDocuments.take(7).toList();

        // When
        final documentsStream =
            database.documentsDao.watchAll(limit: 7, unique: true);

        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        expect(
          documentsStream,
          emitsInOrder([
            equals(limitedExpectedDocuments),
          ]),
        );

        expect(
          limitedExpectedDocuments.length,
          equals(7),
          reason: 'should have 7 documents',
        );

        final uniqueIds =
            limitedExpectedDocuments.map((d) => '${d.idHi}-${d.idLo}').toSet();
        expect(
          uniqueIds.length,
          equals(limitedExpectedDocuments.length),
          reason: 'should have unique document IDs',
        );
      });

      test('returns latest version when document has more than 1 version',
          () async {
        final id = const Uuid().v7();
        final v1 = const Uuid().v7();
        await Future<void>.delayed(const Duration(milliseconds: 1));
        final v2 = const Uuid().v7();

        final documentsWithMetadata = [v1, v2].map((version) {
          final metadata = DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: DocumentRefFactory.buildSigned(
              id: id,
              version: version,
            ),
          );
          return DocumentWithMetadataFactory.build(metadata: metadata);
        }).toList();

        // When
        final documentsStream =
            database.documentsDao.watchAll(limit: 7, unique: true);

        await database.documentsDao.saveAll(documentsWithMetadata);
        // Then
        expect(
          documentsStream,
          emitsInOrder([
            predicate<List<DocumentEntity>>(
              (documents) {
                if (documents.length != 1) return false;
                final doc = documents.first;
                return doc.metadata.version == v2;
              },
              'should return document with version $v2',
            ),
          ]),
        );
      });

      test('emits new version of recent document', () async {
        // Generate base ID
        final id = const Uuid().v7();

        // Create versions with enforced order (v2 is newer than v1)
        final v1 = const Uuid().v7();
        // Wait a moment to ensure second UUID is newer
        await Future<void>.delayed(const Duration(milliseconds: 1));
        final v2 = const Uuid().v7();

        final documentsWithMetadata = DocumentWithMetadataFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: DocumentRefFactory.buildSigned(
              id: id,
              version: v1,
            ),
          ),
        );

        final newVersion = DocumentWithMetadataFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: DocumentRefFactory.buildSigned(
              id: id,
              version: v2,
            ),
          ),
        );

        // When
        final documentsStream = database.documentsDao
            .watchAll(limit: 7, unique: true)
            .asBroadcastStream();

        // Save first version and wait for emission
        await database.documentsDao.saveAll([documentsWithMetadata]);
        final firstEmission = await documentsStream.first;

        // Save second version and wait for emission
        await database.documentsDao.saveAll([newVersion]);
        final secondEmission = await documentsStream.first;

        // Then verify both emissions
        expect(firstEmission, equals([documentsWithMetadata.document]));
        expect(secondEmission, equals([newVersion.document]));
      });

      test('emits new document when is inserted', () async {
        // Generate base ID
        final id1 = const Uuid().v7();

        // Create versions with enforced order (v2 is newer than v1)
        final v1 = const Uuid().v7();
        // Wait a moment to ensure second UUID is newer
        await Future<void>.delayed(const Duration(milliseconds: 1));
        final id2 = const Uuid().v7();
        final v2 = const Uuid().v7();

        final document1 = DocumentWithMetadataFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: DocumentRefFactory.buildSigned(
              id: id1,
              version: v1,
            ),
          ),
        );

        final document2 = DocumentWithMetadataFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: DocumentRefFactory.buildSigned(
              id: id2,
              version: v2,
            ),
          ),
        );

        // When
        final documentsStream = database.documentsDao
            .watchAll(limit: 1, unique: true)
            .asBroadcastStream();

        await database.documentsDao.saveAll([document1]);
        final firstEmission = await documentsStream.first;

        await database.documentsDao.saveAll([document2]);
        final secondEmission = await documentsStream.first;

        // Then verify both emissions
        expect(firstEmission, equals([document1.document]));
        expect(
          secondEmission,
          equals([document2.document]),
        );
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
              selfRef: DocumentRefFactory.buildSigned(id: id),
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
              selfRef: DocumentRefFactory.buildSigned(id: id),
            );
            return DocumentWithMetadataFactory.build(metadata: metadata);
          },
        );

        final expectedCount = documentsWithMetadata.length;
        final ref = SignedDocumentRef(id: id);

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
              selfRef: DocumentRefFactory.buildSigned(id: id),
            );
            return DocumentWithMetadataFactory.build(metadata: metadata);
          },
        );
        final version = documentsWithMetadata.first.document.metadata.version;
        final ref = SignedDocumentRef(id: id, version: version);

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
              selfRef: DocumentRefFactory.buildSigned(),
            );
            return DocumentWithMetadataFactory.build(metadata: metadata);
          },
        );
        final document = documentsWithMetadata.last.document;
        final id = document.metadata.id;
        final version = document.metadata.version;
        final ref = SignedDocumentRef(id: id, version: version);

        // When
        await database.documentsDao.saveAll(documentsWithMetadata);

        // Then
        final count = await database.documentsDao.count(ref: ref);

        expect(count, 1);
      });

      test('Counts comments for specific proposal document version', () async {
        final proposalId = const Uuid().v7();
        final versionId = const Uuid().v7();
        final proposalRef = DocumentRefFactory.buildSigned(
          id: proposalId,
          version: versionId,
        );
        final proposal = DocumentWithMetadataFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: proposalRef,
          ),
        );

        await database.documentsDao.saveAll([proposal]);

        final comments = List.generate(
          10,
          (index) => DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.commentTemplate,
              selfRef: DocumentRefFactory.buildSigned(),
              ref: proposalRef,
            ),
          ),
        );
        final otherComments = List.generate(
          5,
          (index) => DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.commentTemplate,
              selfRef: DocumentRefFactory.buildSigned(),
              ref: DocumentRefFactory.buildSigned(),
            ),
          ),
        );
        await database.documentsDao.saveAll([...comments, ...otherComments]);

        final count = await database.documentsDao.countRefDocumentByType(
          ref: proposalRef,
          type: DocumentType.commentTemplate,
        );

        expect(count, equals(10));
      });

      test('Count versions of specific document', () async {
        final proposalId = const Uuid().v7();
        final versionId = const Uuid().v7();
        final proposalRef = DocumentRefFactory.buildSigned(
          id: proposalId,
          version: versionId,
        );
        final proposal = DocumentWithMetadataFactory.build(
          metadata: DocumentDataMetadata(
            type: DocumentType.proposalDocument,
            selfRef: proposalRef,
          ),
        );

        await database.documentsDao.saveAll([proposal]);

        final versions = List.generate(
          10,
          (index) {
            return DocumentWithMetadataFactory.build(
              metadata: DocumentDataMetadata(
                type: DocumentType.proposalDocument,
                selfRef: DocumentRefFactory.buildSigned(
                  id: proposalId,
                ),
                ref: proposalRef,
              ),
            );
          },
        );

        await database.documentsDao.saveAll(versions);

        final ids = await database.documentsDao.queryVersionsOfId(
          id: proposalId,
        );

        expect(ids.length, equals(11));
      });

      test(
        'Watches comments count',
        () async {
          final proposalId = const Uuid().v7();
          await Future<void>.delayed(const Duration(milliseconds: 1));
          final versionId = const Uuid().v7();
          final proposalId2 = const Uuid().v7();
          final proposalRef = DocumentRefFactory.buildSigned(
            id: proposalId,
            version: versionId,
          );
          final proposal = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.proposalDocument,
              selfRef: proposalRef,
            ),
          );

          final proposalRef2 = DocumentRefFactory.buildSigned(
            id: proposalId2,
            version: versionId,
          );

          await database.documentsDao.saveAll([proposal]);

          final comments = List.generate(2, (index) {
            return DocumentWithMetadataFactory.build(
              metadata: DocumentDataMetadata(
                type: DocumentType.commentTemplate,
                selfRef: DocumentRefFactory.buildSigned(),
                ref: proposalRef,
              ),
            );
          });

          final otherComment = DocumentWithMetadataFactory.build(
            metadata: DocumentDataMetadata(
              type: DocumentType.commentTemplate,
              selfRef: DocumentRefFactory.buildSigned(),
              ref: proposalRef2,
            ),
          );

          await database.documentsDao.saveAll([comments.first, otherComment]);

          final documentCount = database.documentsDao
              .watchCount(ref: proposalRef, type: DocumentType.commentTemplate)
              .asBroadcastStream();

          final firstEmission = await documentCount.first;
          // TODO(damian-molinski): JSONB filtering
          // After proper filtering this test should pass
          expect(firstEmission, equals(1));

          // Save second comment and wait for update
          await database.documentsDao.saveAll([comments.last]);
          final secondEmission = await documentCount.first;
          expect(secondEmission, equals(2));
        },
        skip: true,
      );
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
