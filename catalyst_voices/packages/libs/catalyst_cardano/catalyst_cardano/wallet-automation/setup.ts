import { BrowserContext, chromium, Page } from "@playwright/test";
import { ExtensionDownloader } from "./utils/extensionDownloader";
import { BrowserExtensionName } from "./utils/extensions";
import {
  allowExtension,
  onboardWallet,
  WalletConfig,
} from "./utils/wallets/walletUtils";

const installExtension = async (extensionName: BrowserExtensionName) => {
  const extensionPath = await new ExtensionDownloader().getExtension(
    extensionName
  );
  const browser = await chromium.launchPersistentContext("", {
    headless: false, // extensions only work in headful mode
    ignoreHTTPSErrors: true,
    args: [
      `--disable-extensions-except=${extensionPath}`,
      `--load-extension=${extensionPath}`,
      "--unsafely-treat-insecure-origin-as-secure=http://test-app:80",
    ],
  });
  let [background] = browser.serviceWorkers();
  if (!background) background = await browser.waitForEvent("serviceworker");
  return browser;
};

export const restoreWallet = async (walletConfig: WalletConfig) => {
  const browser = await installExtension(walletConfig.extension.Name);
  const extensionTab = browser.pages()[0];
  walletConfig.extension.HomeUrl = await getDynamicUrlInChrome(
    extensionTab,
    walletConfig
  );
  await extensionTab.goto(walletConfig.extension.HomeUrl);
  await onboardWallet(extensionTab, walletConfig);
  return browser;
};

export const enableWallet = async (
  walletConfig: WalletConfig,
  browser: BrowserContext
) => {
  const page = browser.pages()[0];
  await page.goto("/");
  await page.waitForTimeout(4000);
  const [walletPopup] = await Promise.all([
    browser.waitForEvent("page"),
    page.locator('//*[text()="Enable wallet"]').first().click(),
  ]);
  await walletPopup.waitForTimeout(2000);
  await allowExtension(walletPopup, walletConfig.extension.Name);
  await page.waitForTimeout(2000);
  return browser;
};

/**
 * We need this because some extensions have dynamic URLs
 **/
const getDynamicUrlInChrome = async (
  extensionTab: Page,
  walletConfig: WalletConfig
): Promise<string> => {
  await extensionTab.goto("chrome://extensions/");
  const extensionId = await extensionTab
    .locator("extensions-item")
    .getAttribute("id");
  return `chrome-extension://${extensionId}/${walletConfig.extension.HomeUrl}`;
};
