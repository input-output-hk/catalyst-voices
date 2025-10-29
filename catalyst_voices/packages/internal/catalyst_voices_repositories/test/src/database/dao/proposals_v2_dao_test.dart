import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

import '../connection/test_connection.dart';

void main() {
  late DriftCatalystDatabase db;
  late ProposalsV2Dao dao;

  setUp(() async {
    final connection = await buildTestConnection();
    db = DriftCatalystDatabase(connection);
    dao = db.proposalsV2Dao;
  });

  tearDown(() async {
    await db.close();
  });

  group(ProposalsV2Dao, () {
    group('getProposalsBriefPage', () {
      final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
      final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
      final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

      test('returns empty page for empty database', () async {
        // Given
        const request = PageRequest(page: 0, size: 10);

        // When
        final result = await dao.getProposalsBriefPage(request);

        // Then
        expect(result.items, isEmpty);
        expect(result.total, 0);
        expect(result.page, 0);
        expect(result.maxPerPage, 10);
      });

      test('returns paginated latest proposals', () async {
        // Given
        final entity1 = _createTestDocumentEntity(
          id: 'id-1',
          ver: _buildUuidV7At(earliest),
        );
        final entity2 = _createTestDocumentEntity(
          id: 'id-2',
          ver: _buildUuidV7At(latest),
        );
        final entity3 = _createTestDocumentEntity(
          id: 'id-3',
          ver: _buildUuidV7At(middle),
        );
        await db.documentsV2Dao.saveAll([entity1, entity2, entity3]);

        // And
        const request = PageRequest(page: 0, size: 2);

        // When
        final result = await dao.getProposalsBriefPage(request);

        // Then
        expect(result.items.length, 2);
        expect(result.total, 3);
        expect(result.items[0].proposal.id, 'id-2');
        expect(result.items[1].proposal.id, 'id-3');
      });

      test('returns partial page for out-of-bounds request', () async {
        // Given
        final entities = List.generate(
          3,
          (i) {
            final ts = earliest.add(Duration(milliseconds: i * 100));
            return _createTestDocumentEntity(
              id: 'id-$i',
              ver: _buildUuidV7At(ts),
            );
          },
        );
        await db.documentsV2Dao.saveAll(entities);

        // And: A request for page beyond total (e.g., page 1, size 2 -> last 1)
        const request = PageRequest(page: 1, size: 2);

        // When
        final result = await dao.getProposalsBriefPage(request);

        // Then: Returns remaining items (1), total unchanged
        expect(result.items.length, 1);
        expect(result.total, 3);
        expect(result.page, 1);
        expect(result.maxPerPage, 2);
      });

      test('returns latest version per id with multiple versions', () async {
        // Given
        final entityOld = _createTestDocumentEntity(
          id: 'multi-id',
          ver: _buildUuidV7At(earliest),
          contentData: {'title': 'old'},
        );
        final entityNew = _createTestDocumentEntity(
          id: 'multi-id',
          ver: _buildUuidV7At(latest),
          contentData: {'title': 'new'},
        );
        final otherEntity = _createTestDocumentEntity(
          id: 'other-id',
          ver: _buildUuidV7At(middle),
        );
        await db.documentsV2Dao.saveAll([entityOld, entityNew, otherEntity]);

        // And
        const request = PageRequest(page: 0, size: 10);

        // When
        final result = await dao.getProposalsBriefPage(request);

        // Then
        expect(result.items.length, 2);
        expect(result.total, 2);
        expect(result.items[0].proposal.id, 'multi-id');
        expect(result.items[0].proposal.ver, _buildUuidV7At(latest));
        expect(result.items[0].proposal.content.data['title'], 'new');
        expect(result.items[1].proposal.id, 'other-id');
      });

      test('ignores non-proposal documents in count and items', () async {
        // Given
        final proposal = _createTestDocumentEntity(
          id: 'proposal-id',
          ver: _buildUuidV7At(latest),
        );
        final other = _createTestDocumentEntity(
          id: 'other-id',
          ver: _buildUuidV7At(earliest),
          type: DocumentType.commentDocument,
        );
        await db.documentsV2Dao.saveAll([proposal, other]);

        // And
        const request = PageRequest(page: 0, size: 10);

        // When
        final result = await dao.getProposalsBriefPage(request);

        // Then
        expect(result.items.length, 1);
        expect(result.total, 1);
        expect(result.items[0].proposal.type, DocumentType.proposalDocument);
      });

      test('excludes hidden proposals based on latest action', () async {
        // Given
        final proposal1Ver = _buildUuidV7At(latest);
        final proposal1 = _createTestDocumentEntity(id: 'p1', ver: proposal1Ver);

        final proposal2Ver = _buildUuidV7At(latest);
        final proposal2 = _createTestDocumentEntity(id: 'p2', ver: proposal2Ver);

        final actionOldVer = _buildUuidV7At(middle);
        final actionOld = _createTestDocumentEntity(
          id: 'action-old',
          ver: actionOldVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p2',
          contentData: ProposalSubmissionActionDto.draft.toJson(),
        );
        final actionHideVer = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
        final actionHide = _createTestDocumentEntity(
          id: 'action-hide',
          ver: actionHideVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p2',
          contentData: ProposalSubmissionActionDto.hide.toJson(),
        );

        await db.documentsV2Dao.saveAll([proposal1, proposal2, actionOld, actionHide]);

        // When
        const request = PageRequest(page: 0, size: 10);
        final result = await dao.getProposalsBriefPage(request);

        // Then: Only visible (p1); total=1.
        expect(result.items.length, 1);
        expect(result.total, 1);
        expect(result.items[0].proposal.id, 'p1');
      });

      test('excludes hidden proposals, even later versions, based on latest action', () async {
        // Given
        final proposal1Ver = _buildUuidV7At(latest);
        final proposal1 = _createTestDocumentEntity(id: 'p1', ver: proposal1Ver);

        final proposal2Ver = _buildUuidV7At(latest);
        final proposal2 = _createTestDocumentEntity(id: 'p2', ver: proposal2Ver);

        final proposal3Ver = _buildUuidV7At(latest.add(const Duration(days: 1)));
        final proposal3 = _createTestDocumentEntity(id: 'p2', ver: proposal3Ver);

        final actionOldVer = _buildUuidV7At(middle);
        final actionOld = _createTestDocumentEntity(
          id: 'action-old',
          ver: actionOldVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p2',
          contentData: ProposalSubmissionActionDto.draft.toJson(),
        );
        final actionHideVer = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
        final actionHide = _createTestDocumentEntity(
          id: 'action-hide',
          ver: actionHideVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p2',
          contentData: ProposalSubmissionActionDto.hide.toJson(),
        );

        await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3, actionOld, actionHide]);

        // When
        const request = PageRequest(page: 0, size: 10);
        final result = await dao.getProposalsBriefPage(request);

        // Then: Only visible (p1); total=1.
        expect(result.items.length, 1);
        expect(result.total, 1);
        expect(result.items[0].proposal.id, 'p1');
      });

      test('latest, non hide, action, overrides previous hide', () async {
        // Given
        final proposal1Ver = _buildUuidV7At(latest);
        final proposal1 = _createTestDocumentEntity(id: 'p1', ver: proposal1Ver);

        final proposal2Ver = _buildUuidV7At(latest);
        final proposal2 = _createTestDocumentEntity(id: 'p2', ver: proposal2Ver);

        final proposal3Ver = _buildUuidV7At(latest.add(const Duration(days: 1)));
        final proposal3 = _createTestDocumentEntity(id: 'p2', ver: proposal3Ver);

        final actionOldHideVer = _buildUuidV7At(middle);
        final actionOldHide = _createTestDocumentEntity(
          id: 'action-hide',
          ver: actionOldHideVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p2',
          refVer: proposal2Ver,
          contentData: ProposalSubmissionActionDto.hide.toJson(),
        );
        final actionDraftVer = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
        final actionDraft = _createTestDocumentEntity(
          id: 'action-draft',
          ver: actionDraftVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p2',
          replyVer: proposal3Ver,
          contentData: ProposalSubmissionActionDto.draft.toJson(),
        );

        await db.documentsV2Dao.saveAll([
          proposal1,
          proposal2,
          proposal3,
          actionOldHide,
          actionDraft,
        ]);

        // When
        const request = PageRequest(page: 0, size: 10);
        final result = await dao.getProposalsBriefPage(request);

        // Then: total=2, both are visible
        expect(result.items.length, 2);
        expect(result.total, 2);
        expect(result.items[0].proposal.id, 'p2');
        expect(result.items[1].proposal.id, 'p1');
      });

      test(
        'excludes hidden proposals based on latest version only, '
        'fails without latestProposalSubquery join',
        () async {
          // Given: Multiple versions for one proposal, with hide action on latest version only.
          final earliest = DateTime(2025, 2, 5, 5, 23, 27);
          final middle = DateTime(2025, 2, 5, 5, 25, 33);
          final latest = DateTime(2025, 8, 11, 11, 20, 18);

          // Proposal A: Old version (visible, no hide action for this ver).
          final proposalAOldVer = _buildUuidV7At(earliest);
          final proposalAOld = _createTestDocumentEntity(
            id: 'proposal-a',
            ver: proposalAOldVer,
          );

          // Proposal A: Latest version (hidden, with hide action for this ver).
          final proposalALatestVer = _buildUuidV7At(latest);
          final proposalALatest = _createTestDocumentEntity(
            id: 'proposal-a',
            ver: proposalALatestVer,
          );

          // Hide action for latest version only (refVer = latestVer, ver after latest proposal).
          final actionHideVer = _buildUuidV7At(latest.add(const Duration(seconds: 1)));
          final actionHide = _createTestDocumentEntity(
            id: 'action-hide',
            ver: actionHideVer,
            type: DocumentType.proposalActionDocument,
            refId: 'proposal-a',
            refVer: proposalALatestVer,
            // Specific to latest ver.
            contentData: ProposalSubmissionActionDto.hide.toJson(),
          );

          // Proposal B: Single version, visible (no action).
          final proposalBVer = _buildUuidV7At(middle);
          final proposalB = _createTestDocumentEntity(
            id: 'proposal-b',
            ver: proposalBVer,
          );

          await db.documentsV2Dao.saveAll([proposalAOld, proposalALatest, actionHide, proposalB]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: With join, latest A is hidden → exclude A, total =1 (B only), items =1 (B).
          expect(result.total, 1);
          expect(result.items.length, 1);
          expect(result.items[0].proposal.id, 'proposal-b');
        },
      );

      test('returns specific version when final action points to ref_ver', () async {
        // Given
        final proposal1OldVer = _buildUuidV7At(earliest);
        final proposal1Old = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1OldVer,
          contentData: {'title': 'old version'},
        );

        final proposal1NewVer = _buildUuidV7At(middle);
        final proposal1New = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1NewVer,
          contentData: {'title': 'new version'},
        );

        final proposal2Ver = _buildUuidV7At(latest);
        final proposal2 = _createTestDocumentEntity(id: 'p2', ver: proposal2Ver);

        final actionFinalVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
        final actionFinal = _createTestDocumentEntity(
          id: 'action-final',
          ver: actionFinalVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p1',
          refVer: proposal1OldVer,
          contentData: ProposalSubmissionActionDto.aFinal.toJson(),
        );

        await db.documentsV2Dao.saveAll([proposal1Old, proposal1New, proposal2, actionFinal]);

        // When
        const request = PageRequest(page: 0, size: 10);
        final result = await dao.getProposalsBriefPage(request);

        // Then
        expect(result.items.length, 2);
        expect(result.total, 2);
        final p1Result = result.items.firstWhere((item) => item.proposal.id == 'p1');
        expect(p1Result.proposal.ver, proposal1OldVer);
        expect(p1Result.proposal.content.data['title'], 'old version');
      });

      test('returns latest version when final action has no ref_ver', () async {
        // Given
        final proposal1OldVer = _buildUuidV7At(earliest);
        final proposal1Old = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1OldVer,
          contentData: {'title': 'old version'},
        );

        final proposal1NewVer = _buildUuidV7At(middle);
        final proposal1New = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1NewVer,
          contentData: {'title': 'new version'},
        );

        final actionFinalVer = _buildUuidV7At(latest);
        final actionFinal = _createTestDocumentEntity(
          id: 'action-final',
          ver: actionFinalVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p1',
          // ignore: avoid_redundant_argument_values
          refVer: null,
          contentData: ProposalSubmissionActionDto.aFinal.toJson(),
        );

        await db.documentsV2Dao.saveAll([proposal1Old, proposal1New, actionFinal]);

        // When
        const request = PageRequest(page: 0, size: 10);
        final result = await dao.getProposalsBriefPage(request);

        // Then
        expect(result.items.length, 1);
        expect(result.total, 1);
        expect(result.items[0].proposal.ver, proposal1NewVer);
        expect(result.items[0].proposal.content.data['title'], 'new version');
      });

      test('draft action shows latest version of proposal', () async {
        // Given
        final proposal1OldVer = _buildUuidV7At(earliest);
        final proposal1Old = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1OldVer,
          contentData: {'title': 'old version'},
        );

        final proposal1NewVer = _buildUuidV7At(middle);
        final proposal1New = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1NewVer,
          contentData: {'title': 'new version'},
        );

        final actionDraftVer = _buildUuidV7At(latest);
        final actionDraft = _createTestDocumentEntity(
          id: 'action-draft',
          ver: actionDraftVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p1',
          refVer: proposal1OldVer,
          contentData: ProposalSubmissionActionDto.draft.toJson(),
        );

        await db.documentsV2Dao.saveAll([proposal1Old, proposal1New, actionDraft]);

        // When
        const request = PageRequest(page: 0, size: 10);
        final result = await dao.getProposalsBriefPage(request);

        // Then
        expect(result.items.length, 1);
        expect(result.total, 1);
        expect(result.items[0].proposal.ver, proposal1NewVer);
        expect(result.items[0].proposal.content.data['title'], 'new version');
      });

      test('final action with ref_ver overrides later proposal versions', () async {
        // Given
        final proposal1Ver1 = _buildUuidV7At(earliest);
        final proposal1V1 = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1Ver1,
          contentData: {'version': 1},
        );

        final proposal1Ver2 = _buildUuidV7At(middle);
        final proposal1V2 = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1Ver2,
          contentData: {'version': 2},
        );

        final proposal1Ver3 = _buildUuidV7At(latest);
        final proposal1V3 = _createTestDocumentEntity(
          id: 'p1',
          ver: proposal1Ver3,
          contentData: {'version': 3},
        );

        final actionFinalVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
        final actionFinal = _createTestDocumentEntity(
          id: 'action-final',
          ver: actionFinalVer,
          type: DocumentType.proposalActionDocument,
          refId: 'p1',
          refVer: proposal1Ver2,
          contentData: ProposalSubmissionActionDto.aFinal.toJson(),
        );

        await db.documentsV2Dao.saveAll([proposal1V1, proposal1V2, proposal1V3, actionFinal]);

        // When
        const request = PageRequest(page: 0, size: 10);
        final result = await dao.getProposalsBriefPage(request);

        // Then
        expect(result.items.length, 1);
        expect(result.total, 1);
        expect(result.items[0].proposal.ver, proposal1Ver2);
        expect(result.items[0].proposal.content.data['version'], 2);
      });

      group('NOT IN with NULL values', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        test('action with NULL ref_id does not break query', () async {
          // Given
          final proposal = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
          );
          await db.documentsV2Dao.saveAll([proposal]);

          // And: Action with NULL ref_id
          final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
          final actionNullRef = _createTestDocumentEntity(
            id: 'action-null-ref',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: null,
            contentData: {'action': 'hide'},
          );
          await db.documentsV2Dao.saveAll([actionNullRef]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should still return the proposal (NOT IN with NULL should not fail)
          expect(result.items.length, 1);
          expect(result.items[0].proposal.id, 'p1');
          expect(result.total, 1);
        });

        test('multiple proposals with NULL ref_id actions return all visible proposals', () async {
          // Given
          final proposal1 = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(earliest),
          );
          final proposal2 = _createTestDocumentEntity(
            id: 'p2',
            ver: _buildUuidV7At(latest),
          );
          await db.documentsV2Dao.saveAll([proposal1, proposal2]);

          // And: Multiple actions with NULL ref_id
          final actions = <DocumentEntityV2>[];
          for (int i = 0; i < 3; i++) {
            final actionVer = _buildUuidV7At(latest.add(Duration(hours: i)));
            actions.add(
              _createTestDocumentEntity(
                id: 'action-null-$i',
                ver: actionVer,
                type: DocumentType.proposalActionDocument,
                refId: null,
                contentData: {'action': 'hide'},
              ),
            );
          }
          await db.documentsV2Dao.saveAll(actions);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then
          expect(result.items.length, 2);
          expect(result.total, 2);
        });
      });

      group('JSON extraction NULL safety', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        test('action with malformed JSON does not crash query', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          // Action with malformed JSON
          final actionVer = _buildUuidV7At(latest);
          final action = _createTestDocumentEntity(
            id: 'action-malformed',
            ver: actionVer,
            refId: 'p1',
            type: DocumentType.proposalActionDocument,
            contentData: {'wrong': true},
          );

          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New, action]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should treat as draft and return latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
          expect(result.items[0].proposal.content.data['title'], 'new');
        });

        test('action without action field treats as draft', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

          // And: Action without 'action' field
          final actionVer = _buildUuidV7At(latest);
          final actionNoField = _createTestDocumentEntity(
            id: 'action-no-field',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: {'status': 'pending'},
          );
          await db.documentsV2Dao.saveAll([actionNoField]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should treat as draft and return latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
        });

        test('action with null action value treats as draft', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

          // And: Action with null value
          final actionVer = _buildUuidV7At(latest);
          final actionNullValue = _createTestDocumentEntity(
            id: 'action-null-value',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: {'action': null},
          );
          await db.documentsV2Dao.saveAll([actionNullValue]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should treat as draft and return latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
        });

        test('action with empty string action treats as draft', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

          // And: Action with empty string
          final actionVer = _buildUuidV7At(latest);
          final actionEmpty = _createTestDocumentEntity(
            id: 'action-empty',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: {'action': ''},
          );
          await db.documentsV2Dao.saveAll([actionEmpty]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should treat as draft and return latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
        });

        test('action with wrong type (number) handles gracefully', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

          // And: Action with number instead of string
          final actionVer = _buildUuidV7At(latest);
          final actionNumber = _createTestDocumentEntity(
            id: 'action-number',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: {'action': 42},
          );
          await db.documentsV2Dao.saveAll([actionNumber]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should handle gracefully and return latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
        });

        test('action with boolean value handles gracefully', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

          // And: Action with boolean value
          final actionVer = _buildUuidV7At(latest);
          final actionBool = _createTestDocumentEntity(
            id: 'action-bool',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: {'action': true},
          );
          await db.documentsV2Dao.saveAll([actionBool]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should handle gracefully and return latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
        });

        test('action with nested JSON structure extracts correctly', () async {
          // Given
          final proposal = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(earliest),
          );
          await db.documentsV2Dao.saveAll([proposal]);

          // And: Action with nested structure (should extract $.action, not nested value)
          final actionVer = _buildUuidV7At(latest);
          final actionNested = _createTestDocumentEntity(
            id: 'action-nested',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: {
              'metadata': {'action': 'ignore'},
              'action': 'hide',
            },
          );
          await db.documentsV2Dao.saveAll([actionNested]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should be hidden based on top-level action field
          expect(result.items.length, 0);
          expect(result.total, 0);
        });
      });

      group('Ordering by createdAt vs UUID string', () {
        test('proposals ordered by createdAt not ver string', () async {
          // Given: Three proposals with specific createdAt times
          final time1 = DateTime.utc(2025, 1, 1, 10, 0, 0);
          final time2 = DateTime.utc(2025, 6, 15, 14, 30, 0);
          final time3 = DateTime.utc(2025, 12, 31, 23, 59, 59);

          final ver1 = _buildUuidV7At(time1);
          final ver2 = _buildUuidV7At(time2);
          final ver3 = _buildUuidV7At(time3);

          final proposal1 = _createTestDocumentEntity(
            id: 'p1',
            ver: ver1,
            contentData: {'order': 'oldest'},
          );
          final proposal2 = _createTestDocumentEntity(
            id: 'p2',
            ver: ver2,
            contentData: {'order': 'middle'},
          );
          final proposal3 = _createTestDocumentEntity(
            id: 'p3',
            ver: ver3,
            contentData: {'order': 'newest'},
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should be ordered newest first by createdAt
          expect(result.items.length, 3);
          expect(result.items[0].proposal.content.data['order'], 'newest');
          expect(result.items[1].proposal.content.data['order'], 'middle');
          expect(result.items[2].proposal.content.data['order'], 'oldest');
        });

        test('proposals with manually set createdAt respect createdAt not ver', () async {
          // Given: Non-UUIDv7 versions with explicit createdAt
          final proposal1 = _createTestDocumentEntity(
            id: 'p1',
            ver: '00000000-0000-0000-0000-000000000001',
            createdAt: DateTime.utc(2025, 1, 1),
            contentData: {'when': 'second'},
          );
          final proposal2 = _createTestDocumentEntity(
            id: 'p2',
            ver: '00000000-0000-0000-0000-000000000002',
            createdAt: DateTime.utc(2025, 12, 31),
            contentData: {'when': 'first'},
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should order by createdAt (Dec 31 first), not ver string
          expect(result.items.length, 2);
          expect(result.items[0].proposal.content.data['when'], 'first');
          expect(result.items[1].proposal.content.data['when'], 'second');
        });
      });

      group('Count consistency', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        test('count matches items in complex scenario', () async {
          // Given: Multiple proposals with various actions
          final proposal1Ver = _buildUuidV7At(earliest);
          final proposal1 = _createTestDocumentEntity(id: 'p1', ver: proposal1Ver);

          final proposal2Ver = _buildUuidV7At(middle);
          final proposal2 = _createTestDocumentEntity(id: 'p2', ver: proposal2Ver);

          final proposal3Ver = _buildUuidV7At(latest);
          final proposal3 = _createTestDocumentEntity(id: 'p3', ver: proposal3Ver);

          final actionHideVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
          final actionHide = _createTestDocumentEntity(
            id: 'action-hide',
            ver: actionHideVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: {'action': 'hide'},
          );

          final actionFinalVer = _buildUuidV7At(latest.add(const Duration(hours: 2)));
          final actionFinal = _createTestDocumentEntity(
            id: 'action-final',
            ver: actionFinalVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p2',
            refVer: proposal2Ver,
            contentData: {'action': 'final'},
          );

          await db.documentsV2Dao.saveAll([
            proposal1,
            proposal2,
            proposal3,
            actionHide,
            actionFinal,
          ]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Count should match visible items (p2 final, p3 draft)
          expect(result.items.length, 2);
          expect(result.total, 2);
        });

        test('count remains consistent across pagination', () async {
          // Given: 25 proposals
          final proposals = <DocumentEntityV2>[];
          for (int i = 0; i < 25; i++) {
            final time = DateTime.utc(2025, 1, 1).add(Duration(hours: i));
            final ver = _buildUuidV7At(time);
            proposals.add(
              _createTestDocumentEntity(
                id: 'p$i',
                ver: ver,
                contentData: {'index': i},
              ),
            );
          }
          await db.documentsV2Dao.saveAll(proposals);

          // When: Query multiple pages
          final page1 = await dao.getProposalsBriefPage(const PageRequest(page: 0, size: 10));
          final page2 = await dao.getProposalsBriefPage(const PageRequest(page: 1, size: 10));
          final page3 = await dao.getProposalsBriefPage(const PageRequest(page: 2, size: 10));

          // Then: Total should be consistent across all pages
          expect(page1.total, 25);
          expect(page2.total, 25);
          expect(page3.total, 25);

          expect(page1.items.length, 10);
          expect(page2.items.length, 10);
          expect(page3.items.length, 5);
        });
      });

      group('NULL ref_ver handling', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        test('final action with NULL ref_ver uses latest version', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

          // And: Final action with NULL ref_ver
          final actionVer = _buildUuidV7At(latest);
          final actionFinal = _createTestDocumentEntity(
            id: 'action-final',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: null,
            contentData: {'action': 'final'},
          );
          await db.documentsV2Dao.saveAll([actionFinal]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should use latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
          expect(result.items[0].proposal.content.data['title'], 'new');
        });

        test('final action with empty string ref_ver uses latest version', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

          // And: Final action with empty string ref_ver
          final actionVer = _buildUuidV7At(latest);
          final actionFinal = _createTestDocumentEntity(
            id: 'action-final',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: '',
            contentData: {'action': 'final'},
          );
          await db.documentsV2Dao.saveAll([actionFinal]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should use latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
        });
      });

      group('Case sensitivity', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        test('uppercase HIDE action does not hide proposal', () async {
          // Given
          final proposal = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(earliest),
          );
          await db.documentsV2Dao.saveAll([proposal]);

          // And: Action with uppercase HIDE
          final actionVer = _buildUuidV7At(latest);
          final actionUpper = _createTestDocumentEntity(
            id: 'action-upper',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: {'action': 'HIDE'},
          );
          await db.documentsV2Dao.saveAll([actionUpper]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should NOT hide (case sensitive)
          expect(result.items.length, 1);
        });

        test('mixed case Final action does not treat as final', () async {
          // Given
          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1OldVer,
            contentData: {'title': 'old'},
          );
          final proposal1NewVer = _buildUuidV7At(latest);
          final proposal1New = _createTestDocumentEntity(
            id: 'p1',
            ver: proposal1NewVer,
            contentData: {'title': 'new'},
          );
          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

          // And: Action with mixed case
          final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
          final actionMixed = _createTestDocumentEntity(
            id: 'action-mixed',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: proposal1OldVer,
            contentData: {'action': 'Final'},
          );
          await db.documentsV2Dao.saveAll([actionMixed]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          // Then: Should treat as draft and use latest version
          expect(result.items.length, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
        });
      });

      group('ActionType', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        test('proposal with no action has null actionType', () async {
          final proposalVer = _buildUuidV7At(latest);
          final proposal = _createTestDocumentEntity(
            id: 'p1',
            ver: proposalVer,
          );
          await db.documentsV2Dao.save(proposal);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.id, 'p1');
          expect(result.items.first.actionType, isNull);
        });

        test('proposal with draft action has draft actionType', () async {
          final proposalVer = _buildUuidV7At(earliest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);

          final actionVer = _buildUuidV7At(latest);
          final action = _createTestDocumentEntity(
            id: 'action-1',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: proposalVer,
            contentData: ProposalSubmissionActionDto.draft.toJson(),
          );
          await db.documentsV2Dao.saveAll([proposal, action]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.id, 'p1');
          expect(result.items.first.actionType, ProposalSubmissionAction.draft);
        });

        test('proposal with final action has final_ actionType', () async {
          final proposalVer = _buildUuidV7At(earliest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);

          final actionVer = _buildUuidV7At(latest);
          final action = _createTestDocumentEntity(
            id: 'action-1',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: proposalVer,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
          );
          await db.documentsV2Dao.saveAll([proposal, action]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.id, 'p1');
          expect(result.items.first.actionType, ProposalSubmissionAction.aFinal);
        });

        test('proposal with hide action is excluded and has no actionType', () async {
          final proposalVer = _buildUuidV7At(earliest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);

          final actionVer = _buildUuidV7At(latest);
          final action = _createTestDocumentEntity(
            id: 'action-1',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            contentData: ProposalSubmissionActionDto.hide.toJson(),
          );
          await db.documentsV2Dao.saveAll([proposal, action]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items, isEmpty);
          expect(result.total, 0);
        });

        test('multiple actions uses latest action for actionType', () async {
          final proposalVer = _buildUuidV7At(earliest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);

          final action1Ver = _buildUuidV7At(middle);
          final action1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: action1Ver,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: proposalVer,
            contentData: ProposalSubmissionActionDto.draft.toJson(),
          );

          final action2Ver = _buildUuidV7At(latest);
          final action2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: action2Ver,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: proposalVer,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
          );
          await db.documentsV2Dao.saveAll([proposal, action1, action2]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.id, 'p1');
          expect(result.items.first.actionType, ProposalSubmissionAction.aFinal);
        });

        test('multiple proposals have correct individual actionTypes', () async {
          final proposal1Ver = _buildUuidV7At(earliest);
          final proposal1 = _createTestDocumentEntity(id: 'p1', ver: proposal1Ver);

          final proposal2Ver = _buildUuidV7At(earliest);
          final proposal2 = _createTestDocumentEntity(id: 'p2', ver: proposal2Ver);

          final proposal3Ver = _buildUuidV7At(earliest);
          final proposal3 = _createTestDocumentEntity(id: 'p3', ver: proposal3Ver);

          final action1Ver = _buildUuidV7At(latest);
          final action1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: action1Ver,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: proposal1Ver,
            contentData: ProposalSubmissionActionDto.draft.toJson(),
          );

          final action2Ver = _buildUuidV7At(latest);
          final action2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: action2Ver,
            type: DocumentType.proposalActionDocument,
            refId: 'p2',
            refVer: proposal2Ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
          );

          await db.documentsV2Dao.saveAll([
            proposal1,
            proposal2,
            proposal3,
            action1,
            action2,
          ]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 3);

          final p1 = result.items.firstWhere((e) => e.proposal.id == 'p1');
          final p2 = result.items.firstWhere((e) => e.proposal.id == 'p2');
          final p3 = result.items.firstWhere((e) => e.proposal.id == 'p3');

          expect(p1.actionType, ProposalSubmissionAction.draft);
          expect(p2.actionType, ProposalSubmissionAction.aFinal);
          expect(p3.actionType, isNull);
        });

        test('invalid action value results in null actionType', () async {
          final proposalVer = _buildUuidV7At(earliest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);

          final actionVer = _buildUuidV7At(latest);
          final action = _createTestDocumentEntity(
            id: 'action-1',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: proposalVer,
            contentData: {'action': 'invalid_action'},
          );
          await db.documentsV2Dao.saveAll([proposal, action]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.id, 'p1');
          expect(result.items.first.actionType, isNull);
        });

        test('missing action field in content defaults to draft actionType', () async {
          final proposalVer = _buildUuidV7At(earliest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);

          final actionVer = _buildUuidV7At(latest);
          final action = _createTestDocumentEntity(
            id: 'action-1',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: proposalVer,
            contentData: {},
          );
          await db.documentsV2Dao.saveAll([proposal, action]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.id, 'p1');
          expect(result.items.first.actionType, ProposalSubmissionAction.draft);
        });
      });

      group('VersionIds', () {
        test('returns single version for proposal with one version', () async {
          final proposalVer = _buildUuidV7At(latest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
          await db.documentsV2Dao.saveAll([proposal]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.versionIds.length, 1);
          expect(result.items.first.proposal.ver, proposalVer);
          expect(result.items.first.versionIds, [proposalVer]);
        });

        test(
          'returns all versions ordered by ver ASC for proposal with multiple versions',
          () async {
            final ver1 = _buildUuidV7At(earliest);
            final ver2 = _buildUuidV7At(middle);
            final ver3 = _buildUuidV7At(latest);

            final proposal1 = _createTestDocumentEntity(id: 'p1', ver: ver1);
            final proposal2 = _createTestDocumentEntity(id: 'p1', ver: ver2);
            final proposal3 = _createTestDocumentEntity(id: 'p1', ver: ver3);
            await db.documentsV2Dao.saveAll([proposal3, proposal1, proposal2]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request);

            expect(result.items.length, 1);
            expect(result.items.first.proposal.ver, ver3);
            expect(result.items.first.versionIds.length, 3);
            expect(result.items.first.versionIds, [ver1, ver2, ver3]);
          },
        );
      });

      group('CommentsCount', () {
        test('returns zero comments for proposal without comments', () async {
          final proposalVer = _buildUuidV7At(latest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
          await db.documentsV2Dao.saveAll([proposal]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.commentsCount, 0);
        });

        test('returns correct count for proposal with comments on effective version', () async {
          final proposalVer = _buildUuidV7At(latest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);

          final comment1Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
          final comment1 = _createTestDocumentEntity(
            id: 'c1',
            ver: comment1Ver,
            type: DocumentType.commentDocument,
            refId: 'p1',
            refVer: proposalVer,
          );

          final comment2Ver = _buildUuidV7At(earliest.add(const Duration(hours: 2)));
          final comment2 = _createTestDocumentEntity(
            id: 'c2',
            ver: comment2Ver,
            type: DocumentType.commentDocument,
            refId: 'p1',
            refVer: proposalVer,
          );

          await db.documentsV2Dao.saveAll([proposal, comment1, comment2]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.commentsCount, 2);
        });

        test(
          'counts comments only for effective version when proposal has multiple versions',
          () async {
            final ver1 = _buildUuidV7At(earliest);
            final ver2 = _buildUuidV7At(latest);
            final proposal1 = _createTestDocumentEntity(id: 'p1', ver: ver1);
            final proposal2 = _createTestDocumentEntity(id: 'p1', ver: ver2);

            final comment1Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
            final comment1 = _createTestDocumentEntity(
              id: 'c1',
              ver: comment1Ver,
              type: DocumentType.commentDocument,
              refId: 'p1',
              refVer: ver1,
            );

            final comment2Ver = _buildUuidV7At(latest.add(const Duration(hours: 1)));
            final comment2 = _createTestDocumentEntity(
              id: 'c2',
              ver: comment2Ver,
              type: DocumentType.commentDocument,
              refId: 'p1',
              refVer: ver2,
            );

            final comment3Ver = _buildUuidV7At(latest.add(const Duration(hours: 2)));
            final comment3 = _createTestDocumentEntity(
              id: 'c3',
              ver: comment3Ver,
              type: DocumentType.commentDocument,
              refId: 'p1',
              refVer: ver2,
            );

            await db.documentsV2Dao.saveAll([proposal1, proposal2, comment1, comment2, comment3]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request);

            expect(result.items.length, 1);
            expect(result.items.first.proposal.ver, ver2);
            expect(result.items.first.commentsCount, 2);
          },
        );

        test('counts comments for final action version when specified', () async {
          final ver1 = _buildUuidV7At(earliest);
          final ver2 = _buildUuidV7At(middle);
          final ver3 = _buildUuidV7At(latest);

          final proposal1 = _createTestDocumentEntity(id: 'p1', ver: ver1);
          final proposal2 = _createTestDocumentEntity(id: 'p1', ver: ver2);
          final proposal3 = _createTestDocumentEntity(id: 'p1', ver: ver3);

          final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
          final action = _createTestDocumentEntity(
            id: 'action-1',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: ver2,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
          );

          final comment1Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
          final comment1 = _createTestDocumentEntity(
            id: 'c1',
            ver: comment1Ver,
            type: DocumentType.commentDocument,
            refId: 'p1',
            refVer: ver1,
          );

          final comment2Ver = _buildUuidV7At(middle.add(const Duration(hours: 1)));
          final comment2 = _createTestDocumentEntity(
            id: 'c2',
            ver: comment2Ver,
            type: DocumentType.commentDocument,
            refId: 'p1',
            refVer: ver2,
          );

          final comment3Ver = _buildUuidV7At(latest.add(const Duration(hours: 2)));
          final comment3 = _createTestDocumentEntity(
            id: 'c3',
            ver: comment3Ver,
            type: DocumentType.commentDocument,
            refId: 'p1',
            refVer: ver3,
          );

          await db.documentsV2Dao.saveAll([
            proposal1,
            proposal2,
            proposal3,
            action,
            comment1,
            comment2,
            comment3,
          ]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.ver, ver2);
          expect(result.items.first.commentsCount, 1);
        });

        test('excludes comments from other proposals', () async {
          final proposal1Ver = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(id: 'p1', ver: proposal1Ver);

          final proposal2Ver = _buildUuidV7At(latest);
          final proposal2 = _createTestDocumentEntity(id: 'p2', ver: proposal2Ver);

          final comment1Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
          final comment1 = _createTestDocumentEntity(
            id: 'c1',
            ver: comment1Ver,
            type: DocumentType.commentDocument,
            refId: 'p1',
            refVer: proposal1Ver,
          );

          final comment2Ver = _buildUuidV7At(earliest.add(const Duration(hours: 2)));
          final comment2 = _createTestDocumentEntity(
            id: 'c2',
            ver: comment2Ver,
            type: DocumentType.commentDocument,
            refId: 'p2',
            refVer: proposal2Ver,
          );

          final comment3Ver = _buildUuidV7At(earliest.add(const Duration(hours: 3)));
          final comment3 = _createTestDocumentEntity(
            id: 'c3',
            ver: comment3Ver,
            type: DocumentType.commentDocument,
            refId: 'p2',
            refVer: proposal2Ver,
          );

          await db.documentsV2Dao.saveAll([
            proposal1,
            proposal2,
            comment1,
            comment2,
            comment3,
          ]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 2);

          final p1 = result.items.firstWhere((e) => e.proposal.id == 'p1');
          final p2 = result.items.firstWhere((e) => e.proposal.id == 'p2');

          expect(p1.commentsCount, 1);
          expect(p2.commentsCount, 2);
        });

        test('excludes non-comment documents from count', () async {
          final proposalVer = _buildUuidV7At(latest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);

          final commentVer = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
          final comment = _createTestDocumentEntity(
            id: 'c1',
            ver: commentVer,
            type: DocumentType.commentDocument,
            refId: 'p1',
            refVer: proposalVer,
          );

          final otherDocVer = _buildUuidV7At(earliest.add(const Duration(hours: 2)));
          final otherDoc = _createTestDocumentEntity(
            id: 'other1',
            ver: otherDocVer,
            type: DocumentType.reviewDocument,
            refId: 'p1',
            refVer: proposalVer,
          );

          await db.documentsV2Dao.saveAll([proposal, comment, otherDoc]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.commentsCount, 1);
        });
      });

      group('IsFavorite', () {
        test('returns false when no local metadata exists', () async {
          final proposalVer = _buildUuidV7At(latest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
          await db.documentsV2Dao.saveAll([proposal]);

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.isFavorite, false);
        });

        test('returns false when local metadata exists but isFavorite is false', () async {
          final proposalVer = _buildUuidV7At(latest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
          await db.documentsV2Dao.saveAll([proposal]);

          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'p1',
                  isFavorite: false,
                ),
              );

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.isFavorite, false);
        });

        test('returns true when local metadata exists and isFavorite is true', () async {
          final proposalVer = _buildUuidV7At(latest);
          final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
          await db.documentsV2Dao.saveAll([proposal]);

          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'p1',
                  isFavorite: true,
                ),
              );

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.isFavorite, true);
        });

        test('returns correct isFavorite for proposal with multiple versions', () async {
          final ver1 = _buildUuidV7At(earliest);
          final ver2 = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(id: 'p1', ver: ver1);
          final proposal2 = _createTestDocumentEntity(id: 'p1', ver: ver2);
          await db.documentsV2Dao.saveAll([proposal1, proposal2]);

          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'p1',
                  isFavorite: true,
                ),
              );

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.ver, ver2);
          expect(result.items.first.isFavorite, true);
        });

        test('returns correct individual isFavorite values for multiple proposals', () async {
          final proposal1Ver = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(id: 'p1', ver: proposal1Ver);

          final proposal2Ver = _buildUuidV7At(latest);
          final proposal2 = _createTestDocumentEntity(id: 'p2', ver: proposal2Ver);

          final proposal3Ver = _buildUuidV7At(latest);
          final proposal3 = _createTestDocumentEntity(id: 'p3', ver: proposal3Ver);

          await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'p1',
                  isFavorite: true,
                ),
              );

          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'p2',
                  isFavorite: false,
                ),
              );

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 3);

          final p1 = result.items.firstWhere((e) => e.proposal.id == 'p1');
          final p2 = result.items.firstWhere((e) => e.proposal.id == 'p2');
          final p3 = result.items.firstWhere((e) => e.proposal.id == 'p3');

          expect(p1.isFavorite, true);
          expect(p2.isFavorite, false);
          expect(p3.isFavorite, false);
        });

        test('isFavorite matches on id regardless of version', () async {
          final ver1 = _buildUuidV7At(earliest);
          final ver2 = _buildUuidV7At(middle);
          final ver3 = _buildUuidV7At(latest);

          final proposal1 = _createTestDocumentEntity(id: 'p1', ver: ver1);
          final proposal2 = _createTestDocumentEntity(id: 'p1', ver: ver2);
          final proposal3 = _createTestDocumentEntity(id: 'p1', ver: ver3);

          final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
          final action = _createTestDocumentEntity(
            id: 'action-1',
            ver: actionVer,
            type: DocumentType.proposalActionDocument,
            refId: 'p1',
            refVer: ver1,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3, action]);

          await db
              .into(db.documentsLocalMetadata)
              .insert(
                DocumentsLocalMetadataCompanion.insert(
                  id: 'p1',
                  isFavorite: true,
                ),
              );

          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request);

          expect(result.items.length, 1);
          expect(result.items.first.proposal.ver, ver1);
          expect(result.items.first.isFavorite, true);
        });
      });
    });
  });
}

String _buildUuidV7At(DateTime dateTime) {
  final ts = dateTime.millisecondsSinceEpoch;
  final rand = Uint8List.fromList([42, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
  return const UuidV7().generate(options: V7Options(ts, rand));
}

DocumentEntityV2 _createTestDocumentEntity({
  String? id,
  String? ver,
  Map<String, dynamic> contentData = const {},
  DocumentType type = DocumentType.proposalDocument,
  DateTime? createdAt,
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

  return DocumentEntityV2(
    id: id,
    ver: ver,
    content: DocumentDataContent(contentData),
    createdAt: createdAt ?? ver.tryDateTime ?? DateTime.now(),
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

extension on ProposalSubmissionActionDto {
  Map<String, dynamic> toJson() {
    return ProposalSubmissionActionDocumentDto(action: this).toJson();
  }
}
