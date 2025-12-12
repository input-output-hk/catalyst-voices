enum ProposalsCollaborationStatus {
  /// The invitation is pending, the collaborator needs to accept / reject.
  pending,

  /// The invitation is accepted by the collaborator.
  accepted,

  /// The invitation is rejected by the collaborator.
  rejected,

  /// The collaborator has accepted and then left.
  left,

  /// The collaborator has been removed.
  removed,

  /// The user is the original author of the proposal.
  mainProposer;

  const ProposalsCollaborationStatus();

  bool get isAccepted => this == ProposalsCollaborationStatus.accepted;
}
