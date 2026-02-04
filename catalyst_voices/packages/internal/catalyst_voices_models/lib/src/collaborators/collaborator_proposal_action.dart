enum CollaboratorProposalAction {
  /// The user wishes to accept the invitation to become a collaborator on a proposal.
  acceptInvitation,

  /// The user wishes to reject the invitation to become a collaborator on a proposal.
  rejectInvitation,

  /// The user wishes to leave proposal in which is already collaborator
  leaveProposal,

  /// The user wishes to accept the final proposal submission.
  acceptFinal,

  /// The user wishes to reject the final proposal submission.
  rejectFinal,
}
