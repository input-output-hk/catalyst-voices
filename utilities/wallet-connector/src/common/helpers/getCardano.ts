import type { WalletCollections } from "types/cardano";

export default function getCardano<T extends string | undefined>(walletName?: T): T extends string ? WalletCollections[string] : WalletCollections {
  return walletName
    ? globalThis.cardano[walletName]
    : globalThis.cardano;
}