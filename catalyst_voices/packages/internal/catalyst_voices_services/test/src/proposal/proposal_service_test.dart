// Create mocks
import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

void main() {
  late MockDocumentRepository mockDocumentRepository;
  late MockProposalRepository mockProposalRepository;
  late ProposalService proposalService;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    mockProposalRepository = MockProposalRepository();

    proposalService =
        ProposalService(mockProposalRepository, mockDocumentRepository);

    registerFallbackValue(const SignedDocumentRef(id: 'fallback-id'));

    // Add a default response for any watchProposalCommentsCount call
    when(
      () => mockDocumentRepository.watchProposalCommentsCount(
        ref: any(named: 'ref'),
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
        metadata: ProposalMetadata(id: proposalId1, version: versionId1),
        document: const Document(
          schema: proposalTemplate,
          properties: [],
        ),
      );
      final proposalData2 = ProposalDocument(
        metadata: ProposalMetadata(id: proposalId2, version: versionId1),
        document: const Document(
          schema: proposalTemplate,
          properties: [],
        ),
      );

      // Setup repository responses
      when(
        () => mockDocumentRepository.watchLatestPublicProposalsDocuments(
          limit: null,
        ),
      ).thenAnswer((_) => Stream.value([proposalData1, proposalData2]));

      when(
        () => mockDocumentRepository.getProposalVersionIds(
          ref: any(named: 'ref'),
        ),
      ).thenAnswer((_) => Future.value([versionId1]));

      when(
        () => mockDocumentRepository.watchProposalCommentsCount(
          ref: any(named: 'ref'),
        ),
      ).thenAnswer((_) => Stream.fromIterable([5]));

      // Execute
      final proposals = await proposalService.watchLatestProposals().first;

      // Verify
      expect(proposals.length, equals(2));
      verify(
        () => mockDocumentRepository.watchLatestPublicProposalsDocuments(
          limit: null,
        ),
      ).called(1);

      verify(
        () => mockDocumentRepository.getProposalVersionIds(
          ref: any(named: 'ref'),
        ),
      ).called(2);

      verify(
        () => mockDocumentRepository.watchProposalCommentsCount(
          ref: any(named: 'ref'),
        ),
      ).called(2);
    });

    test(
      'watchLatestProposals reacts to comments count changes',
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

        final proposalData1 = ProposalDocument(
          metadata: ProposalMetadata(id: proposalId1, version: versionId),
          document: const Document(
            schema: proposalTemplate,
            properties: [],
          ),
        );

        final proposalData2 = ProposalDocument(
          metadata: ProposalMetadata(id: proposalId2, version: versionId),
          document: const Document(
            schema: proposalTemplate,
            properties: [],
          ),
        );

        final proposalsStream =
            Stream.value([proposalData1, proposalData2]).asBroadcastStream();

        when(
          () => mockDocumentRepository.watchLatestPublicProposalsDocuments(
            limit: null,
          ),
        ).thenAnswer((_) => proposalsStream);

        when(
          () => mockDocumentRepository.getProposalVersionIds(
            ref: any(named: 'ref'),
          ),
        ).thenAnswer((_) => Future.value([versionId]));

        final commentsStream1 =
            Stream.fromIterable([5, 10]).asBroadcastStream();
        final commentsStream2 = Stream.fromIterable([3, 7]).asBroadcastStream();

        when(
          () => mockDocumentRepository.watchProposalCommentsCount(
            ref: SignedDocumentRef(id: proposalId1),
          ),
        ).thenAnswer((_) => commentsStream1);

        when(
          () => mockDocumentRepository.watchProposalCommentsCount(
            ref: SignedDocumentRef(id: proposalId2),
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

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockProposalRepository extends Mock implements ProposalRepository {}
