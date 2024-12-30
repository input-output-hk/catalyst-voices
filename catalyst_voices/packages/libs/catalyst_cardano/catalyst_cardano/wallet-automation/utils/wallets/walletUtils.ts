import { BrowserContext, Locator, Page } from "@playwright/test";
import { BrowserExtension, BrowserExtensionName } from "../extensions";
import { onboardEternlWallet, signEternlData } from "./eternlUtils";
import { onboardLaceWallet, signLaceData } from "./laceUtils";
import { onboardNufiWallet, signNufiData } from "./nufiUtils";
import { onboardTyphonWallet, signTyphonData } from "./typhonUtils";
import { onboardYoroiWallet, signYoroiData } from "./yoroiUtils";

export interface WalletConfig {
  id: string;
  extension: BrowserExtension;
  seed: string[];
  username: string;
  password: string;
  cipBridge: string[];
}

export const onboardWallet = async (
  page: Page,
  walletConfig: WalletConfig
): Promise<void> => {
  switch (walletConfig.extension.Name) {
    case BrowserExtensionName.Typhon:
      await onboardTyphonWallet(page, walletConfig);
      break;
    case BrowserExtensionName.Lace:
      await onboardLaceWallet(page, walletConfig);
      break;
    case BrowserExtensionName.Eternl:
      await onboardEternlWallet(page, walletConfig);
      break;
    case BrowserExtensionName.Yoroi:
      await onboardYoroiWallet(page, walletConfig);
      break;
    case BrowserExtensionName.Nufi:
      await onboardNufiWallet(page, walletConfig);
      break;
    default:
      throw new Error("Wallet not in use");
  }
  await page.waitForTimeout(2000);
};

//TODO: move specific cases to specific utils for wallets
export const allowExtension = async (
  tab: Page,
  wallet: string
): Promise<void> => {
  switch (wallet) {
    case "Typhon":
      await tab.getByRole("button", { name: "Allow" }).click();
      break;
    case "Lace":
      await tab.getByTestId("connect-authorize-button").click();
      await tab.getByRole("button", { name: "Always" }).click();
      break;
    case "Eternl":
      await tab.locator('button:has-text("Grant Access")').click();
      break;
    case "Yoroi":
      await tab.locator("button:has(#connectedWalletName)").click();
      break;
    case "Nufi":
      await tab.locator("//input[@type='password']").fill("test12345678@!!");
      await tab.locator("button:has-text('Connect')").click();
      await tab.locator("button:has-text('Connect')").click();
      break;
    default:
      throw new Error("Wallet not in use");
  }
};

const getWalletPopup = async (
  browser: BrowserContext,
  triggerLocatorCLick: Locator
): Promise<Page> => {
  if (browser.pages().length > 1) {
    await triggerLocatorCLick.click();
    await browser
      .pages()
      [browser.pages().length - 1].waitForLoadState("domcontentloaded");
    return browser.pages()[browser.pages().length - 1];
  } else {
    const [page] = await Promise.all([
      browser.waitForEvent("page"),
      triggerLocatorCLick.click(),
    ]);
    return page;
  }
};

export const signWalletPopup = async (
  browser: BrowserContext,
  walletConfig: WalletConfig,
  locatorTrigger: Locator,
  isCorrectPassword = true
): Promise<void> => {
  const page = await getWalletPopup(browser, locatorTrigger);
  switch (walletConfig.extension.Name) {
    case BrowserExtensionName.Typhon:
      await signTyphonData(page, walletConfig.password, isCorrectPassword);
      break;
    case BrowserExtensionName.Lace:
      await signLaceData(page, walletConfig.password, isCorrectPassword);
      break;
    case BrowserExtensionName.Eternl:
      await signEternlData(page, walletConfig.password, isCorrectPassword);
      break;
    case BrowserExtensionName.Yoroi:
      await signYoroiData(page, walletConfig.password, isCorrectPassword);
      break;
    case BrowserExtensionName.Nufi:
      await signNufiData(page, walletConfig.password, isCorrectPassword);
      break;
    default:
      throw new Error("Wallet not in use");
  }
};
