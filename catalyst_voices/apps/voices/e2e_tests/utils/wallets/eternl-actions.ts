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

  async restoreWallet(): Promise<void> {
    await this.page.locator('//button[@aria-label="Start setup"]').click();
    await this.page.locator("#modalSetupSettingsFooter button").click();
    await this.selectNetwork(this.walletConfig.network);
    await this.page.locator("#modelSetupSettingsBtnNext").click();
    await this.page.locator("//input[@type='password']").fill('1234');
    await this.page.locator("#btnNext").click();
    await this.page.locator("#passwordInput").fill('1234');
    await this.page.locator("#modelSetupSettingsBtnNext").click();
    

    await this.page.locator('button:has-text("Add Wallet")').click();

    // Click Restore wallet
    await this.page.locator('button:has-text("Restore wallet")').click();

    // Select 15 words
    await this.page.locator('button:has-text("15 words")').click();

    // Click next
    await this.page.locator('button.cc-btn-primary:has-text("next")').click();

    // Enter seed phrase
    await this.page
      .locator("#wordInput")
      .fill(this.walletConfig.seed.join(" "));

    // Continue
    await this.page.locator('button:has-text("continue")').click();

    // Set wallet name
    await this.page
      .locator("#inputWalletName")
      .fill(this.walletConfig.username);

    // Set password
    await this.page.locator("#password").fill(this.walletConfig.password);
    await this.page.locator("#repeatPassword").fill(this.walletConfig.password);

    // Save wallet
    await this.page.locator('button:has-text("save")').click();
    await this.page.locator('button:has-text("save")').click();

    // Click on the light theme area to complete setup
    await this.page
      .locator(
        "div.flex.flex-row.justify-center.items-center.cursor-pointer.cc-area-light-1"
      )
      .click();
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
