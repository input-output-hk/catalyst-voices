/// Describes the link wallet flow during registration.
enum WalletLinkStage {
  /// The welcome screen for the link wallet flow.
  intro,

  /// A screen where the user is asked to connect the cardano wallet.
  selectWallet,

  /// Wallet details after successfully connecting a wallet.
  walletDetails,

  /// A user is asked to select the user roles.
  rolesChooser,

  /// Summary of chosen user roles.
  rolesSummary,

  /// The user submits an RBAC transaction to finish the registration.
  rbacTransaction,
}
