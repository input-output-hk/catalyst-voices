import { expect, Page } from "@playwright/test";
import { WalletConfigModel } from "../../models/walletConfigModel";
import { WalletActions } from "./wallet-actions";

export class EternlActions implements WalletActions {
  private page: Page;
  private walletConfig: WalletConfigModel;

  constructor(wallet: WalletConfigModel, page: Page) {
    this.walletConfig = wallet;
    this.page = page;
  }

  async fillSeedPhrase(page: Page, seedPhrase: string[]): Promise<void> {
    for (let i = 0; i < seedPhrase.length; i++) {
      const inputField = page.locator(`#word${i}`);

      await inputField.click();
      await inputField.fill(seedPhrase[i]);

      await page.waitForTimeout(100);
    }
  }

  async restoreWallet(): Promise<void> {
    await this.page.locator('//button[@aria-label="Start setup"]').click();
    await this.page.locator("#modalSetupSettingsFooter button").click();
    await this.selectNetwork(this.walletConfig.network);
    await this.page.locator("#modelSetupSettingsBtnNext").click();
    await this.page.locator("//input[@type='password']").fill("1234");
    await this.page.locator("#btnNext").click();
    await this.page.locator("#passwordInput").fill("1234");
    await this.page.locator("#modelSetupSettingsBtnNext").click();
    await this.page.locator('button:has-text("Enter a Seed-phrase")').click();
    await this.page.locator('button:has-text("15-word phrase")').click();
    await this.fillSeedPhrase(this.page, this.walletConfig.seed);
    await this.page.locator("#modelRestoreWalletBtnNext").click();
    await this.page.locator("#modelRestoreWalletBtnNext").click();
    await this.page.locator("#walletName").click();
    await this.page.locator("#walletName").fill(this.walletConfig.username);
    await this.page.locator("#modelRestoreWalletBtnNext").click();
    await this.page.locator("#password").fill(this.walletConfig.password);
    await this.page
      .locator("#passwordConfirm")
      .fill(this.walletConfig.password);
    await this.page.locator("#password").click();
    await this.page.locator('button:has-text("Next")').click();
    await this.page.waitForTimeout(3000);
  }

  async connectWallet(): Promise<void> {
    // Grant access to the dApp
    await this.page.locator('button:has-text("Grant Access")').click();
  }

  async approveTransaction(): Promise<void> {
    // Enter password
    await this.page.locator("input#password").fill(this.walletConfig.password);

    // Sign the transaction
    await this.page.locator('//button[.//span[text()="sign"]]').click();
  }

  private async selectNetwork(network: string): Promise<void> {
    if (network === "preprod") {
      await this.page
        .locator("//button[.//div[contains(text(), 'Pre-Production testnet')]]")
        .click();
    } else if (network === "preview") {
      await this.page
        .locator("//button[.//div[contains(text(), 'Preview testnet')]]")
        .click();
    } else if (network === "mainnet") {
      return;
    } else {
      throw new Error(`Unsupported network: ${network}`);
    }
  }
}
