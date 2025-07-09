import { BrowserExtensionName } from "../models/browserExtensionModel";
import { WalletConfigModel } from "../models/walletConfigModel";
import { getBrowserExtension } from "./browserExtensionConfigs";

export const walletConfigs: WalletConfigModel[] = [
  {
    id: "1",
    extension: getBrowserExtension(BrowserExtensionName.Lace),
    seed: [
      "stomach",
      "horn",
      "rail",
      "afraid",
      "flip",
      "also",
      "abandon",
      "speed",
      "chaos",
      "daring",
      "soon",
      "soft",
      "okay",
      "online",
      "benefit",
    ],
    username: "test123",
    password: "test12345678@",
    cipBridge: ["cip-95"],
  },
  {
    id: "2",
    extension: getBrowserExtension(BrowserExtensionName.Eternl),
    seed: [
      "stomach",
      "horn",
      "rail",
      "afraid",
      "flip",
      "also",
      "abandon",
      "speed",
      "chaos",
      "daring",
      "soon",
      "soft",
      "okay",
      "online",
      "benefit",
    ],
    username: "test123",
    password: "test12345678@!!",
    cipBridge: ["cip-30", "cip-95"],
  },
  {
    id: "3",
    extension: getBrowserExtension(BrowserExtensionName.Yoroi),
    seed: [
      "stomach",
      "horn",
      "rail",
      "afraid",
      "flip",
      "also",
      "abandon",
      "speed",
      "chaos",
      "daring",
      "soon",
      "soft",
      "okay",
      "online",
      "benefit",
    ],
    username: "test123",
    password: "test12345678@!!",
    cipBridge: ["cip-95"],
  },
  {
    id: "4",
    extension: getBrowserExtension(BrowserExtensionName.Nufi),
    seed: [
      "stomach",
      "horn",
      "rail",
      "afraid",
      "flip",
      "also",
      "abandon",
      "speed",
      "chaos",
      "daring",
      "soon",
      "soft",
      "okay",
      "online",
      "benefit",
    ],
    username: "test123",
    password: "test12345678@!!",
    cipBridge: ["cip-95"],
  },
];

export const getWalletConfig = (id: string): WalletConfigModel => {
  const walletConfig = walletConfigs.find(
    (walletConfig) => walletConfig.id === id
  );
  if (!walletConfig) {
    throw new Error(`Wallet config with id ${id} not found`);
  }
  return walletConfig;
};

export const getWalletConfigs = (): WalletConfigModel[] => walletConfigs;
