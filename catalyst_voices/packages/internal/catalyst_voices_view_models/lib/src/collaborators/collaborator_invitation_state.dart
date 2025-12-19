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
