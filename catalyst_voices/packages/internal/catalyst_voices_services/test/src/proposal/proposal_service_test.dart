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
  late MockSyncManager mockSyncManager;

  late ProposalService proposalService;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    mockProposalRepository = MockProposalRepository();
    mockSignerService = MockSignerService();
    mockUserService = MockUserService();
    mockActiveCampaignObserver = MockActiveCampaignObserver();
    mockSyncManager = MockSyncManager();

    proposalService = ProposalService(
      mockProposalRepository,
      mockDocumentRepository,
      mockUserService,
      mockSignerService,
      mockActiveCampaignObserver,
      mockSyncManager,
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
          filters: const ProposalsFiltersV2(relationships: {}),
        );
        expect(stream, emits(isEmpty));
      });

      test('watchProposalsCountV2 matches watchWorkspaceProposalsBrief length', () async {
        // Given
        final authorId = CatalystIdFactory.create();
        final filters = ProposalsFiltersV2(relationships: {OriginalAuthor(authorId)});

        final signedDocId = DocumentRefFactory.signedDocumentRef();
        final newDraftId = DocumentRefFactory.draftDocumentRef();

        // A signed proposal
        final signedProposal = ProposalBriefData(
          id: signedDocId,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          title: 'Published Proposal',
          author: authorId,
          versions: [
            ProposalBriefDataVersion(
              ref: signedDocId,
              title: 'Published Proposal',
              versionNumber: 1,
            ),
          ],
        );

        // A completely new local draft
        final localDraftNew = ProposalBriefData(
          id: newDraftId,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          title: 'New Standalone Draft',
          author: authorId,
        );

        // Mock signed proposals page
        when(
          () => mockProposalRepository.watchProposalsBriefPage(
            request: any(named: 'request'),
            order: any(named: 'order'),
            filters: any(named: 'filters'),
          ),
        ).thenAnswer(
          (_) => Stream.value(Page(items: [signedProposal], total: 1, page: 0, maxPerPage: 999)),
        );

        // Mock local drafts list
        when(
          () => mockProposalRepository.watchLocalDraftProposalsBrief(author: any(named: 'author')),
        ).thenAnswer((_) => Stream.value([localDraftNew]));

        // Mock published count
        when(
          () => mockProposalRepository.watchProposalsCountV2(filters: any(named: 'filters')),
        ).thenAnswer((_) => Stream.value(1)); // 1 published proposal

        // Mock local drafts count
        when(
          () => mockProposalRepository.watchLocalDraftProposalsCount(author: any(named: 'author')),
        ).thenAnswer((_) => Stream.value(1)); // 1 local draft

        // When
        final briefsStream = proposalService.watchWorkspaceProposalsBrief(filters: filters);
        final countStream = proposalService.watchProposalsCountV2(
          filters: filters,
          includeLocalDrafts: true,
        );

        // Then - verify count matches list length
        final briefs = await briefsStream.first;
        final count = await countStream.first;

        expect(count, equals(briefs.length)); // Should both be 2 (1 published + 1 local draft)
        expect(count, equals(2));
        expect(briefs, hasLength(2));
      });

      test('merges signed and local proposals correctly', () async {
        // Given
        final authorId = CatalystIdFactory.create();
        final filters = ProposalsFiltersV2(relationships: {OriginalAuthor(authorId)});

        final signedDocId = DocumentRefFactory.signedDocumentRef();
        final newDraftId = DocumentRefFactory.draftDocumentRef();

        // A signed proposal
        final signedProposal = ProposalBriefData(
          id: signedDocId,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          title: 'Published Proposal',
          author: authorId,
          versions: [
            ProposalBriefDataVersion(
              ref: signedDocId,
              title: 'Published Proposal',
              versionNumber: 1,
            ),
          ],
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

    group('watchProposal', () {
      test('returns only public proposal when originalAuthor is null', () async {
        // Given: No originalAuthor provided
        final proposalId = SignedDocumentRef.generateFirstRef();
        final publicProposal = ProposalDataV2(
          id: proposalId,
          proposalOrDocument: ProposalOrDocument.data(
            DocumentData(
              metadata: DocumentDataMetadata.proposal(
                id: proposalId,
                template: SignedDocumentRef.generateFirstRef(),
                parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
                authors: [CatalystIdFactory.create()],
              ),
              content: const DocumentDataContent({'title': 'Public Proposal'}),
            ),
          ),
          submissionAction: ProposalSubmissionAction.draft,
          isFavorite: false,
          categoryName: 'Category',
          versions: [proposalId],
        );

        // Mock public proposal
        when(
          () => mockProposalRepository.watchProposal(id: proposalId),
        ).thenAnswer((_) => Stream.value(publicProposal));

        // When: No originalAuthor provided
        final stream = proposalService.watchProposal(id: proposalId);

        // Then: Should emit only public proposal
        await expectLater(
          stream,
          emits(
            predicate<ProposalDataV2?>((p) {
              return p?.id == proposalId && p?.versions?.length == 1;
            }),
          ),
        );

        // Verify watchLocalProposal was not called
        verifyNever(
          () => mockProposalRepository.watchLocalProposal(
            id: any<DocumentRef>(named: 'id'),
            originalAuthor: any<CatalystId>(named: 'originalAuthor'),
          ),
        );
      });

      test('returns local proposal when id matches localProposal.id', () async {
        // Given: Local proposal with matching id
        final proposalId = DraftRef.generateFirstRef();
        final authorId = CatalystIdFactory.create();

        final localProposal = ProposalDataV2(
          id: proposalId,
          proposalOrDocument: ProposalOrDocument.data(
            DocumentData(
              metadata: DocumentDataMetadata.proposal(
                id: proposalId,
                template: SignedDocumentRef.generateFirstRef(),
                parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
                authors: [authorId],
              ),
              content: const DocumentDataContent({'title': 'Local Draft'}),
            ),
          ),
          submissionAction: null,
          isFavorite: false,
          categoryName: 'Category',
          versions: [proposalId],
        );

        // Mock local proposal
        when(
          () => mockProposalRepository.watchLocalProposal(
            id: proposalId,
            originalAuthor: authorId,
          ),
        ).thenAnswer((_) => Stream.value(localProposal));

        // Mock public proposal (should be ignored)
        when(
          () => mockProposalRepository.watchProposal(id: proposalId),
        ).thenAnswer((_) => Stream.value(null));

        // When: originalAuthor provided and id matches
        final stream = proposalService.watchProposal(
          id: proposalId,
          activeAccount: authorId,
        );

        // Then: Should emit local proposal
        await expectLater(
          stream,
          emits(
            predicate<ProposalDataV2?>((p) {
              return p?.id == proposalId && p == localProposal;
            }),
          ),
        );
      });

      test('merges public and local versions when local has extra versions', () async {
        // Given: Public proposal with 2 versions, local proposal only tracks the document ID
        final proposalId = SignedDocumentRef.generateFirstRef();
        final authorId = CatalystIdFactory.create();
        final version1 = proposalId;
        final version2 = proposalId.nextVersion();
        final localDraftVersion = DraftRef.generateNextRefFor(proposalId.id);

        // Public proposal with 2 public versions
        final publicProposal = ProposalDataV2(
          id: version2,
          proposalOrDocument: ProposalOrDocument.data(
            DocumentData(
              metadata: DocumentDataMetadata.proposal(
                id: version2,
                template: SignedDocumentRef.generateFirstRef(),
                parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
                authors: [authorId],
              ),
              content: const DocumentDataContent({'title': 'Public Proposal'}),
            ),
          ),
          submissionAction: ProposalSubmissionAction.draft,
          isFavorite: false,
          categoryName: 'Category',
          versions: [version1, version2],
        );

        // Local proposal: user is working on a draft edit, so it tracks all versions including the draft
        final localProposal = ProposalDataV2(
          id: version2,
          // User is viewing version2, but has a local draft
          proposalOrDocument: ProposalOrDocument.data(
            DocumentData(
              metadata: DocumentDataMetadata.proposal(
                id: version2,
                template: SignedDocumentRef.generateFirstRef(),
                parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
                authors: [authorId],
              ),
              content: const DocumentDataContent({'title': 'Local Draft'}),
            ),
          ),
          submissionAction: null,
          isFavorite: false,
          categoryName: 'Category',
          versions: [version1, version2, localDraftVersion],
        );

        // Mock repositories
        when(
          () => mockProposalRepository.watchLocalProposal(
            id: version2,
            originalAuthor: authorId,
          ),
        ).thenAnswer((_) => Stream.value(localProposal));

        when(
          () => mockProposalRepository.watchProposal(id: version2),
        ).thenAnswer((_) => Stream.value(publicProposal));

        // When: Query for public version2
        final stream = proposalService.watchProposal(
          id: version2,
          activeAccount: authorId,
        );

        // Then: Should merge versions from local into public
        await expectLater(
          stream,
          emits(
            predicate<ProposalDataV2?>((p) {
              if (p == null) return false;
              // Should have all 3 versions
              if (p.versions?.length != 3) return false;
              // Should be the public proposal as base
              if (p.id != version2) return false;
              // Should contain the local draft version
              return p.versions!.any((v) => v.id == localDraftVersion.id);
            }),
          ),
        );
      });

      test('returns public proposal when local has no extra versions', () async {
        // Given: Public and local proposals with same versions
        final proposalId = SignedDocumentRef.generateFirstRef();
        final authorId = CatalystIdFactory.create();
        final version1 = proposalId;
        final version2 = proposalId.nextVersion();

        final publicProposal = ProposalDataV2(
          id: version2,
          proposalOrDocument: ProposalOrDocument.data(
            DocumentData(
              metadata: DocumentDataMetadata.proposal(
                id: version2,
                template: SignedDocumentRef.generateFirstRef(),
                parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
                authors: [authorId],
              ),
              content: const DocumentDataContent({'title': 'Public Proposal'}),
            ),
          ),
          submissionAction: ProposalSubmissionAction.draft,
          isFavorite: false,
          categoryName: 'Category',
          versions: [version1, version2],
        );

        final localProposal = ProposalDataV2(
          id: version2,
          proposalOrDocument: ProposalOrDocument.data(
            DocumentData(
              metadata: DocumentDataMetadata.proposal(
                id: version2,
                template: SignedDocumentRef.generateFirstRef(),
                parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
                authors: [authorId],
              ),
              content: const DocumentDataContent({'title': 'Local Draft'}),
            ),
          ),
          submissionAction: null,
          isFavorite: false,
          categoryName: 'Category',
          versions: [version1, version2],
        );

        // Mock repositories
        when(
          () => mockProposalRepository.watchLocalProposal(
            id: version2,
            originalAuthor: authorId,
          ),
        ).thenAnswer((_) => Stream.value(localProposal));

        when(
          () => mockProposalRepository.watchProposal(id: version2),
        ).thenAnswer((_) => Stream.value(publicProposal));

        // When
        final stream = proposalService.watchProposal(
          id: version2,
          activeAccount: authorId,
        );

        // Then: Should return public proposal without modification
        await expectLater(
          stream,
          emits(
            predicate<ProposalDataV2?>((p) {
              return p?.versions?.length == 2 && p?.id == version2;
            }),
          ),
        );
      });

      test('returns null when both public and local are null', () async {
        // Given: No proposals exist
        final proposalId = SignedDocumentRef.generateFirstRef();
        final authorId = CatalystIdFactory.create();

        when(
          () => mockProposalRepository.watchLocalProposal(
            id: proposalId,
            originalAuthor: authorId,
          ),
        ).thenAnswer((_) => Stream.value(null));

        when(
          () => mockProposalRepository.watchProposal(id: proposalId),
        ).thenAnswer((_) => Stream.value(null));

        // When
        final stream = proposalService.watchProposal(
          id: proposalId,
          activeAccount: authorId,
        );

        // Then: Should emit null
        await expectLater(stream, emits(null));
      });

      test('emits updates when public proposal changes', () async {
        // Given: Initial public proposal
        final proposalId = SignedDocumentRef.generateFirstRef();
        final streamController = StreamController<ProposalDataV2?>();

        final initialProposal = ProposalDataV2(
          id: proposalId,
          proposalOrDocument: ProposalOrDocument.data(
            DocumentData(
              metadata: DocumentDataMetadata.proposal(
                id: proposalId,
                template: SignedDocumentRef.generateFirstRef(),
                parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
                authors: [CatalystIdFactory.create()],
              ),
              content: const DocumentDataContent({'title': 'Initial'}),
            ),
          ),
          submissionAction: ProposalSubmissionAction.draft,
          isFavorite: false,
          categoryName: 'Category',
          versions: [proposalId],
        );

        final updatedProposal = ProposalDataV2(
          id: proposalId,
          proposalOrDocument: ProposalOrDocument.data(
            DocumentData(
              metadata: DocumentDataMetadata.proposal(
                id: proposalId,
                template: SignedDocumentRef.generateFirstRef(),
                parameters: DocumentParameters({SignedDocumentRef.generateFirstRef()}),
                authors: [CatalystIdFactory.create()],
              ),
              content: const DocumentDataContent({'title': 'Updated'}),
            ),
          ),
          submissionAction: ProposalSubmissionAction.aFinal,
          isFavorite: true,
          categoryName: 'Category',
          versions: [proposalId],
        );

        when(
          () => mockProposalRepository.watchProposal(id: proposalId),
        ).thenAnswer((_) => streamController.stream);

        // When
        final stream = proposalService.watchProposal(id: proposalId);
        final emissions = <ProposalDataV2?>[];
        final subscription = stream.listen(emissions.add);

        // Emit initial value
        streamController.add(initialProposal);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Emit updated value
        streamController.add(updatedProposal);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Then: Should receive both emissions
        expect(emissions.length, 2);
        expect(emissions[0]?.submissionAction, ProposalSubmissionAction.draft);
        expect(emissions[1]?.submissionAction, ProposalSubmissionAction.aFinal);

        await subscription.cancel();
        await streamController.close();
      });
    });

    group('submitCollaboratorProposalAction', () {
      setUp(() {
        registerFallbackValue(ProposalSubmissionAction.aFinal);
        registerFallbackValue(FakeCatalystPrivateKey());

        when(
          () => mockSignerService.useProposerCredentials<SignedDocumentRef>(any()),
        ).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments.first as RoleCredentialsCallback<SignedDocumentRef>;
          await callback(DummyCatalystIdFactory.create(), FakeCatalystPrivateKey());
          return DocumentRefFactory.signedDocumentRef();
        });

        when(
          () => mockSignerService.useProposerCredentials<void>(any()),
        ).thenAnswer((invocation) async {
          final callback = invocation.positionalArguments.first as RoleCredentialsCallback<void>;
          await callback(DummyCatalystIdFactory.create(), FakeCatalystPrivateKey());
          return;
        });

        when(
          () => mockProposalRepository.publishProposalAction(
            actionId: any(named: 'actionId'),
            proposalId: any(named: 'proposalId'),
            action: any(named: 'action'),
            catalystId: any(named: 'catalystId'),
            privateKey: any(named: 'privateKey'),
          ),
        ).thenAnswer((_) async => {});

        when(
          () => mockProposalRepository.removeCollaboratorFromProposal(
            proposalId: any(named: 'proposalId'),
            collaboratorId: any(named: 'collaboratorId'),
            privateKey: any(named: 'privateKey'),
          ),
        ).thenAnswer((_) async => {});
      });

      test('accept invitation will submit draft proposal submission action', () async {
        // Given
        final proposalId = SignedDocumentRef.generateFirstRef();

        // When
        await proposalService.submitCollaboratorProposalAction(
          proposalId: proposalId,
          action: CollaboratorProposalAction.acceptInvitation,
        );

        // Then
        verify(
          () => mockProposalRepository.publishProposalAction(
            actionId: any(named: 'actionId'),
            proposalId: proposalId,
            action: ProposalSubmissionAction.draft,
            catalystId: any(named: 'catalystId'),
            privateKey: any(named: 'privateKey'),
          ),
        );
      });

      test('reject invitation will submit hide proposal submission action', () async {
        // Given
        final proposalId = SignedDocumentRef.generateFirstRef();

        // When
        await proposalService.submitCollaboratorProposalAction(
          proposalId: proposalId,
          action: CollaboratorProposalAction.rejectInvitation,
        );

        // Then
        verify(
          () => mockProposalRepository.publishProposalAction(
            actionId: any(named: 'actionId'),
            proposalId: proposalId,
            action: ProposalSubmissionAction.hide,
            catalystId: any(named: 'catalystId'),
            privateKey: any(named: 'privateKey'),
          ),
        );
      });

      test('leave proposal will remove collaborator', () async {
        // Given
        final proposalId = SignedDocumentRef.generateFirstRef();

        // When
        await proposalService.submitCollaboratorProposalAction(
          proposalId: proposalId,
          action: CollaboratorProposalAction.leaveProposal,
        );

        // Then
        verify(
          () => mockProposalRepository.removeCollaboratorFromProposal(
            proposalId: proposalId,
            collaboratorId: any(named: 'collaboratorId'),
            privateKey: any(named: 'privateKey'),
          ),
        );
      });

      test('accept final proposal will submit final proposal submission action', () async {
        // Given
        final proposalId = SignedDocumentRef.generateFirstRef();

        // When
        await proposalService.submitCollaboratorProposalAction(
          proposalId: proposalId,
          action: CollaboratorProposalAction.acceptFinal,
        );

        // Then
        verify(
          () => mockProposalRepository.publishProposalAction(
            actionId: any(named: 'actionId'),
            proposalId: proposalId,
            action: ProposalSubmissionAction.aFinal,
            catalystId: any(named: 'catalystId'),
            privateKey: any(named: 'privateKey'),
          ),
        );
      });

      test('reject final proposal will submit hide proposal submission action', () async {
        // Given
        final proposalId = SignedDocumentRef.generateFirstRef();

        // When
        await proposalService.submitCollaboratorProposalAction(
          proposalId: proposalId,
          action: CollaboratorProposalAction.rejectFinal,
        );

        // Then
        verify(
          () => mockProposalRepository.publishProposalAction(
            actionId: any(named: 'actionId'),
            proposalId: proposalId,
            action: ProposalSubmissionAction.hide,
            catalystId: any(named: 'catalystId'),
            privateKey: any(named: 'privateKey'),
          ),
        );
      });
    });
  });
}

class MockActiveCampaignObserver extends Mock implements ActiveCampaignObserver {}

class MockSignerService extends Mock implements SignerService {}

class MockSyncManager extends Mock implements SyncManager {}

class MockUserService extends Mock implements UserService {}
