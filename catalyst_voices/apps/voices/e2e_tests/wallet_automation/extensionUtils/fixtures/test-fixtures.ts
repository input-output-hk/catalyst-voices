import { test as base, BrowserContext } from "@playwright/test";

import { getDynamicUrlInChrome, installExtension } from "./setup-ext";
import { onboardWallet, WalletConfig } from "../wallets/walletUtils";
import { BrowserExtensionName } from "../extensions";

type MyFixtures = {
  restoreWallet: (walletConfig: WalletConfig) => Promise<BrowserContext>;
};

export const test = base.extend<MyFixtures>({
  restoreWallet: async ({}, use) => {
    const restoreWalletFn = async (walletConfig: WalletConfig) => {
      const browser = await installExtension(BrowserExtensionName.Lace);
      const extensionTab = browser.pages()[0];
      walletConfig.extension.HomeUrl = await getDynamicUrlInChrome(
        extensionTab,
        walletConfig
      );
      await extensionTab.goto(walletConfig.extension.HomeUrl);
      const address = await onboardWallet(extensionTab, walletConfig);
      return browser;
    };

    // Provide the function to the test
    await use(restoreWalletFn);
  },
});
