import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
        selfRef: proposalRef,
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
            selfRef: SignedDocumentRef.generateFirstRef(),
            name: 'Catalyst Fund14',
            description: 'Description',
            allFunds: MultiCurrencyAmount.single(_adaMajorUnits(20000000)),
            totalAsk: MultiCurrencyAmount.single(_adaMajorUnits(0)),
            fundNumber: 14,
            timeline: const CampaignTimeline(phases: []),
            publish: CampaignPublish.published,
            categories: [
              CampaignCategory(
                selfRef: categoryRef,
                campaignRef: SignedDocumentRef.generateFirstRef(),
                categoryName: 'Test Category',
                categorySubname: 'Test Subname',
                description: 'Test description',
                shortDescription: 'Test short description',
                proposalsCount: 0,
                availableFunds: MultiCurrencyAmount.single(_adaMajorUnits(1000)),
                imageUrl: '',
                totalAsk: MultiCurrencyAmount.single(_adaMajorUnits(0)),
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
            selfRef: SignedDocumentRef.generateFirstRef(),
            name: 'Catalyst Fund14',
            description: 'Description',
            allFunds: MultiCurrencyAmount.single(_adaMajorUnits(20000000)),
            totalAsk: MultiCurrencyAmount.single(_adaMajorUnits(0)),
            fundNumber: 14,
            timeline: const CampaignTimeline(phases: []),
            publish: CampaignPublish.published,
            categories: [
              CampaignCategory(
                selfRef: categoryRef,
                campaignRef: SignedDocumentRef.generateFirstRef(),
                categoryName: 'Test Category',
                categorySubname: 'Test Subname',
                description: 'Test description',
                shortDescription: 'Test short description',
                proposalsCount: 0,
                availableFunds: MultiCurrencyAmount.single(_adaMajorUnits(1000)),
                imageUrl: '',
                totalAsk: MultiCurrencyAmount.single(_adaMajorUnits(0)),
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
            .having((s) => s.userProposals.length, 'proposals count', 2),
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
  });
}

Money _adaMajorUnits(int majorUnits) {
  return Money.fromMajorUnits(currency: Currencies.ada, majorUnits: BigInt.from(majorUnits));
}

class MockCampaignService extends Mock implements CampaignService {}

class MockDocumentMapper extends Mock implements DocumentMapper {}

class MockDownloaderService extends Mock implements DownloaderService {}

class MockProposalService extends Mock implements ProposalService {}
