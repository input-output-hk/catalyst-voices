import { expect, Page } from "@playwright/test";
import { WalletConfig } from "./walletUtils";

export const onboardEternlWallet = async (page: Page, walletConfig: WalletConfig): Promise<void> => {
  await page.locator('button:has-text("Add Wallet")').click();
  await page.locator('button:has-text("Restore wallet")').click();
  await page.locator('button:has-text("15 words")').click();
  await page.locator('button.cc-btn-primary:has-text("next")').click();
  await page.locator('#wordInput').fill(walletConfig.seed.join(' '));
  await page.locator('button:has-text("continue")').click();
  await page.locator('#inputWalletName').fill(walletConfig.username);
  await page.locator('#password').fill(walletConfig.password);
  await page.locator('#repeatPassword').fill(walletConfig.password);
  await page.locator('button:has-text("save")').click();
  await page.locator('button:has-text("save")').click();
  await page.locator('div.flex.flex-row.justify-center.items-center.cursor-pointer.cc-area-light-1').click();
};

export const signEternlData = async (signTab: Page, password: string, isCorrectPassword: boolean): Promise<void> => {
  
  await signTab.locator('input#password').fill(password);
  await signTab.locator('//button[.//span[text()="sign"]]').click();
  if (!isCorrectPassword) {
    expect(await signTab.locator('//div[contains(text(), "try again")]').isVisible()).toBeTruthy();
    await signTab.locator('//button[.//span[text()="cancel"]]').click();
    return
  }
}