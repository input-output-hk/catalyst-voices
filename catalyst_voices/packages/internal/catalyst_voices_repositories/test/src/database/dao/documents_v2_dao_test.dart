// ignore_for_file: avoid_redundant_argument_values

import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_with_authors_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/document_with_authors_factory.dart';
import '../connection/test_connection.dart';

void main() {
  late DriftCatalystDatabase db;
  late DocumentsV2Dao dao;

  setUp(() async {
    final connection = await buildTestConnection();
    db = DriftCatalystDatabase(connection);
    dao = db.documentsV2Dao;
  });

  tearDown(() async {
    await db.close();
  });

  group(DocumentsV2Dao, () {
    group('count', () {
      test('returns zero for empty database', () async {
        // Given: An empty database

        // When: count is called
        final result = await dao.count();

        // Then: Returns 0
        expect(result, 0);
      });

      test('returns correct count after inserting new documents', () async {
        // Given
        final entities = [
          _createTestDocumentEntity(id: 'test-id-1', ver: 'test-ver-1'),
          _createTestDocumentEntity(id: 'test-id-2', ver: 'test-ver-2'),
        ];
        await dao.saveAll(entities);

        // When
        final result = await dao.count();

        // Then
        expect(result, 2);
      });

      test('ignores conflicts and returns accurate count', () async {
        // Given
        final existing = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
        await dao.save(existing);

        final entities = [
          _createTestDocumentEntity(id: 'test-id', ver: 'test-ver'), // Conflict
          _createTestDocumentEntity(id: 'new-id', ver: 'new-ver'), // New
        ];
        await dao.saveAll(entities);

        // When
        final result = await dao.count();

        // Then
        expect(result, 2);
      });
    });

    group('exists', () {
      test('returns false for non-existing ref in empty database', () async {
        // Given
        const ref = SignedDocumentRef.exact(id: 'non-existent-id', version: 'non-existent-ver');

        // When
        final result = await dao.exists(ref);

        // Then
        expect(result, isFalse);
      });

      test('returns true for existing exact ref', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.exact(id: 'test-id', version: 'test-ver');

        // When
        final result = await dao.exists(ref);

        // Then
        expect(result, isTrue);
      });

      test('returns false for non-existing exact ref', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.exact(id: 'test-id', version: 'wrong-ver');

        // When
        final result = await dao.exists(ref);

        // Then: Returns false (ver mismatch)
        expect(result, isFalse);
      });

      test('returns true for loose ref if any version exists', () async {
        // Given
        final entityV1 = _createTestDocumentEntity(id: 'test-id', ver: 'ver-1');
        final entityV2 = _createTestDocumentEntity(id: 'test-id', ver: 'ver-2');
        await dao.saveAll([entityV1, entityV2]);

        // And
        const ref = SignedDocumentRef.loose(id: 'test-id');

        // When
        final result = await dao.exists(ref);

        // Then
        expect(result, isTrue);
      });

      test('returns false for loose ref if no versions exist', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'other-id', ver: 'other-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.loose(id: 'non-existent-id');

        // When
        final result = await dao.exists(ref);

        // Then
        expect(result, isFalse);
      });

      test('handles null version in exact ref (treats as loose)', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.loose(id: 'test-id');

        // When
        final result = await dao.exists(ref);

        // Then: Returns true (any version matches)
        expect(result, isTrue);
      });

      test('performs efficiently for large batches (no N+1 queries)', () async {
        // Given: 1000 entities inserted (simulate large sync)
        final entities = List.generate(
          1000,
          (i) => _createTestDocumentEntity(id: 'batch-$i', ver: 'ver-$i'),
        );
        await dao.saveAll(entities);

        // And: A ref for an existing id
        const ref = SignedDocumentRef.loose(id: 'batch-500');

        // When: exists is called (should use single query)
        final stopwatch = Stopwatch()..start();
        final result = await dao.exists(ref);
        stopwatch.stop();

        // Then: Returns true, and executes quickly (<10ms expected)
        expect(result, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(10));
      });
    });

    group('filterExisting', () {
      test('returns empty list for empty input', () async {
        // Given
        final refs = <DocumentRef>[];

        // When
        final result = await dao.filterExisting(refs);

        // Then
        expect(result, isEmpty);
      });

      test('returns all refs if they exist (mixed exact and loose)', () async {
        // Given
        final entity1 = _createTestDocumentEntity(id: 'id-1', ver: 'ver-1');
        final entity2 = _createTestDocumentEntity(id: 'id-2', ver: 'ver-2');
        await dao.saveAll([entity1, entity2]);

        // And
        final refs = [
          const SignedDocumentRef.exact(id: 'id-1', version: 'ver-1'),
          const SignedDocumentRef.loose(id: 'id-2'),
        ];

        // When
        final result = await dao.filterExisting(refs);

        // Then
        expect(result.length, 2);
        expect(result[0].id, 'id-1');
        expect(result[0].version, 'ver-1');
        expect(result[1].id, 'id-2');
        expect(result[1].version, isNull);
      });

      test('filters out non-existing refs (mixed exact and loose)', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'existing-id', ver: 'existing-ver');
        await dao.save(entity);

        // And
        final refs = [
          const SignedDocumentRef.exact(id: 'existing-id', version: 'existing-ver'),
          const SignedDocumentRef.exact(id: 'non-id', version: 'non-ver'),
          const SignedDocumentRef.loose(id: 'existing-id'),
          const SignedDocumentRef.loose(id: 'non-id'),
        ];

        // When
        final result = await dao.filterExisting(refs);

        // Then
        expect(result.length, 2);
        expect(result[0].id, 'existing-id');
        expect(result[0].version, 'existing-ver');
        expect(result[1].id, 'existing-id');
        expect(result[1].version, isNull);
      });

      test('handles multiple versions for loose refs', () async {
        // Given
        final entityV1 = _createTestDocumentEntity(id: 'multi-id', ver: 'ver-1');
        final entityV2 = _createTestDocumentEntity(id: 'multi-id', ver: 'ver-2');
        await dao.saveAll([entityV1, entityV2]);

        // And
        final refs = [
          const SignedDocumentRef.loose(id: 'multi-id'),
          const SignedDocumentRef.exact(id: 'multi-id', version: 'ver-1'),
          const SignedDocumentRef.exact(id: 'multi-id', version: 'wrong-ver'),
        ];

        // When
        final result = await dao.filterExisting(refs);

        // Then
        expect(result.length, 2);
        expect(result[0].version, isNull);
        expect(result[1].version, 'ver-1');
      });

      test('performs efficiently for large lists (single query)', () async {
        // Given
        final entities = List.generate(
          1000,
          (i) => _createTestDocumentEntity(id: 'batch-${i % 500}', ver: 'ver-$i'),
        );
        await dao.saveAll(entities);

        // And
        final refs = List.generate(
          1000,
          (i) => i.isEven
              ? SignedDocumentRef.exact(id: 'batch-${i % 500}', version: 'ver-$i')
              : SignedDocumentRef.loose(id: 'non-$i'),
        );

        // When
        final stopwatch = Stopwatch()..start();
        final result = await dao.filterExisting(refs);
        stopwatch.stop();

        // Then
        expect(result.length, 500);
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });

    group('getDocument', () {
      test('returns null for non-existing ref in empty database', () async {
        // Given
        const ref = SignedDocumentRef.exact(id: 'non-existent-id', version: 'non-existent-ver');

        // When
        final result = await dao.getDocument(ref);

        // Then
        expect(result, isNull);
      });

      test('returns entity for existing exact ref', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.exact(id: 'test-id', version: 'test-ver');

        // When
        final result = await dao.getDocument(ref);

        // Then
        expect(result, isNotNull);
        expect(result!.id, 'test-id');
        expect(result.ver, 'test-ver');
      });

      test('returns null for non-existing exact ref', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.exact(id: 'test-id', version: 'wrong-ver');

        // When: getDocument is called
        final result = await dao.getDocument(ref);

        // Then: Returns null
        expect(result, isNull);
      });

      test('returns latest entity for loose ref if versions exist', () async {
        // Given
        final oldCreatedAt = DateTime.utc(2023, 2, 2);
        final newerCreatedAt = DateTime.utc(2024, 2, 2);

        final oldVer = _buildUuidV7At(oldCreatedAt);
        final newerVer = _buildUuidV7At(newerCreatedAt);
        final entityOld = _createTestDocumentEntity(id: 'test-id', ver: oldVer);
        final entityNew = _createTestDocumentEntity(id: 'test-id', ver: newerVer);
        await dao.saveAll([entityOld, entityNew]);

        // And
        const ref = SignedDocumentRef.loose(id: 'test-id');

        // When
        final result = await dao.getDocument(ref);

        // Then
        expect(result, isNotNull);
        expect(result!.ver, newerVer);
        expect(result.createdAt, newerCreatedAt);
      });

      test('returns null for loose ref if no versions exist', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'other-id', ver: 'other-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.loose(id: 'non-existent-id');

        // When
        final result = await dao.getDocument(ref);

        // Then
        expect(result, isNull);
      });
    });

    group('saveAll', () {
      test('does nothing for empty list', () async {
        // Given
        final entities = <DocumentWithAuthorsEntity>[];

        // When
        await dao.saveAll(entities);

        // Then
        final count = await dao.count();
        expect(count, 0);
      });

      test('inserts new documents', () async {
        // Given
        final entities = [
          _createTestDocumentEntity(),
          _createTestDocumentEntity(),
        ];

        // When
        await dao.saveAll(entities);

        // Then
        final saved = await db.select(db.documentsV2).get();
        final savedIds = saved.map((e) => e.id);
        final expectedIds = entities.map((e) => e.doc.id);

        expect(savedIds, expectedIds);
      });

      test('ignores conflicts on existing {id, ver}', () async {
        // Given
        final existing = _createTestDocumentEntity(
          id: 'test-id',
          ver: 'test-ver',
          contentData: {'key': 'original'},
        );
        await dao.save(existing);

        // And
        final entities = [
          _createTestDocumentEntity(
            id: 'test-id',
            ver: 'test-ver',
            contentData: {'key': 'modified'},
          ),
          _createTestDocumentEntity(id: 'new-id', ver: 'new-ver'),
        ];

        // When
        await dao.saveAll(entities);

        // Then
        final saved = await db.select(db.documentsV2).get();
        expect(saved.length, 2);
        final existingAfter = saved.firstWhere((e) => e.id == 'test-id');
        expect(existingAfter.content.data['key'], 'original');
        expect(saved.any((e) => e.id == 'new-id'), true);
      });

      test('handles mixed inserts and ignores atomically', () async {
        // Given
        final existing1 = _createTestDocumentEntity(id: 'existing-1', ver: 'ver-1');
        final existing2 = _createTestDocumentEntity(id: 'existing-2', ver: 'ver-2');
        await dao.save(existing1);
        await dao.save(existing2);

        // And:
        final entities = [
          _createTestDocumentEntity(id: 'existing-1', ver: 'ver-1'),
          _createTestDocumentEntity(id: 'new-1', ver: 'new-ver-1'),
          _createTestDocumentEntity(id: 'existing-2', ver: 'ver-2'),
          _createTestDocumentEntity(id: 'new-2', ver: 'new-ver-2'),
        ];

        // When
        await dao.saveAll(entities);

        // Then
        final saved = await db.select(db.documentsV2).get();
        expect(saved.length, 4);
        expect(saved.map((e) => e.id).toSet(), {'existing-1', 'existing-2', 'new-1', 'new-2'});
      });
    });

    group('save', () {
      test('inserts new document', () async {
        // Given
        final entity = _createTestDocumentEntity(
          id: 'test-id',
          ver: '0194d492-1daa-7371-8bd3-c15811b2b063',
        );

        // When
        await dao.save(entity);

        // Then
        final saved = await db.select(db.documentsV2).get();
        expect(saved.length, 1);
        expect(saved[0].id, 'test-id');
        expect(saved[0].ver, '0194d492-1daa-7371-8bd3-c15811b2b063');
      });

      test('ignores conflict on existing {id, ver}', () async {
        // Given
        final existing = _createTestDocumentEntity(
          id: 'test-id',
          ver: '0194d492-1daa-7371-8bd3-c15811b2b063',
          contentData: {'key': 'original'},
        );
        await dao.save(existing);

        // And
        final conflicting = _createTestDocumentEntity(
          id: 'test-id',
          ver: '0194d492-1daa-7371-8bd3-c15811b2b063',
          contentData: {'key': 'modified'},
        );

        // When
        await dao.save(conflicting);

        // Then
        final saved = await db.select(db.documentsV2).get();
        expect(saved.length, 1);
        expect(saved[0].content.data['key'], 'original');
      });
    });

    group('watchDocuments', () {
      test('emits all documents when no filters applied', () async {
        final doc1 = _createTestDocumentEntity(id: 'id1', type: DocumentType.proposalDocument);
        final doc2 = _createTestDocumentEntity(id: 'id2', type: DocumentType.proposalTemplate);
        final doc3 = _createTestDocumentEntity(
          id: 'id3',
          type: DocumentType.proposalActionDocument,
        );

        await dao.saveAll([doc1, doc2, doc3]);

        final stream = dao.watchDocuments();

        await expectLater(
          stream,
          emits(hasLength(3)),
        );
      });

      test('filters documents by type', () async {
        final proposal1 = _createTestDocumentEntity(id: 'id1', type: DocumentType.proposalDocument);
        final proposal2 = _createTestDocumentEntity(id: 'id2', type: DocumentType.proposalDocument);
        final template = _createTestDocumentEntity(id: 'id3', type: DocumentType.proposalTemplate);

        await dao.saveAll([proposal1, proposal2, template]);

        final stream = dao.watchDocuments(type: DocumentType.proposalDocument);

        await expectLater(
          stream,
          emits(
            predicate<List<DocumentEntityV2>>((docs) {
              return docs.length == 2 && docs.every((d) => d.type == DocumentType.proposalDocument);
            }),
          ),
        );
      });

      test('respects limit parameter', () async {
        final docs = List.generate(
          10,
          (i) => _createTestDocumentEntity(id: 'id$i', type: DocumentType.proposalDocument),
        );

        await dao.saveAll(docs);

        final stream = dao.watchDocuments(limit: 5);

        await expectLater(
          stream,
          emits(hasLength(5)),
        );
      });

      test('respects offset parameter', () async {
        final docs = List.generate(
          10,
          (i) => _createTestDocumentEntity(id: 'id$i', type: DocumentType.proposalDocument),
        );

        await dao.saveAll(docs);

        final streamFirst = dao.watchDocuments(limit: 5, offset: 0);
        final streamSecond = dao.watchDocuments(limit: 5, offset: 5);

        final firstBatch = await streamFirst.first;
        final secondBatch = await streamSecond.first;

        expect(firstBatch.length, 5);
        expect(secondBatch.length, 5);
        expect(
          firstBatch
              .map((d) => d.id)
              .toSet()
              .intersection(
                secondBatch.map((d) => d.id).toSet(),
              ),
          isEmpty,
        );
      });

      test('clamps limit to 999 when exceeds maximum', () async {
        final docs = List.generate(
          1000,
          (i) => _createTestDocumentEntity(id: 'id$i', type: DocumentType.proposalDocument),
        );

        await dao.saveAll(docs);

        final stream = dao.watchDocuments(limit: 1500);

        await expectLater(
          stream,
          emits(hasLength(999)),
        );
      });

      test('handles limit of 0', () async {
        final doc = _createTestDocumentEntity(id: 'id1', type: DocumentType.proposalDocument);

        await dao.save(doc);

        final stream = dao.watchDocuments(limit: 0);

        await expectLater(
          stream,
          emits(isEmpty),
        );
      });

      test('emits empty list when no documents exist', () async {
        final stream = dao.watchDocuments();

        await expectLater(
          stream,
          emits(isEmpty),
        );
      });

      test('emits empty list when type filter matches nothing', () async {
        final doc = _createTestDocumentEntity(id: 'id1', type: DocumentType.proposalDocument);

        await dao.save(doc);

        final stream = dao.watchDocuments(type: DocumentType.proposalTemplate);

        await expectLater(
          stream,
          emits(isEmpty),
        );
      });

      test('emits new values when documents are added', () async {
        final stream = dao.watchDocuments();

        final doc1 = _createTestDocumentEntity(id: 'id1', type: DocumentType.proposalDocument);
        final doc2 = _createTestDocumentEntity(id: 'id2', type: DocumentType.proposalDocument);

        final expectation = expectLater(
          stream,
          emitsInOrder([
            isEmpty,
            hasLength(1),
            hasLength(2),
          ]),
        );

        await pumpEventQueue();
        await dao.save(doc1);
        await pumpEventQueue();
        await dao.save(doc2);
        await pumpEventQueue();

        await expectation;
      });

      test('does not emit duplicate when same document saved twice', () async {
        final doc = _createTestDocumentEntity(id: 'id1', type: DocumentType.proposalDocument);

        await dao.save(doc);

        final stream = dao.watchDocuments();

        final expectation = expectLater(
          stream,
          emitsInOrder([
            hasLength(1),
            hasLength(1),
          ]),
        );

        await pumpEventQueue();
        await dao.save(doc);
        await pumpEventQueue();

        await expectation;
      });

      test('combines type filter with limit and offset', () async {
        final proposals = List.generate(
          20,
          (i) => _createTestDocumentEntity(id: 'proposal$i', type: DocumentType.proposalDocument),
        );

        final templates = List.generate(
          10,
          (i) => _createTestDocumentEntity(id: 'template$i', type: DocumentType.proposalTemplate),
        );

        await dao.saveAll([...proposals, ...templates]);

        final stream = dao.watchDocuments(
          type: DocumentType.proposalDocument,
          limit: 5,
          offset: 10,
        );

        await expectLater(
          stream,
          emits(
            predicate<List<DocumentEntityV2>>((docs) {
              return docs.length == 5 && docs.every((d) => d.type == DocumentType.proposalDocument);
            }),
          ),
        );
      });

      test('emits updates when filtered documents change', () async {
        final proposal = _createTestDocumentEntity(id: 'id1', type: DocumentType.proposalDocument);
        final template = _createTestDocumentEntity(id: 'id2', type: DocumentType.proposalTemplate);

        final stream = dao.watchDocuments(type: DocumentType.proposalDocument);

        final expectation = expectLater(
          stream,
          emitsInOrder([
            isEmpty,
            hasLength(1),
            hasLength(1),
          ]),
        );

        await pumpEventQueue();
        await dao.save(proposal);
        await pumpEventQueue();
        await dao.save(template);
        await pumpEventQueue();

        await expectation;
      });

      test('returns all versions when latestOnly is false', () async {
        final v1 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 1)),
        );
        final v2 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 2)),
        );
        final v3 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 3)),
        );

        await dao.saveAll([v1, v2, v3]);

        final stream = dao.watchDocuments(latestOnly: false);

        await expectLater(
          stream,
          emits(hasLength(3)),
        );
      });

      test('returns only latest version of each document when latestOnly is true', () async {
        final doc1v1 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 1)),
        );
        final doc1v2 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 2)),
        );
        final doc2v1 = _createTestDocumentEntity(
          id: 'id2',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 1)),
        );

        await dao.saveAll([doc1v1, doc1v2, doc2v1]);

        final stream = dao.watchDocuments(latestOnly: true);

        final result = await stream.first;

        expect(result.length, 2);
        expect(result.any((d) => d.id == 'id1' && d.ver == doc1v1.doc.ver), isFalse);
        expect(result.any((d) => d.id == 'id1' && d.ver == doc1v2.doc.ver), isTrue);
        expect(result.any((d) => d.id == 'id2' && d.ver == doc2v1.doc.ver), isTrue);
      });

      test('combines latestOnly with type filter', () async {
        final proposal1v1 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 1)),
          type: DocumentType.proposalDocument,
        );
        final proposal1v2 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 2)),
          type: DocumentType.proposalDocument,
        );
        final template1v1 = _createTestDocumentEntity(
          id: 'id2',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 1)),
          type: DocumentType.proposalTemplate,
        );
        final template1v2 = _createTestDocumentEntity(
          id: 'id2',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 2)),
          type: DocumentType.proposalTemplate,
        );

        await dao.saveAll([proposal1v1, proposal1v2, template1v1, template1v2]);

        final stream = dao.watchDocuments(
          type: DocumentType.proposalDocument,
          latestOnly: true,
        );

        final result = await stream.first;

        expect(result.length, 1);
        expect(result.first.id, 'id1');
        expect(result.first.ver, proposal1v2.doc.ver);
        expect(result.first.type, DocumentType.proposalDocument);
      });

      test('combines latestOnly with limit and offset', () async {
        final docs = <DocumentWithAuthorsEntity>[];
        for (var i = 0; i < 10; i++) {
          docs
            ..add(
              _createTestDocumentEntity(
                id: 'id$i',
                ver: _buildUuidV7At(DateTime.utc(2024, 1, 1)),
              ),
            )
            ..add(
              _createTestDocumentEntity(
                id: 'id$i',
                ver: _buildUuidV7At(DateTime.utc(2024, 1, 2)),
              ),
            );
        }

        await dao.saveAll(docs);

        final stream = dao.watchDocuments(
          latestOnly: true,
          limit: 5,
          offset: 3,
        );

        final result = await stream.first;

        expect(result.length, 5);
        expect(
          result.every((d) => d.createdAt.isAtSameMomentAs(DateTime.utc(2024, 1, 2))),
          isTrue,
        );
      });

      test('emits updates when new version added with latestOnly', () async {
        final doc1v1 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 1)),
        );
        final doc1v2 = _createTestDocumentEntity(
          id: 'id1',
          ver: _buildUuidV7At(DateTime.utc(2024, 1, 2)),
        );

        final stream = dao.watchDocuments(latestOnly: true);

        final expectation = expectLater(
          stream,
          emitsInOrder([
            isEmpty,
            predicate<List<DocumentEntityV2>>(
              (docs) => docs.length == 1 && docs.first.ver == doc1v1.doc.ver,
            ),
            predicate<List<DocumentEntityV2>>(
              (docs) => docs.length == 1 && docs.first.ver == doc1v2.doc.ver,
            ),
          ]),
        );

        await pumpEventQueue();
        await dao.save(doc1v1);
        await pumpEventQueue();
        await dao.save(doc1v2);
        await pumpEventQueue();

        await expectation;
      });
    });

    group('getLatestOf', () {
      test('returns null for non-existing id in empty database', () async {
        // Given
        const ref = SignedDocumentRef.exact(id: 'non-existent-id', version: 'non-existent-ver');

        // When
        final result = await dao.getLatestOf(ref);

        // Then
        expect(result, isNull);
      });

      test('returns the document ref when only one version exists', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.loose(id: 'test-id');

        // When
        final result = await dao.getLatestOf(ref);

        // Then
        expect(result, isNotNull);
        expect(result!.id, 'test-id');
        expect(result.version, 'test-ver');
        expect(result.isExact, isTrue);
      });

      test('returns latest version when multiple versions exist (loose ref input)', () async {
        // Given
        final oldCreatedAt = DateTime.utc(2023, 1, 1);
        final newerCreatedAt = DateTime.utc(2024, 6, 15);

        final oldVer = _buildUuidV7At(oldCreatedAt);
        final newerVer = _buildUuidV7At(newerCreatedAt);
        final entityOld = _createTestDocumentEntity(id: 'test-id', ver: oldVer);
        final entityNew = _createTestDocumentEntity(id: 'test-id', ver: newerVer);
        await dao.saveAll([entityOld, entityNew]);

        // And
        const ref = SignedDocumentRef.loose(id: 'test-id');

        // When
        final result = await dao.getLatestOf(ref);

        // Then
        expect(result, isNotNull);
        expect(result!.id, 'test-id');
        expect(result.version, newerVer);
      });

      test('returns latest version even when exact ref points to older version', () async {
        // Given
        final oldCreatedAt = DateTime.utc(2023, 1, 1);
        final newerCreatedAt = DateTime.utc(2024, 6, 15);

        final oldVer = _buildUuidV7At(oldCreatedAt);
        final newerVer = _buildUuidV7At(newerCreatedAt);
        final entityOld = _createTestDocumentEntity(id: 'test-id', ver: oldVer);
        final entityNew = _createTestDocumentEntity(id: 'test-id', ver: newerVer);
        await dao.saveAll([entityOld, entityNew]);

        // And: exact ref pointing to older version
        final ref = SignedDocumentRef.exact(id: 'test-id', version: oldVer);

        // When
        final result = await dao.getLatestOf(ref);

        // Then: still returns the latest version
        expect(result, isNotNull);
        expect(result!.id, 'test-id');
        expect(result.version, newerVer);
      });

      test('returns null for non-existing id when other documents exist', () async {
        // Given
        final entity = _createTestDocumentEntity(id: 'other-id', ver: 'other-ver');
        await dao.save(entity);

        // And
        const ref = SignedDocumentRef.loose(id: 'non-existent-id');

        // When
        final result = await dao.getLatestOf(ref);

        // Then
        expect(result, isNull);
      });

      test('returns latest among many versions', () async {
        // Given
        final dates = [
          DateTime.utc(2023, 1, 1),
          DateTime.utc(2023, 6, 15),
          DateTime.utc(2024, 3, 10),
          DateTime.utc(2024, 12, 25),
          DateTime.utc(2024, 8, 1),
        ];
        final versions = dates.map(_buildUuidV7At).toList();
        final entities = versions
            .map((ver) => _createTestDocumentEntity(id: 'multi-ver-id', ver: ver))
            .toList();
        await dao.saveAll(entities);

        // And
        const ref = SignedDocumentRef.loose(id: 'multi-ver-id');

        // When
        final result = await dao.getLatestOf(ref);

        // Then: returns the version with latest createdAt (2024-12-25)
        expect(result, isNotNull);
        expect(result!.version, versions[3]);
      });
    });

    group('deleteWhere', () {
      test('returns zero when database is empty', () async {
        // Given: An empty database

        // When
        final result = await dao.deleteWhere();

        // Then
        expect(result, 0);
      });

      test('deletes all documents when no filter is provided', () async {
        // Given
        final entities = [
          _createTestDocumentEntity(
            id: 'id-1',
            ver: 'ver-1',
            type: DocumentType.proposalDocument,
          ),
          _createTestDocumentEntity(
            id: 'id-2',
            ver: 'ver-2',
            type: DocumentType.commentDocument,
          ),
          _createTestDocumentEntity(
            id: 'id-3',
            ver: 'ver-3',
            type: DocumentType.proposalTemplate,
          ),
        ];
        await dao.saveAll(entities);

        // When
        final result = await dao.deleteWhere();

        // Then
        expect(result, 3);
        expect(await dao.count(), 0);
      });

      test('deletes documents not in notInType list', () async {
        // Given
        final proposal = _createTestDocumentEntity(
          id: 'proposal-id',
          ver: 'proposal-ver',
          type: DocumentType.proposalDocument,
        );
        final comment = _createTestDocumentEntity(
          id: 'comment-id',
          ver: 'comment-ver',
          type: DocumentType.commentDocument,
        );
        final template = _createTestDocumentEntity(
          id: 'template-id',
          ver: 'template-ver',
          type: DocumentType.proposalTemplate,
        );
        await dao.saveAll([proposal, comment, template]);

        // When
        final result = await dao.deleteWhere(
          notInType: [DocumentType.proposalDocument],
        );

        // Then
        expect(result, 2);
        expect(await dao.count(), 1);

        final remaining = await dao.getDocument(
          const SignedDocumentRef.exact(id: 'proposal-id', version: 'proposal-ver'),
        );
        expect(remaining, isNotNull);
        expect(remaining!.type, DocumentType.proposalDocument);
      });

      test('keeps multiple document types when specified in notInType', () async {
        // Given
        final proposal = _createTestDocumentEntity(
          id: 'proposal-id',
          ver: 'proposal-ver',
          type: DocumentType.proposalDocument,
        );
        final comment = _createTestDocumentEntity(
          id: 'comment-id',
          ver: 'comment-ver',
          type: DocumentType.commentDocument,
        );
        final template = _createTestDocumentEntity(
          id: 'template-id',
          ver: 'template-ver',
          type: DocumentType.proposalTemplate,
        );
        final action = _createTestDocumentEntity(
          id: 'action-id',
          ver: 'action-ver',
          type: DocumentType.proposalActionDocument,
        );
        await dao.saveAll([proposal, comment, template, action]);

        // When
        final result = await dao.deleteWhere(
          notInType: [
            DocumentType.proposalDocument,
            DocumentType.proposalTemplate,
          ],
        );

        // Then
        expect(result, 2);
        expect(await dao.count(), 2);

        final remainingProposal = await dao.getDocument(
          const SignedDocumentRef.exact(id: 'proposal-id', version: 'proposal-ver'),
        );
        final remainingTemplate = await dao.getDocument(
          const SignedDocumentRef.exact(id: 'template-id', version: 'template-ver'),
        );
        final deletedComment = await dao.getDocument(
          const SignedDocumentRef.exact(id: 'comment-id', version: 'comment-ver'),
        );
        final deletedAction = await dao.getDocument(
          const SignedDocumentRef.exact(id: 'action-id', version: 'action-ver'),
        );

        expect(remainingProposal, isNotNull);
        expect(remainingTemplate, isNotNull);
        expect(deletedComment, isNull);
        expect(deletedAction, isNull);
      });

      test('deletes all documents when notInType is empty list', () async {
        // Given
        final entities = [
          _createTestDocumentEntity(
            id: 'id-1',
            ver: 'ver-1',
            type: DocumentType.proposalDocument,
          ),
          _createTestDocumentEntity(
            id: 'id-2',
            ver: 'ver-2',
            type: DocumentType.commentDocument,
          ),
        ];
        await dao.saveAll(entities);

        // When
        final result = await dao.deleteWhere(notInType: []);

        // Then
        expect(result, 2);
        expect(await dao.count(), 0);
      });

      test('returns zero when all documents match notInType filter', () async {
        // Given
        final entities = [
          _createTestDocumentEntity(
            id: 'id-1',
            ver: 'ver-1',
            type: DocumentType.proposalDocument,
          ),
          _createTestDocumentEntity(
            id: 'id-2',
            ver: 'ver-2',
            type: DocumentType.proposalDocument,
          ),
        ];
        await dao.saveAll(entities);

        // When
        final result = await dao.deleteWhere(
          notInType: [DocumentType.proposalDocument],
        );

        // Then
        expect(result, 0);
        expect(await dao.count(), 2);
      });

      test('handles multiple versions of same document id', () async {
        // Given
        final v1 = _createTestDocumentEntity(
          id: 'multi-id',
          ver: 'ver-1',
          type: DocumentType.proposalDocument,
        );
        final v2 = _createTestDocumentEntity(
          id: 'multi-id',
          ver: 'ver-2',
          type: DocumentType.proposalDocument,
        );
        final other = _createTestDocumentEntity(
          id: 'other-id',
          ver: 'other-ver',
          type: DocumentType.commentDocument,
        );
        await dao.saveAll([v1, v2, other]);

        // When
        final result = await dao.deleteWhere(
          notInType: [DocumentType.proposalDocument],
        );

        // Then
        expect(result, 1);
        expect(await dao.count(), 2);
      });

      test('deletes documents with all different types correctly', () async {
        // Given
        final entities = [
          _createTestDocumentEntity(
            id: 'id-1',
            ver: 'ver-1',
            type: DocumentType.proposalDocument,
          ),
          _createTestDocumentEntity(
            id: 'id-2',
            ver: 'ver-2',
            type: DocumentType.commentDocument,
          ),
          _createTestDocumentEntity(
            id: 'id-3',
            ver: 'ver-3',
            type: DocumentType.reviewDocument,
          ),
          _createTestDocumentEntity(
            id: 'id-4',
            ver: 'ver-4',
            type: DocumentType.proposalActionDocument,
          ),
          _createTestDocumentEntity(
            id: 'id-5',
            ver: 'ver-5',
            type: DocumentType.proposalTemplate,
          ),
        ];
        await dao.saveAll(entities);

        // When
        final result = await dao.deleteWhere(
          notInType: [
            DocumentType.proposalDocument,
            DocumentType.proposalTemplate,
            DocumentType.proposalActionDocument,
          ],
        );

        // Then
        expect(result, 2);
        expect(await dao.count(), 3);
      });

      test('performs efficiently with large dataset', () async {
        // Given
        final entities = List.generate(
          1000,
          (i) => _createTestDocumentEntity(
            id: 'id-$i',
            ver: 'ver-$i',
            type: i.isEven ? DocumentType.proposalDocument : DocumentType.commentDocument,
          ),
        );
        await dao.saveAll(entities);

        // When
        final result = await dao.deleteWhere(
          notInType: [DocumentType.proposalDocument],
        );

        // Then
        expect(result, 500);
        expect(await dao.count(), 500);
      });
    });
  });
}

String _buildUuidV7At(DateTime dateTime) => DocumentRefFactory.uuidV7At(dateTime);

DocumentWithAuthorsEntity _createTestDocumentEntity({
  String? id,
  String? ver,
  Map<String, dynamic> contentData = const {},
  DocumentType type = DocumentType.proposalDocument,
  String? authors,
  String? categoryId,
  String? categoryVer,
  String? refId,
  String? refVer,
  String? replyId,
  String? replyVer,
  String? section,
  String? templateId,
  String? templateVer,
}) {
  return DocumentWithAuthorsFactory.create(
    id: id,
    ver: ver,
    contentData: contentData,
    type: type,
    authors: authors,
    categoryId: categoryId,
    categoryVer: categoryVer,
    refId: refId,
    refVer: refVer,
    replyId: replyId,
    replyVer: replyVer,
    section: section,
    templateId: templateId,
    templateVer: templateVer,
  );
}
