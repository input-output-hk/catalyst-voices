import 'dart:math' show Random;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late final CatalystId authorCatalystId;
  late final CatalystId collaborator1Id;
  late final CatalystId collaborator2Id;
  late final CatalystId collaborator3Id;
  late final CatalystId collaborator4Id;
  setUpAll(() {
    authorCatalystId = DummyCatalystIdFactory.create(role0KeyBytes: _generateKeyBytes(0));
    collaborator1Id = DummyCatalystIdFactory.create(role0KeyBytes: _generateKeyBytes(1));
    collaborator2Id = DummyCatalystIdFactory.create(role0KeyBytes: _generateKeyBytes(2));
    collaborator3Id = DummyCatalystIdFactory.create(role0KeyBytes: _generateKeyBytes(3));
    collaborator4Id = DummyCatalystIdFactory.create(role0KeyBytes: _generateKeyBytes(4));
  });
  group(ProposalDataCollaborator, () {
    test(
      'sets all collaborators status as pending when there is no actions '
      'and versions are the same',
      () {
        final collaborators = [collaborator1Id, collaborator2Id, collaborator3Id, collaborator4Id];
        final result = ProposalDataCollaborator.resolveCollaboratorStatuses(
          currentCollaborators: collaborators,
          prevCollaborators: collaborators,
          prevAuthors: [authorCatalystId],
          isProposalFinal: false,
        );

        expect(
          result.map((c) => c.status),
          everyElement(equals(ProposalsCollaborationStatus.pending)),
        );
      },
    );

    test(
      'sets collaborators status properly for each latest action '
      'and versions are the same and proposal is a draft',
      () {
        final collaborators = [collaborator1Id, collaborator2Id, collaborator3Id, collaborator4Id];
        final result = ProposalDataCollaborator.resolveCollaboratorStatuses(
          currentCollaborators: collaborators,
          prevCollaborators: collaborators,
          prevAuthors: [authorCatalystId],
          collaboratorsActions: {
            collaborator2Id.toSignificant(): RawCollaboratorAction(
              action: ProposalSubmissionAction.draft,
              id: collaborator2Id,
              proposalId: SignedDocumentRef.generateFirstRef(),
            ),
            collaborator3Id.toSignificant(): RawCollaboratorAction(
              action: ProposalSubmissionAction.aFinal,
              id: collaborator4Id,
              proposalId: SignedDocumentRef.generateFirstRef(),
            ),
            collaborator4Id.toSignificant(): RawCollaboratorAction(
              action: ProposalSubmissionAction.hide,
              id: collaborator4Id,
              proposalId: SignedDocumentRef.generateFirstRef(),
            ),
          },
          isProposalFinal: false,
        );

        expect(
          result.map((c) => c.status).toList(),
          equals([
            ProposalsCollaborationStatus.pending,
            ProposalsCollaborationStatus.accepted,
            ProposalsCollaborationStatus.accepted,
            ProposalsCollaborationStatus.rejected,
          ]),
        );
      },
    );

    test(
      'sets collaborators status properly for each latest action '
      'and versions are the same and proposal is final',
      () {
        final collaborators = [collaborator1Id, collaborator2Id, collaborator3Id, collaborator4Id];
        final result = ProposalDataCollaborator.resolveCollaboratorStatuses(
          currentCollaborators: collaborators,
          prevCollaborators: collaborators,
          prevAuthors: [authorCatalystId],
          collaboratorsActions: {
            collaborator2Id.toSignificant(): RawCollaboratorAction(
              action: ProposalSubmissionAction.draft,
              id: collaborator2Id,
              proposalId: SignedDocumentRef.generateFirstRef(),
            ),
            collaborator3Id.toSignificant(): RawCollaboratorAction(
              action: ProposalSubmissionAction.aFinal,
              id: collaborator4Id,
              proposalId: SignedDocumentRef.generateFirstRef(),
            ),
            collaborator4Id.toSignificant(): RawCollaboratorAction(
              action: ProposalSubmissionAction.hide,
              id: collaborator4Id,
              proposalId: SignedDocumentRef.generateFirstRef(),
            ),
          },
          isProposalFinal: true,
        );

        expect(
          result.map((c) => c.status).toList(),
          equals([
            ProposalsCollaborationStatus.pending,
            ProposalsCollaborationStatus.pending,
            ProposalsCollaborationStatus.accepted,
            ProposalsCollaborationStatus.rejected,
          ]),
        );
      },
    );

    test(
      'sets collaborators status as left when he is an author of proposal ',
      () {
        final result = ProposalDataCollaborator.resolveCollaboratorStatuses(
          currentCollaborators: [],
          prevCollaborators: [collaborator1Id],
          prevAuthors: [collaborator1Id],
          isProposalFinal: false,
        );

        expect(
          result.map((c) => c.status).toList(),
          equals([
            ProposalsCollaborationStatus.left,
          ]),
        );
      },
    );

    test(
      'sets collaborators status as removed when he is not the author of proposal '
      'and is absent in collaborators list',
      () {
        final result = ProposalDataCollaborator.resolveCollaboratorStatuses(
          currentCollaborators: [],
          prevCollaborators: [collaborator1Id],
          prevAuthors: [authorCatalystId],
          isProposalFinal: false,
        );

        expect(
          result.map((c) => c.status).toList(),
          equals([
            ProposalsCollaborationStatus.removed,
          ]),
        );
      },
    );

    test(
      'sets collaborators status as removed when he is not the author of proposal '
      'and is absent in collaborators list but he accepted invitation',
      () {
        final result = ProposalDataCollaborator.resolveCollaboratorStatuses(
          currentCollaborators: [],
          prevCollaborators: [collaborator1Id],
          prevAuthors: [authorCatalystId],
          collaboratorsActions: {
            collaborator1Id.toSignificant(): RawCollaboratorAction(
              action: ProposalSubmissionAction.draft,
              id: collaborator1Id,
              proposalId: SignedDocumentRef.generateFirstRef(),
            ),
          },
          isProposalFinal: false,
        );

        expect(
          result.map((c) => c.status).toList(),
          equals([
            ProposalsCollaborationStatus.removed,
          ]),
        );
      },
    );

    test(
      'sets collaborators status as left when he is the author of proposal '
      'and is absent in collaborators list but he accepted invitation',
      () {
        final result = ProposalDataCollaborator.resolveCollaboratorStatuses(
          currentCollaborators: [],
          prevCollaborators: [collaborator1Id],
          prevAuthors: [collaborator1Id],
          collaboratorsActions: {
            collaborator1Id.toSignificant(): RawCollaboratorAction(
              action: ProposalSubmissionAction.draft,
              id: collaborator1Id,
              proposalId: SignedDocumentRef.generateFirstRef(),
            ),
          },
          isProposalFinal: false,
        );

        expect(
          result.map((c) => c.status).toList(),
          equals([
            ProposalsCollaborationStatus.left,
          ]),
        );
      },
    );
  });
}

Uint8List _generateKeyBytes(int seed) {
  final random = Random(seed);
  return Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
}
