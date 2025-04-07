import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  late MockDocumentRepository mockDocumentRepository;
  late MockProposalRepository mockProposalRepository;
  late MockUserService mockUserService;
  late MockCampaignRepository mockCampaignRepository;
  late MockSignerService mockSignerService;

  late ProposalService proposalService;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    mockProposalRepository = MockProposalRepository();
    mockSignerService = MockSignerService();
    mockCampaignRepository = MockCampaignRepository();
    mockUserService = MockUserService();

    proposalService = ProposalService(
      mockProposalRepository,
      mockDocumentRepository,
      mockUserService,
      mockSignerService,
      mockCampaignRepository,
    );

    registerFallbackValue(const SignedDocumentRef(id: 'fallback-id'));

    when(
      () => mockDocumentRepository.watchCount(
        ref: any(named: 'ref'),
        type: DocumentType.commentDocument,
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

      when(
        () => mockProposalRepository.watchLatestProposals(
          limit: null,
        ),
      ).thenAnswer((_) => Stream.value([proposalData1, proposalData2]));

      when(
        () => mockProposalRepository.watchProposalPublish(
          refTo: any(named: 'refTo'),
        ),
      ).thenAnswer((_) => Stream.value(ProposalPublish.publishedDraft));

      when(
        () => mockProposalRepository.queryVersionsOfId(
          id: any(named: 'id'),
          includeLocalDrafts: any(named: 'includeLocalDrafts'),
        ),
      ).thenAnswer((_) => Future.value([proposalData1]));

      when(
        () => mockProposalRepository.watchCount(
          ref: any(named: 'ref'),
          type: DocumentType.commentDocument,
        ),
      ).thenAnswer((_) => Stream.fromIterable([5]));

      when(
        () => mockProposalRepository.getProposalPublishForRef(
          ref: any(named: 'ref'),
        ),
      ).thenAnswer((_) => Future.value(ProposalPublish.publishedDraft));

      when(() => mockCampaignRepository.getCategory(any())).thenAnswer(
        (_) => Future.value(staticCampaignCategories.first),
      );

      final proposals = await proposalService.watchLatestProposals().first;

      expect(proposals.length, equals(2));

      verify(
        () => mockProposalRepository.watchLatestProposals(
          limit: null,
        ),
      ).called(1);

      verify(
        () => mockProposalRepository.watchProposalPublish(
          refTo: any(named: 'refTo'),
        ),
      ).called(2);

      verify(
        () => mockProposalRepository.queryVersionsOfId(
          id: any(named: 'id'),
          includeLocalDrafts: any(named: 'includeLocalDrafts'),
        ),
      ).called(2);

      verify(
        () => mockProposalRepository.watchCount(
          ref: any(named: 'ref'),
          type: DocumentType.commentDocument,
        ),
      ).called(2);

      verify(
        () => mockCampaignRepository.getCategory(any()),
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

        final comments1 = ReplaySubject<int>();
        final comments2 = ReplaySubject<int>();

        // Create a broadcast stream for the proposals
        final proposalsStream =
            Stream.value([proposalData1, proposalData2]).asBroadcastStream();

        when(
          () => mockProposalRepository.watchLatestProposals(
            limit: null,
          ),
        ).thenAnswer((_) => proposalsStream);

        when(
          () => mockProposalRepository.watchProposalPublish(
            refTo: any(named: 'refTo'),
          ),
        ).thenAnswer((_) => Stream.value(ProposalPublish.publishedDraft));

        when(
          () => mockProposalRepository.queryVersionsOfId(
            id: any(named: 'id'),
            includeLocalDrafts: any(named: 'includeLocalDrafts'),
          ),
        ).thenAnswer((_) => Future.value([proposalData1]));

        when(
          () => mockProposalRepository.getProposalPublishForRef(
            ref: any(named: 'ref'),
          ),
        ).thenAnswer((_) => Future.value(ProposalPublish.publishedDraft));

        when(() => mockCampaignRepository.getCategory(any())).thenAnswer(
          (_) => Future.value(staticCampaignCategories.first),
        );

        when(
          () => mockProposalRepository.watchCount(
            ref: proposalRef1,
            type: DocumentType.commentDocument,
          ),
        ).thenAnswer((_) => comments1.stream);

        when(
          () => mockProposalRepository.watchCount(
            ref: proposalRef2,
            type: DocumentType.commentDocument,
          ),
        ).thenAnswer((_) => comments2.stream);

        final testStream = proposalService.watchLatestProposals();
        final subscription = testStream.listen((_) {});

        comments1.add(5);
        comments2
          ..add(3)
          ..add(7);
        comments1.add(10);

        await expectLater(
          testStream,
          emitsThrough(
            predicate<List<Proposal>>((proposals) {
              expect(proposals.length, equals(2));
              expect(proposals[0].commentsCount, equals(10));
              expect(proposals[1].commentsCount, equals(7));
              return true;
            }),
          ),
        );

        await subscription.cancel();
        await comments1.close();
        await comments2.close();
      },
    );
  });
}

class MockCampaignRepository extends Mock implements CampaignRepository {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockProposalRepository extends Mock implements ProposalRepository {}

class MockSignerService extends Mock implements SignerService {}

class MockUserService extends Mock implements UserService {}
