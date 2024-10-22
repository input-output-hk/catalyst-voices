import { expect, Page } from "@playwright/test";
import { WalletConfig } from "./walletUtils";

const clickRestoreWalletButton = async (page: Page): Promise<void> => {
  const maxAttempts = 3;

  // Selector for the restore wallet button
  const restoreWalletButtonSelector = '[data-testid="restore-wallet-button"]';

  // Selector for an element that exists only on the next page
  const nextPageSelector = '[data-testid="wallet-setup-step-btn-next"]';

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      // Wait for the restore wallet button to be visible and enabled
      const restoreWalletButton = page.locator(restoreWalletButtonSelector);
      await restoreWalletButton.waitFor({ state: 'visible', timeout: 5000 });
      await expect(restoreWalletButton).toBeEnabled();

      // Click the restore wallet button and wait for the next page to load
      await Promise.all([
        page.waitForSelector(nextPageSelector, { timeout: 10000 }),
        restoreWalletButton.click(),
      ]);

      // Verify that the next page has loaded by checking for a unique element
      const nextPageElement = page.locator(nextPageSelector);
      await nextPageElement.waitFor({ state: 'visible', timeout: 5000 });

      // If the next page is detected, exit the function
      console.log('Successfully navigated to the next page.');
      return;
    } catch (error) {
      if (attempt === maxAttempts) {
        // If it's the last attempt, rethrow the error
        throw new Error(`Failed to click 'restore-wallet-button' after ${maxAttempts} attempts: ${error}`);
      } else {
        // Log the attempt and retry
        console.warn(`Attempt ${attempt} to click 'restore-wallet-button' failed. Retrying...`);
        // Optionally, you can add a short delay before retrying
        await page.waitForTimeout(1000);
      }
    }
  }
};

/*
  * This handles the situation where after clicking restore Lace sometimes leads directly to recovery phrase page
  * and sometimes leads to a page where the user has to click on the recovery phrase button to get to the recovery phrase page
  */
const handleNextPage = async (page: Page): Promise<void> => {
  const title = await page.getByTestId('wallet-setup-step-title').textContent();
  if(title === 'Choose recovery method') {
    await page.locator('[data-testid="wallet-setup-step-btn-next"]').click();
  } else {
    return;
  }
}

export const onboardLaceWallet = async (page: Page, walletConfig: WalletConfig): Promise<void> => {
  await page.locator('[data-testid="analytics-accept-button"]').click();
  await clickRestoreWalletButton(page);
  await handleNextPage(page);
  await page.getByTestId('recovery-phrase-15').click();
  const seedPhrase = walletConfig.seed;
    for (let i = 0; i < seedPhrase.length; i++) {
        const ftSeedPhraseSelector = `//*[@id="mnemonic-word-${i + 1}"]`;
        await page.locator(ftSeedPhraseSelector).fill(seedPhrase[i]);
    }
  await page.getByRole('button', { name: 'Next' }).click();
  await page.getByTestId('wallet-name-input').fill(walletConfig.username);
  await page.getByTestId('wallet-password-verification-input').fill(walletConfig.password);
  await page.getByTestId('wallet-password-confirmation-input').fill(walletConfig.password);
  await page.getByRole('button', { name: 'Open wallet' }).click();
  //Lace is very slow at loading
  await page.getByTestId('profile-dropdown-trigger-menu').click({timeout: 300000});
  await page.getByTestId('header-menu').getByTestId('header-menu-network-choice-container').click();
  await page.getByTestId('header-menu').getByTestId('network-preprod-radio-button').click();
  await page.waitForTimeout(4000);
};

export const signLaceData = async (page: Page, password: string, isCorrectPassword: boolean): Promise<void> => {
  await page.getByRole('button', { name: 'Confirm' }).click();
  await page.getByTestId('password-input').fill(password);
  await page.getByRole('button', { name: 'Confirm' }).click();
  if (!isCorrectPassword) {
    return;
  }
  await page.waitForTimeout(2000);
  //await page.getByRole('button', { name: 'Close' }).click();
 }