import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group(WorkspaceBloc, () {
    late MockCampaignService mockCampaignService;
    late MockProposalService mockProposalService;
    late MockDocumentMapper mockDocumentMapper;
    late MockDownloaderService mockDownloaderService;
    late MockUserService mockUserService;
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
        collaborators: const [],
      ),
      content: const DocumentDataContent({}),
    );

    setUpAll(() {
      registerFallbackValue(SignedDocumentRef.generateFirstRef());
      registerFallbackValue(documentData);
      registerFallbackValue(Uint8List(0));
      registerFallbackValue(const DraftRef(id: 'fallback'));
      registerFallbackValue(const ProposalsFiltersV2());
      registerFallbackValue(authorId);
      registerFallbackValue(const DocumentParameters());
    });

    setUp(() async {
      mockCampaignService = MockCampaignService();
      mockProposalService = MockProposalService();
      mockDocumentMapper = MockDocumentMapper();
      mockDownloaderService = MockDownloaderService();
      mockUserService = MockUserService();

      final mockKeychain = MockKeychain();
      when(() => mockKeychain.id).thenReturn('test-keychain');
      final mockAccount = Account.dummy(
        catalystId: authorId,
        keychain: mockKeychain,
        isActive: true,
      );

      // Set up default mocks for user service
      when(() => mockUserService.user).thenReturn(
        User.optional(accounts: [mockAccount]),
      );
      when(() => mockUserService.watchUnlockedActiveAccount).thenAnswer(
        (_) => Stream.value(mockAccount),
      );

      // Set up default mock for campaign service
      when(() => mockCampaignService.getActiveCampaign()).thenAnswer(
        (_) async => null,
      );
      when(() => mockCampaignService.watchActiveCampaign).thenAnswer(
        (_) => Stream.value(null),
      );

      // Set up default mock for invitations and approvals count
      when(() => mockProposalService.watchInvitesApprovalsCount(id: any(named: 'id'))).thenAnswer(
        (_) => Stream.value(const AccountInvitesApprovalsCount(invitesCount: 0, approvalsCount: 0)),
      );

      // Set up default mock for watching workspace proposals
      when(
        () => mockProposalService.watchWorkspaceProposalsBrief(filters: any(named: 'filters')),
      ).thenAnswer(
        (_) => const Stream.empty(),
      );

      workspaceBloc = WorkspaceBloc(
        mockUserService,
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

    group('Proposal sync tests', () {
      blocTest<WorkspaceBloc, WorkspaceState>(
        'internal data change - all derived properties stay in sync',
        build: () => workspaceBloc,
        act: (bloc) {
          final proposals = [
            _createProposal(
              title: 'Local 1',
              publish: ProposalPublish.localDraft,
              commentsCount: 0,
              isLatestLocal: true,
            ),
            _createProposal(
              title: 'Local 2',
              publish: ProposalPublish.localDraft,
              commentsCount: 0,
              isLatestLocal: true,
            ),
          ];
          bloc.add(InternalDataChangeEvent(proposals));
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
                'hasComments is false',
                false,
              ),
        ],
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'internal data change - all derived properties stay in sync with mixed proposals',
        build: () => workspaceBloc,
        act: (bloc) {
          final proposals = [
            _createProposal(
              title: 'Local 1',
              publish: ProposalPublish.localDraft,
              commentsCount: 0,
              isLatestLocal: true,
            ),
            _createProposal(
              title: 'Local 2',
              publish: ProposalPublish.localDraft,
              commentsCount: 0,
              isLatestLocal: true,
            ),
            _createProposal(
              title: 'Draft',
              publish: ProposalPublish.publishedDraft,
              commentsCount: 5,
            ),
            _createProposal(
              title: 'Final',
              publish: ProposalPublish.submittedProposal,
              commentsCount: 2,
            ),
          ];
          bloc.add(InternalDataChangeEvent(proposals));
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
              // hasComments is true because draft and final have comments
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
          final local = _createProposal(
            title: 'Local',
            publish: ProposalPublish.localDraft,
            commentsCount: 0,
            isLatestLocal: true,
          );
          const draftRef = DraftRef(id: 'draft-123');
          final draft = _createProposal(
            title: 'Draft',
            publish: ProposalPublish.publishedDraft,
            commentsCount: 5,
            id: draftRef,
          );
          final final$ = _createProposal(
            title: 'Final',
            publish: ProposalPublish.submittedProposal,
            commentsCount: 0,
          );

          // Load initial proposals and delete the draft proposal
          bloc
            ..add(InternalDataChangeEvent([local, draft, final$]))
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
              proposalId: any(named: 'proposalId'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => workspaceBloc,
        act: (bloc) {
          final local1 = _createProposal(
            title: 'Local 1',
            publish: ProposalPublish.localDraft,
            commentsCount: 0,
            isLatestLocal: true,
          );
          final local2Ref = SignedDocumentRef.generateFirstRef();
          final local2 = _createProposal(
            title: 'Local 2',
            publish: ProposalPublish.localDraft,
            commentsCount: 0,
            isLatestLocal: true,
            id: local2Ref,
          );
          final draft = _createProposal(
            title: 'Draft',
            publish: ProposalPublish.publishedDraft,
            commentsCount: 5,
          );

          // Load initial proposals and forget local2
          bloc
            ..add(InternalDataChangeEvent([local1, local2, draft]))
            ..add(ForgetProposalEvent(local2Ref));
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
              proposalId: any(named: 'proposalId'),
            ),
          ).called(1);
        },
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'hasComments is false when no proposals have comments',
        build: () => workspaceBloc,
        act: (bloc) {
          final proposals = [
            _createProposal(
              title: 'Local',
              publish: ProposalPublish.localDraft,
              commentsCount: 0,
              isLatestLocal: true,
            ),
            _createProposal(
              title: 'Final',
              publish: ProposalPublish.submittedProposal,
              commentsCount: 0,
            ),
          ];
          bloc.add(InternalDataChangeEvent(proposals));
        },
        expect: () => [
          isA<WorkspaceState>()
              .having((s) => s.userProposals.hasComments, 'hasComments', false)
              .having((s) => s.userProposals.localProposals.items.length, 'local count', 1)
              .having((s) => s.userProposals.finalProposals.items.length, 'final count', 1),
        ],
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'change workspace filters - updates state correctly',
        setUp: () {
          when(
            () => mockProposalService.watchWorkspaceProposalsBrief(filters: any(named: 'filters')),
          ).thenAnswer((_) => const Stream.empty());
        },
        build: () => workspaceBloc,
        act: (bloc) {
          bloc.add(const ChangeWorkspaceFilters(filters: WorkspaceFilters.mainProposer));
        },
        expect: () => [
          isA<WorkspaceState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having(
                (s) => s.userProposals.currentFilter,
                'filter',
                WorkspaceFilters.mainProposer,
              ),
          isA<WorkspaceState>().having((s) => s.isLoading, 'isLoading', false),
        ],
      );
    });
  });
}

UsersProposalOverview _createProposal({
  required String title,
  required ProposalPublish publish,
  required int commentsCount,
  bool isLatestLocal = false,
  DocumentRef? id,
}) {
  final effectiveId = id ?? SignedDocumentRef.generateFirstRef();
  return UsersProposalOverview(
    id: effectiveId,
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
    iteration: 1,
    ownership: const AuthorProposalOwnership(),
    parameters: const DocumentParameters(),
  );
}

class MockCampaignService extends Mock implements CampaignService {}

class MockDocumentMapper extends Mock implements DocumentMapper {}

class MockDownloaderService extends Mock implements DownloaderService {}

class MockProposalService extends Mock implements ProposalService {}

class MockUserService extends Mock implements UserService {}
