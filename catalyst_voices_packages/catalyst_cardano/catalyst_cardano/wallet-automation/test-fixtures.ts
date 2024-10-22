import { test as base, BrowserContext, chromium, Page } from '@playwright/test';
import { allowExtension, onboardWallet, WalletConfig } from './utils/wallets/walletUtils';
import { BrowserExtensionName } from './utils/extensions';
import { ExtensionDownloader } from './utils/extensionDownloader';
import { HomePage } from './pages/homePage';

type MyFixtures = {
  enableWallet: (walletConfig: WalletConfig) => Promise<BrowserContext>;
  installExtension: (extensionName: BrowserExtensionName) => Promise<BrowserContext>;
};

export const test = base.extend<MyFixtures>({
  enableWallet: async ({ installExtension }, use) => {
    let browser: BrowserContext | null = null;

    const enableWalletFn = async (walletConfig: WalletConfig) => {
      browser = await installExtension(walletConfig.extension.Name);
      const extensionTab = browser.pages()[0];
      await extensionTab.goto(walletConfig.extension.HomeUrl);
      await onboardWallet(extensionTab, walletConfig);
      await extensionTab.goto('/');
      await extensionTab.waitForTimeout(4000);
      const [walletPopup] = await Promise.all([
        browser.waitForEvent('page'),
        extensionTab.locator('//*[text()="Enable wallet"]').click(),
      ]);
      await walletPopup.waitForTimeout(2000);
      await allowExtension(walletPopup, walletConfig.extension.Name);
      await extensionTab.waitForTimeout(2000);
      await extensionTab.reload();
      //await new HomePage(extensionTab).balanceLabel.waitFor({ state: 'visible' });
      return browser;
    };
  
    // Provide the function to the test
    await use(enableWalletFn);

    if(browser) {
      await browser.close();
    }
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