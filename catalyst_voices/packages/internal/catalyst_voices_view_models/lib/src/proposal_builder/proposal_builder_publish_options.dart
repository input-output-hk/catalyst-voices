enum ProposalBuilderPublishOptions {
  /// The user sees and can use the publish options.
  enabled,

  /// The user sees but cannot use publish options until they
  /// are unlocked (i.e. via email verification.
  locked,

  /// The user doesn't see the publish options.
  disabled,
}
