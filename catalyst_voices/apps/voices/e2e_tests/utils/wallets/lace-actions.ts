import { expect, Page } from "@playwright/test";
import { WalletConfigModel } from "../../models/walletConfigModel";
import { WalletActions } from "./wallet-actions";

export class LaceActions implements WalletActions {
  private page: Page;
  private walletConfig: WalletConfigModel;

  constructor(wallet: WalletConfigModel, page: Page) {
    this.walletConfig = wallet;
    this.page = page;
  }

  async restoreWallet(): Promise<void> {
    // Click restore wallet button with retry logic
    await this.clickRestoreWalletButton();

    // Handle the next page (sometimes shows "Choose recovery method")
    await this.handleNextPage();

    // Select 15-word recovery phrase
    await this.page.locator('//span[@data-testid="recovery-phrase-15"]').click();

    // Enter seed phrase
    for (let i = 0; i < this.walletConfig.seed.length; i++) {
      const seedPhraseSelector = `//*[@id="mnemonic-word-${i + 1}"]`;
      await this.page.locator(seedPhraseSelector).fill(this.walletConfig.seed[i]);
    }

    // Continue to next step
    await this.page.locator('[data-testid="wallet-setup-step-btn-next"]').click();

    // Set wallet name and password
    await this.page.locator('[data-testid="wallet-name-input"]').fill(this.walletConfig.username);
    await this.page
      .locator('[data-testid="wallet-password-verification-input"]')
      .fill(this.walletConfig.password);
    await this.page
      .locator('[data-testid="wallet-password-confirmation-input"]')
      .fill(this.walletConfig.password);

    // Continue through the setup
    await this.page.locator('[data-testid="wallet-setup-step-btn-next"]').click();
    // await this.page
    // .locator('[data-testid="wallet-setup-step-btn-next"]')
    //.click();

    // Switch to preprod network
    await this.page
      .locator('//*[@data-testid="profile-dropdown-trigger-menu"]')
      .click({ timeout: 300000 });
    await this.page
      .locator('//*[@data-testid="header-menu"]')
      .locator('//*[@data-testid="header-menu-network-choice-container"]')
      .click();
    await this.page
      .locator('//*[@data-testid="header-menu"]')
      .locator('//*[@data-testid="network-preprod-radio-button"]')
      .click();
    await this.page.waitForSelector('[data-testid="portfolio-balance-label"]', {
      timeout: 10000,
      state: "visible",
    });
  }

  async connectWallet(): Promise<void> {
    // Authorize the connection
    await this.page.locator("//button[@data-testid='connect-authorize-button']").click();
    await this.page.locator("//button[@data-testid='connect-modal-accept-always']").click();
  }

  async approveTransaction(): Promise<void> {
    // Click confirm button
    await this.page.getByRole("button", { name: "Confirm" }).click();

    // Enter password
    await this.page
      .locator("//input[@data-testid='password-input']")
      .fill(this.walletConfig.password);

    // Sign transaction
    await this.page.locator("//button[@data-testid='sign-transaction-confirm']").click();

    // Wait for transaction to complete
    await this.page.waitForTimeout(2000);

    // Close the popup
    await this.page.close();
  }

  private async clickRestoreWalletButton(): Promise<void> {
    const maxAttempts = 3;
    const restoreWalletButtonSelector = '[data-testid="restore-wallet-button"]';
    const nextPageSelector = '[data-testid="wallet-setup-step-btn-next"]';

    for (let attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        // Wait for the restore wallet button to be visible and enabled
        const restoreWalletButton = this.page.locator(restoreWalletButtonSelector);
        await restoreWalletButton.waitFor({ state: "visible", timeout: 5000 });
        await expect(restoreWalletButton).toBeEnabled();

        // Click the restore wallet button and wait for the next page to load
        await Promise.all([
          this.page.waitForSelector(nextPageSelector, { timeout: 10000 }),
          restoreWalletButton.click(),
        ]);

        // Verify that the next page has loaded by checking for a unique element
        const nextPageElement = this.page.locator(nextPageSelector);
        await nextPageElement.waitFor({ state: "visible", timeout: 5000 });

        return;
      } catch (error) {
        if (attempt === maxAttempts) {
          // If it's the last attempt, rethrow the error
          throw new Error(
            `Failed to click 'restore-wallet-button' after ${maxAttempts} attempts: ${error}`
          );
        } else {
          // Log the attempt and retry
          console.warn(`Attempt ${attempt} to click 'restore-wallet-button' failed. Retrying...`);
          // Optionally, you can add a short delay before retrying
          await this.page.waitForTimeout(1000);
        }
      }
    }
  }

  private async handleNextPage(): Promise<void> {
    const title = await this.page
      .locator('//*[@data-testid="wallet-setup-step-title"]')
      .textContent();
    if (title === "Choose recovery method") {
      await this.page.locator('[data-testid="wallet-setup-step-btn-next"]').click();
    }
  }
}
