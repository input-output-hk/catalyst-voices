import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class AcceptedCollaboratorInvitationState extends CollaboratorInvitationState {
  const AcceptedCollaboratorInvitationState();
}

final class AcceptedFinalProposalConsentState extends CollaboratorFinalProposalConsentState {
  const AcceptedFinalProposalConsentState();
}

sealed class CollaboratorFinalProposalConsentState extends CollaboratorProposalState {
  const CollaboratorFinalProposalConsentState();
}

sealed class CollaboratorInvitationState extends CollaboratorProposalState {
  const CollaboratorInvitationState();
}

sealed class CollaboratorProposalState extends Equatable {
  const CollaboratorProposalState();

  /// Creates a [CollaboratorProposalState] from collaborator data.
  ///
  /// Determines the appropriate state based on:
  /// - Whether the active account is a collaborator
  /// - The collaborator's status
  /// - Whether the proposal is final or draft
  factory CollaboratorProposalState.fromCollaboratorData({
    required List<ProposalDataCollaborator> collaborators,
    required CatalystId? activeAccountId,
    required bool isFinal,
  }) {
    // If no active account, user is not a collaborator
    if (activeAccountId == null) {
      return const NoneCollaboratorProposalState();
    }

    // Find the collaborator matching the active account
    final collaborator = collaborators.firstWhereOrNull(
      (c) => c.id.isSameAs(activeAccountId),
    );

    // If not found in collaborators list, return None
    if (collaborator == null) {
      return const NoneCollaboratorProposalState();
    }

    // Handle edge cases (mainProposer, left, removed)
    if (collaborator.status == ProposalsCollaborationStatus.mainProposer ||
        collaborator.status == ProposalsCollaborationStatus.left ||
        collaborator.status == ProposalsCollaborationStatus.removed) {
      return const NoneCollaboratorProposalState();
    }

    // Map status to appropriate state based on proposal finality
    return switch (collaborator.status) {
      ProposalsCollaborationStatus.accepted when isFinal =>
        const AcceptedFinalProposalConsentState(),
      ProposalsCollaborationStatus.accepted => const AcceptedCollaboratorInvitationState(),
      ProposalsCollaborationStatus.rejected when isFinal =>
        const RejectedCollaboratorFinalProposalConsentState(),
      ProposalsCollaborationStatus.rejected => const RejectedCollaboratorInvitationState(),
      ProposalsCollaborationStatus.pending when isFinal =>
        const PendingCollaboratorFinalProposalConsentState(),
      ProposalsCollaborationStatus.pending => const PendingCollaboratorInvitationState(),
      _ => const NoneCollaboratorProposalState(),
    };
  }

  @override
  List<Object?> get props => [];
}

final class NoneCollaboratorProposalState extends CollaboratorProposalState {
  const NoneCollaboratorProposalState();
}

final class PendingCollaboratorFinalProposalConsentState
    extends CollaboratorFinalProposalConsentState {
  const PendingCollaboratorFinalProposalConsentState();
}

final class PendingCollaboratorInvitationState extends CollaboratorInvitationState {
  const PendingCollaboratorInvitationState();
}

final class RejectedCollaboratorFinalProposalConsentState
    extends CollaboratorFinalProposalConsentState {
  const RejectedCollaboratorFinalProposalConsentState();
}

final class RejectedCollaboratorInvitationState extends CollaboratorInvitationState {
  const RejectedCollaboratorInvitationState();
}
