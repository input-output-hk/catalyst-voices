// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_dynamic_calls

import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.dart';
import 'package:catalyst_voices_repositories/src/database/model/document_composite_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.drift.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/document_composite_factory.dart';
import '../connection/test_connection.dart';
import '../drift_test_platforms.dart';

void main() {
  group(
    ProposalsV2Dao,
    () {
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

      group('getVisibleProposalsCount', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        final cat1 = DocumentRefFactory.signedDocumentRef();
        final cat2 = DocumentRefFactory.signedDocumentRef();
        final cat3 = DocumentRefFactory.signedDocumentRef();

        test('returns 0 for empty database', () async {
          final result = await dao.getVisibleProposalsCount();

          expect(result, 0);
        });

        test('returns correct count for proposals without actions', () async {
          final entities = List.generate(
            5,
            (i) => _createTestDocumentEntity(
              id: 'p-$i',
              ver: _buildUuidV7At(earliest.add(Duration(hours: i))),
            ),
          );
          await db.documentsV2Dao.saveAll(entities);

          final result = await dao.getVisibleProposalsCount();

          expect(result, 5);
        });

        test('counts only latest version of proposals with multiple versions', () async {
          final entityOldV1 = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(earliest),
          );
          final entityNewV1 = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
          );
          final entityOldV2 = _createTestDocumentEntity(
            id: 'p2',
            ver: _buildUuidV7At(earliest),
          );
          final entityNewV2 = _createTestDocumentEntity(
            id: 'p2',
            ver: _buildUuidV7At(middle),
          );
          await db.documentsV2Dao.saveAll([entityOldV1, entityNewV1, entityOldV2, entityNewV2]);

          final result = await dao.getVisibleProposalsCount();

          expect(result, 2);
        });

        test('excludes hidden proposals from count', () async {
          final author = _createTestAuthor();

          final p1Ver = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(
            id: p1Ver,
            ver: p1Ver,
            authors: [author],
          );

          final p2Ver = _buildUuidV7At(middle);
          final proposal2 = _createTestDocumentEntity(
            id: p2Ver,
            ver: p2Ver,
            authors: [author],
          );

          final hideAction = _createTestDocumentEntity(
            id: 'action-hide',
            ver: _buildUuidV7At(earliest),
            type: DocumentType.proposalActionDocument,
            refId: p2Ver,
            refVer: p2Ver,
            contentData: ProposalSubmissionActionDto.hide.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, hideAction]);

          final result = await dao.getVisibleProposalsCount();

          expect(result, 1);
        });

        test('excludes all versions when latest action is hide', () async {
          final author = _createTestAuthor();

          final proposal1 = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
            authors: [author],
          );

          final p2v1Ver = _buildUuidV7At(earliest);
          final proposal2V1 = _createTestDocumentEntity(
            id: p2v1Ver,
            ver: p2v1Ver,
            authors: [author],
          );

          final p2v2Ver = _buildUuidV7At(middle);
          final proposal2V2 = _createTestDocumentEntity(
            id: p2v1Ver,
            ver: p2v2Ver,
            authors: [author],
          );

          final p2v3Ver = _buildUuidV7At(latest);
          final proposal2V3 = _createTestDocumentEntity(
            id: p2v1Ver,
            ver: p2v3Ver,
            authors: [author],
          );

          final hideAction = _createTestDocumentEntity(
            id: 'action-hide',
            ver: _buildUuidV7At(latest.add(const Duration(hours: 1))),
            type: DocumentType.proposalActionDocument,
            refId: proposal2V3.doc.id,
            refVer: proposal2V3.doc.ver,
            contentData: ProposalSubmissionActionDto.hide.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([
            proposal1,
            proposal2V1,
            proposal2V2,
            proposal2V3,
            hideAction,
          ]);

          final result = await dao.getVisibleProposalsCount();

          expect(result, 1);
        });

        test('counts only proposals matching category filter', () async {
          final proposal1 = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
            parameters: [cat1],
          );

          final proposal2 = _createTestDocumentEntity(
            id: 'p2',
            ver: _buildUuidV7At(middle),
            parameters: [cat2],
          );

          final proposal3 = _createTestDocumentEntity(
            id: 'p3',
            ver: _buildUuidV7At(earliest),
            parameters: [cat2],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

          final result = await dao.getVisibleProposalsCount(
            filters: ProposalsFiltersV2(categoryId: cat1.id),
          );

          expect(result, 1);
        });

        test('respects campaign categories filter', () async {
          final proposal1 = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
            parameters: [cat1],
          );

          final proposal2 = _createTestDocumentEntity(
            id: 'p2',
            ver: _buildUuidV7At(middle),
            parameters: [cat2],
          );

          final proposal3 = _createTestDocumentEntity(
            id: 'p3',
            ver: _buildUuidV7At(earliest),
            parameters: [cat3],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

          final result = await dao.getVisibleProposalsCount(
            filters: ProposalsFiltersV2(
              campaign: ProposalsCampaignFilters(categoriesIds: {cat1.id, cat2.id}),
            ),
          );

          expect(result, 2);
        });

        test('returns 0 for empty campaign categories', () async {
          final proposal1 = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
            parameters: [cat1],
          );
          await db.documentsV2Dao.saveAll([proposal1]);

          final result = await dao.getVisibleProposalsCount(
            filters: const ProposalsFiltersV2(
              campaign: ProposalsCampaignFilters(categoriesIds: {}),
            ),
          );

          expect(result, 0);
        });

        test('returns 0 when categoryId not in campaign categories', () async {
          final proposal1 = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
            parameters: [cat1],
          );
          await db.documentsV2Dao.saveAll([proposal1]);

          final result = await dao.getVisibleProposalsCount(
            filters: ProposalsFiltersV2(
              campaign: ProposalsCampaignFilters(categoriesIds: {cat2.id, cat3.id}),
              categoryId: cat1.id,
            ),
          );

          expect(result, 0);
        });

        test('respects status filter for draft proposals', () async {
          final author = _createTestAuthor();

          final draftVer = _buildUuidV7At(latest);
          final draftProposal = _createTestDocumentEntity(
            id: draftVer,
            ver: draftVer,
            authors: [author],
          );

          final finalProposalVer = _buildUuidV7At(middle);
          final finalProposal = _createTestDocumentEntity(
            id: finalProposalVer,
            ver: finalProposalVer,
            authors: [author],
          );

          final finalAction = _createTestDocumentEntity(
            id: 'action-final',
            ver: _buildUuidV7At(earliest),
            type: DocumentType.proposalActionDocument,
            refId: finalProposal.doc.id,
            refVer: finalProposal.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([draftProposal, finalProposal, finalAction]);

          final result = await dao.getVisibleProposalsCount(
            filters: const ProposalsFiltersV2(status: ProposalStatusFilter.draft),
          );

          expect(result, 1);
        });

        test('respects status filter for final proposals', () async {
          final author = _createTestAuthor();

          final draftVer = _buildUuidV7At(latest);
          final draftProposal = _createTestDocumentEntity(
            id: draftVer,
            ver: draftVer,
            authors: [author],
          );

          final finalProposalVer = _buildUuidV7At(middle);
          final finalProposal = _createTestDocumentEntity(
            id: finalProposalVer,
            ver: finalProposalVer,
            authors: [author],
          );

          final finalAction = _createTestDocumentEntity(
            id: 'action-final',
            ver: _buildUuidV7At(earliest),
            type: DocumentType.proposalActionDocument,
            refId: finalProposal.doc.id,
            refVer: finalProposal.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([draftProposal, finalProposal, finalAction]);

          final result = await dao.getVisibleProposalsCount(
            filters: const ProposalsFiltersV2(status: ProposalStatusFilter.aFinal),
          );

          expect(result, 1);
        });

        test('counts proposals with authors filter', () async {
          final author1 = _createTestAuthor(name: 'author1');
          final author2 = _createTestAuthor(name: 'author2', role0KeySeed: 1);

          final p1Ver = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(
            id: p1Ver,
            ver: p1Ver,
            authors: [author1],
          );

          final p2Ver = _buildUuidV7At(middle);
          final proposal2 = _createTestDocumentEntity(
            id: p2Ver,
            ver: p2Ver,
            authors: [author2],
          );

          final p3Ver = _buildUuidV7At(earliest);
          final proposal3 = _createTestDocumentEntity(
            id: p3Ver,
            ver: p3Ver,
            authors: [author1],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

          final result = await dao.getVisibleProposalsCount(
            filters: ProposalsFiltersV2(originalAuthor: author1),
          );

          expect(result, 2);
        });

        test('ignores non-proposal documents in count', () async {
          final proposal = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
          );

          final comment = _createTestDocumentEntity(
            id: 'c1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.commentDocument,
          );

          final template = _createTestDocumentEntity(
            id: 't1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalTemplate,
          );

          await db.documentsV2Dao.saveAll([proposal, comment, template]);

          final result = await dao.getVisibleProposalsCount();

          expect(result, 1);
        });

        test('hidden from different author then proposals do not exclude proposal', () async {
          final author = _createTestAuthor(name: 'Good', role0KeySeed: 1);
          final differentAuthor = _createTestAuthor(name: 'Bad', role0KeySeed: 2);

          final p1Ver = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(
            id: p1Ver,
            ver: p1Ver,
            authors: [author],
          );

          final p2Ver = _buildUuidV7At(middle);
          final proposal2 = _createTestDocumentEntity(
            id: p2Ver,
            ver: p2Ver,
            authors: [author],
          );

          final hideAction = _createTestDocumentEntity(
            id: 'action-hide',
            ver: _buildUuidV7At(earliest),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.hide.toJson(),
            authors: [differentAuthor],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, hideAction]);

          final result = await dao.getVisibleProposalsCount();

          expect(result, 2);
        });
      });

      group('updateProposalFavorite', () {
        test('marks proposal as favorite when isFavorite is true', () async {
          await dao.updateProposalFavorite(id: 'p1', isFavorite: true);

          final metadata = await (db.select(
            db.documentsLocalMetadata,
          )..where((tbl) => tbl.id.equals('p1'))).getSingleOrNull();

          expect(metadata, isNotNull);
          expect(metadata!.id, 'p1');
          expect(metadata.isFavorite, true);
        });

        test('removes favorite status when isFavorite is false', () async {
          await dao.updateProposalFavorite(id: 'p1', isFavorite: true);

          await dao.updateProposalFavorite(id: 'p1', isFavorite: false);

          final metadata = await (db.select(
            db.documentsLocalMetadata,
          )..where((tbl) => tbl.id.equals('p1'))).getSingleOrNull();

          expect(metadata, isNull);
        });

        test('does nothing when removing non-existent favorite', () async {
          await dao.updateProposalFavorite(id: 'p1', isFavorite: false);

          final metadata = await (db.select(
            db.documentsLocalMetadata,
          )..where((tbl) => tbl.id.equals('p1'))).getSingleOrNull();

          expect(metadata, isNull);
        });

        test('can mark multiple proposals as favorites', () async {
          await dao.updateProposalFavorite(id: 'p1', isFavorite: true);
          await dao.updateProposalFavorite(id: 'p2', isFavorite: true);
          await dao.updateProposalFavorite(id: 'p3', isFavorite: true);

          final favorites = await db.select(db.documentsLocalMetadata).get();

          expect(favorites, hasLength(3));
          expect(favorites.map((e) => e.id).toSet(), {'p1', 'p2', 'p3'});
        });
      });

      group('getProposalsBriefPage', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        test('returns empty page for empty database', () async {
          // Given
          const request = PageRequest(page: 0, size: 10);

          // When
          final result = await dao.getProposalsBriefPage(request: request);

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
          final result = await dao.getProposalsBriefPage(request: request);

          // Then
          expect(result.items, hasLength(2));
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
          final result = await dao.getProposalsBriefPage(request: request);

          // Then: Returns remaining items (1), total unchanged
          expect(result.items, hasLength(1));
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
          final result = await dao.getProposalsBriefPage(request: request);

          // Then
          expect(result.items, hasLength(2));
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
          final result = await dao.getProposalsBriefPage(request: request);

          // Then
          expect(result.items, hasLength(1));
          expect(result.total, 1);
          expect(result.items[0].proposal.type, DocumentType.proposalDocument);
        });

        test('excludes hidden proposals based on latest action', () async {
          // Given
          final author = _createTestAuthor();

          final proposal1Ver = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(latest.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            authors: [author],
          );

          final actionOldVer = _buildUuidV7At(middle);
          final actionOld = _createTestDocumentEntity(
            id: 'action-old',
            ver: actionOldVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.draft.toJson(),
            authors: [author],
          );
          final actionHideVer = _buildUuidV7At(earliest.add(const Duration(hours: 6)));
          final actionHide = _createTestDocumentEntity(
            id: 'action-hide',
            ver: actionHideVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.hide.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, actionOld, actionHide]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request: request);

          // Then: Only visible (p1); total=1.
          expect(result.items, hasLength(1));
          expect(result.total, 1);
          expect(result.items[0].proposal.id, proposal1.doc.id);
        });

        test('excludes hidden proposals, even later versions, based on latest action', () async {
          // Given
          final author = _createTestAuthor();

          final proposal1Ver = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(latest.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            authors: [author],
          );

          final proposal3Ver = _buildUuidV7At(latest.add(const Duration(days: 5)));
          final proposal3 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal3Ver,
            authors: [author],
          );

          final actionOldVer = _buildUuidV7At(middle);
          final actionOld = _createTestDocumentEntity(
            id: 'action-old',
            ver: actionOldVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.draft.toJson(),
            authors: [author],
          );
          final actionHideVer = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
          final actionHide = _createTestDocumentEntity(
            id: 'action-hide',
            ver: actionHideVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.hide.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3, actionOld, actionHide]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request: request);

          // Then: Only visible (p1); total=1.
          expect(result.items, hasLength(1));
          expect(result.total, 1);
          expect(result.items[0].proposal.id, proposal1.doc.id);
        });

        test('latest, non hide, action, overrides previous hide', () async {
          // Given
          final author = _createTestAuthor();

          final proposal1Ver = _buildUuidV7At(latest);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(latest.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            authors: [author],
          );

          final proposal3Ver = _buildUuidV7At(latest.add(const Duration(days: 1)));
          final proposal3 = _createTestDocumentEntity(
            id: proposal2.doc.id,
            ver: proposal3Ver,
            authors: [author],
          );

          final actionOldHideVer = _buildUuidV7At(middle);
          final actionOldHide = _createTestDocumentEntity(
            id: 'action-hide',
            ver: actionOldHideVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.hide.toJson(),
            authors: [author],
          );
          final actionDraftVer = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
          final actionDraft = _createTestDocumentEntity(
            id: 'action-draft',
            ver: actionDraftVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal3.doc.id,
            refVer: proposal3.doc.ver,
            contentData: ProposalSubmissionActionDto.draft.toJson(),
            authors: [author],
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
          final result = await dao.getProposalsBriefPage(request: request);

          // Then: total=2, both are visible
          expect(result.items, hasLength(2));
          expect(result.total, 2);
          expect(result.items[0].proposal.id, proposal2.doc.id);
          expect(result.items[1].proposal.id, proposal1.doc.id);
        });

        test(
          'excludes hidden proposals based on latest version only, '
          'fails without latestProposalSubquery join',
          () async {
            // Given: Multiple versions for one proposal, with hide action on latest version only.
            final earliest = DateTime(2025, 2, 5, 5, 23, 27);
            final middle = DateTime(2025, 2, 5, 5, 25, 33);
            final latest = DateTime(2025, 8, 11, 11, 20, 18);

            final author = _createTestAuthor();

            // Proposal A: Old version (visible, no hide action for this ver).
            final proposalAOldVer = _buildUuidV7At(earliest);
            final proposalAOld = _createTestDocumentEntity(
              id: proposalAOldVer,
              ver: proposalAOldVer,
              authors: [author],
            );

            // Proposal A: Latest version (hidden, with hide action for this ver).
            final proposalALatestVer = _buildUuidV7At(latest);
            final proposalALatest = _createTestDocumentEntity(
              id: proposalAOld.doc.id,
              ver: proposalALatestVer,
              authors: [author],
            );

            // Hide action for latest version only (refVer = latestVer, ver after latest proposal).
            final actionHideVer = _buildUuidV7At(latest.add(const Duration(seconds: 1)));
            final actionHide = _createTestDocumentEntity(
              id: 'action-hide',
              ver: actionHideVer,
              type: DocumentType.proposalActionDocument,
              refId: proposalALatest.doc.id,
              refVer: proposalALatest.doc.ver,
              // Specific to latest ver.
              contentData: ProposalSubmissionActionDto.hide.toJson(),
              authors: [author],
            );

            // Proposal B: Single version, visible (no action).
            final proposalBVer = _buildUuidV7At(middle);
            final proposalB = _createTestDocumentEntity(
              id: proposalBVer,
              ver: proposalBVer,
              authors: [author],
            );

            await db.documentsV2Dao.saveAll([proposalAOld, proposalALatest, actionHide, proposalB]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: With join, latest A is hidden → exclude A, total =1 (B only), items =1 (B).
            expect(result.total, 1);
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.id, proposalB.doc.id);
          },
        );

        test('returns specific version when final action points to ref_ver', () async {
          // Given
          final author = _createTestAuthor();

          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: proposal1OldVer,
            ver: proposal1OldVer,
            contentData: {'title': 'old version'},
            authors: [author],
          );

          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: proposal1Old.doc.id,
            ver: proposal1NewVer,
            contentData: {'title': 'new version'},
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(latest);
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            authors: [author],
          );

          final actionFinalVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
          final actionFinal = _createTestDocumentEntity(
            id: 'action-final',
            ver: actionFinalVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal1Old.doc.id,
            refVer: proposal1Old.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New, proposal2, actionFinal]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request: request);

          // Then
          expect(result.items, hasLength(2));
          expect(result.total, 2);
          final p1Result = result.items.firstWhere(
            (item) => item.proposal.id == proposal1Old.doc.id,
          );
          expect(p1Result.proposal.ver, proposal1OldVer);
          expect(p1Result.proposal.content.data['title'], 'old version');
        });

        test('returns latest version when final action has no ref_ver', () async {
          // Given
          final author = _createTestAuthor();

          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: proposal1OldVer,
            ver: proposal1OldVer,
            contentData: {'title': 'old version'},
            authors: [author],
          );

          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: proposal1Old.doc.id,
            ver: proposal1NewVer,
            contentData: {'title': 'new version'},
            authors: [author],
          );

          final actionFinalVer = _buildUuidV7At(latest);
          final actionFinal = _createTestDocumentEntity(
            id: 'action-final',
            ver: actionFinalVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal1Old.doc.id,
            refVer: null,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New, actionFinal]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request: request);

          // Then
          expect(result.items, hasLength(1));
          expect(result.total, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
          expect(result.items[0].proposal.content.data['title'], 'new version');
        });

        test('draft action shows latest version of proposal', () async {
          // Given
          final author = _createTestAuthor();

          final proposal1OldVer = _buildUuidV7At(earliest);
          final proposal1Old = _createTestDocumentEntity(
            id: proposal1OldVer,
            ver: proposal1OldVer,
            contentData: {'title': 'old version'},
            authors: [author],
          );

          final proposal1NewVer = _buildUuidV7At(middle);
          final proposal1New = _createTestDocumentEntity(
            id: proposal1Old.doc.id,
            ver: proposal1NewVer,
            contentData: {'title': 'new version'},
            authors: [author],
          );

          final actionDraftVer = _buildUuidV7At(latest);
          final actionDraft = _createTestDocumentEntity(
            id: 'action-draft',
            ver: actionDraftVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal1Old.doc.id,
            refVer: proposal1Old.doc.ver,
            contentData: ProposalSubmissionActionDto.draft.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1Old, proposal1New, actionDraft]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request: request);

          // Then
          expect(result.items, hasLength(1));
          expect(result.total, 1);
          expect(result.items[0].proposal.ver, proposal1NewVer);
          expect(result.items[0].proposal.content.data['title'], 'new version');
        });

        test('final action with ref_ver overrides later proposal versions', () async {
          // Given
          final author = _createTestAuthor();

          final proposal1Ver1 = _buildUuidV7At(earliest);
          final proposal1V1 = _createTestDocumentEntity(
            id: proposal1Ver1,
            ver: proposal1Ver1,
            contentData: {'version': 1},
            authors: [author],
          );

          final proposal1Ver2 = _buildUuidV7At(middle);
          final proposal1V2 = _createTestDocumentEntity(
            id: proposal1V1.doc.id,
            ver: proposal1Ver2,
            contentData: {'version': 2},
            authors: [author],
          );

          final proposal1Ver3 = _buildUuidV7At(latest);
          final proposal1V3 = _createTestDocumentEntity(
            id: proposal1V1.doc.id,
            ver: proposal1Ver3,
            contentData: {'version': 3},
            authors: [author],
          );

          final actionFinalVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
          final actionFinal = _createTestDocumentEntity(
            id: 'action-final',
            ver: actionFinalVer,
            type: DocumentType.proposalActionDocument,
            refId: proposal1V2.doc.id,
            refVer: proposal1V2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1V1, proposal1V2, proposal1V3, actionFinal]);

          // When
          const request = PageRequest(page: 0, size: 10);
          final result = await dao.getProposalsBriefPage(request: request);

          // Then
          expect(result.items, hasLength(1));
          expect(result.total, 1);
          expect(result.items[0].proposal.ver, proposal1Ver2);
          expect(result.items[0].proposal.content.data['version'], 2);
        });

        group('NOT IN with NULL values', () {
          final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
          final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

          test('action with NULL ref_id does not break query', () async {
            // Given
            final author = _createTestAuthor();

            final pId = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(id: pId, ver: pId, authors: [author]);
            await db.documentsV2Dao.saveAll([proposal]);

            // And: Action with NULL ref_id
            final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
            final actionNullRef = _createTestDocumentEntity(
              id: 'action-null-ref',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: null,
              contentData: {'action': 'hide'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionNullRef]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should still return the proposal (NOT IN with NULL should not fail)
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.id, pId);
            expect(result.total, 1);
          });

          test(
            'multiple proposals with NULL ref_id actions return all visible proposals',
            () async {
              // Given
              final author = _createTestAuthor();

              final p1Id = _buildUuidV7At(earliest);
              final proposal1 = _createTestDocumentEntity(id: p1Id, ver: p1Id, authors: [author]);

              final p2Id = _buildUuidV7At(latest);
              final proposal2 = _createTestDocumentEntity(id: p2Id, ver: p2Id, authors: [author]);
              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              // And: Multiple actions with NULL ref_id
              final actions = <DocumentCompositeEntity>[];
              for (var i = 0; i < 3; i++) {
                final actionVer = _buildUuidV7At(latest.add(Duration(hours: i)));
                actions.add(
                  _createTestDocumentEntity(
                    id: 'action-null-$i',
                    ver: actionVer,
                    type: DocumentType.proposalActionDocument,
                    refId: null,
                    contentData: {'action': 'hide'},
                    authors: [author],
                  ),
                );
              }
              await db.documentsV2Dao.saveAll(actions);

              // When
              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(request: request);

              // Then
              expect(result.items, hasLength(2));
              expect(result.total, 2);
            },
          );
        });

        group('JSON extraction NULL safety', () {
          final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
          final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
          final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

          final author = _createTestAuthor();

          test('action with malformed JSON does not crash query', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(middle);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            // Action with malformed JSON
            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-malformed',
              ver: actionVer,
              refId: proposal1Old.doc.id,
              refVer: proposal1Old.doc.ver,
              type: DocumentType.proposalActionDocument,
              contentData: {'wrong': true},
              authors: [author],
            );

            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New, action]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should treat as draft and return latest version
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.ver, proposal1NewVer);
            expect(result.items[0].proposal.content.data['title'], 'new');
          });

          test('action without action field treats as draft', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(middle);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

            // And: Action without 'action' field
            final actionVer = _buildUuidV7At(latest);
            final actionNoField = _createTestDocumentEntity(
              id: 'action-no-field',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1Old.doc.id,
              refVer: proposal1Old.doc.ver,
              contentData: {'status': 'pending'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionNoField]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should treat as draft and return latest version
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.ver, proposal1NewVer);
          });

          test('action with null action value treats as draft', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(middle);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

            // And: Action with null value
            final actionVer = _buildUuidV7At(latest);
            final actionNullValue = _createTestDocumentEntity(
              id: 'action-null-value',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1New.doc.id,
              refVer: proposal1New.doc.ver,
              contentData: {'action': null},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionNullValue]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should treat as draft and return latest version
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.ver, proposal1NewVer);
          });

          test('action with empty string action treats as draft', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(middle);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

            // And: Action with empty string
            final actionVer = _buildUuidV7At(latest);
            final actionEmpty = _createTestDocumentEntity(
              id: 'action-empty',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1Old.doc.id,
              refVer: proposal1Old.doc.ver,
              contentData: {'action': ''},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionEmpty]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should treat as draft and return latest version
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.ver, proposal1NewVer);
          });

          test('action with wrong type (number) handles gracefully', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(middle);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

            // And: Action with number instead of string
            final actionVer = _buildUuidV7At(latest);
            final actionNumber = _createTestDocumentEntity(
              id: 'action-number',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1New.doc.id,
              refVer: proposal1New.doc.ver,
              contentData: {'action': 42},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionNumber]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should handle gracefully and return latest version
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.ver, proposal1NewVer);
          });

          test('action with boolean value handles gracefully', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(middle);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

            // And: Action with boolean value
            final actionVer = _buildUuidV7At(latest);
            final actionBool = _createTestDocumentEntity(
              id: 'action-bool',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1Old.doc.id,
              refVer: proposal1Old.doc.ver,
              contentData: {'action': true},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionBool]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should handle gracefully and return latest version
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.ver, proposal1NewVer);
          });

          test('action with nested JSON structure extracts correctly', () async {
            // Given
            final pId = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: pId,
              ver: pId,
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal]);

            // And: Action with nested structure (should extract $.action, not nested value)
            final actionVer = _buildUuidV7At(latest);
            final actionNested = _createTestDocumentEntity(
              id: 'action-nested',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: {
                'metadata': {'action': 'ignore'},
                'action': 'hide',
              },
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionNested]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should be hidden based on top-level action field
            expect(result.items, hasLength(0));
            expect(result.total, 0);
          });
        });

        group('Ordering by createdAt vs UUID string', () {
          final author = _createTestAuthor();

          test('proposals ordered by createdAt not ver string', () async {
            // Given: Three proposals with specific createdAt times
            final time1 = DateTime.utc(2025, 1, 1, 10, 0, 0);
            final time2 = DateTime.utc(2025, 6, 15, 14, 30, 0);
            final time3 = DateTime.utc(2025, 12, 31, 23, 59, 59);

            final ver1 = _buildUuidV7At(time1);
            final ver2 = _buildUuidV7At(time2);
            final ver3 = _buildUuidV7At(time3);

            final proposal1 = _createTestDocumentEntity(
              id: ver1,
              ver: ver1,
              contentData: {'order': 'oldest'},
              authors: [author],
            );
            final proposal2 = _createTestDocumentEntity(
              id: ver2,
              ver: ver2,
              contentData: {'order': 'middle'},
              authors: [author],
            );
            final proposal3 = _createTestDocumentEntity(
              id: ver3,
              ver: ver3,
              contentData: {'order': 'newest'},
              authors: [author],
            );

            await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should be ordered newest first by createdAt
            expect(result.items, hasLength(3));
            expect(result.items[0].proposal.content.data['order'], 'newest');
            expect(result.items[1].proposal.content.data['order'], 'middle');
            expect(result.items[2].proposal.content.data['order'], 'oldest');
          });

          test('proposals with manually set createdAt respect createdAt not ver', () async {
            // Given: Non-UUIDv7 versions with explicit createdAt
            final proposal1 = _createTestDocumentEntity(
              id: '00000000-0000-0000-0000-000000000001',
              ver: '00000000-0000-0000-0000-000000000001',
              createdAt: DateTime.utc(2025, 1, 1),
              contentData: {'when': 'second'},
            );
            final proposal2 = _createTestDocumentEntity(
              id: '00000000-0000-0000-0000-000000000002',
              ver: '00000000-0000-0000-0000-000000000002',
              createdAt: DateTime.utc(2025, 12, 31),
              contentData: {'when': 'first'},
            );

            await db.documentsV2Dao.saveAll([proposal1, proposal2]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should order by createdAt (Dec 31 first), not ver string
            expect(result.items, hasLength(2));
            expect(result.items[0].proposal.content.data['when'], 'first');
            expect(result.items[1].proposal.content.data['when'], 'second');
          });
        });

        group('Count consistency', () {
          final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
          final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
          final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

          final author = _createTestAuthor();

          test('count matches items in complex scenario', () async {
            // Given: Multiple proposals with various actions
            final proposal1Ver = _buildUuidV7At(earliest);
            final proposal1 = _createTestDocumentEntity(
              id: proposal1Ver,
              ver: proposal1Ver,
              authors: [author],
            );

            final proposal2Ver = _buildUuidV7At(middle);
            final proposal2 = _createTestDocumentEntity(
              id: proposal2Ver,
              ver: proposal2Ver,
              authors: [author],
            );

            final proposal3Ver = _buildUuidV7At(latest);
            final proposal3 = _createTestDocumentEntity(
              id: proposal3Ver,
              ver: proposal3Ver,
              authors: [author],
            );

            final actionHideVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
            final actionHide = _createTestDocumentEntity(
              id: 'action-hide',
              ver: actionHideVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1.doc.id,
              refVer: proposal1.doc.ver,
              contentData: ProposalSubmissionActionDto.hide.toJson(),
              authors: [author],
            );

            final actionFinalVer = _buildUuidV7At(latest.add(const Duration(hours: 2)));
            final actionFinal = _createTestDocumentEntity(
              id: 'action-final',
              ver: actionFinalVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal2.doc.id,
              refVer: proposal2.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
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
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Count should match visible items (p2 final, p3 draft)
            expect(result.items, hasLength(2));
            expect(result.total, 2);
          });

          test('count remains consistent across pagination', () async {
            // Given: 25 proposals
            final proposals = <DocumentCompositeEntity>[];
            for (var i = 0; i < 25; i++) {
              final time = DateTime.utc(2025, 1, 1).add(Duration(hours: i));
              final ver = _buildUuidV7At(time);
              proposals.add(
                _createTestDocumentEntity(
                  id: ver,
                  ver: ver,
                  contentData: {'index': i},
                  authors: [author],
                ),
              );
            }
            await db.documentsV2Dao.saveAll(proposals);

            // When: Query multiple pages
            final page1 = await dao.getProposalsBriefPage(
              request: const PageRequest(page: 0, size: 10),
            );
            final page2 = await dao.getProposalsBriefPage(
              request: const PageRequest(page: 1, size: 10),
            );
            final page3 = await dao.getProposalsBriefPage(
              request: const PageRequest(page: 2, size: 10),
            );

            // Then: Total should be consistent across all pages
            expect(page1.total, 25);
            expect(page2.total, 25);
            expect(page3.total, 25);

            expect(page1.items, hasLength(10));
            expect(page2.items, hasLength(10));
            expect(page3.items, hasLength(5));
          });
        });

        group('NULL ref_ver handling', () {
          final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
          final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
          final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

          final author = _createTestAuthor();

          test('final action with NULL ref_ver uses latest version', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(middle);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

            // And: Final action with NULL ref_ver
            final actionVer = _buildUuidV7At(latest);
            final actionFinal = _createTestDocumentEntity(
              id: 'action-final',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1Old.doc.id,
              refVer: null,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionFinal]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should use latest version
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.ver, proposal1NewVer);
            expect(result.items[0].proposal.content.data['title'], 'new');
          });

          test('final action with empty string ref_ver excludes proposal', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(middle);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

            // And: Final action with empty string ref_ver
            final actionVer = _buildUuidV7At(latest);
            final actionFinal = _createTestDocumentEntity(
              id: 'action-final',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1Old.doc.id,
              refVer: '',
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionFinal]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should be empty
            expect(result.items, isEmpty);
          });
        });

        group('Case sensitivity', () {
          final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
          final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

          final author = _createTestAuthor();

          test('uppercase HIDE action does not hide proposal', () async {
            // Given
            final pId = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(id: pId, ver: pId, authors: [author]);
            await db.documentsV2Dao.saveAll([proposal]);

            // And: Action with uppercase HIDE
            final actionVer = _buildUuidV7At(latest);
            final actionUpper = _createTestDocumentEntity(
              id: 'action-upper',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: pId,
              refVer: pId,
              contentData: {'action': 'HIDE'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionUpper]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should NOT hide (case sensitive)
            expect(result.items, hasLength(1));
          });

          test('mixed case Final action does not treat as final', () async {
            // Given
            final proposal1OldVer = _buildUuidV7At(earliest);
            final proposal1Old = _createTestDocumentEntity(
              id: proposal1OldVer,
              ver: proposal1OldVer,
              contentData: {'title': 'old'},
              authors: [author],
            );
            final proposal1NewVer = _buildUuidV7At(latest);
            final proposal1New = _createTestDocumentEntity(
              id: proposal1Old.doc.id,
              ver: proposal1NewVer,
              contentData: {'title': 'new'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal1Old, proposal1New]);

            // And: Action with mixed case
            final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
            final actionMixed = _createTestDocumentEntity(
              id: 'action-mixed',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1Old.doc.id,
              refVer: proposal1Old.doc.ver,
              contentData: {'action': 'Final'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([actionMixed]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then: Should treat as draft and use latest version
            expect(result.items, hasLength(1));
            expect(result.items[0].proposal.ver, proposal1NewVer);
          });
        });

        group('ActionType', () {
          final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
          final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
          final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

          final author = _createTestAuthor();

          test('proposal with no action has null actionType', () async {
            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [author],
            );
            await db.documentsV2Dao.save(proposal);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.id, proposal.doc.id);
            expect(result.items.first.actionType, isNull);
          });

          test('proposal with draft action has draft actionType', () async {
            final proposalVer = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [author],
            );

            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: ProposalSubmissionActionDto.draft.toJson(),
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal, action]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.id, proposal.doc.id);
            expect(result.items.first.actionType, ProposalSubmissionAction.draft);
          });

          test('proposal with final action has final_ actionType', () async {
            final proposalVer = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [author],
            );

            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal, action]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.id, proposal.doc.id);
            expect(result.items.first.actionType, ProposalSubmissionAction.aFinal);
          });

          test('proposal with hide action is excluded and has no actionType', () async {
            final proposalVer = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [author],
            );

            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: ProposalSubmissionActionDto.hide.toJson(),
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal, action]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, isEmpty);
            expect(result.total, 0);
          });

          test('multiple actions uses latest action for actionType', () async {
            final proposalVer = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [author],
            );

            final action1Ver = _buildUuidV7At(middle);
            final action1 = _createTestDocumentEntity(
              id: 'action-1',
              ver: action1Ver,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: ProposalSubmissionActionDto.draft.toJson(),
              authors: [author],
            );

            final action2Ver = _buildUuidV7At(latest);
            final action2 = _createTestDocumentEntity(
              id: 'action-2',
              ver: action2Ver,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal, action1, action2]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.id, proposal.doc.id);
            expect(result.items.first.actionType, ProposalSubmissionAction.aFinal);
          });

          test('multiple proposals have correct individual actionTypes', () async {
            final proposal1Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
            final proposal1 = _createTestDocumentEntity(
              id: proposal1Ver,
              ver: proposal1Ver,
              authors: [author],
            );

            final proposal2Ver = _buildUuidV7At(earliest.add(const Duration(hours: 2)));
            final proposal2 = _createTestDocumentEntity(
              id: proposal2Ver,
              ver: proposal2Ver,
              authors: [author],
            );

            final proposal3Ver = _buildUuidV7At(earliest.add(const Duration(hours: 3)));
            final proposal3 = _createTestDocumentEntity(
              id: proposal3Ver,
              ver: proposal3Ver,
              authors: [author],
            );

            final action1Ver = _buildUuidV7At(latest);
            final action1 = _createTestDocumentEntity(
              id: 'action-1',
              ver: action1Ver,
              type: DocumentType.proposalActionDocument,
              refId: proposal1.doc.id,
              refVer: proposal1.doc.ver,
              contentData: ProposalSubmissionActionDto.draft.toJson(),
              authors: [author],
            );

            final action2Ver = _buildUuidV7At(latest);
            final action2 = _createTestDocumentEntity(
              id: 'action-2',
              ver: action2Ver,
              type: DocumentType.proposalActionDocument,
              refId: proposal2.doc.id,
              refVer: proposal2.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );

            await db.documentsV2Dao.saveAll([
              proposal1,
              proposal2,
              proposal3,
              action1,
              action2,
            ]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(3));

            final p1 = result.items.firstWhere((e) => e.proposal.id == proposal1.doc.id);
            final p2 = result.items.firstWhere((e) => e.proposal.id == proposal2.doc.id);
            final p3 = result.items.firstWhere((e) => e.proposal.id == proposal3.doc.id);

            expect(p1.actionType, ProposalSubmissionAction.draft);
            expect(p2.actionType, ProposalSubmissionAction.aFinal);
            expect(p3.actionType, isNull);
          });

          test('invalid action value results in null actionType', () async {
            final proposalVer = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [author],
            );

            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: {'action': 'invalid_action'},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal, action]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.id, proposal.doc.id);
            expect(result.items.first.actionType, isNull);
          });

          test('missing action field in content defaults to draft actionType', () async {
            final proposalVer = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [author],
            );

            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: {},
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal, action]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.id, proposal.doc.id);
            expect(result.items.first.actionType, ProposalSubmissionAction.draft);
          });

          test('proposal with final action from collaborator is not final', () async {
            final originalAuthor = _createTestAuthor(name: 'Main', role0KeySeed: 1);
            final coProposer = _createTestAuthor(name: 'Collab', role0KeySeed: 2);

            final proposalVer = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [originalAuthor],
              collaborators: [coProposer],
            );

            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [coProposer],
            );
            await db.documentsV2Dao.saveAll([proposal, action]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.id, proposal.doc.id);
            expect(result.items.first.actionType, isNull);
          });

          test('proposal with final action from author with different username final', () async {
            final originalAuthor = _createTestAuthor(name: 'Main', role0KeySeed: 1);
            final updatedOriginalAuthor = originalAuthor.copyWith(
              username: const Optional('Damian'),
            );

            final proposalVer = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: proposalVer,
              ver: proposalVer,
              authors: [originalAuthor],
            );

            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [updatedOriginalAuthor],
            );
            await db.documentsV2Dao.saveAll([proposal, action]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.id, proposal.doc.id);
            expect(result.items.first.actionType, ProposalSubmissionAction.aFinal);
          });
        });

        group('VersionIds', () {
          test('returns single version for proposal with one version', () async {
            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
            await db.documentsV2Dao.saveAll([proposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.versionIds, hasLength(1));
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
              final result = await dao.getProposalsBriefPage(request: request);

              expect(result.items, hasLength(1));
              expect(result.items.first.proposal.ver, ver3);
              expect(result.items.first.versionIds, hasLength(3));
              expect(result.items.first.versionIds, [ver1, ver2, ver3]);
            },
          );
        });

        group('CommentsCount', () {
          final author = _createTestAuthor();

          test('returns zero comments for proposal without comments', () async {
            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
            await db.documentsV2Dao.saveAll([proposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.commentsCount, 0);
          });

          test('returns correct count for proposal with comments on effective version', () async {
            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(id: proposalVer, ver: proposalVer);

            final comment1Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
            final comment1 = _createTestDocumentEntity(
              id: comment1Ver,
              ver: comment1Ver,
              type: DocumentType.commentDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
            );

            final comment2Ver = _buildUuidV7At(earliest.add(const Duration(hours: 2)));
            final comment2 = _createTestDocumentEntity(
              id: comment2Ver,
              ver: comment2Ver,
              type: DocumentType.commentDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
            );

            await db.documentsV2Dao.saveAll([proposal, comment1, comment2]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
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
                refId: proposal1.doc.id,
                refVer: proposal1.doc.ver,
              );

              final comment2Ver = _buildUuidV7At(latest.add(const Duration(hours: 1)));
              final comment2 = _createTestDocumentEntity(
                id: 'c2',
                ver: comment2Ver,
                type: DocumentType.commentDocument,
                refId: proposal2.doc.id,
                refVer: proposal2.doc.ver,
              );

              final comment3Ver = _buildUuidV7At(latest.add(const Duration(hours: 2)));
              final comment3 = _createTestDocumentEntity(
                id: 'c3',
                ver: comment3Ver,
                type: DocumentType.commentDocument,
                refId: proposal2.doc.id,
                refVer: proposal2.doc.ver,
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2, comment1, comment2, comment3]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(request: request);

              expect(result.items, hasLength(1));
              expect(result.items.first.proposal.ver, ver2);
              expect(result.items.first.commentsCount, 2);
            },
          );

          test('counts comments for final action version when specified', () async {
            final ver1 = _buildUuidV7At(earliest);
            final ver2 = _buildUuidV7At(middle);
            final ver3 = _buildUuidV7At(latest);

            final proposal1 = _createTestDocumentEntity(id: ver1, ver: ver1, authors: [author]);
            final proposal2 = _createTestDocumentEntity(id: ver1, ver: ver2, authors: [author]);
            final proposal3 = _createTestDocumentEntity(id: ver1, ver: ver3, authors: [author]);

            final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal2.doc.id,
              refVer: proposal2.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );

            final comment1Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
            final comment1 = _createTestDocumentEntity(
              id: 'c1',
              ver: comment1Ver,
              type: DocumentType.commentDocument,
              refId: proposal1.doc.id,
              refVer: proposal1.doc.ver,
            );

            final comment2Ver = _buildUuidV7At(middle.add(const Duration(hours: 1)));
            final comment2 = _createTestDocumentEntity(
              id: 'c2',
              ver: comment2Ver,
              type: DocumentType.commentDocument,
              refId: proposal2.doc.id,
              refVer: proposal2.doc.ver,
            );

            final comment3Ver = _buildUuidV7At(latest.add(const Duration(hours: 2)));
            final comment3 = _createTestDocumentEntity(
              id: 'c3',
              ver: comment3Ver,
              type: DocumentType.commentDocument,
              refId: proposal3.doc.id,
              refVer: proposal3.doc.ver,
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
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.ver, proposal2.doc.ver);
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
              refId: proposal1.doc.id,
              refVer: proposal1.doc.ver,
            );

            final comment2Ver = _buildUuidV7At(earliest.add(const Duration(hours: 2)));
            final comment2 = _createTestDocumentEntity(
              id: 'c2',
              ver: comment2Ver,
              type: DocumentType.commentDocument,
              refId: proposal2.doc.id,
              refVer: proposal2.doc.ver,
            );

            final comment3Ver = _buildUuidV7At(earliest.add(const Duration(hours: 3)));
            final comment3 = _createTestDocumentEntity(
              id: 'c3',
              ver: comment3Ver,
              type: DocumentType.commentDocument,
              refId: proposal2.doc.id,
              refVer: proposal2.doc.ver,
            );

            await db.documentsV2Dao.saveAll([
              proposal1,
              proposal2,
              comment1,
              comment2,
              comment3,
            ]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(2));

            final p1 = result.items.firstWhere((e) => e.proposal.id == proposal1.doc.id);
            final p2 = result.items.firstWhere((e) => e.proposal.id == proposal2.doc.id);

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
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
            );

            final otherDocVer = _buildUuidV7At(earliest.add(const Duration(hours: 2)));
            final otherDoc = _createTestDocumentEntity(
              id: 'other1',
              ver: otherDocVer,
              type: DocumentType.reviewDocument,
              refId: proposal.doc.id,
              refVer: proposal.doc.ver,
            );

            await db.documentsV2Dao.saveAll([proposal, comment, otherDoc]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.commentsCount, 1);
          });
        });

        group('IsFavorite', () {
          test('returns false when no local metadata exists', () async {
            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
            await db.documentsV2Dao.saveAll([proposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
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
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
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
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
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
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
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
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(3));

            final p1 = result.items.firstWhere((e) => e.proposal.id == 'p1');
            final p2 = result.items.firstWhere((e) => e.proposal.id == 'p2');
            final p3 = result.items.firstWhere((e) => e.proposal.id == 'p3');

            expect(p1.isFavorite, true);
            expect(p2.isFavorite, false);
            expect(p3.isFavorite, false);
          });

          test('isFavorite matches on id regardless of version', () async {
            final author = _createTestAuthor();

            final ver1 = _buildUuidV7At(earliest);
            final ver2 = _buildUuidV7At(middle);
            final ver3 = _buildUuidV7At(latest);

            final proposal1 = _createTestDocumentEntity(id: ver1, ver: ver1, authors: [author]);
            final proposal2 = _createTestDocumentEntity(id: ver1, ver: ver2, authors: [author]);
            final proposal3 = _createTestDocumentEntity(id: ver1, ver: ver3, authors: [author]);

            final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1.doc.id,
              refVer: proposal1.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );

            await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3, action]);

            await db
                .into(db.documentsLocalMetadata)
                .insert(
                  DocumentsLocalMetadataCompanion.insert(
                    id: proposal1.doc.id,
                    isFavorite: true,
                  ),
                );

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.ver, proposal1.doc.ver);
            expect(result.items.first.isFavorite, true);
          });
        });

        group('Template', () {
          test('returns null when proposal has no template', () async {
            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(id: 'p1', ver: proposalVer);
            await db.documentsV2Dao.saveAll([proposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.template, isNull);
          });

          test('returns null when template does not exist in database', () async {
            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(
              id: 'p1',
              ver: proposalVer,
              templateId: 'template-1',
              templateVer: 'template-ver-1',
            );
            await db.documentsV2Dao.saveAll([proposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.template, isNull);
          });

          test('returns template when it exists with matching id and ver', () async {
            final templateVer = _buildUuidV7At(earliest);
            final template = _createTestDocumentEntity(
              id: 'template-1',
              ver: templateVer,
              type: DocumentType.proposalTemplate,
              contentData: {'title': 'Template Title'},
            );

            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(
              id: 'p1',
              ver: proposalVer,
              templateId: 'template-1',
              templateVer: templateVer,
            );

            await db.documentsV2Dao.saveAll([template, proposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.template, isNotNull);
            expect(result.items.first.template!.id, 'template-1');
            expect(result.items.first.template!.ver, templateVer);
            expect(result.items.first.template!.type, DocumentType.proposalTemplate);
            expect(result.items.first.template!.content.data['title'], 'Template Title');
          });

          test('returns null when template id matches but ver does not', () async {
            final templateVer1 = _buildUuidV7At(earliest);
            final template1 = _createTestDocumentEntity(
              id: 'template-1',
              ver: templateVer1,
              type: DocumentType.proposalTemplate,
            );

            final templateVer2 = _buildUuidV7At(middle);
            final template2 = _createTestDocumentEntity(
              id: 'template-1',
              ver: templateVer2,
              type: DocumentType.proposalTemplate,
            );

            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(
              id: 'p1',
              ver: proposalVer,
              templateId: 'template-1',
              templateVer: templateVer1,
            );

            await db.documentsV2Dao.saveAll([template1, template2, proposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.template, isNotNull);
            expect(result.items.first.template!.ver, templateVer1);
          });

          test('returns null when document type is not proposalTemplate', () async {
            final templateVer = _buildUuidV7At(earliest);
            final template = _createTestDocumentEntity(
              id: 'template-1',
              ver: templateVer,
              type: DocumentType.commentDocument,
            );

            final proposalVer = _buildUuidV7At(latest);
            final proposal = _createTestDocumentEntity(
              id: 'p1',
              ver: proposalVer,
              templateId: 'template-1',
              templateVer: templateVer,
            );

            await db.documentsV2Dao.saveAll([template, proposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.template, isNull);
          });

          test(
            'returns correct templates for multiple proposals with different templates',
            () async {
              final template1Ver = _buildUuidV7At(earliest);
              final template1 = _createTestDocumentEntity(
                id: 'template-1',
                ver: template1Ver,
                type: DocumentType.proposalTemplate,
                contentData: {'title': 'Template 1'},
              );

              final template2Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
              final template2 = _createTestDocumentEntity(
                id: 'template-2',
                ver: template2Ver,
                type: DocumentType.proposalTemplate,
                contentData: {'title': 'Template 2'},
              );

              final proposal1Ver = _buildUuidV7At(latest);
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: proposal1Ver,
                templateId: 'template-1',
                templateVer: template1Ver,
              );

              final proposal2Ver = _buildUuidV7At(latest);
              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: proposal2Ver,
                templateId: 'template-2',
                templateVer: template2Ver,
              );

              final proposal3Ver = _buildUuidV7At(latest);
              final proposal3 = _createTestDocumentEntity(
                id: 'p3',
                ver: proposal3Ver,
              );

              await db.documentsV2Dao.saveAll([
                template1,
                template2,
                proposal1,
                proposal2,
                proposal3,
              ]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(request: request);

              expect(result.items, hasLength(3));

              final p1 = result.items.firstWhere((e) => e.proposal.id == 'p1');
              final p2 = result.items.firstWhere((e) => e.proposal.id == 'p2');
              final p3 = result.items.firstWhere((e) => e.proposal.id == 'p3');

              expect(p1.template, isNotNull);
              expect(p1.template!.id, 'template-1');
              expect(p1.template!.content.data['title'], 'Template 1');

              expect(p2.template, isNotNull);
              expect(p2.template!.id, 'template-2');
              expect(p2.template!.content.data['title'], 'Template 2');

              expect(p3.template, isNull);
            },
          );

          test('template is associated with effective proposal version', () async {
            final author = _createTestAuthor();

            final template1Ver = _buildUuidV7At(earliest);
            final template1 = _createTestDocumentEntity(
              id: 'template-1',
              ver: template1Ver,
              type: DocumentType.proposalTemplate,
              contentData: {'title': 'Template 1'},
            );

            final template2Ver = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
            final template2 = _createTestDocumentEntity(
              id: 'template-2',
              ver: template2Ver,
              type: DocumentType.proposalTemplate,
              contentData: {'title': 'Template 2'},
            );

            final ver1 = _buildUuidV7At(middle);
            final proposal1 = _createTestDocumentEntity(
              id: ver1,
              ver: ver1,
              templateId: 'template-1',
              templateVer: template1Ver,
              authors: [author],
            );

            final ver2 = _buildUuidV7At(latest);
            final proposal2 = _createTestDocumentEntity(
              id: ver1,
              ver: ver2,
              templateId: 'template-2',
              templateVer: template2Ver,
              authors: [author],
            );

            final actionVer = _buildUuidV7At(latest.add(const Duration(hours: 1)));
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1.doc.id,
              refVer: proposal1.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );

            await db.documentsV2Dao.saveAll([
              template1,
              template2,
              proposal1,
              proposal2,
              action,
            ]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            expect(result.items, hasLength(1));
            expect(result.items.first.proposal.ver, ver1);
            expect(result.items.first.template, isNotNull);
            expect(result.items.first.template!.id, 'template-1');
            expect(result.items.first.template!.content.data['title'], 'Template 1');
          });
        });

        group('originalAuthors', () {
          test('returns author from the first version', () async {
            // Given
            final author = _createTestAuthor(name: 'original');
            final ver1 = _buildUuidV7At(earliest);
            final proposal = _createTestDocumentEntity(
              id: ver1,
              ver: ver1,
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposal]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then
            expect(result.items, hasLength(1));
            expect(result.items.first.originalAuthors, hasLength(1));
            expect(result.items.first.originalAuthors.first, author);
          });

          test('returns original author even when latest version has different author', () async {
            // Given
            final originalAuthor = _createTestAuthor(name: 'original', role0KeySeed: 1);
            final collaborator = _createTestAuthor(name: 'collab', role0KeySeed: 2);

            final ver1 = _buildUuidV7At(earliest);
            final ver2 = _buildUuidV7At(latest);

            // V1 signed by original author
            final proposalV1 = _createTestDocumentEntity(
              id: ver1,
              ver: ver1,
              authors: [originalAuthor],
            );

            // V2 signed by collaborator
            final proposalV2 = _createTestDocumentEntity(
              id: ver1,
              ver: ver2,
              authors: [collaborator],
            );

            await db.documentsV2Dao.saveAll([proposalV1, proposalV2]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then
            expect(result.items, hasLength(1));
            final item = result.items.first;

            // Should show latest version details
            expect(item.proposal.ver, ver2);
            // But original authors from V1
            expect(item.originalAuthors, hasLength(1));
            expect(item.originalAuthors.first, originalAuthor);
            expect(item.originalAuthors.first, isNot(collaborator));
          });

          test('returns empty list if origin version (id==ver) is missing', () async {
            // Given
            final author = _createTestAuthor(name: 'original');
            final id = _buildUuidV7At(earliest);
            final ver2 = _buildUuidV7At(latest);

            // Only saving V2, V1 is missing from local DB
            final proposalV2 = _createTestDocumentEntity(
              id: id,
              ver: ver2,
              authors: [author],
            );
            await db.documentsV2Dao.saveAll([proposalV2]);

            // When
            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(request: request);

            // Then
            expect(result.items, hasLength(1));
            // Since we can't join on id=ver, this should be empty
            expect(result.items.first.originalAuthors, isEmpty);
          });
        });

        group('Ordering', () {
          test('sorts alphabetically by title', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'setup': {
                    'title': {'title': 'Zebra Project'},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'setup': {
                    'title': {'title': 'Alpha Project'},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': 'Middle Project'},
                  },
                },
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Alphabetical(),
            );

            expect(result.items, hasLength(3));
            expect(
              result.items[0].proposal.content.data['setup']['title']['title'],
              'Alpha Project',
            );
            expect(
              result.items[1].proposal.content.data['setup']['title']['title'],
              'Middle Project',
            );
            expect(
              result.items[2].proposal.content.data['setup']['title']['title'],
              'Zebra Project',
            );
          });

          test('sorts alphabetically case-insensitively', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'setup': {
                    'title': {'title': 'zebra project'},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'setup': {
                    'title': {'title': 'Alpha PROJECT'},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': 'MIDDLE project'},
                  },
                },
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Alphabetical(),
            );

            expect(result.items, hasLength(3));
            expect(
              result.items[0].proposal.content.data['setup']['title']['title'],
              'Alpha PROJECT',
            );
            expect(
              result.items[1].proposal.content.data['setup']['title']['title'],
              'MIDDLE project',
            );
            expect(
              result.items[2].proposal.content.data['setup']['title']['title'],
              'zebra project',
            );
          });

          test('sorts alphabetically with missing titles at the end', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'setup': {
                    'title': {'title': 'Zebra Project'},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(middle),
                contentData: {},
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': 'Alpha Project'},
                  },
                },
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Alphabetical(),
            );

            expect(result.items, hasLength(3));
            expect(
              result.items[0].proposal.content.data['setup']['title']['title'],
              'Alpha Project',
            );
            expect(
              result.items[1].proposal.content.data['setup']['title']['title'],
              'Zebra Project',
            );
            expect(result.items[2].proposal.id, 'id-2');
          });

          test('sorts alphabetically with empty string titles at the end', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'setup': {
                    'title': {'title': 'Zebra Project'},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'setup': {
                    'title': {'title': ''},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': 'Alpha Project'},
                  },
                },
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Alphabetical(),
            );

            expect(result.items, hasLength(3));
            expect(
              result.items[0].proposal.content.data['setup']['title']['title'],
              'Alpha Project',
            );
            expect(
              result.items[1].proposal.content.data['setup']['title']['title'],
              'Zebra Project',
            );
            expect(result.items[2].proposal.id, 'id-2');
          });

          test('sorts by budget ascending', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 50000},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 10000},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 30000},
                  },
                },
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Budget(isAscending: true),
            );

            expect(result.items, hasLength(3));
            expect(
              result.items[0].proposal.content.data['summary']['budget']['requestedFunds'],
              10000,
            );
            expect(
              result.items[1].proposal.content.data['summary']['budget']['requestedFunds'],
              30000,
            );
            expect(
              result.items[2].proposal.content.data['summary']['budget']['requestedFunds'],
              50000,
            );
          });

          test('sorts by budget descending', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 50000},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 10000},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 30000},
                  },
                },
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Budget(isAscending: false),
            );

            expect(result.items, hasLength(3));
            expect(
              result.items[0].proposal.content.data['summary']['budget']['requestedFunds'],
              50000,
            );
            expect(
              result.items[1].proposal.content.data['summary']['budget']['requestedFunds'],
              30000,
            );
            expect(
              result.items[2].proposal.content.data['summary']['budget']['requestedFunds'],
              10000,
            );
          });

          test('sorts by budget ascending with missing values at the end', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 50000},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(middle),
                contentData: {},
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 10000},
                  },
                },
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Budget(isAscending: true),
            );

            expect(result.items, hasLength(3));
            expect(
              result.items[0].proposal.content.data['summary']['budget']['requestedFunds'],
              10000,
            );
            expect(
              result.items[1].proposal.content.data['summary']['budget']['requestedFunds'],
              50000,
            );
            expect(result.items[2].proposal.id, 'id-2');
          });

          test('sorts by budget descending with missing values at the end', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 50000},
                  },
                },
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(middle),
                contentData: {},
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'summary': {
                    'budget': {'requestedFunds': 10000},
                  },
                },
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Budget(isAscending: false),
            );

            expect(result.items, hasLength(3));
            expect(
              result.items[0].proposal.content.data['summary']['budget']['requestedFunds'],
              50000,
            );
            expect(
              result.items[1].proposal.content.data['summary']['budget']['requestedFunds'],
              10000,
            );
            expect(result.items[2].proposal.id, 'id-2');
          });

          test('sorts by update date ascending', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(latest),
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(earliest),
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(middle),
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const UpdateDate.asc(),
            );

            expect(result.items, hasLength(3));
            expect(result.items[0].proposal.id, 'id-2');
            expect(result.items[1].proposal.id, 'id-3');
            expect(result.items[2].proposal.id, 'id-1');
          });

          test('sorts by update date descending', () async {
            final entities = [
              _createTestDocumentEntity(
                id: 'id-1',
                ver: _buildUuidV7At(earliest),
              ),
              _createTestDocumentEntity(
                id: 'id-2',
                ver: _buildUuidV7At(latest),
              ),
              _createTestDocumentEntity(
                id: 'id-3',
                ver: _buildUuidV7At(middle),
              ),
            ];
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const UpdateDate.desc(),
            );

            expect(result.items, hasLength(3));
            expect(result.items[0].proposal.id, 'id-2');
            expect(result.items[1].proposal.id, 'id-3');
            expect(result.items[2].proposal.id, 'id-1');
          });

          test('respects pagination', () async {
            final entities = List.generate(
              5,
              (i) => _createTestDocumentEntity(
                id: 'id-$i',
                ver: _buildUuidV7At(earliest.add(Duration(hours: i))),
                contentData: {
                  'setup': {
                    'title': {'title': 'Project ${String.fromCharCode(65 + i)}'},
                  },
                },
              ),
            );
            await db.documentsV2Dao.saveAll(entities);

            const request = PageRequest(page: 1, size: 2);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Alphabetical(),
            );

            expect(result.items, hasLength(2));
            expect(result.total, 5);
            expect(result.page, 1);
            expect(
              result.items[0].proposal.content.data['setup']['title']['title'],
              'Project C',
            );
            expect(
              result.items[1].proposal.content.data['setup']['title']['title'],
              'Project D',
            );
          });

          test('works with multiple versions of same proposal', () async {
            final oldVer = _buildUuidV7At(earliest);
            final oldProposal = _createTestDocumentEntity(
              id: 'multi-id',
              ver: oldVer,
              contentData: {
                'setup': {
                  'title': {'title': 'Old Title'},
                },
                'summary': {
                  'budget': {'requestedFunds': 10000},
                },
              },
            );

            final newVer = _buildUuidV7At(latest);
            final newProposal = _createTestDocumentEntity(
              id: 'multi-id',
              ver: newVer,
              contentData: {
                'setup': {
                  'title': {'title': 'New Title'},
                },
                'summary': {
                  'budget': {'requestedFunds': 50000},
                },
              },
            );

            final otherVer = _buildUuidV7At(middle);
            final otherProposal = _createTestDocumentEntity(
              id: 'other-id',
              ver: otherVer,
              contentData: {
                'setup': {
                  'title': {'title': 'Middle Title'},
                },
                'summary': {
                  'budget': {'requestedFunds': 30000},
                },
              },
            );

            await db.documentsV2Dao.saveAll([oldProposal, newProposal, otherProposal]);

            const request = PageRequest(page: 0, size: 10);
            final resultAlphabetical = await dao.getProposalsBriefPage(
              request: request,
              order: const Alphabetical(),
            );

            expect(resultAlphabetical.items, hasLength(2));
            expect(
              resultAlphabetical.items[0].proposal.content.data['setup']['title']['title'],
              'Middle Title',
            );
            expect(
              resultAlphabetical.items[1].proposal.content.data['setup']['title']['title'],
              'New Title',
            );

            final resultBudget = await dao.getProposalsBriefPage(
              request: request,
              order: const Budget(isAscending: true),
            );

            expect(resultBudget.items, hasLength(2));
            expect(
              resultBudget.items[0].proposal.content.data['summary']['budget']['requestedFunds'],
              30000,
            );
            expect(
              resultBudget.items[1].proposal.content.data['summary']['budget']['requestedFunds'],
              50000,
            );
          });

          test('works with final action pointing to specific version', () async {
            final author = _createTestAuthor();

            final ver1 = _buildUuidV7At(earliest);
            final proposal1 = _createTestDocumentEntity(
              id: ver1,
              ver: ver1,
              contentData: {
                'setup': {
                  'title': {'title': 'Version 1'},
                },
                'summary': {
                  'budget': {'requestedFunds': 10000},
                },
              },
              authors: [author],
            );

            final ver2 = _buildUuidV7At(middle);
            final proposal2 = _createTestDocumentEntity(
              id: ver1,
              ver: ver2,
              contentData: {
                'setup': {
                  'title': {'title': 'Version 2'},
                },
                'summary': {
                  'budget': {'requestedFunds': 50000},
                },
              },
              authors: [author],
            );

            final actionVer = _buildUuidV7At(latest);
            final action = _createTestDocumentEntity(
              id: 'action-1',
              ver: actionVer,
              type: DocumentType.proposalActionDocument,
              refId: proposal1.doc.id,
              refVer: proposal1.doc.ver,
              contentData: ProposalSubmissionActionDto.aFinal.toJson(),
              authors: [author],
            );

            final otherVer = _buildUuidV7At(middle);
            final otherProposal = _createTestDocumentEntity(
              id: otherVer,
              ver: otherVer,
              contentData: {
                'setup': {
                  'title': {'title': 'Other Proposal'},
                },
                'summary': {
                  'budget': {'requestedFunds': 30000},
                },
              },
              authors: [author],
            );

            await db.documentsV2Dao.saveAll([proposal1, proposal2, action, otherProposal]);

            const request = PageRequest(page: 0, size: 10);
            final result = await dao.getProposalsBriefPage(
              request: request,
              order: const Budget(isAscending: true),
            );

            expect(result.items, hasLength(2));
            expect(result.items[0].proposal.ver, ver1);
            expect(
              result.items[0].proposal.content.data['summary']['budget']['requestedFunds'],
              10000,
            );
            expect(
              result.items[1].proposal.content.data['summary']['budget']['requestedFunds'],
              30000,
            );
          });
        });

        group('Filtering', () {
          final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
          final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
          final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

          final author = _createTestAuthor();

          group('by status', () {
            test('filters draft proposals without action documents', () async {
              final draftProposal1 = _createTestDocumentEntity(
                id: 'draft-no-action',
                ver: _buildUuidV7At(latest),
              );

              final d2Id = _buildUuidV7At(middle.add(const Duration(hours: 1)));
              final draftProposal2 = _createTestDocumentEntity(
                id: d2Id,
                ver: d2Id,
                authors: [author],
              );

              final draftActionVer = _buildUuidV7At(middle);
              final draftAction = _createTestDocumentEntity(
                id: 'action-draft',
                ver: draftActionVer,
                type: DocumentType.proposalActionDocument,
                refId: draftProposal2.doc.id,
                refVer: draftProposal2.doc.ver,
                contentData: ProposalSubmissionActionDto.draft.toJson(),
                authors: [author],
              );

              final fpId = _buildUuidV7At(earliest.add(const Duration(hours: 1)));
              final finalProposal = _createTestDocumentEntity(
                id: fpId,
                ver: fpId,
                authors: [author],
              );

              final finalActionVer = _buildUuidV7At(earliest);
              final finalAction = _createTestDocumentEntity(
                id: 'action-final',
                ver: finalActionVer,
                type: DocumentType.proposalActionDocument,
                refId: finalProposal.doc.id,
                refVer: finalProposal.doc.ver,
                contentData: ProposalSubmissionActionDto.aFinal.toJson(),
                authors: [author],
              );

              await db.documentsV2Dao.saveAll([
                draftProposal1,
                draftProposal2,
                draftAction,
                finalProposal,
                finalAction,
              ]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(status: ProposalStatusFilter.draft),
              );

              expect(result.items, hasLength(2));
              expect(result.total, 2);
              expect(
                result.items.map((e) => e.proposal.id).toSet(),
                {draftProposal1.doc.id, draftProposal2.doc.id},
              );
            });

            test('filters draft proposals', () async {
              final draftProposal = _createTestDocumentEntity(
                id: 'draft-id',
                ver: _buildUuidV7At(latest),
              );

              final finalProposalVer = _buildUuidV7At(middle);
              final finalProposal = _createTestDocumentEntity(
                id: finalProposalVer,
                ver: finalProposalVer,
                authors: [author],
              );

              final finalActionVer = _buildUuidV7At(earliest);
              final finalAction = _createTestDocumentEntity(
                id: 'action-final',
                ver: finalActionVer,
                type: DocumentType.proposalActionDocument,
                refId: finalProposal.doc.id,
                refVer: finalProposal.doc.ver,
                contentData: ProposalSubmissionActionDto.aFinal.toJson(),
                authors: [author],
              );

              await db.documentsV2Dao.saveAll([draftProposal, finalProposal, finalAction]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(status: ProposalStatusFilter.draft),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'draft-id');
            });

            test('filters final proposals', () async {
              final draftProposal = _createTestDocumentEntity(
                id: 'draft-id',
                ver: _buildUuidV7At(latest),
              );

              final finalProposalVer = _buildUuidV7At(middle);
              final finalProposal = _createTestDocumentEntity(
                id: finalProposalVer,
                ver: finalProposalVer,
                authors: [author],
              );

              final finalActionVer = _buildUuidV7At(earliest);
              final finalAction = _createTestDocumentEntity(
                id: 'action-final',
                ver: finalActionVer,
                type: DocumentType.proposalActionDocument,
                refId: finalProposal.doc.id,
                refVer: finalProposal.doc.ver,
                contentData: ProposalSubmissionActionDto.aFinal.toJson(),
                authors: [author],
              );

              await db.documentsV2Dao.saveAll([draftProposal, finalProposal, finalAction]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(status: ProposalStatusFilter.aFinal),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, finalProposal.doc.id);
            });
          });

          group('by favorite', () {
            test('filters favorite proposals', () async {
              final favoriteProposal = _createTestDocumentEntity(
                id: 'favorite-id',
                ver: _buildUuidV7At(latest),
              );

              final notFavoriteProposal = _createTestDocumentEntity(
                id: 'not-favorite-id',
                ver: _buildUuidV7At(middle),
              );

              await db.documentsV2Dao.saveAll([favoriteProposal, notFavoriteProposal]);

              await dao.updateProposalFavorite(id: 'favorite-id', isFavorite: true);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(isFavorite: true),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'favorite-id');
              expect(result.items[0].isFavorite, true);
            });

            test('filters non-favorite proposals', () async {
              final favoriteProposal = _createTestDocumentEntity(
                id: 'favorite-id',
                ver: _buildUuidV7At(latest),
              );

              final notFavoriteProposal = _createTestDocumentEntity(
                id: 'not-favorite-id',
                ver: _buildUuidV7At(middle),
              );

              await db.documentsV2Dao.saveAll([favoriteProposal, notFavoriteProposal]);

              await dao.updateProposalFavorite(id: 'favorite-id', isFavorite: true);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(isFavorite: false),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'not-favorite-id');
              expect(result.items[0].isFavorite, false);
            });
          });

          group('by author', () {
            test('filters proposals by author CatalystId', () async {
              final author1 = _createTestAuthor(name: 'john_doe', role0KeySeed: 1);
              final author2 = _createTestAuthor(name: 'alice', role0KeySeed: 2);
              final author3 = _createTestAuthor(name: 'bob', role0KeySeed: 3);

              final p1Authors = [author1, author2];
              final p1Ver = _buildUuidV7At(latest);
              final proposal1 = _createTestDocumentEntity(
                id: p1Ver,
                ver: p1Ver,
                authors: p1Authors,
              );

              final p2Ver = _buildUuidV7At(middle);
              final proposal2 = _createTestDocumentEntity(
                id: p2Ver,
                ver: p2Ver,
                authors: [author3],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(originalAuthor: author1),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, p1Ver);
            });

            test('filters proposals by different author CatalystId', () async {
              final author1 = _createTestAuthor(name: 'john_doe', role0KeySeed: 1);
              final author2 = _createTestAuthor(name: 'alice', role0KeySeed: 2);

              final p1Ver = _buildUuidV7At(latest);
              final proposal1 = _createTestDocumentEntity(
                id: p1Ver,
                ver: p1Ver,
                authors: [author1],
              );

              final p2Ver = _buildUuidV7At(middle);
              final proposal2 = _createTestDocumentEntity(
                id: p2Ver,
                ver: p2Ver,
                authors: [author2],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(originalAuthor: author2),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, p2Ver);
            });

            test('handles author with special characters in username', () async {
              final authorWithSpecialChars = _createTestAuthor(
                /* cSpell:disable */
                name: "test'user_100%",
                /* cSpell:enable */
                role0KeySeed: 1,
              );
              final normalAuthor = _createTestAuthor(name: 'normal', role0KeySeed: 2);

              final p1Ver = _buildUuidV7At(latest);
              final proposal1 = _createTestDocumentEntity(
                id: p1Ver,
                ver: p1Ver,
                authors: [authorWithSpecialChars],
              );

              final p2Ver = _buildUuidV7At(middle);
              final proposal2 = _createTestDocumentEntity(
                id: p2Ver,
                ver: p2Ver,
                authors: [normalAuthor],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(originalAuthor: authorWithSpecialChars),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, p1Ver);
            });

            test(
              'excludes proposals where author is only a collaborator (signed later version)',
              () async {
                final originalAuthor = _createTestAuthor(name: 'Creator', role0KeySeed: 1);
                final collaborator = _createTestAuthor(name: 'Collab', role0KeySeed: 2);

                final genesisVer = _buildUuidV7At(earliest);
                final latestVer = _buildUuidV7At(latest);

                // V1: Signed by Original Author (id == ver)
                final proposalV1 = _createTestDocumentEntity(
                  id: genesisVer,
                  ver: genesisVer,
                  authors: [originalAuthor],
                );

                // V2: Signed by Collaborator (id != ver)
                final proposalV2 = _createTestDocumentEntity(
                  id: genesisVer,
                  ver: latestVer,
                  authors: [collaborator],
                );

                await db.documentsV2Dao.saveAll([proposalV1, proposalV2]);

                // When: Filtering by Collaborator
                const request = PageRequest(page: 0, size: 10);
                final result = await dao.getProposalsBriefPage(
                  request: request,
                  filters: ProposalsFiltersV2(originalAuthor: collaborator),
                );

                // Then: Should exclude the proposal
                expect(result.items, isEmpty);
                expect(result.total, 0);

                // When: Filtering by Original Author
                final resultOriginal = await dao.getProposalsBriefPage(
                  request: request,
                  filters: ProposalsFiltersV2(originalAuthor: originalAuthor),
                );

                // Then: Should include the proposal (showing latest version V2)
                expect(resultOriginal.items.length, 1);
                expect(resultOriginal.items[0].proposal.ver, latestVer);
              },
            );
          });

          group('by category', () {
            test('filters proposals by category id', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();
              final cat2 = DocumentRefFactory.signedDocumentRef();

              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                parameters: [cat1],
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                parameters: [cat2],
              );

              final proposal3 = _createTestDocumentEntity(
                id: 'p3',
                ver: _buildUuidV7At(earliest),
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(categoryId: cat1.id),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'p1');
            });
          });

          group('by search query', () {
            test('searches in authors field', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                authors: _createTestAuthors(['john-doe', 'jane-smith']),
                contentData: {
                  'setup': {
                    'title': {'title': 'Other Title'},
                    'proposer': {'applicant': 'Other Name'},
                  },
                },
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                authors: _createTestAuthors(['alice-wonder']),
                contentData: {
                  'setup': {
                    'title': {'title': 'Different Title'},
                    'proposer': {'applicant': 'Different Name'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: 'john'),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'p1');
            });

            test('searches in applicant name from JSON content', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                authors: _createTestAuthors(['other-author']),
                contentData: {
                  'setup': {
                    'title': {'title': 'Other Title'},
                    'proposer': {'applicant': 'John Doe'},
                  },
                },
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                authors: _createTestAuthors(['different-author']),
                contentData: {
                  'setup': {
                    'title': {'title': 'Different Title'},
                    'proposer': {'applicant': 'Jane Smith'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: 'John'),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'p1');
            });

            test('searches in title from JSON content', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                authors: _createTestAuthors(['other-author']),
                contentData: {
                  'setup': {
                    'title': {'title': 'Blockchain Revolution'},
                    'proposer': {'applicant': 'Other Name'},
                  },
                },
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                authors: _createTestAuthors(['different-author']),
                contentData: {
                  'setup': {
                    'title': {'title': 'Smart Contracts Study'},
                    'proposer': {'applicant': 'Different Name'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: 'Revolution'),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'p1');
            });

            test('searches case-insensitively', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': 'Blockchain Revolution'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: 'blockchain'),
              );

              expect(result.items, hasLength(1));
              expect(result.items[0].proposal.id, 'p1');
            });

            test('returns multiple matches from different fields', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                authors: _createTestAuthors(['tech-author']),
                contentData: {
                  'setup': {
                    'title': {'title': 'Other Title'},
                  },
                },
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'setup': {
                    'title': {'title': 'Tech Innovation'},
                  },
                },
              );

              final proposal3 = _createTestDocumentEntity(
                id: 'p3',
                ver: _buildUuidV7At(earliest),
                contentData: {
                  'setup': {
                    'proposer': {'applicant': 'Tech Expert'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: 'tech'),
              );

              expect(result.items, hasLength(3));
              expect(result.total, 3);
            });
          });

          group('SQL injection protection', () {
            test('escapes single quotes in search query', () async {
              final proposal = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': "Project with 'quotes'"},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: "Project with 'quotes'"),
              );

              expect(result.items, hasLength(1));
              expect(result.items[0].proposal.id, 'p1');
            });

            test('prevents SQL injection via search query', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': 'Legitimate Title'},
                  },
                },
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'setup': {
                    'title': {'title': 'Other Title'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(
                  searchQuery: "' OR '1'='1",
                ),
              );

              expect(result.items, hasLength(0));
              expect(result.total, 0);
            });

            test('escapes LIKE wildcards in search query', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': '100% Complete'},
                  },
                },
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'setup': {
                    'title': {'title': '100X Complete'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: '100%'),
              );

              expect(result.items, hasLength(1));
              expect(result.items[0].proposal.id, 'p1');
            });

            test('escapes underscores in search query', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': 'test_case'},
                  },
                },
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'setup': {
                    /* cSpell:disable */
                    'title': {'title': 'testXcase'},
                    /* cSpell:enable */
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: 'test_case'),
              );

              expect(result.items, hasLength(1));
              expect(result.items[0].proposal.id, 'p1');
            });

            test('escapes backslashes in search query', () async {
              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                contentData: {
                  'setup': {
                    'title': {'title': r'path\to\file'},
                  },
                },
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                contentData: {
                  'setup': {
                    'title': {'title': 'path/to/file'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(searchQuery: r'path\to\file'),
              );

              expect(result.items, hasLength(1));
              expect(result.items[0].proposal.id, 'p1');
            });

            test('escapes special characters in category id', () async {
              /* cSpell:disable */
              const cat1 = SignedDocumentRef(id: "cat'egory-1", ver: "cat'egory-1");
              /* cSpell:enable */
              final cat2 = DocumentRefFactory.signedDocumentRef();

              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                parameters: [cat1],
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                parameters: [cat2],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(categoryId: cat1.id),
              );

              expect(result.items, hasLength(1));
              expect(result.items[0].proposal.id, 'p1');
            });
          });

          group('by latest update', () {
            test('filters proposals created within duration', () async {
              final now = DateTime.now();
              final oneHourAgo = now.subtract(const Duration(hours: 1));
              final twoDaysAgo = now.subtract(const Duration(days: 2));

              final recentProposal = _createTestDocumentEntity(
                id: 'recent',
                ver: _buildUuidV7At(oneHourAgo),
                createdAt: oneHourAgo,
              );

              final oldProposal = _createTestDocumentEntity(
                id: 'old',
                ver: _buildUuidV7At(twoDaysAgo),
                createdAt: twoDaysAgo,
              );

              await db.documentsV2Dao.saveAll([recentProposal, oldProposal]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(latestUpdate: Duration(days: 1)),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'recent');
            });
          });

          group('combined filters', () {
            test('applies status and favorite filters together', () async {
              final draftFavorite = _createTestDocumentEntity(
                id: 'draft-fav',
                ver: _buildUuidV7At(latest),
              );

              final draftNotFavorite = _createTestDocumentEntity(
                id: 'draft-not-fav',
                ver: _buildUuidV7At(middle.add(const Duration(hours: 1))),
              );

              final finalProposalVer = _buildUuidV7At(middle);
              final finalFavorite = _createTestDocumentEntity(
                id: finalProposalVer,
                ver: finalProposalVer,
                authors: [author],
              );

              final finalActionVer = _buildUuidV7At(earliest);
              final finalAction = _createTestDocumentEntity(
                id: 'action-final',
                ver: finalActionVer,
                type: DocumentType.proposalActionDocument,
                refId: finalFavorite.doc.id,
                refVer: finalFavorite.doc.ver,
                contentData: ProposalSubmissionActionDto.aFinal.toJson(),
                authors: [author],
              );

              await db.documentsV2Dao.saveAll([
                draftFavorite,
                draftNotFavorite,
                finalFavorite,
                finalAction,
              ]);

              await dao.updateProposalFavorite(id: draftFavorite.doc.id, isFavorite: true);
              await dao.updateProposalFavorite(id: finalFavorite.doc.id, isFavorite: true);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(
                  status: ProposalStatusFilter.draft,
                  isFavorite: true,
                ),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, draftFavorite.doc.id);
            });

            test('applies author, category, and search filters together', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();
              final cat2 = DocumentRefFactory.signedDocumentRef();
              final author1 = _createTestAuthor(name: 'john', role0KeySeed: 1);
              final author2 = _createTestAuthor(name: 'jane', role0KeySeed: 2);

              final matchingVer = _buildUuidV7At(latest);
              final matchingProposal = _createTestDocumentEntity(
                id: matchingVer,
                ver: matchingVer,
                authors: [author1],
                parameters: [cat1],
                contentData: {
                  'setup': {
                    'title': {'title': 'Blockchain Project'},
                  },
                },
              );

              final wrongAuthorVer = _buildUuidV7At(middle.add(const Duration(hours: 2)));
              final wrongAuthor = _createTestDocumentEntity(
                id: wrongAuthorVer,
                ver: wrongAuthorVer,
                authors: [author2],
                parameters: [cat1],
                contentData: {
                  'setup': {
                    'title': {'title': 'Blockchain Project'},
                  },
                },
              );

              final wrongCategoryVer = _buildUuidV7At(middle.add(const Duration(hours: 1)));
              final wrongCategory = _createTestDocumentEntity(
                id: wrongCategoryVer,
                ver: wrongCategoryVer,
                authors: [author1],
                parameters: [cat2],
                contentData: {
                  'setup': {
                    'title': {'title': 'Blockchain Project'},
                  },
                },
              );

              final wrongTitleVer = _buildUuidV7At(middle);
              final wrongTitle = _createTestDocumentEntity(
                id: wrongTitleVer,
                ver: wrongTitleVer,
                authors: [author1],
                parameters: [cat1],
                contentData: {
                  'setup': {
                    'title': {'title': 'Other Project'},
                  },
                },
              );

              await db.documentsV2Dao.saveAll([
                matchingProposal,
                wrongAuthor,
                wrongCategory,
                wrongTitle,
              ]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(
                  originalAuthor: author1,
                  categoryId: cat1.id,
                  searchQuery: 'Blockchain',
                ),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, matchingVer);
            });
          });

          group('by campaign', () {
            test('filters proposals by campaign categories', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();
              final cat2 = DocumentRefFactory.signedDocumentRef();
              final cat3 = DocumentRefFactory.signedDocumentRef();

              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                parameters: [cat1],
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle.add(const Duration(hours: 1))),
                parameters: [cat2],
              );

              final proposal3 = _createTestDocumentEntity(
                id: 'p3',
                ver: _buildUuidV7At(middle),
                parameters: [cat3],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(
                  campaign: ProposalsCampaignFilters(categoriesIds: {cat1.id, cat2.id}),
                ),
              );

              expect(result.items, hasLength(2));
              expect(result.total, 2);
              expect(result.items.map((e) => e.proposal.id).toSet(), {'p1', 'p2'});
            });

            test('returns empty when campaign categories is empty', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();
              final cat2 = DocumentRefFactory.signedDocumentRef();

              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                parameters: [cat1],
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle),
                parameters: [cat2],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(
                  campaign: ProposalsCampaignFilters(categoriesIds: {}),
                ),
              );

              expect(result.items, hasLength(0));
              expect(result.total, 0);
            });

            test('combines categoryId with campaign filter when compatible', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();
              final cat2 = DocumentRefFactory.signedDocumentRef();
              final cat3 = DocumentRefFactory.signedDocumentRef();

              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                parameters: [cat1],
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle.add(const Duration(hours: 1))),
                parameters: [cat2],
              );

              final proposal3 = _createTestDocumentEntity(
                id: 'p3',
                ver: _buildUuidV7At(middle),
                parameters: [cat3],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(
                  campaign: ProposalsCampaignFilters(categoriesIds: {cat1.id, cat2.id}),
                  categoryId: cat1.id,
                ),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'p1');
              expect(result.items[0].proposal.parameters.containsId(cat1.id), isTrue);
            });

            test('returns empty when categoryId not in campaign', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();
              final cat2 = DocumentRefFactory.signedDocumentRef();
              final cat3 = DocumentRefFactory.signedDocumentRef();

              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                parameters: [cat1],
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle.add(const Duration(hours: 1))),
                parameters: [cat2],
              );

              final proposal3 = _createTestDocumentEntity(
                id: 'p3',
                ver: _buildUuidV7At(middle),
                parameters: [cat3],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(
                  campaign: ProposalsCampaignFilters(categoriesIds: {cat1.id, cat2.id}),
                  categoryId: cat3.id,
                ),
              );

              expect(result.items, hasLength(0));
              expect(result.total, 0);
            });

            test('ignores campaign filter when null', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();
              final cat2 = DocumentRefFactory.signedDocumentRef();
              final cat3 = DocumentRefFactory.signedDocumentRef();

              final proposal1 = _createTestDocumentEntity(
                id: 'p1',
                ver: _buildUuidV7At(latest),
                parameters: [cat1],
              );

              final proposal2 = _createTestDocumentEntity(
                id: 'p2',
                ver: _buildUuidV7At(middle.add(const Duration(hours: 1))),
                parameters: [cat2],
              );

              final proposal3 = _createTestDocumentEntity(
                id: 'p3',
                ver: _buildUuidV7At(middle),
                parameters: [cat3],
              );

              await db.documentsV2Dao.saveAll([proposal1, proposal2, proposal3]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(campaign: null),
              );

              expect(result.items, hasLength(3));
              expect(result.total, 3);
            });

            test('handles null category_id in database', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();
              final cat2 = DocumentRefFactory.signedDocumentRef();

              final proposalWithCategory = _createTestDocumentEntity(
                id: 'p-with-cat',
                ver: _buildUuidV7At(latest),
                parameters: [cat1],
              );

              final proposalWithoutCategory = _createTestDocumentEntity(
                id: 'p-without-cat',
                ver: _buildUuidV7At(middle),
                parameters: [],
              );

              await db.documentsV2Dao.saveAll([proposalWithCategory, proposalWithoutCategory]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(
                  campaign: ProposalsCampaignFilters(categoriesIds: {cat1.id, cat2.id}),
                ),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, 'p-with-cat');
            });

            test('handles multiple categories efficiently', () async {
              final proposals = List.generate(
                5,
                (i) => _createTestDocumentEntity(
                  id: 'p-$i',
                  ver: _buildUuidV7At(earliest.add(Duration(hours: i))),
                  parameters: [SignedDocumentRef(id: 'cat-$i', ver: 'cat-$i')],
                ),
              );

              await db.documentsV2Dao.saveAll(proposals);

              const request = PageRequest(page: 0, size: 10);
              const categoriesIds = {'cat-0', 'cat-2', 'cat-4'};
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: const ProposalsFiltersV2(
                  campaign: ProposalsCampaignFilters(categoriesIds: categoriesIds),
                ),
              );

              final parameters = result.items
                  .map((e) => e.proposal.parameters.set)
                  .flattened
                  .toSet();

              final parametersIds = parameters.map((e) => e.id).toSet();

              expect(result.items, hasLength(3));
              expect(result.total, 3);
              expect(
                parametersIds.containsAll(categoriesIds),
                isTrue,
              );
            });

            test('campaign filter respects status filter', () async {
              final cat1 = DocumentRefFactory.signedDocumentRef();

              final draftProposalVer = _buildUuidV7At(latest);
              final draftProposal = _createTestDocumentEntity(
                id: draftProposalVer,
                ver: draftProposalVer,
                parameters: [cat1],
              );

              final finalProposalVer = _buildUuidV7At(middle);
              final finalProposal = _createTestDocumentEntity(
                id: finalProposalVer,
                ver: finalProposalVer,
                parameters: [cat1],
                authors: [author],
              );

              final finalActionVer = _buildUuidV7At(earliest);
              final finalAction = _createTestDocumentEntity(
                id: 'action-final',
                ver: finalActionVer,
                type: DocumentType.proposalActionDocument,
                refId: finalProposal.doc.id,
                refVer: finalProposal.doc.ver,
                contentData: ProposalSubmissionActionDto.aFinal.toJson(),
                authors: [author],
              );

              await db.documentsV2Dao.saveAll([draftProposal, finalProposal, finalAction]);

              const request = PageRequest(page: 0, size: 10);
              final result = await dao.getProposalsBriefPage(
                request: request,
                filters: ProposalsFiltersV2(
                  campaign: ProposalsCampaignFilters(categoriesIds: {cat1.id}),
                  status: ProposalStatusFilter.draft,
                ),
              );

              expect(result.items, hasLength(1));
              expect(result.total, 1);
              expect(result.items[0].proposal.id, draftProposal.doc.id);
            });
          });
        });
      });

      group('getProposalsTotalTask', () {
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        final nodeId = DocumentNodeId.fromString('summary.budget.requestedFunds');

        final cat1 = DocumentRefFactory.signedDocumentRef();
        final cat2 = DocumentRefFactory.signedDocumentRef();
        final cat3 = DocumentRefFactory.signedDocumentRef();

        test('returns empty map when categories list is empty', () async {
          const filters = ProposalsTotalAskFilters();

          final result = await dao.getProposalsTotalTask(
            nodeId: nodeId,
            filters: filters,
          );

          expect(result, const ProposalsTotalAsk({}));
        });

        test('returns empty map when no final proposals exist', () async {
          final draftProposal = _createTestDocumentEntity(
            id: 'p1',
            ver: _buildUuidV7At(latest),
            parameters: [cat1],
            templateId: 'template-1',
            templateVer: 'template-1',
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
          );

          await db.documentsV2Dao.saveAll([draftProposal]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result, const ProposalsTotalAsk({}));
        });

        test('aggregates budget from single template with final proposals', () async {
          final author = _createTestAuthor();
          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');

          final proposal1Ver = _buildUuidV7At(middle);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(middle.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 25000},
              },
            },
            authors: [author],
          );

          final finalAction1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal1.doc.id,
            refVer: proposal1.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          final finalAction2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, finalAction1, finalAction2]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          final templateResult = result.data[templateRef];

          expect(result.data, hasLength(1));
          expect(templateResult, isNotNull);
          expect(templateResult!.totalAsk, 35000);
          expect(templateResult.finalProposalsCount, 2);
        });

        test('groups by different template versions separately', () async {
          final author = _createTestAuthor();
          const templateRef1 = SignedDocumentRef(id: 'template-1', ver: 'template-1-v1');
          const templateRef2 = SignedDocumentRef(id: 'template-1', ver: 'template-1-v2');

          final proposal1Ver = _buildUuidV7At(middle);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            parameters: [cat1],
            templateId: templateRef1.id,
            templateVer: templateRef1.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(middle.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            parameters: [cat1],
            templateId: templateRef2.id,
            templateVer: templateRef2.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 20000},
              },
            },
            authors: [author],
          );

          final finalAction1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal1.doc.id,
            refVer: proposal1.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          final finalAction2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, finalAction1, finalAction2]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result.data, hasLength(2));
          expect(result.data[templateRef1]!.totalAsk, 10000);
          expect(result.data[templateRef1]!.finalProposalsCount, 1);
          expect(result.data[templateRef2]!.totalAsk, 20000);
          expect(result.data[templateRef2]!.finalProposalsCount, 1);
        });

        test('groups by different templates separately', () async {
          final author = _createTestAuthor();
          const templateRef1 = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');
          const templateRef2 = SignedDocumentRef(id: 'template-2', ver: 'template-2-ver');

          final proposal1Ver = _buildUuidV7At(middle);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            parameters: [cat1],
            templateId: templateRef1.id,
            templateVer: templateRef1.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(middle.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            parameters: [cat1],
            templateId: templateRef2.id,
            templateVer: templateRef2.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 30000},
              },
            },
            authors: [author],
          );

          final finalAction1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal1.doc.id,
            refVer: proposal1.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          final finalAction2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, finalAction1, finalAction2]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result.data, hasLength(2));
          expect(result.data[templateRef1]!.totalAsk, 10000);
          expect(result.data[templateRef1]!.finalProposalsCount, 1);
          expect(result.data[templateRef2]!.totalAsk, 30000);
          expect(result.data[templateRef2]!.finalProposalsCount, 1);
        });

        test('treats non-integer budget values as 0', () async {
          final author = _createTestAuthor();
          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');

          final proposal1Ver = _buildUuidV7At(middle);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 'not-a-number'},
              },
            },
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(middle.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 15000},
              },
            },
            authors: [author],
          );

          final finalAction1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal1.doc.id,
            refVer: proposal1.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          final finalAction2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, finalAction1, finalAction2]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result.data[templateRef]!.totalAsk, 15000);
          expect(result.data[templateRef]!.finalProposalsCount, 2);
        });

        test('respects category filter', () async {
          final author = _createTestAuthor();
          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');

          final proposal1Ver = _buildUuidV7At(middle);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(middle.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            parameters: [cat2],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 30000},
              },
            },
            authors: [author],
          );

          final finalAction1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal1.doc.id,
            refVer: proposal1.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          final finalAction2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, finalAction1, finalAction2]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result.data, hasLength(1));
          expect(result.data[templateRef]!.totalAsk, 10000);
          expect(result.data[templateRef]!.finalProposalsCount, 1);
        });

        test('handles multiple categories in filter', () async {
          final author = _createTestAuthor();
          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');

          final proposal1Ver = _buildUuidV7At(middle);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(middle.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            parameters: [cat2],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 20000},
              },
            },
            authors: [author],
          );

          final proposal3Ver = _buildUuidV7At(middle.add(const Duration(hours: 6)));
          final proposal3 = _createTestDocumentEntity(
            id: proposal3Ver,
            ver: proposal3Ver,
            parameters: [cat3],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 30000},
              },
            },
            authors: [author],
          );

          final finalAction1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal1.doc.id,
            refVer: proposal1.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          final finalAction2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          final finalAction3 = _createTestDocumentEntity(
            id: 'action-3',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal3.doc.id,
            refVer: proposal3.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([
            proposal1,
            proposal2,
            proposal3,
            finalAction1,
            finalAction2,
            finalAction3,
          ]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id, cat2.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result.data, hasLength(1));
          expect(result.data[templateRef]!.totalAsk, 30000);
          expect(result.data[templateRef]!.finalProposalsCount, 2);
        });

        test('uses correct version when final action points to specific version', () async {
          final author = _createTestAuthor();
          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');

          final pId = _buildUuidV7At(earliest);
          final proposalV1 = _createTestDocumentEntity(
            id: pId,
            ver: pId,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final proposalV2 = _createTestDocumentEntity(
            id: pId,
            ver: _buildUuidV7At(middle),
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 25000},
              },
            },
            authors: [author],
          );

          final proposalV3 = _createTestDocumentEntity(
            id: pId,
            ver: _buildUuidV7At(latest),
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 50000},
              },
            },
            authors: [author],
          );

          final finalAction = _createTestDocumentEntity(
            id: 'action-final',
            ver: _buildUuidV7At(latest.add(const Duration(hours: 1))),
            type: DocumentType.proposalActionDocument,
            refId: proposalV2.doc.id,
            refVer: proposalV2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposalV1, proposalV2, proposalV3, finalAction]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result.data[templateRef]!.totalAsk, 25000);
          expect(result.data[templateRef]!.finalProposalsCount, 1);
        });

        test('excludes final actions without valid ref_ver', () async {
          final author = _createTestAuthor();
          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');

          final p1Id = _buildUuidV7At(earliest);
          final proposalV1 = _createTestDocumentEntity(
            id: p1Id,
            ver: p1Id,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final proposalV2 = _createTestDocumentEntity(
            id: p1Id,
            ver: _buildUuidV7At(latest),
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 30000},
              },
            },
            authors: [author],
          );

          final finalActionWithoutRefVer = _createTestDocumentEntity(
            id: 'action-final',
            ver: _buildUuidV7At(latest.add(const Duration(hours: 1))),
            type: DocumentType.proposalActionDocument,
            refId: p1Id,
            refVer: null,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposalV1, proposalV2, finalActionWithoutRefVer]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result, const ProposalsTotalAsk({}));
        });

        test('extracts value from custom nodeId path', () async {
          final author = _createTestAuthor();
          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');
          final customNodeId = DocumentNodeId.fromString('custom.path.value');

          final proposal1Ver = _buildUuidV7At(middle);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'custom': {
                'path': {'value': 5000},
              },
            },
            authors: [author],
          );

          final proposal2Ver = _buildUuidV7At(middle.add(const Duration(hours: 4)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'custom': {
                'path': {'value': 7500},
              },
            },
            authors: [author],
          );

          final finalAction1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal1.doc.id,
            refVer: proposal1.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          final finalAction2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, proposal2, finalAction1, finalAction2]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: customNodeId,
          );

          expect(result.data[templateRef]!.totalAsk, 12500);
          expect(result.data[templateRef]!.finalProposalsCount, 2);
        });

        test('final action not from author do not include proposal', () async {
          final author = _createTestAuthor(name: 'Main', role0KeySeed: 1);
          final collab = _createTestAuthor(name: 'Collab', role0KeySeed: 2);

          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1-ver');

          final p1Id = _buildUuidV7At(earliest);
          final proposalV1 = _createTestDocumentEntity(
            id: p1Id,
            ver: p1Id,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final proposalV2 = _createTestDocumentEntity(
            id: p1Id,
            ver: _buildUuidV7At(latest),
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 30000},
              },
            },
            authors: [author],
          );

          final finalActionWithoutRefVer = _createTestDocumentEntity(
            id: 'action-final',
            ver: _buildUuidV7At(latest.add(const Duration(hours: 1))),
            type: DocumentType.proposalActionDocument,
            refId: proposalV2.doc.id,
            refVer: proposalV2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [collab],
          );

          await db.documentsV2Dao.saveAll([proposalV1, proposalV2, finalActionWithoutRefVer]);

          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final result = await dao.getProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          expect(result, const ProposalsTotalAsk({}));
        });
      });

      group('watchProposalTemplatesTotalTask', () {
        // ignore: unused_local_variable
        final earliest = DateTime.utc(2025, 2, 5, 5, 23, 27);
        final middle = DateTime.utc(2025, 2, 5, 5, 25, 33);
        final latest = DateTime.utc(2025, 8, 11, 11, 20, 18);

        final nodeId = DocumentNodeId.fromString('summary.budget.requestedFunds');

        final cat1 = DocumentRefFactory.signedDocumentRef();

        test('returns empty map when categories list is empty', () async {
          const filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: []),
          );

          final stream = dao.watchProposalsTotalTask(
            filters: filters,
            nodeId: nodeId,
          );

          await expectLater(
            stream,
            emits(const ProposalsTotalAsk({})),
          );
        });

        test('stream emits updated values when data changes', () async {
          final author = _createTestAuthor();
          const templateRef = SignedDocumentRef(id: 'template-1', ver: 'template-1');

          final proposal1Ver = _buildUuidV7At(middle);
          final proposal1 = _createTestDocumentEntity(
            id: proposal1Ver,
            ver: proposal1Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 10000},
              },
            },
            authors: [author],
          );

          final finalAction1 = _createTestDocumentEntity(
            id: 'action-1',
            ver: _buildUuidV7At(latest),
            type: DocumentType.proposalActionDocument,
            refId: proposal1.doc.id,
            refVer: proposal1.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal1, finalAction1]);

          final emissions = <Map<DocumentRef, ProposalsTotalAskPerTemplate>>[];
          final filters = ProposalsTotalAskFilters(
            campaign: CampaignFilters(categoriesIds: [cat1.id]),
          );

          final subscription = dao
              .watchProposalsTotalTask(filters: filters, nodeId: nodeId)
              .listen((event) => emissions.add(event.data));

          await pumpEventQueue();
          await pumpEventQueue();
          expect(emissions, hasLength(1));
          expect(emissions[0][templateRef]!.totalAsk, 10000);

          final proposal2Ver = _buildUuidV7At(middle.add(const Duration(hours: 1)));
          final proposal2 = _createTestDocumentEntity(
            id: proposal2Ver,
            ver: proposal2Ver,
            parameters: [cat1],
            templateId: templateRef.id,
            templateVer: templateRef.ver,
            contentData: {
              'summary': {
                'budget': {'requestedFunds': 20000},
              },
            },
            authors: [author],
          );

          final finalAction2 = _createTestDocumentEntity(
            id: 'action-2',
            ver: _buildUuidV7At(latest.add(const Duration(hours: 1))),
            type: DocumentType.proposalActionDocument,
            refId: proposal2.doc.id,
            refVer: proposal2.doc.ver,
            contentData: ProposalSubmissionActionDto.aFinal.toJson(),
            authors: [author],
          );

          await db.documentsV2Dao.saveAll([proposal2, finalAction2]);
          await pumpEventQueue();

          expect(emissions, hasLength(2));
          expect(emissions[1][templateRef]!.totalAsk, 30000);

          await subscription.cancel();
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
  final buffer = StringBuffer('id.catalyst://');
  final role0Key = Uint8List.fromList(List.filled(32, role0KeySeed));

  if (name != null) {
    buffer
      ..write(name)
      ..write('@');
  }

  buffer
    ..write('preprod.cardano/')
    ..write(base64UrlNoPadEncode(role0Key));

  return CatalystId.parse(buffer.toString());
}

List<CatalystId> _createTestAuthors(
  List<String> names, {
  // ignore: unused_element_parameter
  int Function(String) role0KeySeed = _seedRole0KeySeedGetter,
}) {
  return names
      .map((e) => _createTestAuthor(name: e, role0KeySeed: _seedRole0KeySeedGetter(e)))
      .toList();
}

DocumentCompositeEntity _createTestDocumentEntity({
  String? id,
  String? ver,
  Map<String, dynamic> contentData = const {},
  DocumentType type = DocumentType.proposalDocument,
  DateTime? createdAt,
  List<CatalystId>? authors,
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
    createdAt: createdAt,
    authors: authors,
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

int _seedRole0KeySeedGetter(String name) => 0;

extension on ProposalSubmissionActionDto {
  Map<String, dynamic> toJson() {
    return ProposalSubmissionActionDocumentDto(action: this).toJson();
  }
}
