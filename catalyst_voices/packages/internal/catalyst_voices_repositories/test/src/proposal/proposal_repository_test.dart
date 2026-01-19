import 'dart:async';

import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const SignedDocumentRef(id: 'fallback-id'));
    registerFallbackValue(<CatalystId>[]);
    registerFallbackValue(<DocumentRef>[]);
    registerFallbackValue(DocumentType.proposalActionDocument);
  });

  group(ProposalRepository, () {
    late _MockSignedDocumentManager mockSignedDocumentManager;
    late _MockDocumentRepository mockDocumentRepository;
    late _MockDocumentDataRemoteSource mockDocumentDataRemoteSource;
    late _MockSignedDocumentDataSource mockSignedDocumentDataSource;
    late _MockProposalDocumentDataLocalSource mockProposalsLocalSource;
    late _MockCastedVotesObserver mockCastedVotesObserver;
    late _MockVotingBallotBuilder mockBallotBuilder;
    late ProposalRepository repository;

    setUp(() {
      mockSignedDocumentManager = _MockSignedDocumentManager();
      mockDocumentRepository = _MockDocumentRepository();
      mockDocumentDataRemoteSource = _MockDocumentDataRemoteSource();
      mockSignedDocumentDataSource = _MockSignedDocumentDataSource();
      mockProposalsLocalSource = _MockProposalDocumentDataLocalSource();
      mockCastedVotesObserver = _MockCastedVotesObserver();
      mockBallotBuilder = _MockVotingBallotBuilder();

      repository = ProposalRepository(
        mockSignedDocumentManager,
        mockDocumentRepository,
        mockDocumentDataRemoteSource,
        mockSignedDocumentDataSource,
        mockProposalsLocalSource,
        mockCastedVotesObserver,
        mockBallotBuilder,
      );
    });

    group('watchProposal', () {
      test('returns null when proposal does not exist', () async {
        // Given
        const proposalId = SignedDocumentRef(id: 'proposal-1', ver: 'v1');

        // Mock null proposal (not found)
        when(
          () => mockProposalsLocalSource.watchRawProposalData(id: proposalId),
        ).thenAnswer((_) => Stream.value(null));

        when(
          () => mockDocumentRepository.watchCount(
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) => Stream.value(0));

        when(() => mockBallotBuilder.watchVotes).thenAnswer(
          (_) => Stream.value(<Vote>[]),
        );

        when(() => mockCastedVotesObserver.watchCastedVotes).thenAnswer(
          (_) => Stream.value(<Vote>[]),
        );

        // When
        final stream = repository.watchProposal(id: proposalId);

        // Then
        await expectLater(stream, emits(isNull));
      });

      test('returns ProposalDataV2 when proposal exists', () async {
        // Given
        const proposalId = SignedDocumentRef(
          id: 'proposal-1',
          ver: 'v1',
        );

        final rawProposal = _createRawProposal(
          id: 'proposal-1',
          ver: 'v1',
        );

        // Mock proposal exists
        when(
          () => mockProposalsLocalSource.watchRawProposalData(id: proposalId),
        ).thenAnswer((_) => Stream.value(rawProposal));

        when(
          () => mockDocumentRepository.watchCount(
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) => Stream.value(0));

        when(() => mockBallotBuilder.watchVotes).thenAnswer(
          (_) => Stream.value(<Vote>[]),
        );

        when(() => mockCastedVotesObserver.watchCastedVotes).thenAnswer(
          (_) => Stream.value(<Vote>[]),
        );

        // Mock collaborators actions
        when(
          () => mockProposalsLocalSource.getCollaboratorsActions(
            proposalsRefs: any(named: 'proposalsRefs'),
          ),
        ).thenAnswer((_) async => <String, RawProposalCollaboratorsActions>{});

        // Mock previous version
        when(
          () => mockProposalsLocalSource.getPreviousOf(id: proposalId),
        ).thenAnswer(
          (_) async => const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
        );

        // Mock previous version metadata
        when(
          () => mockDocumentRepository.getDocumentMetadata(
            id: const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
          ),
        ).thenAnswer(
          (_) async => DocumentDataMetadata.proposal(
            id: const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
            template: const SignedDocumentRef(id: 'template-1', ver: 'template-ver-1'),
            parameters: const DocumentParameters(),
            authors: const [],
            collaborators: const [],
          ),
        );

        // Mock proposal submission actions
        when(
          () => mockDocumentRepository.getProposalSubmissionActions(
            referencing: any(named: 'referencing'),
            authors: any(named: 'authors'),
          ),
        ).thenAnswer((_) async => <DocumentData>[]);

        // When
        final stream = repository.watchProposal(id: proposalId);

        // Then
        await expectLater(
          stream,
          emits(
            predicate<ProposalDataV2?>((data) {
              if (data == null) return false;
              if (data.id != proposalId) return false;
              if (data.proposalOrDocument.asProposalDocument == null) return false;
              return true;
            }),
          ),
        );
      });

      test('includes draft and casted votes correctly', () async {
        // Given
        const proposalId = SignedDocumentRef(
          id: 'proposal-1',
          ver: 'v1',
        );

        final rawProposal = _createRawProposal(
          id: 'proposal-1',
          ver: 'v1',
        );

        final draftVote = Vote.draft(
          proposal: proposalId,
          type: VoteType.yes,
        );

        final castedVote = Vote(
          id: const SignedDocumentRef(id: 'vote-1', ver: 'v1'),
          proposal: proposalId,
          type: VoteType.yes,
        );

        // Mock proposal exists
        when(
          () => mockProposalsLocalSource.watchRawProposalData(id: proposalId),
        ).thenAnswer((_) => Stream.value(rawProposal));

        when(
          () => mockDocumentRepository.watchCount(
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) => Stream.value(0));

        when(() => mockBallotBuilder.watchVotes).thenAnswer(
          (_) => Stream.value([draftVote]),
        );

        when(() => mockCastedVotesObserver.watchCastedVotes).thenAnswer(
          (_) => Stream.value([castedVote]),
        );

        // Mock collaborators actions
        when(
          () => mockProposalsLocalSource.getCollaboratorsActions(
            proposalsRefs: any(named: 'proposalsRefs'),
          ),
        ).thenAnswer((_) async => <String, RawProposalCollaboratorsActions>{});

        // Mock previous version
        when(
          () => mockProposalsLocalSource.getPreviousOf(id: proposalId),
        ).thenAnswer(
          (_) async => const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
        );

        // Mock previous version metadata
        when(
          () => mockDocumentRepository.getDocumentMetadata(
            id: const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
          ),
        ).thenAnswer(
          (_) async => DocumentDataMetadata.proposal(
            id: const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
            template: const SignedDocumentRef(id: 'template-1', ver: 'template-ver-1'),
            parameters: const DocumentParameters(),
            authors: const [],
            collaborators: const [],
          ),
        );

        // Mock proposal submission actions
        when(
          () => mockDocumentRepository.getProposalSubmissionActions(
            referencing: any(named: 'referencing'),
            authors: any(named: 'authors'),
          ),
        ).thenAnswer((_) async => <DocumentData>[]);

        // When
        final stream = repository.watchProposal(id: proposalId);

        // Then - Note: votes are only included if proposal is final
        await expectLater(
          stream,
          emits(
            predicate<ProposalDataV2?>((data) {
              if (data == null) return false;
              // Votes should be null because the proposal is not final
              return data.votes == null;
            }),
          ),
        );
      });

      test('reacts to action count changes (trigger stream)', () async {
        // Given
        const proposalId = SignedDocumentRef(
          id: 'proposal-1',
          ver: 'v1',
        );

        final rawProposal = _createRawProposal(
          id: 'proposal-1',
          ver: 'v1',
        );

        final proposalStreamController = StreamController<RawProposal?>();
        final actionCountController = StreamController<int>();

        // Mock proposal stream
        when(
          () => mockProposalsLocalSource.watchRawProposalData(id: proposalId),
        ).thenAnswer((_) => proposalStreamController.stream);

        when(
          () => mockDocumentRepository.watchCount(
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) => actionCountController.stream);

        when(() => mockBallotBuilder.watchVotes).thenAnswer(
          (_) => Stream.value(<Vote>[]),
        );

        when(() => mockCastedVotesObserver.watchCastedVotes).thenAnswer(
          (_) => Stream.value(<Vote>[]),
        );

        // Mock collaborators actions
        when(
          () => mockProposalsLocalSource.getCollaboratorsActions(
            proposalsRefs: any(named: 'proposalsRefs'),
          ),
        ).thenAnswer((_) async => <String, RawProposalCollaboratorsActions>{});

        // Mock previous version
        when(
          () => mockProposalsLocalSource.getPreviousOf(id: proposalId),
        ).thenAnswer(
          (_) async => const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
        );

        // Mock previous version metadata
        when(
          () => mockDocumentRepository.getDocumentMetadata(
            id: const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
          ),
        ).thenAnswer(
          (_) async => DocumentDataMetadata.proposal(
            id: const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
            template: const SignedDocumentRef(id: 'template-1', ver: 'template-ver-1'),
            parameters: const DocumentParameters(),
            authors: const [],
            collaborators: const [],
          ),
        );

        // Mock proposal submission actions
        when(
          () => mockDocumentRepository.getProposalSubmissionActions(
            referencing: any(named: 'referencing'),
            authors: any(named: 'authors'),
          ),
        ).thenAnswer((_) async => <DocumentData>[]);

        // When
        final stream = repository.watchProposal(id: proposalId);
        final emissions = <ProposalDataV2?>[];

        final subscription = stream.listen(emissions.add);

        // Emit initial values
        proposalStreamController.add(rawProposal);
        actionCountController.add(0);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Trigger update by changing action count
        actionCountController.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Then
        expect(emissions.length, equals(2));
        expect(emissions[0], isNotNull);
        expect(emissions[1], isNotNull);

        await subscription.cancel();
        await proposalStreamController.close();
        await actionCountController.close();
      });

      test('updates when votes change', () async {
        // Given
        const proposalId = SignedDocumentRef(
          id: 'proposal-1',
          ver: 'v1',
        );

        final rawProposal = _createRawProposal(
          id: 'proposal-1',
          ver: 'v1',
        );

        final draftVotesController = StreamController<List<Vote>>();

        // Mock proposal exists
        when(
          () => mockProposalsLocalSource.watchRawProposalData(id: proposalId),
        ).thenAnswer((_) => Stream.value(rawProposal));

        when(
          () => mockDocumentRepository.watchCount(
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) => Stream.value(0));

        when(() => mockBallotBuilder.watchVotes).thenAnswer(
          (_) => draftVotesController.stream,
        );

        when(() => mockCastedVotesObserver.watchCastedVotes).thenAnswer(
          (_) => Stream.value(<Vote>[]),
        );

        // Mock collaborators actions
        when(
          () => mockProposalsLocalSource.getCollaboratorsActions(
            proposalsRefs: any(named: 'proposalsRefs'),
          ),
        ).thenAnswer((_) async => <String, RawProposalCollaboratorsActions>{});

        // Mock previous version
        when(
          () => mockProposalsLocalSource.getPreviousOf(id: proposalId),
        ).thenAnswer(
          (_) async => const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
        );

        // Mock previous version metadata
        when(
          () => mockDocumentRepository.getDocumentMetadata(
            id: const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
          ),
        ).thenAnswer(
          (_) async => DocumentDataMetadata.proposal(
            id: const SignedDocumentRef(id: 'proposal-1', ver: 'v0'),
            template: const SignedDocumentRef(id: 'template-1', ver: 'template-ver-1'),
            parameters: const DocumentParameters(),
            authors: const [],
            collaborators: const [],
          ),
        );

        // Mock proposal submission actions
        when(
          () => mockDocumentRepository.getProposalSubmissionActions(
            referencing: any(named: 'referencing'),
            authors: any(named: 'authors'),
          ),
        ).thenAnswer((_) async => <DocumentData>[]);

        // When
        final stream = repository.watchProposal(id: proposalId);
        final emissions = <ProposalDataV2?>[];

        final subscription = stream.listen(emissions.add);

        // Emit initial empty votes
        draftVotesController.add(<Vote>[]);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Add a draft vote
        final draftVote = Vote.draft(
          proposal: proposalId,
          type: VoteType.yes,
        );
        draftVotesController.add([draftVote]);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Then
        expect(emissions.length, equals(2));
        expect(emissions[0], isNotNull);
        expect(emissions[1], isNotNull);

        await subscription.cancel();
        await draftVotesController.close();
      });
    });

    group('removeCollaboratorFromProposal', () {
      test('removes collaborator from proposal and publishes updated document', () async {
        // Given
        registerFallbackValue(Uint8List(0));
        registerFallbackValue(SignedDocumentUnknownPayload(Uint8List(0)));
        registerFallbackValue(
          DocumentDataMetadata(
            contentType: DocumentContentType.unknown,
            type: DocumentType.unknown,
            id: DocumentRefFactory.signedDocumentRef(),
          ),
        );
        registerFallbackValue(CatalystIdFactory.create());
        registerFallbackValue(FakeCatalystPrivateKey());

        const proposalId = SignedDocumentRef(id: 'proposal-1', ver: 'v1');
        final collaboratorId = CatalystIdFactory.create(
          username: 'collaborator-1',
        );
        final otherCollaboratorId = CatalystIdFactory.create(
          username: 'other-collaborator',
          role0KeySeed: 1,
        );

        final originalMetadata = DocumentDataMetadata.proposal(
          id: proposalId,
          template: const SignedDocumentRef(id: 'template-1', ver: 'template-ver-1'),
          parameters: const DocumentParameters(),
          authors: const [],
          collaborators: [otherCollaboratorId, collaboratorId],
        );

        final mockOriginalDocument = FakeSignedDocument(
          metadata: originalMetadata,
          payload: SignedDocumentBinaryPayload(Uint8List(0)),
        );

        final expectedUpdatedId = proposalId.fresh().toSignedDocumentRef();
        final expectedUpdatedMetadata = originalMetadata.copyWith(
          id: expectedUpdatedId,
          collaborators: Optional([otherCollaboratorId]),
        );

        final mockUpdatedDocument = FakeSignedDocument(
          metadata: expectedUpdatedMetadata,
          payload: SignedDocumentBinaryPayload(Uint8List(0)),
        );

        // When
        when(
          () => mockDocumentRepository.getDocumentArtifact(id: proposalId),
        ).thenAnswer((_) async => DocumentArtifact(Uint8List(0)));

        when(
          () => mockSignedDocumentManager.parseDocument(any()),
        ).thenAnswer((_) async => mockOriginalDocument);

        when(
          () => mockSignedDocumentManager.signRawDocument(
            any(),
            metadata: any(named: 'metadata'),
            catalystId: any(named: 'catalystId'),
            privateKey: any(named: 'privateKey'),
          ),
        ).thenAnswer((_) async => mockUpdatedDocument);

        when(
          () => mockDocumentRepository.publishDocument(document: mockUpdatedDocument),
        ).thenAnswer((_) async {
          return;
        });

        await repository.removeCollaboratorFromProposal(
          proposalId: proposalId,
          collaboratorId: collaboratorId,
          privateKey: FakeCatalystPrivateKey(),
        );

        // Then
        verify(
          () => mockSignedDocumentManager.signRawDocument(
            any(),
            metadata: any(
              named: 'metadata',
              that: predicate<DocumentDataMetadata>((meta) {
                if (meta.id.id != 'proposal-1') return false;
                if (meta.id.ver == 'v1') return false; // new version
                return listEquals(meta.collaborators, [otherCollaboratorId]);
              }),
            ),
            catalystId: collaboratorId,
            privateKey: any(named: 'privateKey'),
          ),
        ).called(1);

        verify(
          () => mockDocumentRepository.publishDocument(document: mockUpdatedDocument),
        ).called(1);
      });
    });
  });
}

RawProposal _createRawProposal({
  required String id,
  required String ver,
  List<String>? versionIds,
  int commentsCount = 0,
  bool isFavorite = false,
}) {
  final proposalData = DocumentData(
    content: const DocumentDataContent(<String, dynamic>{}),
    metadata: DocumentDataMetadata.proposal(
      id: SignedDocumentRef(id: id, ver: ver),
      template: const SignedDocumentRef(id: 'template-1', ver: 'template-ver-1'),
      parameters: const DocumentParameters(),
      authors: const [],
      collaborators: const [],
    ),
  );

  // Minimal valid template schema data
  final templateData = DocumentData(
    content: const DocumentDataContent(<String, dynamic>{
      r'$schema': 'https://example.com/schema',
      r'$id': 'https://example.com/template',
      'title': 'Test Template',
      'description': 'A test template',
      'definitions': <String, dynamic>{},
      'properties': <String, dynamic>{},
      'required': <String>[],
      'x-order': <String>[],
    }),
    metadata: DocumentDataMetadata(
      id: const SignedDocumentRef(id: 'template-1', ver: 'template-ver-1'),
      type: DocumentType.proposalTemplate,
      contentType: DocumentContentType.json,
    ),
  );

  return RawProposal(
    proposal: proposalData,
    template: templateData,
    versionIds: versionIds ?? [ver],
    commentsCount: commentsCount,
    isFavorite: isFavorite,
    originalAuthors: const [],
  );
}

class _MockCastedVotesObserver extends Mock implements CastedVotesObserver {}

class _MockDocumentDataRemoteSource extends Mock implements DocumentDataRemoteSource {}

class _MockDocumentRepository extends Mock implements DocumentRepository {}

class _MockProposalDocumentDataLocalSource extends Mock
    implements ProposalDocumentDataLocalSource {}

class _MockSignedDocumentDataSource extends Mock implements SignedDocumentDataSource {}

class _MockSignedDocumentManager extends Mock implements SignedDocumentManager {}

class _MockVotingBallotBuilder extends Mock implements VotingBallotBuilder {}
