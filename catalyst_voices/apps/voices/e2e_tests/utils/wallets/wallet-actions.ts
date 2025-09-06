export interface WalletActions {
  restoreWallet: () => Promise<void>;
  connectWallet: () => Promise<void>;
  approveTransaction: () => Promise<void>;
}
