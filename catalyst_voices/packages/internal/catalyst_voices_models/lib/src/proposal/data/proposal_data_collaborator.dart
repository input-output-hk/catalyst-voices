import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class ProposalDataCollaborator extends Equatable {
  final CatalystId id;
  final ProposalsCollaborationStatus status;
  final ProposalInvitationStatus invitation;
  final DateTime? createdAt;

  const ProposalDataCollaborator({
    required this.id,
    required this.status,
    required this.invitation,
    required this.createdAt,
  });

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
    required RawCollaboratorAction? rawAction,
    required bool isProposalFinal,
    required DocumentRef proposalId,
  }) {
    final action = proposalId.id != rawAction?.proposalId.id ? null : rawAction?.action;

    // if proposal is final and actions is for different version we should skip it and
    // consider no action which affects status.
    final statusAction = isProposalFinal && rawAction?.proposalId != proposalId ? null : action;

    final status = switch (statusAction) {
      null => ProposalsCollaborationStatus.pending,
      ProposalSubmissionAction.aFinal => ProposalsCollaborationStatus.accepted,
      // When proposal is final, draft action does not mean it's accepted
      ProposalSubmissionAction.draft when isProposalFinal => ProposalsCollaborationStatus.pending,
      ProposalSubmissionAction.draft => ProposalsCollaborationStatus.accepted,
      ProposalSubmissionAction.hide => ProposalsCollaborationStatus.rejected,
    };

    final invitation = switch (action) {
      null => ProposalInvitationStatus.pending,
      ProposalSubmissionAction.aFinal ||
      ProposalSubmissionAction.draft => ProposalInvitationStatus.accepted,
      ProposalSubmissionAction.hide => ProposalInvitationStatus.rejected,
    };

    return ProposalDataCollaborator(
      id: id,
      status: status,
      invitation: invitation,
      createdAt: rawAction?.actionId.id.dateTime,
    );
  }

  @override
  List<Object?> get props => [id, status, createdAt];

  static List<ProposalDataCollaborator> resolveCollaboratorStatuses({
    required bool isProposalFinal,
    required DocumentRef proposalId,
    List<CatalystId> currentCollaborators = const [],
    Map<CatalystId, RawCollaboratorAction> collaboratorsActions = const {},
    List<CatalystId> prevCollaborators = const [],
    List<CatalystId> prevAuthors = const [],
    DateTime? createdAt,
  }) {
    final currentCollaboratorsStatuses = currentCollaborators.map((id) {
      final collaboratorAction = collaboratorsActions[id.toSignificant()];
      return ProposalDataCollaborator.fromAction(
        id: id,
        rawAction: collaboratorAction,
        isProposalFinal: isProposalFinal,
        proposalId: proposalId,
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

      return ProposalDataCollaborator(
        id: id,
        status: status,
        invitation: ProposalInvitationStatus.rejected,
        createdAt: createdAt,
      );
    });

    return [
      ...missingCollaboratorsStatuses,
      ...currentCollaboratorsStatuses,
    ];
  }
}
