import path from "path";
import dotenv from "dotenv";
dotenv.config({
  path: path.join(process.cwd(), "catalyst_voices/apps/voices/e2e_tests/.env"),
});

import { test as base, BrowserContext } from "@playwright/test";

import {
  connectToBrowser,
  getDynamicUrlInChrome,
} from "../utils/browser-extension";
import { WalletConfigModel } from "../models/walletConfigModel";
import { onboardWallet } from "../utils/wallets/walletActions";

type WalletFixtures = {
  restoreWallet: (walletConfig: WalletConfigModel) => Promise<BrowserContext>;
};

export const test = base.extend<WalletFixtures>({
  restoreWallet: async ({}, use) => {
    const restoreWalletFn = async (walletConfig: WalletConfigModel) => {
      const chromePath = process.env.CHROME_PATH;
      if (!chromePath) {
        throw new Error("CHROME_PATH is not set");
      }
      const browser = await connectToBrowser(
        walletConfig.extension.Name,
        chromePath
      );
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
