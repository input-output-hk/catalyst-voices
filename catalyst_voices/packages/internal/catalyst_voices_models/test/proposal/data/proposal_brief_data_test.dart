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
          versionIds: [
            id.ver!,
            DocumentRefFactory.randomUuidV7(),
            DocumentRefFactory.randomUuidV7(),
          ],
          commentsCount: 10,
          isFavorite: true,
          originalAuthors: [author],
        );
        final proposalOrDocument = ProposalOrDocument.data(rawProposal.proposal);

        // When
        final brief = ProposalBriefData.build(
          data: rawProposal,
          proposal: proposalOrDocument,
        );

        // Then
        expect(brief.id, rawProposal.proposal.id);
        expect(brief.author, author);
        expect(brief.title, title);
        expect(brief.isFinal, isTrue);
        expect(brief.isFavorite, isTrue);
        expect(brief.iteration, 1);
        expect(brief.commentsCount, isNull);
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
        );
        final collaboratorBAction = RawCollaboratorAction(
          id: collaboratorB,
          proposalId: id,
          action: ProposalSubmissionAction.hide,
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
          versionIds: [id.ver!],
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
  });
}
