import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MockCampaignService mockCampaignService;
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
    mockCampaignService = MockCampaignService();

    proposalService = ProposalService(
      mockProposalRepository,
      mockDocumentRepository,
      mockUserService,
      mockSignerService,
      mockCampaignService,
    );

    registerFallbackValue(const SignedDocumentRef(id: 'fallback-id'));
    registerFallbackValue(const ProposalsCountFilters());

    when(
      () => mockDocumentRepository.watchCount(
        refTo: any(named: 'refTo'),
        type: DocumentType.commentDocument,
      ),
    ).thenAnswer((_) => Stream.fromIterable([5]));
  });

  group(ProposalService, () {
    test(
        'submitProposalForReview throws '
        '$ProposalLimitReachedException when over limit', () async {
      final proposalRef = SignedDocumentRef.generateFirstRef();
      final categoryId = SignedDocumentRef.generateFirstRef();
      final catalystId = DummyCatalystIdFactory.create();
      final account = Account.dummy(
        catalystId: catalystId,
        keychain: MockKeychain(),
        isActive: true,
      );
      final user = User.optional(accounts: [account]);
      const proposalsCount = ProposalsCount(
        finals: ProposalDocument.maxSubmittedProposalsPerUser + 1,
      );

      when(() => mockUserService.watchUser).thenAnswer((_) => Stream.value(user));

      when(
        () => mockProposalRepository.watchProposalsCount(
          filters: any(named: 'filters'),
        ),
      ).thenAnswer((_) => Stream.value(proposalsCount));

      expect(
        () async => proposalService.submitProposalForReview(
          proposalRef: proposalRef,
          categoryId: categoryId,
        ),
        throwsA(isA<ProposalLimitReachedException>()),
      );
    });
  });
}

class MockCampaignService extends Mock implements CampaignService {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockKeychain extends Mock implements Keychain {}

class MockProposalRepository extends Mock implements ProposalRepository {}

class MockSignerService extends Mock implements SignerService {}

class MockUserService extends Mock implements UserService {}
