enum ProposalInvitationStatus {
  /// No action from collaborator for proposal's (id)  any version
  pending,

  /// Latest action from collaborator for proposal (id) is draft or final
  accepted,

  /// Latest action from collaborator for proposal (id) is hide
  rejected;

  const ProposalInvitationStatus();

  bool get isAccepted => this == ProposalInvitationStatus.accepted;
}
