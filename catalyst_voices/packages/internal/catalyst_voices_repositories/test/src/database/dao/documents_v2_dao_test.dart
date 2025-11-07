import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_with_authors_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

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
  });
}

String _buildUuidV7At(DateTime dateTime) {
  final ts = dateTime.millisecondsSinceEpoch;
  final rand = Uint8List.fromList([42, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
  return const UuidV7().generate(options: V7Options(ts, rand));
}

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
  id ??= DocumentRefFactory.randomUuidV7();
  ver ??= id;
  authors ??= '';

  final docEntity = DocumentEntityV2(
    id: id,
    ver: ver,
    content: DocumentDataContent(contentData),
    createdAt: ver.tryDateTime ?? DateTime.now(),
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

  final authorsEntities = authors
      .split(',')
      .where((element) => element.trim().isNotEmpty)
      .map(CatalystId.tryParse)
      .nonNulls
      .map(
        (e) => DocumentAuthorEntity(
          documentId: docEntity.id,
          documentVer: docEntity.ver,
          authorCatId: e.toUri().toString(),
          authorCatIdSignificant: e.toSignificant().toUri().toString(),
          authorUsername: e.username,
        ),
      )
      .toList();

  return DocumentWithAuthorsEntity(docEntity, authorsEntities);
}
