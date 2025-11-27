enum ProposalsCollaborationStatus {
  accepted,
  rejected,
  pending;

  const ProposalsCollaborationStatus();

  bool get isAccepted => this == ProposalsCollaborationStatus.accepted;
}
