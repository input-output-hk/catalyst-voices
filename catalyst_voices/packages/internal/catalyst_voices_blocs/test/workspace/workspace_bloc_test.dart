import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group(WorkspaceBloc, () {
    late MockCampaignService mockCampaignService;
    late MockProposalService mockProposalService;
    late MockDocumentMapper mockDocumentMapper;
    late MockDownloaderService mockDownloaderService;

    late WorkspaceBloc workspaceBloc;

    final proposalRef = SignedDocumentRef.generateFirstRef();
    final categoryRef = SignedDocumentRef.generateFirstRef();
    final authorId = CatalystId(host: 'test', role0Key: Uint8List(32));

    final documentData = DocumentData(
      metadata: DocumentDataMetadata.proposal(
        id: proposalRef,
        template: SignedDocumentRef.generateFirstRef(),
        parameters: DocumentParameters({categoryRef}),
        authors: [authorId],
      ),
      content: const DocumentDataContent({}),
    );

    setUpAll(() {
      registerFallbackValue(SignedDocumentRef.generateFirstRef());
      registerFallbackValue(documentData);
      registerFallbackValue(Uint8List(0));
      registerFallbackValue(const DraftRef(id: 'fallback'));
    });

    setUp(() async {
      mockCampaignService = MockCampaignService();
      mockProposalService = MockProposalService();
      mockDocumentMapper = MockDocumentMapper();
      mockDownloaderService = MockDownloaderService();

      workspaceBloc = WorkspaceBloc(
        mockCampaignService,
        mockProposalService,
        mockDocumentMapper,
        mockDownloaderService,
      );
    });

    tearDown(() async {
      await workspaceBloc.close();
    });
    test('initial state is correct', () {
      expect(workspaceBloc.state, const WorkspaceState());
    });

    blocTest<WorkspaceBloc, WorkspaceState>(
      'emit loading state and loaded state when watching proposals succeeds',
      setUp: () async {
        when(() => mockCampaignService.getActiveCampaign()).thenAnswer(
          (_) async => Campaign(
            id: SignedDocumentRef.generateFirstRef(),
            name: 'Catalyst Fund14',
            description: 'Description',
            allFunds: MultiCurrencyAmount.single(_adaMajorUnits(20000000)),
            fundNumber: 14,
            timeline: const CampaignTimeline(phases: []),
            publish: CampaignPublish.published,
            categories: [
              CampaignCategory(
                id: categoryRef,
                campaignRef: SignedDocumentRef.generateFirstRef(),
                categoryName: 'Test Category',
                categorySubname: 'Test Subname',
                description: 'Test description',
                shortDescription: 'Test short description',
                availableFunds: MultiCurrencyAmount.single(_adaMajorUnits(1000)),
                imageUrl: '',
                range: Range(
                  min: _adaMajorUnits(10),
                  max: _adaMajorUnits(100),
                ),
                currency: Currencies.ada,
                descriptions: const [],
                dos: const [],
                donts: const [],
                submissionCloseDate: DateTime(2024, 12, 31),
              ),
            ],
          ),
        );
      },
      build: () {
        when(() => mockProposalService.watchUserProposals()).thenAnswer(
          (_) => Stream.value(
            [ProposalWithVersionX.dummy(ProposalPublish.localDraft, categoryRef: categoryRef)],
          ),
        );
        return workspaceBloc;
      },
      act: (bloc) => bloc.add(const WatchUserProposalsEvent()),
      expect: () => [
        isA<WorkspaceState>().having((s) => s.isLoading, 'isLoading', true),
        isA<WorkspaceState>().having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<WorkspaceBloc, WorkspaceState>(
      'watch user proposals - success',
      setUp: () async {
        when(() => mockCampaignService.getActiveCampaign()).thenAnswer(
          (_) async => Campaign(
            id: SignedDocumentRef.generateFirstRef(),
            name: 'Catalyst Fund14',
            description: 'Description',
            allFunds: MultiCurrencyAmount.single(_adaMajorUnits(20000000)),
            // TODO(LynxLynxx): refactor it when _mapProposalToViewModel will be refactored
            fundNumber: 0,
            timeline: const CampaignTimeline(phases: []),
            publish: CampaignPublish.published,
            categories: [
              CampaignCategory(
                id: categoryRef,
                campaignRef: SignedDocumentRef.generateFirstRef(),
                categoryName: 'Test Category',
                categorySubname: 'Test Subname',
                description: 'Test description',
                shortDescription: 'Test short description',
                availableFunds: MultiCurrencyAmount.single(_adaMajorUnits(1000)),
                imageUrl: '',
                range: Range(
                  min: _adaMajorUnits(10),
                  max: _adaMajorUnits(100),
                ),
                currency: Currencies.ada,
                descriptions: const [],
                dos: const [],
                donts: const [],
                submissionCloseDate: DateTime(2024, 12, 31),
              ),
            ],
          ),
        );
      },
      build: () {
        when(() => mockProposalService.watchUserProposals()).thenAnswer(
          (_) => Stream.value([
            ProposalWithVersionX.dummy(ProposalPublish.localDraft, categoryRef: categoryRef),
            ProposalWithVersionX.dummy(ProposalPublish.localDraft, categoryRef: categoryRef),
          ]),
        );

        return workspaceBloc;
      },
      act: (bloc) => bloc.add(const WatchUserProposalsEvent()),
      expect: () => [
        isA<WorkspaceState>().having((s) => s.isLoading, 'isLoading', true),
        isA<WorkspaceState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.userProposals.localProposals.items.length, 'proposals count', 2),
      ],
    );

    blocTest<WorkspaceBloc, WorkspaceState>(
      'watch user proposals - failure',
      build: () {
        when(
          () => mockProposalService.watchUserProposals(),
        ).thenAnswer((_) => Stream.error(Exception('Failed to load')));
        return workspaceBloc;
      },
      act: (bloc) => bloc.add(const WatchUserProposalsEvent()),
      expect: () => [
        isA<WorkspaceState>().having((s) => s.isLoading, 'isLoading', true),
        isA<WorkspaceState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.error, 'has error', isNotNull),
      ],
    );

    group('Proposal sync tests', () {
      UsersProposalOverview createProposal({
        required String title,
        required ProposalPublish publish,
        required int commentsCount,
        bool isLatestLocal = false,
        DocumentRef? id,
      }) {
        final effectiveId = id ?? SignedDocumentRef.generateFirstRef();
        return UsersProposalOverview(
          id: effectiveId,
          parameters: DocumentParameters({categoryRef}),
          title: title,
          updateDate: DateTime(2025, 10, 15),
          fundsRequested: Money.zero(currency: Currencies.ada),
          publish: publish,
          versions: [
            ProposalVersionViewModel(
              title: title,
              id: effectiveId,
              createdAt: DateTime(2025, 10, 15),
              publish: publish,
              isLatest: true,
              isLatestLocal: isLatestLocal,
              versionNumber: 1,
            ),
          ],
          fromActiveCampaign: true,
          commentsCount: commentsCount,
          category: 'Test Category',
          fundNumber: 14,
        );
      }

      blocTest<WorkspaceBloc, WorkspaceState>(
        'loading proposals all derived properties stay in sync',
        build: () => workspaceBloc,
        act: (bloc) {
          final proposals = [
            createProposal(
              title: 'Local 1',
              publish: ProposalPublish.localDraft,
              commentsCount: 0,
              isLatestLocal: true,
            ),
            createProposal(
              title: 'Local 2 with comments',
              publish: ProposalPublish.localDraft,
              commentsCount: 3,
              isLatestLocal: true,
            ),
          ];
          bloc.add(LoadProposalsEvent(proposals));
        },
        expect: () => [
          isA<WorkspaceState>()
              .having(
                (s) => s.userProposals.finalProposals.items.length,
                'There is no finalProposals',
                0,
              )
              .having(
                (s) => s.userProposals.draftProposals.items.length,
                'There is no draftProposals',
                0,
              )
              .having(
                (s) => s.userProposals.localProposals.items.length,
                'There is 2 localProposals',
                2,
              )
              .having(
                (s) => s.userProposals.notPublished.items.length,
                'There is 2 notPublished (both locals have isLatestLocal)',
                2,
              )
              .having(
                (s) => s.userProposals.hasComments,
                'hasComments is true because local2 has comments',
                true,
              ),
        ],
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'loadProposals - all derived properties stay in sync',
        build: () => workspaceBloc,
        act: (bloc) {
          final proposals = [
            createProposal(
              title: 'Local 1',
              publish: ProposalPublish.localDraft,
              commentsCount: 0,
              isLatestLocal: true,
            ),
            createProposal(
              title: 'Local 2 with comments',
              publish: ProposalPublish.localDraft,
              commentsCount: 3,
              isLatestLocal: true,
            ),
            createProposal(
              title: 'Draft',
              publish: ProposalPublish.publishedDraft,
              commentsCount: 5,
            ),
            createProposal(
              title: 'Final',
              publish: ProposalPublish.submittedProposal,
              commentsCount: 0,
            ),
          ];
          bloc.add(LoadProposalsEvent(proposals));
        },
        expect: () => [
          isA<WorkspaceState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.userProposals.localProposals.items.length, 'local count', 2)
              .having((s) => s.userProposals.draftProposals.items.length, 'draft count', 1)
              .having((s) => s.userProposals.finalProposals.items.length, 'final count', 1)
              // published includes draft and final (both have isPublished or isDraft)
              .having((s) => s.userProposals.published.items.length, 'published count', 2)
              // notPublished includes locals with isLatestLocal
              .having((s) => s.userProposals.notPublished.items.length, 'notPublished count', 2)
              // hasComments is true because local2 and draft have comments
              .having((s) => s.userProposals.hasComments, 'hasComments', true),
        ],
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'deleteProposal - derived properties stay in sync after deletion',
        setUp: () {
          when(() => mockProposalService.deleteDraftProposal(any())).thenAnswer((_) async => {});
        },
        build: () => workspaceBloc,
        act: (bloc) {
          final local = createProposal(
            title: 'Local',
            publish: ProposalPublish.localDraft,
            commentsCount: 0,
            isLatestLocal: true,
          );
          const draftRef = DraftRef(id: 'draft-123');
          final draft = createProposal(
            title: 'Draft',
            publish: ProposalPublish.publishedDraft,
            commentsCount: 5,
            id: draftRef,
          );
          final final$ = createProposal(
            title: 'Final',
            publish: ProposalPublish.submittedProposal,
            commentsCount: 0,
          );

          // Load initial proposals and delete the draft proposal
          bloc
            ..add(LoadProposalsEvent([local, draft, final$]))
            ..add(const DeleteDraftProposalEvent(ref: draftRef));
        },
        expect: () => [
          // After load
          isA<WorkspaceState>()
              .having((s) => s.userProposals.draftProposals.items.length, 'draft count before', 1)
              .having((s) => s.userProposals.hasComments, 'hasComments before', true),
          // Delete starts - loading
          isA<WorkspaceState>().having((s) => s.isLoading, 'isLoading', true),
          // Still loading but proposals rebuilt from cache
          isA<WorkspaceState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.userProposals.localProposals.items.length, 'local count', 1)
              .having((s) => s.userProposals.draftProposals.items.length, 'draft count after', 0)
              .having((s) => s.userProposals.finalProposals.items.length, 'final count', 1)
              .having((s) => s.userProposals.published.items.length, 'published count', 1)
              .having((s) => s.userProposals.notPublished.items.length, 'notPublished count', 1)
              // hasComments should be false after deleting the only proposal with comments
              .having((s) => s.userProposals.hasComments, 'hasComments after', false),
          // Delete completes - loading done
          isA<WorkspaceState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.userProposals.draftProposals.items.length, 'draft count still', 0),
        ],
        verify: (_) {
          verify(() => mockProposalService.deleteDraftProposal(any())).called(1);
        },
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'forgetProposal - derived properties stay in sync after forgetting',
        setUp: () {
          when(
            () => mockProposalService.forgetProposal(
              proposalRef: any(named: 'proposalRef'),
              proposalParameters: any(named: 'proposalParameters'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => workspaceBloc,
        act: (bloc) {
          final local1 = createProposal(
            title: 'Local 1',
            publish: ProposalPublish.localDraft,
            commentsCount: 0,
            isLatestLocal: true,
          );
          final local2 = createProposal(
            title: 'Local 2 with comments',
            publish: ProposalPublish.localDraft,
            commentsCount: 3,
            isLatestLocal: true,
          );
          final draft = createProposal(
            title: 'Draft',
            publish: ProposalPublish.publishedDraft,
            commentsCount: 5,
          );

          // Load initial proposals
          bloc
            ..add(LoadProposalsEvent([local1, local2, draft]))
            ..add(ForgetProposalEvent(local2.id));
        },
        expect: () => [
          // After load
          isA<WorkspaceState>()
              .having((s) => s.userProposals.localProposals.items.length, 'local count before', 2)
              .having((s) => s.userProposals.hasComments, 'hasComments before', true),
          // Forget starts - loading
          isA<WorkspaceState>().having((s) => s.isLoading, 'isLoading', true),
          // Still loading but proposals rebuilt from cache
          isA<WorkspaceState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.userProposals.localProposals.items.length, 'local count after', 1)
              .having((s) => s.userProposals.draftProposals.items.length, 'draft count', 1)
              .having((s) => s.userProposals.notPublished.items.length, 'notPublished count', 1)
              // hasComments should still be true because draft still has comments
              .having((s) => s.userProposals.hasComments, 'hasComments after', true),
          // Forget completes - loading done
          isA<WorkspaceState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.userProposals.localProposals.items.length, 'local count still', 1),
        ],
        verify: (_) {
          verify(
            () => mockProposalService.forgetProposal(
              proposalRef: any(named: 'proposalRef'),
              proposalParameters: DocumentParameters({categoryRef}),
            ),
          ).called(1);
        },
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'hasComments is false when no proposals have comments',
        build: () => workspaceBloc,
        act: (bloc) {
          final proposals = [
            createProposal(
              title: 'Local',
              publish: ProposalPublish.localDraft,
              commentsCount: 0,
              isLatestLocal: true,
            ),
            createProposal(
              title: 'Final',
              publish: ProposalPublish.submittedProposal,
              commentsCount: 0,
            ),
          ];
          bloc.add(LoadProposalsEvent(proposals));
        },
        expect: () => [
          isA<WorkspaceState>()
              .having((s) => s.userProposals.hasComments, 'hasComments', false)
              .having((s) => s.userProposals.localProposals.items.length, 'local count', 1)
              .having((s) => s.userProposals.finalProposals.items.length, 'final count', 1),
        ],
      );
    });
  });
}

Money _adaMajorUnits(int majorUnits) {
  return Money.fromMajorUnits(currency: Currencies.ada, majorUnits: BigInt.from(majorUnits));
}

class MockCampaignService extends Mock implements CampaignService {}

class MockDocumentMapper extends Mock implements DocumentMapper {}

class MockDownloaderService extends Mock implements DownloaderService {}

class MockProposalService extends Mock implements ProposalService {}
