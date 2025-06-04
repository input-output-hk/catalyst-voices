import { Page } from "playwright";
import { WalletConfig } from "./walletUtils";

export const onboardNufiWallet = async (
  page: Page,
  walletConfig: WalletConfig
): Promise<void> => {
  await page.locator("//*[@data-testid='RestorePageIcon']").click();
  const seedPhrase = walletConfig.seed;
  for (let i = 0; i < 15; i++) {
    await page
      .locator(`//div[@rtl-data-test-id='mnemonic-field-input-${i}']//input`)
      .fill(seedPhrase[i]);
  }
  await page
    .locator("//span[@data-test-id='terms-and-conditions-checkbox']/input")
    .check();
  await page.locator("button:has-text('Continue')").click();
  await page
    .locator("//input[@rtl-data-test-id='wallet-name-field']")
    .fill(walletConfig.username);
  await page.locator("//input[@id=':rg:']").fill(walletConfig.password);
  await page.locator("//input[@id=':rh:']").fill(walletConfig.password);
  await page.locator("button:has-text('Continue')").click();
  await page.locator("button:has-text('Recover')").click();
  await page.locator("button:has-text('Go to Wallet')").click();
};

export const connectWalletPopup = async (page: Page): Promise<void> => {
  await page.locator("button:has-text('Connect')").click();
};

export const signNufiData = async (
  page: Page,
  password: string,
  isCorrectPassword: boolean
): Promise<void> => {
  if (!isCorrectPassword) {
    await page.locator("button:has-text('Reject')").click();
    return;
  }
  await page.locator("button:has-text('Sign')").click();
};
