import { WalletApi } from "@cardano-sdk/cip30";
import { ExtractedWalletApi } from "types/cardano";

export default async function extractApiData(api: WalletApi): Promise<ExtractedWalletApi> {
  return {
    networkId: await api.getNetworkId(),
    utxos: await api.getUtxos(),
    balance: await api.getBalance(),
    collateral: await api.getCollateral(),
    usedAddresses: await api.getUsedAddresses(),
    unusedAddresses: await api.getUnusedAddresses(),
    changeAddress: await api.getChangeAddress(),
    rewardAddresses: await api.getRewardAddresses(),
    signTx: api.signTx,
    signData: api.signData,
    submitTx: api.submitTx,
  };
}