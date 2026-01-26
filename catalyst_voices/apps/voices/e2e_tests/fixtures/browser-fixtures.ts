import path from "path";
import dotenv from "dotenv";
dotenv.config({
  path: path.join(process.cwd(), "catalyst_voices/apps/voices/e2e_tests/.env"),
});

import { test as base, BrowserContext, chromium } from "@playwright/test";

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
import { ExtensionDownloader } from "../utils/extensionDownloader";

type BrowserFixtures = {
  testModel: TestModel;
  launchBrowser: BrowserContext;
  useBrowser: BrowserContext;
  restoreWallet: BrowserContext;
};

export const test = base.extend<BrowserFixtures>({
  testModel: [
    new TestModel(getAccountModel("DummyForTesting"), getWalletConfigByName("Eternl")),
    { option: true },
  ],
  launchBrowser: async ({ testModel }, use) => {
    const chromePath = process.env.CHROME_PATH;
    if (!chromePath) {
      throw new Error("CHROME_PATH is not set");
    }
    let browser: BrowserContext;
    if (testModel.walletConfig.extension.Name === BrowserExtensionName.NoExtension) {
      browser = await connectToBrowser(chromePath);
    } else {
      browser = await connectToBrowser(chromePath, testModel.walletConfig.extension.Name);
    }
    browser.grantPermissions(["clipboard-read", "clipboard-write"]);
    await use(browser);
    await closeBrowserWithExtension(browser);
  },

  // This is Playwright browser to run extension without downloading separate browser
  useBrowser: async ({ testModel }, use) => {
    const extensionPath = await new ExtensionDownloader().getExtension(
      testModel.walletConfig.extension.Name
    );
    const browser = await chromium.launchPersistentContext("", {
      headless: false,
      ignoreHTTPSErrors: true,
      args: [
        "--remote-debugging-port=9222",
        "--no-first-run",
        "--no-default-browser-check",
        `--disable-extensions-except=${extensionPath}`,
        `--load-extension=${extensionPath}`,
        // Docker-specific flags for stability
        "--no-sandbox",
        "--disable-setuid-sandbox",
        "--disable-dev-shm-usage",
        "--disable-gpu",
      ],
    });
    await browser.grantPermissions(["clipboard-read", "clipboard-write"]);
    await use(browser);
    await browser.close();
  },

  restoreWallet: async ({ useBrowser, testModel }, use) => {
    const extensionTab = useBrowser.pages()[0];
    testModel.walletConfig.extension.HomeUrl = await getDynamicUrlInChrome(
      extensionTab,
      testModel.walletConfig
    );
    await extensionTab.goto(testModel.walletConfig.extension.HomeUrl);
    await createWalletActions(testModel.walletConfig, extensionTab).restoreWallet();

    await use(useBrowser);
  },
});
