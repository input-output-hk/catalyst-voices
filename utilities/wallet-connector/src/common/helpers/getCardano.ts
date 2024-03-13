import { Cip30Wallet } from "@cardano-sdk/cip30";

type WalletCollections = {
  [k: string]: Cip30Wallet;
};

export default function getCardano<T extends string>(walletName?: T): T extends string ? Cip30Wallet : WalletCollections {
  return walletName
    ? globalThis.cardano[walletName]
    : globalThis.cardano;
}