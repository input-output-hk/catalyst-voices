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
  rbacTransaction;

  WalletLinkStage? get next {
    final isLast = index == WalletLinkStage.values.length - 1;
    if (isLast) {
      return null;
    }

    return WalletLinkStage.values[index + 1];
  }

  WalletLinkStage? get previous {
    final isFirst = index == 0;
    if (isFirst) {
      return null;
    }

    return WalletLinkStage.values[index - 1];
  }
}
