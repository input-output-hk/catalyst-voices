import { Page } from "playwright";
import { WalletConfig } from "./walletUtils";

export const onboardTyphonWallet = async (page: Page, walletConfig: WalletConfig): Promise<void> => {
  //switch to preprod network
  await page.locator('button#headlessui-menu-button-1').click();
  await page.locator('button#headlessui-menu-item-6').click();
  //import wallet
  await page.getByRole('button', { name: 'Import' }).click();
  await page.getByPlaceholder('Wallet Name').fill(walletConfig.username);
  await page.getByPlaceholder('Password', { exact: true }).fill(walletConfig.password);
  await page.getByPlaceholder('Confirm Password', { exact: true }).fill(walletConfig.password);
  await page.locator('input#termsAndConditions').click();
  await page.getByRole('button', { name: 'Continue' }).click();

  // Input seed phrase
  const seedPhrase = walletConfig.seed;
  for (let i = 0; i < seedPhrase.length; i++) {
      const ftSeedPhraseSelector = `(//input[@type='text'])[${i + 1}]`;
      await page.locator(ftSeedPhraseSelector).fill(seedPhrase[i]);
  }

  await page.locator('//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div/div[1]/div[1]/div[1]/span[1]').click();
  await page.getByRole('button', { name: 'Unlock Wallet' }).click();
};

export const signTyphonData = async (signTab: Page, password: string, isCorrectPassword: boolean): Promise<void> => {
  await signTab.getByRole('button', { name: 'Sign' }).click();
  await signTab.getByPlaceholder('Password', { exact: true }).fill(password);
  if (!isCorrectPassword) {
      return
  }
  await signTab.getByRole('button', { name: 'confirm' }).click();
}