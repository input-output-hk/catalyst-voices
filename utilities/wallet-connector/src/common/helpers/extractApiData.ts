import type { WalletApi } from "@cardano-sdk/cip30";

import type { ExtractedWalletApi } from "types/cardano";

export default async function extractApiData(api: WalletApi): Promise<ExtractedWalletApi> {
  const safeTry = async <T>(fn: () => Promise<T>): Promise<T> => {
    try {
      return await fn();
    } catch (err) {
      return `Failed: ${String(err)}` as T;
    }
  };
  
  return {
    networkId: await safeTry(api.getNetworkId),
    utxos: await safeTry(api.getUtxos),
    balance: await safeTry(api.getBalance),
    collateral: await safeTry(api.getCollateral),
    usedAddresses: await safeTry(api.getUsedAddresses),
    unusedAddresses: await safeTry(api.getUnusedAddresses),
    changeAddress: await safeTry(api.getChangeAddress),
    rewardAddresses: await safeTry(api.getRewardAddresses),
    signTx: api.signTx,
    signData: api.signData,
    submitTx: api.submitTx,
  };
}