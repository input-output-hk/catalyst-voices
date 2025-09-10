import path from "path";
import dotenv from "dotenv";
dotenv.config({
  path: path.join(process.cwd(), "catalyst_voices/apps/voices/e2e_tests/.env"),
});

import { test as base, BrowserContext } from "@playwright/test";

import {
  connectToBrowser,
  getDynamicUrlInChrome,
  closeBrowserWithExtension,
} from "../utils/browser-extension";
import { createWalletActions } from "../utils/wallets/wallet-actions-factory";
import { BrowserExtensionName } from "../models/browserExtensionModel";
import { TestModel } from "../models/testModel";
import { getAccountModel } from "../data/accountConfigs";
import { getWalletConfigByName } from "../data/walletConfigs";

type BrowserFixtures = {
  testModel: TestModel;
  launchBrowser: BrowserContext;
  restoreWallet: BrowserContext;
};

export const test = base.extend<BrowserFixtures>({
  testModel: [
    new TestModel(
      getAccountModel("DummyForTesting"),
      getWalletConfigByName("Lace")
    ),
    { option: true },
  ],
  launchBrowser: async ({ testModel }, use) => {
    
    const chromePath = process.env.CHROME_PATH;
    if (!chromePath) {
      throw new Error("CHROME_PATH is not set");
    }
    let browser: BrowserContext;
    if (
      testModel.walletConfig.extension.Name === BrowserExtensionName.NoExtension
    ) {
      browser = await connectToBrowser(chromePath);
    } else {
      browser = await connectToBrowser(
        chromePath,
        testModel.walletConfig.extension.Name
      );
    }
    browser.grantPermissions(["clipboard-read", "clipboard-write"]);
    await use(browser);
    await closeBrowserWithExtension(browser);
  },

  restoreWallet: async ({ launchBrowser, testModel }, use) => {
    const extensionTab = launchBrowser.pages()[0];
    testModel.walletConfig.extension.HomeUrl = await getDynamicUrlInChrome(
      extensionTab,
      testModel.walletConfig
    );
    await extensionTab.goto(testModel.walletConfig.extension.HomeUrl);
    await createWalletActions(
      testModel.walletConfig,
      extensionTab
    ).restoreWallet();

    await use(launchBrowser);
  },
});
