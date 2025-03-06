enum ProposalPublish {
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
}

// Note. This enum may be deleted later. Its here for backwards compatibility.
enum ProposalStatus { ready, draft, inProgress, private, open, live, completed }
