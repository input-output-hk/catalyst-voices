import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ProposalDataCollaborator extends Equatable {
  final CatalystId id;
  final ProposalsCollaborationStatus status;

  const ProposalDataCollaborator({required this.id, required this.status});

  /// Creates a collaborator with status derived from the submission action.
  ///
  /// Status mapping:
  /// - `null` action → [ProposalsCollaborationStatus.pending]
  /// - [ProposalSubmissionAction.aFinal] → [ProposalsCollaborationStatus.accepted]
  /// - [ProposalSubmissionAction.draft] when proposal is final → [ProposalsCollaborationStatus.pending]
  /// - [ProposalSubmissionAction.draft] when proposal is draft → [ProposalsCollaborationStatus.accepted]
  /// - [ProposalSubmissionAction.hide] → [ProposalsCollaborationStatus.rejected]
  factory ProposalDataCollaborator.fromAction({
    required CatalystId id,
    required ProposalSubmissionAction? action,
    required bool isProposalFinal,
  }) {
    final status = switch (action) {
      null => ProposalsCollaborationStatus.pending,
      ProposalSubmissionAction.aFinal => ProposalsCollaborationStatus.accepted,
      // When proposal is final, draft action does not mean it's accepted
      ProposalSubmissionAction.draft when isProposalFinal => ProposalsCollaborationStatus.pending,
      ProposalSubmissionAction.draft => ProposalsCollaborationStatus.accepted,
      ProposalSubmissionAction.hide => ProposalsCollaborationStatus.rejected,
    };

    return ProposalDataCollaborator(id: id, status: status);
  }

  @override
  List<Object?> get props => [id, status];

  static List<ProposalDataCollaborator> resolveCollaboratorStatuses({
    required bool isProposalFinal,
    Map<CatalystId, RawCollaboratorAction> collaboratorsActions = const {},
    List<CatalystId> originalAuthor = const [],
    List<CatalystId> prevCollaborators = const [],
    List<CatalystId> prevAuthors = const [],
  }) {
    final significantPrevCollaborators = prevCollaborators.toSignificant();
    final significantOriginalAuthor = originalAuthor.toSignificant();
    final significantPrevAuthors = prevAuthors.toSignificant();

    final collaboratorsStatuses = <ProposalDataCollaborator>[];
    for (final collaborator in collaboratorsActions.keys) {
      final significantCollaborator = collaborator.toSignificant();
      // collaborator was removed from list and original authors are the same
      if (!significantPrevCollaborators.contains(significantCollaborator) &&
          listEquals(significantOriginalAuthor, significantPrevAuthors)) {
        collaboratorsStatuses.add(
          ProposalDataCollaborator(id: collaborator, status: ProposalsCollaborationStatus.removed),
        );
        // collaborator was removed from the list and original author is not the same as prev Author
      } else if (!significantPrevCollaborators.contains(significantCollaborator) &&
          !listEquals(significantOriginalAuthor, significantPrevAuthors)) {
        collaboratorsStatuses.add(
          ProposalDataCollaborator(id: collaborator, status: ProposalsCollaborationStatus.left),
        );
      } else {
        collaboratorsStatuses.add(
          ProposalDataCollaborator.fromAction(
            id: collaborator,
            action: collaboratorsActions[significantCollaborator]?.action,
            isProposalFinal: isProposalFinal,
          ),
        );
      }
    }
    return collaboratorsStatuses;
  }
}

extension on List<CatalystId> {
  List<CatalystId> toSignificant() => map((e) => e.toSignificant()).toList();
}
