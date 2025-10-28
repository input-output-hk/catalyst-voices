import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
}

extension on ProposalSubmissionActionDto {
  Map<String, dynamic> toJson() {
    return ProposalSubmissionActionDocumentDto(action: this).toJson();
  }
}
