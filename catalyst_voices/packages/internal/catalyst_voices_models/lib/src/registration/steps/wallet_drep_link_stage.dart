enum WalletDrepLinkStage {
  /// A screen where the user is informed about the linked key.
  rolesConfirmation,

  /// A screen where the user is asked to connect the cardano wallet.
  selectWallet,

  /// Wallet and account details after successfully connecting a wallet.
  walletAccountDetails,

  /// The user submits an RBAC transaction to finish the registration.
  rbacTransaction;

  WalletDrepLinkStage? get next {
    final isLast = this == WalletDrepLinkStage.values.last;
    if (isLast) {
      return null;
    }

    return WalletDrepLinkStage.values[index + 1];
  }

  WalletDrepLinkStage? get previous {
    final isFirst = index == 0;
    if (isFirst) {
      return null;
    }

    return WalletDrepLinkStage.values[index - 1];
  }
}
