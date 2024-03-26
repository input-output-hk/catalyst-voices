import type { WalletApi } from "@cardano-sdk/cip30";
import { Address, TransactionUnspentOutput, Value } from "@emurgo/cardano-serialization-lib-asmjs";
import { camelCase, mapValues } from "lodash-es";

import type { ExtractedWalletApi } from "types/cardano";

export default async function extractApiData(
  api: WalletApi & { [ext: `cip${number}`]: unknown },
  cipExt?: number
): Promise<ExtractedWalletApi> {
  const safeTry = async <T>(
    fn: () => Promise<T>,
    transformer?: (v: T) => T
  ): Promise<{ raw: T; formatted: T }> => {
    try {
      const v = await fn();
      return transformer
        ? {
            raw: v,
            formatted: transformer(v),
          }
        : {
            raw: v,
            formatted: v,
          };
    } catch (err) {
      const fmtErr = `Failed: ${String(err)}` as T;
      return {
        raw: fmtErr,
        formatted: fmtErr,
      };
    }
  };

  let extData = {};
  if (typeof cipExt === "number") {
    const out = [];
    for (const [key, value] of Object.entries(api[`cip${cipExt}`] ?? {})) {
      if (key.startsWith("get") && value instanceof Function) {
        const resVal = await value?.();

        out.push([
          camelCase(key.slice(3)),
          {
            from: `cip${cipExt}`,
            raw: resVal,
            value: resVal,
          },
        ]);
      }
    }
    extData = Object.fromEntries(out);
  }

  return {
    ...api,
    info: {
      ...mapValues(
        {
          networkId: await safeTry(api.getNetworkId),
          utxos: await safeTry(api.getUtxos, (v) =>
            v?.map((v) => TransactionUnspentOutput.from_hex(v).to_json())
          ),
          balance: await safeTry(api.getBalance, (v) =>
            Number(Value.from_hex(v).coin().to_str()).toLocaleString("en")
          ),
          collateral: await safeTry(
            api.getCollateral,
            (v) => v?.map((v) => TransactionUnspentOutput.from_hex(v).to_json()) ?? v
          ),
          usedAddresses: await safeTry(
            api.getUsedAddresses,
            (v) => v?.map((v) => Address.from_hex(v).to_bech32()) ?? v
          ),
          unusedAddresses: await safeTry(
            api.getUnusedAddresses,
            (v) => v?.map((v) => Address.from_hex(v).to_bech32()) ?? v
          ),
          changeAddress: await safeTry(api.getChangeAddress, (v) =>
            Address.from_hex(v).to_bech32()
          ),
          rewardAddresses: await safeTry(
            api.getRewardAddresses,
            (v) => v?.map((v) => Address.from_hex(v).to_bech32()) ?? v
          ),
        },
        (v) => ({ from: "cip30", raw: v.raw, value: v.formatted })
      ),
      ...extData,
    },
  };
}
