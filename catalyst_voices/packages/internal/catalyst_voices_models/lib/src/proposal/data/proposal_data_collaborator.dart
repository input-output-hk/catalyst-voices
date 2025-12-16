import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

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
    List<CatalystId> currentCollaborators = const [],
    Map<CatalystId, RawCollaboratorAction> collaboratorsActions = const {},
    List<CatalystId> prevCollaborators = const [],
    List<CatalystId> prevAuthors = const [],
  }) {
    final currentCollaboratorsStatuses = currentCollaborators.map((id) {
      return ProposalDataCollaborator.fromAction(
        id: id,
        action: collaboratorsActions[id.toSignificant()]?.action,
        isProposalFinal: isProposalFinal,
      );
    });

    final missingCollaborators = prevCollaborators.where(
      (prev) => currentCollaborators.none((current) => prev.isSameAs(current)),
    );

    final missingCollaboratorsStatuses = missingCollaborators.map((id) {
      final didAuthorPrevVersion = prevAuthors.any((author) => author.isSameAs(id));
      // If they authored the previous version, they left voluntarily.
      // Otherwise, they were removed by someone else.
      final status = didAuthorPrevVersion
          ? ProposalsCollaborationStatus.left
          : ProposalsCollaborationStatus.removed;
      return ProposalDataCollaborator(id: id, status: status);
    });

    return [
      ...missingCollaboratorsStatuses,
      ...currentCollaboratorsStatuses,
    ];
  }
}
