import { BrowserExtensionName } from "../models/browserExtensionModel";
import { WalletConfigModel } from "../models/walletConfigModel";
import { getBrowserExtension } from "./browserExtensionConfigs";
// cspell: disable
export const walletConfigs: WalletConfigModel[] = [
  {
    name: "Lace",
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
    network: "preprod",
    username: "test123",
    password: "Test12345678@!!",
    cipBridge: ["cip-95"],
    mainAddress:
      "addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg55r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4ywuzuny7p7csr9kx9g",
    stakeAddress: "stake_test1up0ugh5h0nrezdv62uaaxuq0ha7c5p02pu2j8wpwfj0qlvg2det9t",
  },
  {
    name: "Eternl",
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
    network: "preprod",
    username: "test123",
    password: "Test12345678@!!",
    cipBridge: ["cip-30", "cip-95"],
    mainAddress:
      "addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg55r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4ywuzuny7p7csr9kx9g",
    stakeAddress: "stake_test1up0ugh5h0nrezdv62uaaxuq0ha7c5p02pu2j8wpwfj0qlvg2det9t",
  },
  {
    name: "Yoroi",
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
    network: "preprod",
    username: "test123",
    password: "Test12345678@!!",
    cipBridge: ["cip-95"],
    mainAddress:
      "addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg55r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4ywuzuny7p7csr9kx9g",
    stakeAddress: "stake_test1up0ugh5h0nrezdv62uaaxuq0ha7c5p02pu2j8wpwfj0qlvg2det9t",
  },
  {
    name: "Nufi",
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
    network: "preprod",
    username: "test123",
    password: "Test12345678@!!",
    cipBridge: ["cip-95"],
    mainAddress:
      "addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg55r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4ywuzuny7p7csr9kx9g",
    stakeAddress: "stake_test1up0ugh5h0nrezdv62uaaxuq0ha7c5p02pu2j8wpwfj0qlvg2det9t",
  },
  {
    name: "Vespr",
    extension: getBrowserExtension(BrowserExtensionName.Vespr),
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
    network: "preprod",
    username: "test123",
    password: "Test12345678@!!",
    cipBridge: ["cip-95"],
    mainAddress:
      "addr_test1qq2fckuzdvxu074ngumdkwn68tuuse67yg55r8exmkwdnn2lc30fwlx8jy6e54em6dcql0ma3gz75rc4ywuzuny7p7csr9kx9g",
    stakeAddress: "stake_test1up0ugh5h0nrezdv62uaaxuq0ha7c5p02pu2j8wpwfj0qlvg2det9t",
  },
];
// cspell: enable

/**
 * Get the wallet config by name
 * @param name - The name of the wallet config
 * @returns The wallet config
 */
export const getWalletConfigByName = (name: string): WalletConfigModel => {
  const walletConfig = walletConfigs.find((walletConfig) => walletConfig.name === name);
  if (!walletConfig) {
    throw new Error(`Wallet config with name ${name} not found`);
  }
  return walletConfig;
};

/**
 * Get the wallet config by extension name
 * @param name - The name of the extension
 * @returns The wallet config
 */
export const getWalletConfigByExtensionName = (name: BrowserExtensionName): WalletConfigModel => {
  const walletConfig = walletConfigs.find((walletConfig) => walletConfig.extension.Name === name);
  if (!walletConfig) {
    throw new Error(`Wallet config with extension name ${name} not found`);
  }
  return walletConfig;
};

/**
 * Get one of each extension
 * @returns One of each extension
 */
export const getOneOfEachExtensions = (): WalletConfigModel[] => {
  return walletConfigs.filter(
    (walletConfig) =>
      walletConfig.extension.Name === BrowserExtensionName.Lace ||
      walletConfig.extension.Name === BrowserExtensionName.Eternl ||
      walletConfig.extension.Name === BrowserExtensionName.Yoroi ||
      walletConfig.extension.Name === BrowserExtensionName.Nufi
  );
};

/**
 * Get all wallet configs
 * @returns All wallet configs
 */
export const getWalletConfigs = (): WalletConfigModel[] => walletConfigs;
