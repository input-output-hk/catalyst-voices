import { pickBy } from "lodash-es";
import type { WalletCollections } from "types/cardano";

export default function getCardano<T extends string | undefined>(
  walletName?: T
): T extends string ? WalletCollections[string] : WalletCollections {
  return (walletName ? globalThis.cardano[walletName] : filterPolluteObjects(globalThis.cardano)) as T extends string
    ? WalletCollections[string]
    : WalletCollections;
}

function filterPolluteObjects(cardano: any): WalletCollections {
  return pickBy(cardano, (v) => typeof v === "object" && "enable" in v)
}
