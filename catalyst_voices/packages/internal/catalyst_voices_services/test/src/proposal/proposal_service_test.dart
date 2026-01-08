import 'dart:async';

import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
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
  late MockCastedVotesObserver mockCastedVotesObserver;
  late VotingBallotBuilder ballotBuilder;

  late ProposalService proposalService;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    mockProposalRepository = MockProposalRepository();
    mockSignerService = MockSignerService();
    mockUserService = MockUserService();
    mockActiveCampaignObserver = MockActiveCampaignObserver();
    mockCastedVotesObserver = MockCastedVotesObserver();
    ballotBuilder = VotingBallotLocalBuilder();

    proposalService = ProposalService(
      mockProposalRepository,
      mockDocumentRepository,
      mockUserService,
      mockSignerService,
      mockActiveCampaignObserver,
      mockCastedVotesObserver,
      ballotBuilder,
    );

    registerFallbackValue(const SignedDocumentRef(id: 'fallback-id'));
    registerFallbackValue(const ProposalsFiltersV2());

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
      final categoryRef = SignedDocumentRef.generateFirstRef();
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
          proposalRef: proposalRef,
          proposalParameters: DocumentParameters({categoryRef}),
        ),
        throwsA(isA<ProposalLimitReachedException>()),
      );
    });
  });
}

class MockActiveCampaignObserver extends Mock implements ActiveCampaignObserver {}

class MockCastedVotesObserver extends Mock implements CastedVotesObserver {}

class MockSignerService extends Mock implements SignerService {}

class MockUserService extends Mock implements UserService {}
