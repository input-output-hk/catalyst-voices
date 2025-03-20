import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  late MockDocumentRepository mockDocumentRepository;
  late MockProposalRepository mockProposalRepository;
  late MockUserService mockUserService;
  late MockCampaignRepository mockCampaignRepository;
  late MockKeyDerivationService mockKeyDerivationService;

  late ProposalService proposalService;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    mockProposalRepository = MockProposalRepository();
    mockKeyDerivationService = MockKeyDerivationService();
    mockCampaignRepository = MockCampaignRepository();
    mockUserService = MockUserService();

    proposalService = ProposalService(
      mockProposalRepository,
      mockUserService,
      mockKeyDerivationService,
      mockCampaignRepository,
    );

    registerFallbackValue(const SignedDocumentRef(id: 'fallback-id'));

    when(
      () => mockDocumentRepository.watchCount(
        ref: any(named: 'ref'),
        type: DocumentType.commentTemplate,
      ),
    ).thenAnswer((_) => Stream.fromIterable([5]));
  });

  group(ProposalService, () {
    test('watchLatestProposals returns correct proposals', () async {
      const proposalTemplate = DocumentSchema(
        parentSchemaUrl: '',
        schemaSelfUrl: '',
        title: '',
        description: MarkdownData.empty,
        properties: [],
        order: [],
      );

      final proposalId1 = const Uuid().v7();
      final versionId1 = const Uuid().v7();
      await Future.delayed(const Duration(milliseconds: 1), () {});
      final proposalId2 = const Uuid().v7();

      final proposalData1 = ProposalDocument(
        metadata: ProposalMetadata(
          selfRef: SignedDocumentRef(
            id: proposalId1,
            version: versionId1,
          ),
          templateRef: SignedDocumentRef.generateFirstRef(),
          categoryId: SignedDocumentRef.generateFirstRef(),
          authors: const [],
        ),
        document: const Document(
          schema: proposalTemplate,
          properties: [],
        ),
      );
      final proposalData2 = ProposalDocument(
        metadata: ProposalMetadata(
          selfRef: SignedDocumentRef(
            id: proposalId2,
            version: versionId1,
          ),
          templateRef: SignedDocumentRef.generateFirstRef(),
          categoryId: SignedDocumentRef.generateFirstRef(),
          authors: const [],
        ),
        document: const Document(
          schema: proposalTemplate,
          properties: [],
        ),
      );

      // Setup repository responses
      when(
        () => mockProposalRepository.watchLatestProposals(
          limit: null,
        ),
      ).thenAnswer((_) => Stream.value([proposalData1, proposalData2]));

      when(
        () => mockProposalRepository.queryVersionsOfId(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) => Future.value([proposalData1]));

      when(
        () => mockProposalRepository.watchCount(
          ref: any(named: 'ref'),
          type: DocumentType.commentTemplate,
        ),
      ).thenAnswer((_) => Stream.fromIterable([5]));

      when(() => mockCampaignRepository.getCategory(any())).thenAnswer(
        (_) => Future.value(staticCampaignCategories.first),
      );

      // Execute
      final proposals = await proposalService.watchLatestProposals().first;

      // Verify
      expect(proposals.length, equals(2));
      verify(
        () => mockProposalRepository.watchLatestProposals(
          limit: null,
        ),
      ).called(1);

      verify(
        () => mockProposalRepository.queryVersionsOfId(
          id: any(named: 'id'),
        ),
      ).called(2);

      verify(
        () => mockProposalRepository.watchCount(
          ref: any(named: 'ref'),
          type: DocumentType.commentTemplate,
        ),
      ).called(2);
    });

    test(
      'watchProposalsDocuments reacts to comments count changes',
      () async {
        const proposalTemplate = DocumentSchema(
          parentSchemaUrl: '',
          schemaSelfUrl: '',
          title: '',
          description: MarkdownData.empty,
          properties: [],
          order: [],
        );

        final proposalId1 = const Uuid().v7();
        final proposalId2 = const Uuid().v7();
        final versionId = const Uuid().v7();

        final proposalRef1 = SignedDocumentRef(
          id: proposalId1,
          version: versionId,
        );

        final proposalRef2 = SignedDocumentRef(
          id: proposalId2,
          version: versionId,
        );

        final proposalData1 = ProposalDocument(
          metadata: ProposalMetadata(
            selfRef: proposalRef1,
            templateRef: SignedDocumentRef.generateFirstRef(),
            categoryId: SignedDocumentRef.generateFirstRef(),
            authors: const [],
          ),
          document: const Document(
            schema: proposalTemplate,
            properties: [],
          ),
        );

        final proposalData2 = ProposalDocument(
          metadata: ProposalMetadata(
            selfRef: proposalRef2,
            templateRef: SignedDocumentRef.generateFirstRef(),
            categoryId: SignedDocumentRef.generateFirstRef(),
            authors: const [],
          ),
          document: const Document(
            schema: proposalTemplate,
            properties: [],
          ),
        );

        final proposalsStream =
            Stream.value([proposalData1, proposalData2]).asBroadcastStream();

        when(
          () => mockProposalRepository.watchLatestProposals(
            limit: null,
          ),
        ).thenAnswer((_) => proposalsStream);

        when(
          () => mockProposalRepository.queryVersionsOfId(
            id: proposalRef1.id,
          ),
        ).thenAnswer((_) => Future.value([proposalData1]));

        when(
          () => mockProposalRepository.queryVersionsOfId(
            id: proposalRef2.id,
          ),
        ).thenAnswer((_) => Future.value([proposalData2]));

        when(() => mockCampaignRepository.getCategory(any())).thenAnswer(
          (_) => Future.value(staticCampaignCategories.first),
        );

        final commentsStream1 =
            Stream.fromIterable([5, 10]).asBroadcastStream();
        final commentsStream2 = Stream.fromIterable([3, 7]).asBroadcastStream();

        when(
          () => mockProposalRepository.watchCount(
            ref: proposalRef1,
            type: DocumentType.commentTemplate,
          ),
        ).thenAnswer((_) => commentsStream1);

        when(
          () => mockProposalRepository.watchCount(
            ref: proposalRef2,
            type: DocumentType.commentTemplate,
          ),
        ).thenAnswer((_) => commentsStream2);

        await expectLater(
          proposalService.watchLatestProposals().map(
                (proposals) => proposals.map((p) => p.commentsCount).toList(),
              ),
          emitsInOrder([
            [5, 3],
            [5, 7],
            [10, 7],
          ]),
        );
      },
    );
  });
}

class MockCampaignRepository extends Mock implements CampaignRepository {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockKeyDerivationService extends Mock implements KeyDerivationService {}

class MockProposalRepository extends Mock implements ProposalRepository {}

class MockUserService extends Mock implements UserService {}
