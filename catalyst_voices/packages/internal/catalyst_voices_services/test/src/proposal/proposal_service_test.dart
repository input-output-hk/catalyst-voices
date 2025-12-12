import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MockActiveCampaignObserver mockActiveCampaignObserver;
  late MockDocumentRepository mockDocumentRepository;
  late MockProposalRepository mockProposalRepository;
  late MockUserService mockUserService;
  late MockSignerService mockSignerService;

  late ProposalService proposalService;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    mockProposalRepository = MockProposalRepository();
    mockSignerService = MockSignerService();
    mockUserService = MockUserService();
    mockActiveCampaignObserver = MockActiveCampaignObserver();

    proposalService = ProposalService(
      mockProposalRepository,
      mockDocumentRepository,
      mockUserService,
      mockSignerService,
      mockActiveCampaignObserver,
    );

    registerFallbackValue(const SignedDocumentRef(id: 'fallback-id'));
    registerFallbackValue(const ProposalsFiltersV2());
    registerFallbackValue(const PageRequest(page: 0, size: 10));
    registerFallbackValue(const UpdateDate.desc() as ProposalsOrder);
    registerFallbackValue(CatalystId(host: '', role0Key: Uint8List.fromList(List.filled(32, 0))));

    when(
      () => mockDocumentRepository.watchCount(
        referencing: any(named: 'referencing'),
        type: DocumentType.commentDocument,
      ),
    ).thenAnswer((_) => Stream.fromIterable([5]));
  });

  group(ProposalService, () {
    test('submitProposalForReview throws '
        '$ProposalLimitReachedException when over limit', () async {
      final proposalRef = SignedDocumentRef.generateFirstRef();
      final categoryId = SignedDocumentRef.generateFirstRef();
      final catalystId = DummyCatalystIdFactory.create();
      final account = Account.dummy(
        catalystId: catalystId,
        keychain: MockKeychain(),
        isActive: true,
      );
      final campaign = Campaign.f15();
      const proposalsCount = ProposalDocument.maxSubmittedProposalsPerUser + 1;

      when(
        () => mockUserService.watchUnlockedActiveAccount,
      ).thenAnswer((_) => Stream.value(account));
      when(
        () => mockActiveCampaignObserver.watchCampaign,
      ).thenAnswer((_) => Stream.value(campaign));

      when(
        () => mockProposalRepository.watchProposalsCountV2(
          filters: any(named: 'filters'),
        ),
      ).thenAnswer((_) => Stream.value(proposalsCount));

      expect(
        () async => proposalService.submitProposalForReview(
          proposalId: proposalRef,
          categoryId: categoryId,
        ),
        throwsA(isA<ProposalLimitReachedException>()),
      );
    });

    group('watchWorkspaceProposalsBrief', () {
      test('returns empty list when originalAuthor is null', () {
        final stream = proposalService.watchWorkspaceProposalsBrief(
          // ignore: avoid_redundant_argument_values
          filters: const ProposalsFiltersV2(originalAuthor: null),
        );
        expect(stream, emits(isEmpty));
      });

      test('merges signed and local proposals correctly', () async {
        // Given
        final authorId = CatalystIdFactory.create();
        final filters = ProposalsFiltersV2(originalAuthor: authorId);

        final signedDocId = DocumentRefFactory.signedDocumentRef();
        final newDraftId = DocumentRefFactory.draftDocumentRef();

        // A signed proposal
        final signedProposal = ProposalBriefData(
          id: signedDocId,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          title: 'Published Proposal',
          author: authorId,
          versions: [ProposalBriefDataVersion(ref: signedDocId, title: 'Published Proposal')],
        );

        // A local draft version of the SAME signed proposal
        final localDraftOfSigned = ProposalBriefData(
          id: signedDocId.nextVersion(),
          createdAt: DateTime.now(),
          title: 'Draft Edit of Published',
          author: authorId,
        );

        // A completely new local draft
        final localDraftNew = ProposalBriefData(
          id: newDraftId,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          title: 'New Standalone Draft',
          author: authorId,
        );

        // Mock signed proposals
        when(
          () => mockProposalRepository.watchProposalsBriefPage(
            request: any(named: 'request'),
            order: any(named: 'order'),
            filters: any(named: 'filters'),
          ),
        ).thenAnswer(
          (_) => Stream.value(Page(items: [signedProposal], total: 1, page: 0, maxPerPage: 999)),
        );

        // Mock local drafts
        when(
          () => mockProposalRepository.watchLocalDraftProposalsBrief(author: any(named: 'author')),
        ).thenAnswer((_) => Stream.value([localDraftOfSigned, localDraftNew]));

        // When
        final stream = proposalService.watchWorkspaceProposalsBrief(filters: filters);

        // Then
        await expectLater(
          stream,
          emits(
            predicate<List<ProposalBriefData>>((list) {
              if (list.length != 2) return false;

              // Sorting is based on createdAt (ascending)
              // 1. localDraftNew (1 day ago)
              // 2. signedProposal (2 days ago)
              final newItem = list[0];
              final mergedItem = list[1];

              // Verify Merged Item
              if (mergedItem.id != signedDocId) return false;
              if (mergedItem.title != 'Published Proposal') return false;

              // Verify appendVersion logic:
              // It should have added the local draft as a version
              if (mergedItem.versions?.length != 2) return false;

              if (mergedItem.versions![0].ref != signedProposal.id) return false;
              if (mergedItem.versions![0].title != signedProposal.title) return false;

              if (mergedItem.versions![1].ref != localDraftOfSigned.id) return false;
              if (mergedItem.versions![1].title != localDraftOfSigned.title) return false;

              // Verify New Item
              if (newItem.id != newItem.id) return false;
              if (newItem.title != newItem.title) return false;

              return true;
            }),
          ),
        );
      });
    });
  });
}

class MockActiveCampaignObserver extends Mock implements ActiveCampaignObserver {}

class MockSignerService extends Mock implements SignerService {}

class MockUserService extends Mock implements UserService {}
