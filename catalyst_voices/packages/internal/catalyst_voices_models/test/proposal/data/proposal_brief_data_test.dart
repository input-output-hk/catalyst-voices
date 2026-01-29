import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ProposalBriefData, () {
    group('build', () {
      test('basic raw data is mapped correctly', () {
        // Given
        final id = DocumentRefFactory.signedDocumentRef();
        final author = CatalystIdFactory.create();
        const title = 'Test Proposal';

        final rawProposal = RawProposalBrief(
          proposal: DocumentDataFactory.build(
            id: id,
            authors: [author],
            content: const DocumentDataContent({
              'setup': {
                'title': {'title': title},
              },
            }),
          ),
          template: null,
          actionType: ProposalSubmissionAction.aFinal,
          commentsCount: 10,
          isFavorite: true,
          originalAuthors: [author],
        );
        final proposalOrDocument = ProposalOrDocument.data(rawProposal.proposal);

        // When
        final brief = ProposalBriefData.build(
          data: rawProposal,
          proposal: proposalOrDocument,
          versionTitles: VersionsTitles({
            id.ver!: title,
            DocumentRefFactory.randomUuidV7(): null,
            DocumentRefFactory.randomUuidV7(): null,
          }),
        );

        // Then
        expect(brief.id, rawProposal.proposal.id);
        expect(brief.author, author);
        expect(brief.title, title);
        expect(brief.isFinal, isTrue);
        expect(brief.isFavorite, isTrue);
        expect(brief.iteration, 1);
        expect(brief.commentsCount, 10);
        expect(brief.versions?.length, 3);
        expect(brief.collaborators?.first.id, isNull);
      });

      test('collaborators actions are mapped correctly', () {
        // Given
        final id = DocumentRefFactory.signedDocumentRef();
        final author = CatalystIdFactory.create(username: 'Author');
        final collaboratorA = CatalystIdFactory.create(username: 'CollabA', role0KeySeed: 1);
        final collaboratorB = CatalystIdFactory.create(username: 'CollabB', role0KeySeed: 2);

        final collaboratorAAction = RawCollaboratorAction(
          id: collaboratorA,
          proposalId: id,
          action: ProposalSubmissionAction.draft,
          actionId: SignedDocumentRef.generateFirstRef(),
        );
        final collaboratorBAction = RawCollaboratorAction(
          id: collaboratorB,
          proposalId: id,
          action: ProposalSubmissionAction.hide,
          actionId: SignedDocumentRef.generateFirstRef(),
        );

        final collaboratorsActions = {
          collaboratorA.toSignificant(): collaboratorAAction,
          collaboratorB.toSignificant(): collaboratorBAction,
        };

        final rawProposal = RawProposalBrief(
          proposal: DocumentDataFactory.build(
            id: id,
            authors: [author],
            collaborators: [collaboratorA, collaboratorB],
          ),
          template: null,
          actionType: ProposalSubmissionAction.draft,
          commentsCount: 0,
          isFavorite: false,
          originalAuthors: [author],
        );
        final proposalOrDocument = ProposalOrDocument.data(rawProposal.proposal);

        // When
        final brief = ProposalBriefData.build(
          data: rawProposal,
          proposal: proposalOrDocument,
          collaboratorsActions: collaboratorsActions,
        );

        // Then
        expect(brief.collaborators, hasLength(2));

        final collabA = brief.collaborators!.firstWhere((element) => element.id == collaboratorA);
        final collabB = brief.collaborators!.firstWhere((element) => element.id == collaboratorB);

        expect(collabA.status, ProposalsCollaborationStatus.accepted);
        expect(collabB.status, ProposalsCollaborationStatus.rejected);
      });
    });

    group('appendVersion', () {
      test('creates new list with version when versions is null', () {
        // Given
        final id = DocumentRefFactory.signedDocumentRef();
        final baseBrief = ProposalBriefData(
          id: id,
          createdAt: DateTime.now(),
          // ignore: avoid_redundant_argument_values
          versions: null,
        );
        final newVersionRef = DocumentRefFactory.signedDocumentRef();
        const newVersionTitle = 'New Version';

        // When
        final updatedBrief = baseBrief.appendVersion(
          ref: newVersionRef,
          title: newVersionTitle,
        );

        // Then
        expect(baseBrief.versions, isNull, reason: 'Original object should remain unchanged');
        expect(updatedBrief.versions, hasLength(1));
        expect(updatedBrief.versions!.first.ref, newVersionRef);
        expect(updatedBrief.versions!.first.title, newVersionTitle);
      });

      test('appends version to the end of an existing list', () {
        // Given
        final id = DocumentRefFactory.signedDocumentRef();
        final existingVersionRef = DocumentRefFactory.signedDocumentRef();
        final existingVersion = ProposalBriefDataVersion(
          ref: existingVersionRef,
          title: 'Old',
          versionNumber: 1,
        );

        final baseBrief = ProposalBriefData(
          id: id,
          createdAt: DateTime.now(),
          versions: [existingVersion],
        );

        final newVersionRef = DocumentRefFactory.signedDocumentRef();
        const newVersionTitle = 'New Version';

        // When
        final updatedBrief = baseBrief.appendVersion(
          ref: newVersionRef,
          title: newVersionTitle,
        );

        // Then
        expect(updatedBrief.versions, hasLength(2));
        // Versions are sorted oldest→newest, so existing version should be first
        expect(updatedBrief.versions![0], existingVersion);
        expect(updatedBrief.versions![1].ref, newVersionRef);
        expect(updatedBrief.versions![1].title, newVersionTitle);
      });

      test('handles optional title correctly (null title)', () {
        // Given
        final id = DocumentRefFactory.signedDocumentRef();
        final baseBrief = ProposalBriefData(
          id: id,
          createdAt: DateTime.now(),
        );
        final newVersionRef = DocumentRefFactory.signedDocumentRef();

        // When
        final updatedBrief = baseBrief.appendVersion(
          ref: newVersionRef,
          // ignore: avoid_redundant_argument_values
          title: null,
        );

        // Then
        expect(updatedBrief.versions, hasLength(1));
        expect(updatedBrief.versions!.first.title, isNull);
      });
    });
  });
}
