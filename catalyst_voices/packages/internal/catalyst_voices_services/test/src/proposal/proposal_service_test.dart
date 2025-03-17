// Create mocks
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
  late MockKeyDerivationService mockKeyDerivationService;

  late ProposalService proposalService;

  setUp(() {
    mockDocumentRepository = MockDocumentRepository();
    mockProposalRepository = MockProposalRepository();
    mockKeyDerivationService = MockKeyDerivationService();
    mockUserService = MockUserService();

    proposalService = ProposalService(
      mockProposalRepository,
      mockDocumentRepository,
      mockUserService,
      mockKeyDerivationService,
    );

    registerFallbackValue(const SignedDocumentRef(id: 'fallback-id'));

    // Add a default response for any watchProposalCommentsCount call
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
        ),
        document: const Document(
          schema: proposalTemplate,
          properties: [],
        ),
      );

      // Setup repository responses
      when(
        () => mockDocumentRepository.watchProposalsDocuments(
          limit: null,
        ),
      ).thenAnswer((_) => Stream.value([proposalData1, proposalData2]));

      when(
        () => mockDocumentRepository.queryVersionIds(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) => Future.value([versionId1]));

      when(
        () => mockDocumentRepository.watchCount(
          ref: any(named: 'ref'),
          type: DocumentType.commentTemplate,
        ),
      ).thenAnswer((_) => Stream.fromIterable([5]));

      // Execute
      final proposals = await proposalService.watchLatestProposals().first;

      // Verify
      expect(proposals.length, equals(2));
      verify(
        () => mockDocumentRepository.watchProposalsDocuments(
          limit: null,
        ),
      ).called(1);

      verify(
        () => mockDocumentRepository.queryVersionIds(
          id: any(named: 'id'),
        ),
      ).called(2);

      verify(
        () => mockDocumentRepository.watchCount(
          ref: any(named: 'ref'),
          type: DocumentType.commentTemplate,
        ),
      ).called(2);
    });

    test(
      'watchProposalsDocuments reacts to comments count changes',
      () async {
        // TODO(damian-molinski): JSONB filtering
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
          metadata: ProposalMetadata(
            selfRef: SignedDocumentRef(
              id: proposalId1,
              version: versionId,
            ),
          ),
          document: const Document(
            schema: proposalTemplate,
            properties: [],
          ),
        );

        final proposalData2 = ProposalDocument(
          metadata: ProposalMetadata(
            selfRef: SignedDocumentRef(
              id: proposalId1,
              version: versionId,
            ),
          ),
          document: const Document(
            schema: proposalTemplate,
            properties: [],
          ),
        );

        final proposalsStream =
            Stream.value([proposalData1, proposalData2]).asBroadcastStream();

        when(
          () => mockDocumentRepository.watchProposalsDocuments(
            limit: null,
          ),
        ).thenAnswer((_) => proposalsStream);

        when(
          () => mockDocumentRepository.queryVersionIds(
            id: any(named: 'id'),
          ),
        ).thenAnswer((_) => Future.value([versionId]));

        final commentsStream1 =
            Stream.fromIterable([5, 10]).asBroadcastStream();
        final commentsStream2 = Stream.fromIterable([3, 7]).asBroadcastStream();

        when(
          () => mockDocumentRepository.watchCount(
            ref: SignedDocumentRef(id: proposalId1),
            type: DocumentType.commentTemplate,
          ),
        ).thenAnswer((_) => commentsStream1);

        when(
          () => mockDocumentRepository.watchCount(
            ref: SignedDocumentRef(id: proposalId2),
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
      skip: true,
    );
  });
}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockKeyDerivationService extends Mock implements KeyDerivationService {}

class MockProposalRepository extends Mock implements ProposalRepository {}

class MockUserService extends Mock implements UserService {}
