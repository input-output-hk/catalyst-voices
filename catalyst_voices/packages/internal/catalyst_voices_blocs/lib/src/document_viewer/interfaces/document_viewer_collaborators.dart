/// Interface for collaborator-related functionality in document viewers.
abstract interface class DocumentViewerCollaborators {
  /// Accepts a collaborator invitation for the proposal.
  Future<void> acceptCollaboratorInvitation();

  /// Accepts the final proposal consent.
  Future<void> acceptFinalProposal();

  /// Dismisses the collaborator banner.
  void dismissCollaboratorBanner();

  /// Rejects a collaborator invitation.
  Future<void> rejectCollaboratorInvitation();

  /// Rejects the final proposal consent.
  Future<void> rejectFinalProposal();
}
