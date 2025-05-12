enum ProposalPublish implements Comparable<ProposalPublish> {
  /// A proposal has not yet been published,
  /// it's stored only in the local storage.
  localDraft,

  /// A proposal has been published as a draft.
  publishedDraft,

  /// A proposal has been published and submitted into review.
  ///
  /// After the review stage is done the proposal will be live
  /// with no additional proposer action.
  submittedProposal;

  bool get isDraft => this == publishedDraft;

  bool get isLocal => this == localDraft;

  bool get isPublished => this == submittedProposal;

  /// Sorts in reverse order to how the [ProposalStatus] enums are declared.
  @override
  int compareTo(ProposalPublish other) {
    return other.index.compareTo(index);
  }
}

// Note. This enum may be deleted later. Its here for backwards compatibility.
enum ProposalStatus { ready, draft, inProgress, private, open, live, completed }

enum ProposalSubmissionAction {
  /// Moves the proposal to review.
  ///
  /// After this action the proposal status
  /// will be [ProposalPublish.submittedProposal].
  aFinal,

  /// Reverts the proposal from [ProposalPublish.submittedProposal]
  /// to [ProposalPublish.publishedDraft].
  draft,

  /// Requests the proposal be hidden (not final, but a hidden draft).
  /// `hide` is only actioned if sent by the author,
  /// for a collaborator its synonymous with `draft`.
  hide,
}
