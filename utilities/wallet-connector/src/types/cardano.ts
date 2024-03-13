import * as cip30 from "@cardano-sdk/cip30";

type Extracted<T extends (...args: any) => any> = Awaited<ReturnType<T>>;

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
}