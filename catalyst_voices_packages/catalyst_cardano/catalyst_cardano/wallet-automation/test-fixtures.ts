import { test as base, BrowserContext, chromium } from '@playwright/test';
import { allowExtension, onboardWallet, WalletConfig } from './utils/wallets/walletUtils';
import { BrowserExtensionName } from './utils/extensions';
import { ExtensionDownloader } from './utils/extensionDownloader';

type MyFixtures = {
  enableWallet: (walletConfig: WalletConfig) => Promise<void>;
  installExtension: (extensionName: BrowserExtensionName) => Promise<BrowserContext>;
};

export const test = base.extend<MyFixtures>({
  enableWallet: async ({ installExtension }, use) => {
    await use(async (walletConfig: WalletConfig) => {
      const browser = await installExtension(walletConfig.extension.Name);
      const extensionTab = await browser.newPage();
      await extensionTab.goto(walletConfig.extension.HomeUrl);
      await onboardWallet(extensionTab, walletConfig);
      await extensionTab.goto('/')
      // Typical way of handling popups
      const [walletPopup] = await Promise.all([
        browser.waitForEvent('page'),
        // Trigger the action that opens the wallet window
        extensionTab.locator('//*[text()="Enable wallet"]').click()
      ]);
      // const popupPromise = page.waitForEvent('popup');
      // await extensionTab.locator('//*[text()="Enable wallet"]').click();
      await allowExtension(walletPopup, walletConfig.extension.Name);
    });
  },

  installExtension: async ({ }, use) => {
    await use(async (extensionName: BrowserExtensionName) => {
      const extensionPath = await new ExtensionDownloader().getExtension(extensionName);
      const browser = await chromium.launchPersistentContext('', {
        headless: false, // extensions only work in headfull mode
        args: [
            `--disable-extensions-except=${extensionPath}`,
            `--load-extension=${extensionPath}`,
        ],
    });
    let [background] = browser.serviceWorkers();
    if (!background)
    background = await browser.waitForEvent('serviceworker');
    return browser;
    });
  }
});