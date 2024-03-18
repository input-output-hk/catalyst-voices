import * as cip30 from "@cardano-sdk/cip30";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Extracted<T extends (...args: any) => any> = Awaited<ReturnType<T>>;

export type WalletCollections = {
  [k: string]: Omit<cip30.Cip30Wallet, "enable"> & {
    enable(args: { extensions: { cip: number; }[]; }): Promise<cip30.WalletApi>;
    supportedExtensions: { cip: number; }[];
  };
};

export type ExtensionArguments = {
  cip?: number;
};

export type ExtractedWalletApi = {
  networkId: Extracted<cip30.GetNetworkId>;
  utxos: Extracted<cip30.GetUtxos>;
  balance: Extracted<cip30.GetBalance>;
  collateral: Extracted<cip30.GetCollateral>;
  usedAddresses: Extracted<cip30.GetUsedAddresses>;
  unusedAddresses: Extracted<cip30.GetUnusedAddresses>;
  changeAddress: Extracted<cip30.GetChangeAddress>;
  rewardAddresses: Extracted<cip30.GetRewardAddresses>;
  signTx: cip30.SignTx;
  signData: cip30.SignData;
  submitTx: cip30.SubmitTx;
};