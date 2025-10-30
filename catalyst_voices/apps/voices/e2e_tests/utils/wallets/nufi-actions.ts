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
    await this.page.locator("p:has-text('Restore Wallet')").click();
    const seedPhrase = this.walletConfig.seed;
    for (let i = 0; i < 15; i++) {
      await this.page
        .locator(`//div[@data-test-id='mnemonic-field-input-${i}']//input`)
        .fill(seedPhrase[i]);
    }
    await this.page
      .locator("//span[@data-test-id='terms-and-conditions-checkbox']/input")
      .check();
    await this.page.locator("button:has-text('Continue')").click();

    await this.page
      .locator("//input[@rtl-data-test-id='wallet-name-field']")
      .fill(this.walletConfig.username);

    await this.page
      .locator("[data-test-id='wallet-password-field'] input")
      .pressSequentially(this.walletConfig.password);
    await this.page
      .locator("[data-test-id='wallet-password-confirm-field'] input")
      .pressSequentially(this.walletConfig.password);
    await this.page
      .getByRole("button", { name: "Recover", exact: true })
      .click();
    await this.page.getByRole("button", { name: "Go to Wallet" }).click();
    await this.page.getByText("Close").click();
  }

  async connectWallet(): Promise<void> {
    if (await this.page.locator("//input[@type='password']").isVisible()) {
      await this.page
        .locator("//input[@type='password']")
        .fill(this.walletConfig.password);
    }

    await this.page.locator("button:has-text('Connect')").click();
    //await this.page.locator("button:has-text('Connect')").click();
  }

  async approveTransaction(): Promise<void> {
    await this.page.locator("button:has-text('Sign')").click();
  }
}
