import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
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
    final documentData = DocumentData(
      metadata: DocumentDataMetadata(
        type: DocumentType.proposalDocument,
        selfRef: proposalRef,
        template: SignedDocumentRef.generateFirstRef(),
        categoryId: SignedDocumentRef.generateFirstRef(),
      ),
      content: const DocumentDataContent({}),
    );

    setUpAll(() {
      registerFallbackValue(SignedDocumentRef.generateFirstRef());
      registerFallbackValue(documentData);
      registerFallbackValue(Uint8List(0));
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
      build: () {
        when(() => mockProposalService.watchUserProposals()).thenAnswer(
          (_) => Stream.value(
            [ProposalWithVersionX.dummy(ProposalPublish.localDraft)],
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
      build: () {
        when(() => mockProposalService.watchUserProposals()).thenAnswer(
          (_) => Stream.value([
            ProposalWithVersionX.dummy(ProposalPublish.localDraft),
            ProposalWithVersionX.dummy(ProposalPublish.localDraft),
          ]),
        );
        return workspaceBloc;
      },
      act: (bloc) => bloc.add(const WatchUserProposalsEvent()),
      expect: () => [
        isA<WorkspaceState>().having((s) => s.isLoading, 'isLoading', true),
        isA<WorkspaceState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.userProposals.length, 'proposals count', 2),
      ],
    );

    blocTest<WorkspaceBloc, WorkspaceState>(
      'watch user proposals - failure',
      build: () {
        when(() => mockProposalService.watchUserProposals())
            .thenAnswer((_) => Stream.error(Exception('Failed to load')));
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
  });
}

class MockCampaignService extends Mock implements CampaignService {}

class MockDocumentMapper extends Mock implements DocumentMapper {}

class MockDownloaderService extends Mock implements DownloaderService {}

class MockProposalService extends Mock implements ProposalService {}
