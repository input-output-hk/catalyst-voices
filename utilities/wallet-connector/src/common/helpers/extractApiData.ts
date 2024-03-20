import type { WalletApi } from "@cardano-sdk/cip30";
import { camelCase, mapValues } from "lodash-es";

export default async function extractApiData(api: WalletApi, cipExt?: number): Promise<any> {
  const safeTry = async <T>(fn: () => Promise<T>): Promise<T> => {
    try {
      return await fn();
    } catch (err) {
      return `Failed: ${String(err)}` as T;
    }
  };

  let extData = {};
  if (typeof cipExt === "number") {
    const out = [];
    for (const [key, value] of Object.entries((api as any)[`cip${cipExt}`] ?? {})) {
      if (key.startsWith("get") && value instanceof Function) {
        out.push([
          camelCase(key.slice(3)),
          {
            from: `cip${cipExt}`,
            value: await value?.()
          }
        ]);
      }
    }
    extData = Object.fromEntries(out);
  }

  return {
    ...api,
    info: {
      ...mapValues({
        networkId: await safeTry(api.getNetworkId),
        utxos: await safeTry(api.getUtxos),
        balance: await safeTry(api.getBalance),
        collateral: await safeTry(api.getCollateral),
        usedAddresses: await safeTry(api.getUsedAddresses),
        unusedAddresses: await safeTry(api.getUnusedAddresses),
        changeAddress: await safeTry(api.getChangeAddress),
        rewardAddresses: await safeTry(api.getRewardAddresses),
      }, (v) => ({ from: "cip30", value: v })),
      ...extData
    }
  };
}
