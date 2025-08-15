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
      await restoreWalletButton.waitFor({ state: "visible", timeout: 5000 });
      await expect(restoreWalletButton).toBeEnabled();

      // Click the restore wallet button and wait for the next page to load
      await Promise.all([
        page.waitForSelector(nextPageSelector, { timeout: 10000 }),
        restoreWalletButton.click(),
      ]);

      // Verify that the next page has loaded by checking for a unique element
      const nextPageElement = page.locator(nextPageSelector);
      await nextPageElement.waitFor({ state: "visible", timeout: 5000 });

      // If the next page is detected, exit the function
      console.log("Successfully navigated to the next page.");
      return;
    } catch (error) {
      if (attempt === maxAttempts) {
        // If it's the last attempt, rethrow the error
        throw new Error(
          `Failed to click 'restore-wallet-button' after ${maxAttempts} attempts: ${error}`
        );
      } else {
        // Log the attempt and retry
        console.warn(
          `Attempt ${attempt} to click 'restore-wallet-button' failed. Retrying...`
        );
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
  const title = await page.getByTestId("wallet-setup-step-title").textContent();
  if (title === "Choose recovery method") {
    await page.locator('[data-testid="wallet-setup-step-btn-next"]').click();
  } else {
    return;
  }
};

export const onboardLaceWallet = async (
  page: Page,
  walletConfig: WalletConfig
): Promise<void> => {
  await page.locator('[data-testid="restore-wallet-button"]').click();

  const inputs = page.locator('input[data-testid="mnemonic-word-input"]');
  for (let i = 0; i < 24; i++) {
   const input = inputs.nth(i);
   await input.fill(walletConfig.seed[i]);

}
await page.locator('[data-testid="wallet-setup-step-btn-next"]').click();
await page.locator('[data-testid="wallet-password-verification-input"]').fill(walletConfig.password);
await page.locator('[data-testid="wallet-password-confirmation-input"]').fill(walletConfig.password);
await page.locator('[data-testid="wallet-setup-step-btn-next"]').click();
await page.locator('//button[@data-testid="profile-dropdown-trigger-menu"]').click();
await page.locator('[data-testid="header-menu-network-choice-value"]').first().click();
await page.locator('[data-testid="network-preprod-radio-button"]').first().click();
};

export const signLaceData = async (
  page: Page,
  password: string,
  isCorrectPassword: boolean
): Promise<void> => {
  await page.getByRole("button", { name: "Confirm" }).click();
  await page.getByTestId("password-input").fill(password);
  await page.getByTestId("sign-transaction-confirm").click();
  if (!isCorrectPassword) {
    await page.close();
    return;
  }
  await page.waitForTimeout(2000);
  await page.close();
};
