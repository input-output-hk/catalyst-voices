import { Page } from "@playwright/test";
import { WalletConfigModel } from "../../models/walletConfigModel";
import { WalletActions } from "./wallet-actions";

export class NufiActions implements WalletActions {
  private page: Page;
  private walletConfig: WalletConfigModel;

  constructor(wallet: WalletConfigModel, page: Page) {
    this.walletConfig = wallet;
    this.page = page;
  }

  async restoreWallet(): Promise<void> {
    // Click restore page icon
    await this.page.locator("//*[@data-testid='RestorePageIcon']").click();

    // Enter seed phrase
    const seedPhrase = this.walletConfig.seed;
    for (let i = 0; i < 15; i++) {
      await this.page
        .locator(`//div[@rtl-data-test-id='mnemonic-field-input-${i}']//input`)
        .fill(seedPhrase[i]);
    }

    // Accept terms and conditions
    await this.page
      .locator("//span[@data-test-id='terms-and-conditions-checkbox']/input")
      .check();

    // Continue
    await this.page.locator("button:has-text('Continue')").click();

    // Set wallet name
    await this.page
      .locator("//input[@rtl-data-test-id='wallet-name-field']")
      .fill(this.walletConfig.username);

    // Set password (using specific field IDs)
    await this.page
      .locator("//input[@id=':rg:']")
      .fill(this.walletConfig.password);
    await this.page
      .locator("//input[@id=':rh:']")
      .fill(this.walletConfig.password);

    // Continue
    await this.page.locator("button:has-text('Continue')").click();

    // Recover wallet
    await this.page.locator("button:has-text('Recover')").click();

    // Go to wallet
    await this.page.locator("button:has-text('Go to Wallet')").click();
  }

  async connectWallet(): Promise<void> {
    // First, enter password if required
    await this.page
      .locator("//input[@type='password']")
      .fill(this.walletConfig.password);

    // Click connect button (there are typically two)
    await this.page.locator("button:has-text('Connect')").click();
    await this.page.locator("button:has-text('Connect')").click();
  }

  async approveTransaction(): Promise<void> {
    // Sign the transaction
    await this.page.locator("button:has-text('Sign')").click();
  }
}
