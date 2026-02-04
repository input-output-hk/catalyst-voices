// ignore_for_file: avoid_redundant_argument_values
import 'dart:typed_data';

import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/documents_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_composite_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/document_composite_factory.dart';
import '../connection/test_connection.dart';
import '../drift_test_platforms.dart';

void main() {
  group(
    DocumentsV2Dao,
    () {
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

        test('filters by type and returns matching count', () async {
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
          final result = await dao.count(type: DocumentType.proposalDocument);

          // Then
          expect(result, 1);
        });

        test('returns zero when no documents match type filter', () async {
          // Given
          final comment = _createTestDocumentEntity(
            id: 'comment-id',
            ver: 'comment-ver',
            type: DocumentType.commentDocument,
          );
          await dao.save(comment);

          // When
          final result = await dao.count(type: DocumentType.proposalDocument);

          // Then
          expect(result, 0);
        });

        test('filters by loose ref and returns all versions count', () async {
          // Given
          final v1 = _createTestDocumentEntity(id: 'multi-id', ver: 'ver-1');
          final v2 = _createTestDocumentEntity(id: 'multi-id', ver: 'ver-2');
          final other = _createTestDocumentEntity(id: 'other-id', ver: 'other-ver');
          await dao.saveAll([v1, v2, other]);

          // When
          final result = await dao.count(
            id: const SignedDocumentRef.loose(id: 'multi-id'),
          );

          // Then
          expect(result, 2);
        });

        test('filters by exact ref and returns single match', () async {
          // Given
          final v1 = _createTestDocumentEntity(id: 'multi-id', ver: 'ver-1');
          final v2 = _createTestDocumentEntity(id: 'multi-id', ver: 'ver-2');
          await dao.saveAll([v1, v2]);

          // When
          final result = await dao.count(
            id: const SignedDocumentRef.exact(id: 'multi-id', ver: 'ver-1'),
          );

          // Then
          expect(result, 1);
        });

        test('returns zero for non-existing ref', () async {
          // Given
          final entity = _createTestDocumentEntity(id: 'existing-id', ver: 'existing-ver');
          await dao.save(entity);

          // When
          final result = await dao.count(
            id: const SignedDocumentRef.exact(id: 'non-existent', ver: 'non-ver'),
          );

          // Then
          expect(result, 0);
        });

        test('filters by loose refTo and returns documents referencing id', () async {
          // Given
          final proposal = _createTestDocumentEntity(
            id: 'proposal-id',
            ver: 'proposal-ver',
            type: DocumentType.proposalDocument,
          );
          final action1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: 'action-ver-1',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          final action2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: 'action-ver-2',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver-2',
          );
          final unrelated = _createTestDocumentEntity(
            id: 'unrelated',
            ver: 'unrelated-ver',
            type: DocumentType.proposalActionDocument,
            refId: 'other-proposal',
            refVer: 'other-ver',
          );
          await dao.saveAll([proposal, action1, action2, unrelated]);

          // When
          final result = await dao.count(
            referencing: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, 2);
        });

        test('filters by exact refTo and returns documents referencing exact version', () async {
          // Given
          final action1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: 'action-ver-1',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver-1',
          );
          final action2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: 'action-ver-2',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver-2',
          );
          await dao.saveAll([action1, action2]);

          // When
          final result = await dao.count(
            referencing: const SignedDocumentRef.exact(
              id: 'proposal-id',
              ver: 'proposal-ver-1',
            ),
          );

          // Then
          expect(result, 1);
        });

        test('returns zero when no documents match refTo filter', () async {
          // Given
          final action = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'action-ver',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          await dao.save(action);

          // When
          final result = await dao.count(
            referencing: const SignedDocumentRef.loose(id: 'non-existent-proposal'),
          );

          // Then
          expect(result, 0);
        });

        test('combines type and ref filters', () async {
          // Given
          final proposal1 = _createTestDocumentEntity(
            id: 'proposal-id',
            ver: 'ver-1',
            type: DocumentType.proposalDocument,
          );
          final proposal2 = _createTestDocumentEntity(
            id: 'proposal-id',
            ver: 'ver-2',
            type: DocumentType.proposalDocument,
          );
          final comment = _createTestDocumentEntity(
            id: 'proposal-id',
            ver: 'ver-3',
            type: DocumentType.commentDocument,
          );
          await dao.saveAll([proposal1, proposal2, comment]);

          // When
          final result = await dao.count(
            type: DocumentType.proposalDocument,
            id: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, 2);
        });

        test('combines type and refTo filters', () async {
          // Given
          final action = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'action-ver',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          final comment = _createTestDocumentEntity(
            id: 'comment-id',
            ver: 'comment-ver',
            type: DocumentType.commentDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          await dao.saveAll([action, comment]);

          // When
          final result = await dao.count(
            type: DocumentType.proposalActionDocument,
            referencing: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, 1);
        });

        test('combines all three filters', () async {
          // Given
          final action1 = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'ver-1',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          final action2 = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'ver-2',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          final action3 = _createTestDocumentEntity(
            id: 'other-action',
            ver: 'ver-3',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          await dao.saveAll([action1, action2, action3]);

          // When
          final result = await dao.count(
            type: DocumentType.proposalActionDocument,
            id: const SignedDocumentRef.loose(id: 'action-id'),
            referencing: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, 2);
        });
      });

      group('exists', () {
        test('returns false for non-existing ref in empty database', () async {
          // Given
          const ref = SignedDocumentRef.exact(id: 'non-existent-id', ver: 'non-existent-ver');

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
          const ref = SignedDocumentRef.exact(id: 'test-id', ver: 'test-ver');

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
          const ref = SignedDocumentRef.exact(id: 'test-id', ver: 'wrong-ver');

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
            const SignedDocumentRef.exact(id: 'id-1', ver: 'ver-1'),
            const SignedDocumentRef.loose(id: 'id-2'),
          ];

          // When
          final result = await dao.filterExisting(refs);

          // Then
          expect(result, hasLength(2));
          expect(result[0].id, 'id-1');
          expect(result[0].ver, 'ver-1');
          expect(result[1].id, 'id-2');
          expect(result[1].ver, isNull);
        });

        test('filters out non-existing refs (mixed exact and loose)', () async {
          // Given
          final entity = _createTestDocumentEntity(id: 'existing-id', ver: 'existing-ver');
          await dao.save(entity);

          // And
          final refs = [
            const SignedDocumentRef.exact(id: 'existing-id', ver: 'existing-ver'),
            const SignedDocumentRef.exact(id: 'non-id', ver: 'non-ver'),
            const SignedDocumentRef.loose(id: 'existing-id'),
            const SignedDocumentRef.loose(id: 'non-id'),
          ];

          // When
          final result = await dao.filterExisting(refs);

          // Then
          expect(result, hasLength(2));
          expect(result[0].id, 'existing-id');
          expect(result[0].ver, 'existing-ver');
          expect(result[1].id, 'existing-id');
          expect(result[1].ver, isNull);
        });

        test('handles multiple versions for loose refs', () async {
          // Given
          final entityV1 = _createTestDocumentEntity(id: 'multi-id', ver: 'ver-1');
          final entityV2 = _createTestDocumentEntity(id: 'multi-id', ver: 'ver-2');
          await dao.saveAll([entityV1, entityV2]);

          // And
          final refs = [
            const SignedDocumentRef.loose(id: 'multi-id'),
            const SignedDocumentRef.exact(id: 'multi-id', ver: 'ver-1'),
            const SignedDocumentRef.exact(id: 'multi-id', ver: 'wrong-ver'),
          ];

          // When
          final result = await dao.filterExisting(refs);

          // Then
          expect(result, hasLength(2));
          expect(result[0].ver, isNull);
          expect(result[1].ver, 'ver-1');
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
                ? SignedDocumentRef.exact(id: 'batch-${i % 500}', ver: 'ver-$i')
                : SignedDocumentRef.loose(id: 'non-$i'),
          );

          // When
          final stopwatch = Stopwatch()..start();
          final result = await dao.filterExisting(refs);
          stopwatch.stop();

          // Then
          expect(result, hasLength(500));
          expect(stopwatch.elapsedMilliseconds, lessThan(100));
        });
      });

      group('getDocument', () {
        test('returns null for non-existing ref in empty database', () async {
          // Given
          const ref = SignedDocumentRef.exact(id: 'non-existent-id', ver: 'non-existent-ver');

          // When
          final result = await dao.getDocument(id: ref);

          // Then
          expect(result, isNull);
        });

        test('returns entity for existing exact ref', () async {
          // Given
          final entity = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
          await dao.save(entity);

          // And
          const ref = SignedDocumentRef.exact(id: 'test-id', ver: 'test-ver');

          // When
          final result = await dao.getDocument(id: ref);

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
          const ref = SignedDocumentRef.exact(id: 'test-id', ver: 'wrong-ver');

          // When
          final result = await dao.getDocument(id: ref);

          // Then
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
          final result = await dao.getDocument(id: ref);

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
          final result = await dao.getDocument(id: ref);

          // Then
          expect(result, isNull);
        });

        test('filters by type and returns matching document', () async {
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
          await dao.saveAll([proposal, comment]);

          // When
          final result = await dao.getDocument(type: DocumentType.proposalDocument);

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'proposal-id');
          expect(result.type, DocumentType.proposalDocument);
        });

        test('returns null when no documents match type filter', () async {
          // Given
          final comment = _createTestDocumentEntity(
            id: 'comment-id',
            ver: 'comment-ver',
            type: DocumentType.commentDocument,
          );
          await dao.save(comment);

          // When
          final result = await dao.getDocument(type: DocumentType.proposalDocument);

          // Then
          expect(result, isNull);
        });

        test('returns latest document when filtering by type only', () async {
          // Given
          final oldCreatedAt = DateTime.utc(2023, 1, 1);
          final newerCreatedAt = DateTime.utc(2024, 1, 1);

          final oldVer = _buildUuidV7At(oldCreatedAt);
          final newerVer = _buildUuidV7At(newerCreatedAt);

          final oldProposal = _createTestDocumentEntity(
            id: 'proposal-1',
            ver: oldVer,
            type: DocumentType.proposalDocument,
          );
          final newProposal = _createTestDocumentEntity(
            id: 'proposal-2',
            ver: newerVer,
            type: DocumentType.proposalDocument,
          );
          await dao.saveAll([oldProposal, newProposal]);

          // When
          final result = await dao.getDocument(type: DocumentType.proposalDocument);

          // Then
          expect(result, isNotNull);
        });

        test('filters by loose refTo and returns latest referencing document', () async {
          // Given
          final oldCreatedAt = DateTime.utc(2023, 1, 1);
          final newerCreatedAt = DateTime.utc(2024, 1, 1);

          final oldVer = _buildUuidV7At(oldCreatedAt);
          final newerVer = _buildUuidV7At(newerCreatedAt);

          final action1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: oldVer,
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          final action2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: newerVer,
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver-2',
          );
          final unrelated = _createTestDocumentEntity(
            id: 'unrelated',
            ver: 'unrelated-ver',
            type: DocumentType.proposalActionDocument,
            refId: 'other-proposal',
            refVer: 'other-ver',
          );
          await dao.saveAll([action1, action2, unrelated]);

          // When
          final result = await dao.getDocument(
            referencing: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, isNotNull);
          expect(result!.refId, 'proposal-id');
        });

        test('filters by exact refTo and returns matching document', () async {
          // Given
          final action1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: 'action-ver-1',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver-1',
          );
          final action2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: 'action-ver-2',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver-2',
          );
          await dao.saveAll([action1, action2]);

          // When
          final result = await dao.getDocument(
            referencing: const SignedDocumentRef.exact(
              id: 'proposal-id',
              ver: 'proposal-ver-1',
            ),
          );

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'action-1');
          expect(result.refVer, 'proposal-ver-1');
        });

        test('returns null when no documents match refTo filter', () async {
          // Given
          final action = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'action-ver',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          await dao.save(action);

          // When
          final result = await dao.getDocument(
            referencing: const SignedDocumentRef.loose(id: 'non-existent-proposal'),
          );

          // Then
          expect(result, isNull);
        });

        test('combines type and ref filters', () async {
          // Given
          final proposal = _createTestDocumentEntity(
            id: 'doc-id',
            ver: 'ver-1',
            type: DocumentType.proposalDocument,
          );
          final comment = _createTestDocumentEntity(
            id: 'doc-id',
            ver: 'ver-2',
            type: DocumentType.commentDocument,
          );
          await dao.saveAll([proposal, comment]);

          // When
          final result = await dao.getDocument(
            type: DocumentType.proposalDocument,
            id: const SignedDocumentRef.loose(id: 'doc-id'),
          );

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'doc-id');
          expect(result.ver, 'ver-1');
          expect(result.type, DocumentType.proposalDocument);
        });

        test('returns null when type and ref filters have no intersection', () async {
          // Given
          final proposal = _createTestDocumentEntity(
            id: 'proposal-id',
            ver: 'proposal-ver',
            type: DocumentType.proposalDocument,
          );
          await dao.save(proposal);

          // When
          final result = await dao.getDocument(
            type: DocumentType.commentDocument,
            id: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, isNull);
        });

        test('combines type and refTo filters', () async {
          // Given
          final action = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'action-ver',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          final comment = _createTestDocumentEntity(
            id: 'comment-id',
            ver: 'comment-ver',
            type: DocumentType.commentDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          await dao.saveAll([action, comment]);

          // When
          final result = await dao.getDocument(
            type: DocumentType.proposalActionDocument,
            referencing: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'action-id');
          expect(result.type, DocumentType.proposalActionDocument);
        });

        test('combines ref and refTo filters', () async {
          // Given
          final action1 = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'ver-1',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-1',
            refVer: 'proposal-ver',
          );
          final action2 = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'ver-2',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-2',
            refVer: 'proposal-ver',
          );
          await dao.saveAll([action1, action2]);

          // When
          final result = await dao.getDocument(
            id: const SignedDocumentRef.loose(id: 'action-id'),
            referencing: const SignedDocumentRef.loose(id: 'proposal-1'),
          );

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'action-id');
          expect(result.refId, 'proposal-1');
        });

        test('combines all three filters', () async {
          // Given
          final oldCreatedAt = DateTime.utc(2023, 1, 1);
          final newerCreatedAt = DateTime.utc(2024, 1, 1);

          final oldVer = _buildUuidV7At(oldCreatedAt);
          final newerVer = _buildUuidV7At(newerCreatedAt);

          final action1 = _createTestDocumentEntity(
            id: 'action-id',
            ver: oldVer,
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          final action2 = _createTestDocumentEntity(
            id: 'action-id',
            ver: newerVer,
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          final comment = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'comment-ver',
            type: DocumentType.commentDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          await dao.saveAll([action1, action2, comment]);

          // When
          final result = await dao.getDocument(
            type: DocumentType.proposalActionDocument,
            id: const SignedDocumentRef.loose(id: 'action-id'),
            referencing: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'action-id');
          expect(result.ver, newerVer);
          expect(result.type, DocumentType.proposalActionDocument);
          expect(result.refId, 'proposal-id');
        });

        test('returns null when all three filters have no intersection', () async {
          // Given
          final action = _createTestDocumentEntity(
            id: 'action-id',
            ver: 'action-ver',
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-id',
            refVer: 'proposal-ver',
          );
          await dao.save(action);

          // When
          final result = await dao.getDocument(
            type: DocumentType.commentDocument,
            id: const SignedDocumentRef.loose(id: 'action-id'),
            referencing: const SignedDocumentRef.loose(id: 'proposal-id'),
          );

          // Then
          expect(result, isNull);
        });

        test('returns newest document by author (original author)', () async {
          // Given
          final author = _createTestAuthor(name: 'Damian');
          final genesisVer = _buildUuidV7At(DateTime(2023));

          final proposal1 = _createTestDocumentEntity(
            id: genesisVer,
            ver: genesisVer,
            type: DocumentType.proposalDocument,
            authors: [author],
          );
          final newerVer = _buildUuidV7At(DateTime(2024));
          final proposal2 = _createTestDocumentEntity(
            id: genesisVer,
            ver: newerVer,
            type: DocumentType.proposalDocument,
            authors: [author],
          );
          await dao.saveAll([proposal1, proposal2]);

          // When
          final result = await dao.getDocument(originalAuthor: author);

          // Then
          expect(result, isNotNull);
          expect(result?.ver, newerVer);
        });

        test('returns null if author is not original author (signed only later version)', () async {
          // Given
          final originalAuthor = _createTestAuthor(name: 'Creator');
          final collaborator = _createTestAuthor(name: 'Collab', role0KeySeed: 1);

          final genesisVer = _buildUuidV7At(DateTime(2023));

          // V1: Signed by Creator
          final proposalV1 = _createTestDocumentEntity(
            id: genesisVer,
            ver: genesisVer,
            type: DocumentType.proposalDocument,
            authors: [originalAuthor],
          );

          // V2: Signed by Collaborator
          final newerVer = _buildUuidV7At(DateTime(2024));
          final proposalV2 = _createTestDocumentEntity(
            id: genesisVer,
            ver: newerVer,
            type: DocumentType.proposalDocument,
            authors: [collaborator],
          );

          await dao.saveAll([proposalV1, proposalV2]);

          // When: querying for the collaborator
          final result = await dao.getDocument(originalAuthor: collaborator);

          // Then: Should not find the document because collaborator didn't sign V1 (id==ver)
          expect(result, isNull);
        });

        test('author filter returns version signed by that specific author', () async {
          // Given
          final creator = _createTestAuthor(name: 'Creator', role0KeySeed: 1);
          final updater = _createTestAuthor(name: 'Updater', role0KeySeed: 2);

          final genesisVer = _buildUuidV7At(DateTime(2023));
          final updateVer = _buildUuidV7At(DateTime(2024));

          // V1: Signed by Creator
          final v1 = _createTestDocumentEntity(
            id: genesisVer,
            ver: genesisVer,
            authors: [creator],
          );

          // V2: Signed by Updater
          final v2 = _createTestDocumentEntity(
            id: genesisVer,
            ver: updateVer,
            authors: [updater],
          );

          await dao.saveAll([v1, v2]);

          // When: Querying for Creator (who only signed V1)
          final resultCreator = await dao.getDocument(author: creator);

          // Then: Should return V1
          expect(resultCreator, isNotNull);
          expect(resultCreator?.ver, genesisVer);

          // When: Querying for Updater (who signed V2)
          final resultUpdater = await dao.getDocument(author: updater);

          // Then: Should return V2
          expect(resultUpdater, isNotNull);
          expect(resultUpdater?.ver, updateVer);
        });

        test('originalAuthor filter returns latest version even if signed by collaborator', () async {
          // Given
          final creator = _createTestAuthor(name: 'Creator', role0KeySeed: 1);
          final updater = _createTestAuthor(name: 'Updater', role0KeySeed: 2);

          final genesisVer = _buildUuidV7At(DateTime(2023));
          final updateVer = _buildUuidV7At(DateTime(2024));

          // V1: Signed by Creator (id == ver)
          final v1 = _createTestDocumentEntity(
            id: genesisVer,
            ver: genesisVer,
            authors: [creator],
          );

          // V2: Signed by Updater (id != ver)
          final v2 = _createTestDocumentEntity(
            id: genesisVer,
            ver: updateVer,
            authors: [updater],
          );

          await dao.saveAll([v1, v2]);

          // When: Querying for Creator as 'originalAuthor'
          final resultCreator = await dao.getDocument(originalAuthor: creator);

          // Then: Should return V2 (the latest version), because Creator owns the document series (signed V1)
          expect(resultCreator, isNotNull);
          expect(resultCreator?.ver, updateVer);

          // When: Querying for Creator as 'originalAuthor'
          final resultUpdater = await dao.getDocument(originalAuthor: updater);

          // Then: Should return null as updater do not own first version
          expect(resultUpdater, isNull);
        });
      });

      group('getDocumentMetadata', () {
        test('returns null for non-existing ref in empty database', () async {
          // Given
          const ref = SignedDocumentRef.exact(id: 'non-existent-id', ver: 'non-existent-ver');

          // When
          final result = await dao.getDocumentMetadata(ref);

          // Then
          expect(result, isNull);
        });

        test('returns metadata for existing exact ref', () async {
          // Given
          final entity = _createTestDocumentEntity(
            id: 'test-id',
            ver: 'test-ver',
            type: DocumentType.proposalDocument,
            refId: 'ref-id',
            refVer: 'ref-ver',
            templateId: 'template-id',
            templateVer: 'template-ver',
            section: 'test-section',
          );
          await dao.save(entity);

          // And
          const ref = SignedDocumentRef.exact(id: 'test-id', ver: 'test-ver');

          // When
          final result = await dao.getDocumentMetadata(ref);

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'test-id');
          expect(result.ver, 'test-ver');
          expect(result.type, DocumentType.proposalDocument);
          expect(result.refId, 'ref-id');
          expect(result.refVer, 'ref-ver');
          expect(result.templateId, 'template-id');
          expect(result.templateVer, 'template-ver');
          expect(result.section, 'test-section');
        });

        test('returns null for non-existing exact ref', () async {
          // Given
          final entity = _createTestDocumentEntity(id: 'test-id', ver: 'test-ver');
          await dao.save(entity);

          // And
          const ref = SignedDocumentRef.exact(id: 'test-id', ver: 'wrong-ver');

          // When
          final result = await dao.getDocumentMetadata(ref);

          // Then
          expect(result, isNull);
        });

        test('returns latest metadata for loose ref when multiple versions exist', () async {
          // Given
          final oldCreatedAt = DateTime.utc(2023, 1, 1);
          final newerCreatedAt = DateTime.utc(2024, 1, 1);

          final oldVer = _buildUuidV7At(oldCreatedAt);
          final newerVer = _buildUuidV7At(newerCreatedAt);

          final entityOld = _createTestDocumentEntity(id: 'test-id', ver: oldVer);
          final entityNew = _createTestDocumentEntity(id: 'test-id', ver: newerVer);
          await dao.saveAll([entityOld, entityNew]);

          // And
          const ref = SignedDocumentRef.loose(id: 'test-id');

          // When
          final result = await dao.getDocumentMetadata(ref);

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
          final result = await dao.getDocumentMetadata(ref);

          // Then
          expect(result, isNull);
        });

        test('returns all metadata fields correctly populated', () async {
          // Given
          final author = _createTestAuthor(name: 'TestAuthor');
          final collaborator = _createTestAuthor(name: 'Collaborator', role0KeySeed: 1);
          final paramRef = DocumentRefFactory.signedDocumentRef();

          final entity = _createTestDocumentEntity(
            id: 'full-doc-id',
            ver: 'full-doc-ver',
            type: DocumentType.proposalDocument,
            authors: [author],
            collaborators: [collaborator],
            refId: 'parent-ref-id',
            refVer: 'parent-ref-ver',
            replyId: 'reply-id',
            replyVer: 'reply-ver',
            section: 'test-section',
            templateId: 'tmpl-id',
            templateVer: 'tmpl-ver',
            parameters: [paramRef],
          );
          await dao.save(entity);

          // When
          final result = await dao.getDocumentMetadata(
            const SignedDocumentRef.exact(id: 'full-doc-id', ver: 'full-doc-ver'),
          );

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'full-doc-id');
          expect(result.ver, 'full-doc-ver');
          expect(result.type, DocumentType.proposalDocument);
          expect(result.authors, contains(author));
          expect(result.collaborators, contains(collaborator));
          expect(result.refId, 'parent-ref-id');
          expect(result.refVer, 'parent-ref-ver');
          expect(result.replyId, 'reply-id');
          expect(result.replyVer, 'reply-ver');
          expect(result.section, 'test-section');
          expect(result.templateId, 'tmpl-id');
          expect(result.templateVer, 'tmpl-ver');
          expect(result.parameters.isNotEmpty, isTrue);
        });
      });

      group('getDocumentArtifact', () {
        test('returns artifact for exact ref', () async {
          // Given: A document and its artifact exist
          final artifact = DocumentArtifact(Uint8List.fromList([0xCA, 0xFE, 0xBA, 0xBE]));
          final doc = _createTestDocumentEntity(id: 'doc-1', ver: 'ver-1', artifact: artifact);

          await dao.save(doc);

          // When
          final result = await dao.getDocumentArtifact(
            const SignedDocumentRef.exact(id: 'doc-1', ver: 'ver-1'),
          );

          // Then
          expect(result, equals(artifact));
        });

        test('returns null for exact ref mismatch', () async {
          // Given: Artifact exists for ver-1
          final artifact = DocumentArtifact(Uint8List.fromList([1, 2, 3]));
          final doc = _createTestDocumentEntity(id: 'doc-1', ver: 'ver-1', artifact: artifact);

          await dao.save(doc);

          // When: We query for ver-2
          final result = await dao.getDocumentArtifact(
            const SignedDocumentRef.exact(id: 'doc-1', ver: 'ver-2'),
          );

          // Then
          expect(result, isNull);
        });

        test('returns latest artifact for loose ref (latest by ver)', () async {
          // Given: Two versions of a document, both with artifacts
          final v1 = _buildUuidV7At(DateTime.utc(2024, 1, 1));
          final v2 = _buildUuidV7At(DateTime.utc(2024, 1, 2));

          final artifactV1 = DocumentArtifact(Uint8List.fromList([1]));
          final artifactV2 = DocumentArtifact(Uint8List.fromList([2]));

          final docV1 = _createTestDocumentEntity(id: 'doc-multi', ver: v1, artifact: artifactV1);
          final docV2 = _createTestDocumentEntity(id: 'doc-multi', ver: v2, artifact: artifactV2);

          await dao.saveAll([docV1, docV2]);

          // When: We query with a loose ref (no version specified)
          final result = await dao.getDocumentArtifact(
            const SignedDocumentRef.loose(id: 'doc-multi'),
          );

          // Then: We expect the artifact from the latest version (v2)
          expect(result, equals(artifactV2));
        });

        test('respects foreign key cascade delete', () async {
          // Given: A document with an artifact
          final artifact = DocumentArtifact(Uint8List.fromList([1]));
          final doc = _createTestDocumentEntity(id: 'doc-del', ver: 'ver-1', artifact: artifact);
          await dao.save(doc);

          // When: The parent document is deleted
          await (db.delete(db.documentsV2)..where((tbl) => tbl.id.equals('doc-del'))).go();

          // Then: The artifact should also be gone
          final remaining = await dao.getDocumentArtifact(
            const SignedDocumentRef.exact(id: 'doc-del', ver: 'ver-1'),
          );

          expect(remaining, isNull);
        });
      });

      group('saveAll', () {
        test('does nothing for empty list', () async {
          // Given
          final entities = <DocumentCompositeEntity>[];

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
          expect(saved, hasLength(2));
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
          expect(saved, hasLength(4));
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
          expect(saved, hasLength(1));
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
          expect(saved, hasLength(1));
          expect(saved[0].content.data['key'], 'original');
        });

        test(
          'document which author has coma in username is saved and recovered correctly',
          () async {
            // Given
            final author = _createTestAuthor(name: 'Hello,World');
            final entity = _createTestDocumentEntity(
              id: 'test-id',
              ver: '0194d492-1daa-7371-8bd3-c15811b2b063',
              authors: [author],
            );

            // When
            await dao.save(entity);

            // Then
            final saved = await db.select(db.documentsV2).get();
            expect(saved, hasLength(1));
            expect(saved[0].id, 'test-id');
            expect(saved[0].ver, '0194d492-1daa-7371-8bd3-c15811b2b063');
            expect(saved[0].authors, [author]);
            expect(saved[0].authors.first.username, author.username);
          },
        );
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
          final proposal1 = _createTestDocumentEntity(
            id: 'id1',
            type: DocumentType.proposalDocument,
          );
          final proposal2 = _createTestDocumentEntity(
            id: 'id2',
            type: DocumentType.proposalDocument,
          );
          final template = _createTestDocumentEntity(
            id: 'id3',
            type: DocumentType.proposalTemplate,
          );

          await dao.saveAll([proposal1, proposal2, template]);

          final stream = dao.watchDocuments(type: DocumentType.proposalDocument);

          await expectLater(
            stream,
            emits(
              predicate<List<DocumentEntityV2>>((docs) {
                return docs.length == 2 &&
                    docs.every((d) => d.type == DocumentType.proposalDocument);
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

          expect(firstBatch, hasLength(5));
          expect(secondBatch, hasLength(5));
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
                return docs.length == 5 &&
                    docs.every((d) => d.type == DocumentType.proposalDocument);
              }),
            ),
          );
        });

        test('emits updates when filtered documents change', () async {
          final proposal = _createTestDocumentEntity(
            id: 'id1',
            type: DocumentType.proposalDocument,
          );
          final template = _createTestDocumentEntity(
            id: 'id2',
            type: DocumentType.proposalTemplate,
          );

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

          expect(result, hasLength(2));
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

          expect(result, hasLength(1));
          expect(result.first.id, 'id1');
          expect(result.first.ver, proposal1v2.doc.ver);
          expect(result.first.type, DocumentType.proposalDocument);
        });

        test('combines latestOnly with limit and offset', () async {
          final docs = <DocumentCompositeEntity>[];
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

          expect(result, hasLength(5));
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

      group('getPreviousOf', () {
        test('returns null for non-existing id in empty database', () async {
          // Given
          const ref = SignedDocumentRef.exact(id: 'non-existent-id', ver: 'non-existent-ver');

          // When
          final result = await dao.getPreviousOf(id: ref);

          // Then
          expect(result, isNull);
        });

        test('returns first version for loose ref when document exists', () async {
          // Given
          final genesisVer = _buildUuidV7At(DateTime.utc(2023, 1, 1));
          final entity = _createTestDocumentEntity(id: genesisVer, ver: genesisVer);
          await dao.save(entity);

          final ref = SignedDocumentRef.loose(id: genesisVer);

          // When
          final result = await dao.getPreviousOf(id: ref);

          // Then
          expect(result, isNotNull);
          expect(result!.id, genesisVer);
          expect(result.ver, genesisVer);
          expect(result.isExact, isTrue);
        });

        test('returns null for loose ref when no genesis version exists', () async {
          // Given: Document where id != ver (not a genesis version)
          final entity = _createTestDocumentEntity(id: 'test-id', ver: 'different-ver');
          await dao.save(entity);

          // And
          const ref = SignedDocumentRef.loose(id: 'test-id');

          // When
          final result = await dao.getPreviousOf(id: ref);

          // Then
          expect(result, isNull);
        });

        test('returns null for loose ref with non-existing id', () async {
          // Given
          final entity = _createTestDocumentEntity(id: 'other-id', ver: 'other-ver');
          await dao.save(entity);

          // And
          const ref = SignedDocumentRef.loose(id: 'non-existent-id');

          // When
          final result = await dao.getPreviousOf(id: ref);

          // Then
          expect(result, isNull);
        });

        test('returns null for exact ref when only one version exists', () async {
          // Given
          final ver = _buildUuidV7At(DateTime.utc(2024, 1, 1));
          final entity = _createTestDocumentEntity(id: 'test-id', ver: ver);
          await dao.save(entity);

          // And
          final ref = SignedDocumentRef.exact(id: 'test-id', ver: ver);

          // When
          final result = await dao.getPreviousOf(id: ref);

          // Then
          expect(result, isNull);
        });

        test('returns previous version for exact ref with multiple versions', () async {
          // Given
          final oldCreatedAt = DateTime.utc(2023, 1, 1);
          final newerCreatedAt = DateTime.utc(2024, 1, 1);

          final oldVer = _buildUuidV7At(oldCreatedAt);
          final newerVer = _buildUuidV7At(newerCreatedAt);

          final entityOld = _createTestDocumentEntity(id: 'test-id', ver: oldVer);
          final entityNew = _createTestDocumentEntity(id: 'test-id', ver: newerVer);
          await dao.saveAll([entityOld, entityNew]);

          // And: ref pointing to newer version
          final ref = SignedDocumentRef.exact(id: 'test-id', ver: newerVer);

          // When
          final result = await dao.getPreviousOf(id: ref);

          // Then
          expect(result, isNotNull);
          expect(result!.id, 'test-id');
          expect(result.ver, oldVer);
        });

        test('returns immediately previous version among many versions', () async {
          // Given: 5 versions with distinct creation times
          final dates = [
            DateTime.utc(2023, 1, 1),
            DateTime.utc(2023, 6, 15),
            DateTime.utc(2024, 3, 10),
            DateTime.utc(2024, 8, 1),
            DateTime.utc(2024, 12, 25),
          ];
          final versions = dates.map(_buildUuidV7At).toList();
          final entities = versions
              .map((ver) => _createTestDocumentEntity(id: 'multi-ver-id', ver: ver))
              .toList();
          await dao.saveAll(entities);

          // And: ref pointing to version at index 3 (2024-08-01)
          final ref = SignedDocumentRef.exact(id: 'multi-ver-id', ver: versions[3]);

          // When
          final result = await dao.getPreviousOf(id: ref);

          // Then: returns version at index 2 (2024-03-10)
          expect(result, isNotNull);
          expect(result!.ver, versions[2]);
        });

        test('does not return versions from different document ids', () async {
          // Given: Two documents with overlapping timestamps
          final sharedTime = DateTime.utc(2024, 1, 1);
          final olderTime = DateTime.utc(2023, 1, 1);

          final doc1Ver = _buildUuidV7At(sharedTime);
          final doc2OldVer = _buildUuidV7At(olderTime);
          final doc2NewVer = _buildUuidV7At(sharedTime.add(const Duration(hours: 1)));

          final doc1 = _createTestDocumentEntity(id: 'doc-1', ver: doc1Ver);
          final doc2Old = _createTestDocumentEntity(id: 'doc-2', ver: doc2OldVer);
          final doc2New = _createTestDocumentEntity(id: 'doc-2', ver: doc2NewVer);
          await dao.saveAll([doc1, doc2Old, doc2New]);

          // And: ref pointing to doc-1's only version
          final ref = SignedDocumentRef.exact(id: 'doc-1', ver: doc1Ver);

          // When
          final result = await dao.getPreviousOf(id: ref);

          // Then: should return null, not doc-2's older version
          expect(result, isNull);
        });
      });

      group('getLatestOf', () {
        test('returns null for non-existing id in empty database', () async {
          // Given
          const ref = SignedDocumentRef.exact(id: 'non-existent-id', ver: 'non-existent-ver');

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
          expect(result.ver, 'test-ver');
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
          expect(result.ver, newerVer);
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
          final ref = SignedDocumentRef.exact(id: 'test-id', ver: oldVer);

          // When
          final result = await dao.getLatestOf(ref);

          // Then: still returns the latest version
          expect(result, isNotNull);
          expect(result!.id, 'test-id');
          expect(result.ver, newerVer);
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
          expect(result!.ver, versions[3]);
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
            excludeTypes: [DocumentType.proposalDocument],
          );

          // Then
          expect(result, 2);
          expect(await dao.count(), 1);

          final remaining = await dao.getDocument(
            id: const SignedDocumentRef.exact(id: 'proposal-id', ver: 'proposal-ver'),
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
            excludeTypes: [
              DocumentType.proposalDocument,
              DocumentType.proposalTemplate,
            ],
          );

          // Then
          expect(result, 2);
          expect(await dao.count(), 2);

          final remainingProposal = await dao.getDocument(
            id: const SignedDocumentRef.exact(id: 'proposal-id', ver: 'proposal-ver'),
          );
          final remainingTemplate = await dao.getDocument(
            id: const SignedDocumentRef.exact(id: 'template-id', ver: 'template-ver'),
          );
          final deletedComment = await dao.getDocument(
            id: const SignedDocumentRef.exact(id: 'comment-id', ver: 'comment-ver'),
          );
          final deletedAction = await dao.getDocument(
            id: const SignedDocumentRef.exact(id: 'action-id', ver: 'action-ver'),
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
          final result = await dao.deleteWhere(excludeTypes: []);

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
            excludeTypes: [DocumentType.proposalDocument],
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
            excludeTypes: [DocumentType.proposalDocument],
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
              type: DocumentType.brandParametersDocument,
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
            excludeTypes: [
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
            excludeTypes: [DocumentType.proposalDocument],
          );

          // Then
          expect(result, 500);
          expect(await dao.count(), 500);
        });
      });

      group('getDocuments', () {
        test('returns empty list for empty database', () async {
          // Given: An empty database

          // When
          final result = await dao.getDocuments(
            latestOnly: false,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, isEmpty);
        });

        test('returns all documents when no filters applied', () async {
          // Given
          final doc1 = _createTestDocumentEntity(id: 'id-1', ver: 'ver-1');
          final doc2 = _createTestDocumentEntity(id: 'id-2', ver: 'ver-1');
          await dao.saveAll([doc1, doc2]);

          // When
          final result = await dao.getDocuments(
            latestOnly: false,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, hasLength(2));
          expect(result.map((e) => e.id), containsAll(['id-1', 'id-2']));
        });

        test('filters by type', () async {
          // Given
          final proposal = _createTestDocumentEntity(
            id: 'p-1',
            type: DocumentType.proposalDocument,
          );
          final template = _createTestDocumentEntity(
            id: 't-1',
            type: DocumentType.proposalTemplate,
          );
          await dao.saveAll([proposal, template]);

          // When
          final result = await dao.getDocuments(
            type: DocumentType.proposalDocument,
            latestOnly: false,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, hasLength(1));
          expect(result.first.id, 'p-1');
          expect(result.first.type, DocumentType.proposalDocument);
        });

        test('filters by loose ref (returns all versions)', () async {
          // Given
          final v1 = _createTestDocumentEntity(id: 'doc-1', ver: 'v1');
          final v2 = _createTestDocumentEntity(id: 'doc-1', ver: 'v2');
          final other = _createTestDocumentEntity(id: 'doc-2', ver: 'v1');
          await dao.saveAll([v1, v2, other]);

          // When
          final result = await dao.getDocuments(
            id: const SignedDocumentRef.loose(id: 'doc-1'),
            latestOnly: false,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, hasLength(2));
          expect(result.map((e) => e.ver), containsAll(['v1', 'v2']));
        });

        test('filters by exact ref', () async {
          // Given
          final v1 = _createTestDocumentEntity(id: 'doc-1', ver: 'v1');
          final v2 = _createTestDocumentEntity(id: 'doc-1', ver: 'v2');
          await dao.saveAll([v1, v2]);

          // When
          final result = await dao.getDocuments(
            id: const SignedDocumentRef.exact(id: 'doc-1', ver: 'v1'),
            latestOnly: false,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, hasLength(1));
          expect(result.first.ver, 'v1');
        });

        test('filters by refTo (loose)', () async {
          // Given
          final target = _createTestDocumentEntity(id: 'target-1');
          final ref1 = _createTestDocumentEntity(
            id: 'ref-1',
            refId: 'target-1',
            refVer: 'any',
          );
          final ref2 = _createTestDocumentEntity(
            id: 'ref-2',
            refId: 'target-1',
            refVer: 'other',
          );
          final other = _createTestDocumentEntity(id: 'other', refId: 'other-target');
          await dao.saveAll([target, ref1, ref2, other]);

          // When
          final result = await dao.getDocuments(
            referencing: const SignedDocumentRef.loose(id: 'target-1'),
            latestOnly: false,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, hasLength(2));
          expect(result.map((e) => e.id), containsAll(['ref-1', 'ref-2']));
        });

        test('filters by refTo (exact)', () async {
          // Given
          final v1 = _createTestDocumentEntity(
            id: 'ref-1',
            refId: 'target',
            refVer: 'v1',
          );
          final v2 = _createTestDocumentEntity(
            id: 'ref-2',
            refId: 'target',
            refVer: 'v2',
          );
          await dao.saveAll([v1, v2]);

          // When
          final result = await dao.getDocuments(
            referencing: const SignedDocumentRef.exact(id: 'target', ver: 'v1'),
            latestOnly: false,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, hasLength(1));
          expect(result.first.id, 'ref-1');
        });

        test('returns only latest versions when latestOnly is true', () async {
          // Given
          final oldTime = DateTime.utc(2024, 1, 1);
          final newTime = DateTime.utc(2024, 1, 2);

          final doc1V1 = _createTestDocumentEntity(
            id: 'doc-1',
            ver: _buildUuidV7At(oldTime),
          );
          final doc1V2 = _createTestDocumentEntity(
            id: 'doc-1',
            ver: _buildUuidV7At(newTime),
          );
          final doc2 = _createTestDocumentEntity(
            id: 'doc-2',
            ver: _buildUuidV7At(oldTime),
          );

          await dao.saveAll([doc1V1, doc1V2, doc2]);

          // When
          final result = await dao.getDocuments(
            latestOnly: true,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, hasLength(2));
          expect(result.map((e) => e.id), containsAll(['doc-1', 'doc-2']));

          final resultDoc1 = result.firstWhere((e) => e.id == 'doc-1');
          expect(resultDoc1.ver, doc1V2.doc.ver);
        });

        test('pagination works with limit and offset', () async {
          // Given: 5 documents
          final docs = List.generate(
            5,
            (i) => _createTestDocumentEntity(
              id: 'doc-$i',
              ver: _buildUuidV7At(DateTime.utc(2024, 1, 1).add(Duration(minutes: i))),
            ),
          );

          await dao.saveAll(docs);

          // When
          final result = await dao.getDocuments(
            latestOnly: false,
            limit: 2,
            offset: 1,
          );

          // Then
          expect(result, hasLength(2));
        });

        test('respects campaign filters (categories)', () async {
          // Given
          final cat1 = DocumentRefFactory.signedDocumentRef();
          final cat2 = DocumentRefFactory.signedDocumentRef();

          final doc1 = _createTestDocumentEntity(id: 'd1', parameters: [cat1]);
          final doc2 = _createTestDocumentEntity(id: 'd2', parameters: [cat2]);
          final doc3 = _createTestDocumentEntity(id: 'd3', parameters: [cat1]);
          await dao.saveAll([doc1, doc2, doc3]);

          // When
          final result = await dao.getDocuments(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
            latestOnly: false,
            limit: 100,
            offset: 0,
          );

          // Then
          expect(result, hasLength(2));
          expect(result.map((e) => e.id), containsAll(['d1', 'd3']));
        });

        test('combines type, latestOnly and campaign filters', () async {
          // Given
          final catA = DocumentRefFactory.signedDocumentRef();
          final catB = DocumentRefFactory.signedDocumentRef();

          final oldProposal = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(DateTime(2023)),
            type: DocumentType.proposalDocument,
            parameters: [catA],
          );
          final newProposal = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(DateTime(2024)),
            type: DocumentType.proposalDocument,
            parameters: [catA],
          );
          final otherCatProposal = _createTestDocumentEntity(
            id: 'p2',
            ver: _buildUuidV7At(DateTime(2024)),
            type: DocumentType.proposalDocument,
            parameters: [catB],
          );
          final wrongType = _createTestDocumentEntity(
            id: 't1',
            type: DocumentType.proposalTemplate,
            parameters: [catA],
          );

          await dao.saveAll([oldProposal, newProposal, otherCatProposal, wrongType]);

          // When
          final result = await dao.getDocuments(
            type: DocumentType.proposalDocument,
            campaign: CampaignFilters(categoriesIds: [catA.id]),
            latestOnly: true,
            limit: 10,
            offset: 0,
          );

          // Then
          expect(result, hasLength(1));
          expect(result.first.id, 'p1');
          expect(result.first.ver, newProposal.doc.ver);
        });

        test('results should be ordered by createdAt DESC (Newest First)', () async {
          // Given: Three documents with distinct creation times
          final oldestDate = DateTime.utc(2023, 1, 1);
          final middleDate = DateTime.utc(2023, 6, 1);
          final newestDate = DateTime.utc(2024, 1, 1);

          final oldestDoc = _createTestDocumentEntity(
            id: 'doc-old',
            ver: _buildUuidV7At(oldestDate),
          );
          final middleDoc = _createTestDocumentEntity(
            id: 'doc-mid',
            ver: _buildUuidV7At(middleDate),
          );
          final newestDoc = _createTestDocumentEntity(
            id: 'doc-new',
            ver: _buildUuidV7At(newestDate),
          );

          // When: Saved in SCRAMBLED order (Old -> New -> Middle)
          await dao.save(oldestDoc);
          await dao.save(newestDoc);
          await dao.save(middleDoc);

          // And: We query with pagination
          final result = await dao.getDocuments(
            latestOnly: false,
            limit: 10,
            offset: 0,
          );

          // Then: We EXPECT them sorted by time (New -> Mid -> Old)
          expect(result, hasLength(3));

          expect(
            result[0].id,
            'doc-new',
            reason: 'First item should be the newest document',
          );

          expect(
            result[1].id,
            'doc-mid',
            reason: 'Second item should be the middle document',
          );

          expect(
            result[2].id,
            'doc-old',
            reason: 'Last item should be the oldest document',
          );
        });

        test('pagination stays consistent across updates', () async {
          // Given
          final docs = List.generate(
            5,
            (i) => _createTestDocumentEntity(
              id: 'doc-$i',
              ver: _buildUuidV7At(DateTime.utc(2024, 1, 1).add(Duration(minutes: i))),
            ),
          );

          await dao.saveAll(docs);

          // When: We fetch Page 1 (size 2)
          final page1 = await dao.getDocuments(latestOnly: false, limit: 2, offset: 0);

          // And: We insert a VERY OLD document (simulating a sync of historical data)
          final ancientDoc = _createTestDocumentEntity(
            id: 'doc-ancient',
            ver: _buildUuidV7At(DateTime.utc(2020, 1, 1)),
          );
          await dao.save(ancientDoc);

          // And
          final page1Again = await dao.getDocuments(latestOnly: false, limit: 2, offset: 0);

          // Then
          expect(page1Again[0].id, page1[0].id);
        });
      });
    },
    skip: driftSkip,
  );
}

String _buildUuidV7At(DateTime dateTime) => DocumentRefFactory.uuidV7At(dateTime);

CatalystId _createTestAuthor({
  String? name,
  int role0KeySeed = 0,
}) {
  return CatalystIdFactory.create(username: name, role0KeySeed: role0KeySeed);
}

DocumentCompositeEntity _createTestDocumentEntity({
  String? id,
  String? ver,
  Map<String, dynamic> contentData = const {},
  DocumentType type = DocumentType.proposalDocument,
  List<CatalystId>? authors,
  DocumentArtifact? artifact,
  String? refId,
  String? refVer,
  String? replyId,
  String? replyVer,
  String? section,
  String? templateId,
  String? templateVer,
  List<CatalystId>? collaborators,
  List<DocumentRef>? parameters,
}) {
  return DocumentCompositeFactory.create(
    id: id,
    ver: ver,
    contentData: contentData,
    type: type,
    authors: authors,
    artifact: artifact,
    refId: refId,
    refVer: refVer,
    replyId: replyId,
    replyVer: replyVer,
    section: section,
    templateId: templateId,
    templateVer: templateVer,
    parameters: parameters ?? [],
    collaborators: collaborators ?? [],
  );
}
