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
    /* cspell: disable */
    await this.page.locator('//button[@aria-label="Start setup"]').click();
    await this.page.locator("#modalSetupSettingsFooter button").click();
    await this.selectNetwork(this.walletConfig.network);

    await this.page
      .locator("//div[@id='eternl-modal']//button[@id='modelSetupSettingsBtnNext']")
      .click();
    await this.page.locator("#passwordInput").fill(this.walletConfig.password);
    await this.page.locator("#btnNext").click();
    await this.page.locator("#passwordInput").fill(this.walletConfig.password);
    await this.page.locator("#modelSetupSettingsBtnNext").click();

    await this.page.locator("(//input[@type='checkbox'])[1]").click();
    await this.page.locator("(//input[@type='checkbox'])[2]").click();
    await this.page.locator("(//input[@type='checkbox'])[3]").click();
    await this.page.locator("//button[span[text()='Confirm']]").click();

    // Click Restore wallet
    await this.page.locator('button:has-text("Enter a Seed-phrase")').click();

    await this.page
      .locator(`button:has-text("${this.walletConfig.seed.length}-word phrase")`)
      .click();

    await this.writeDownSeedPhraseWords();
    await this.page.locator('button#modelRestoreWalletBtnNext:has-text("Next")').click();
    await this.page.locator('button#modelRestoreWalletBtnNext:has-text("Next")').click();

    await this.page.locator("#walletName").fill(this.walletConfig.name);
    await this.page.locator('button#modelRestoreWalletBtnNext:has-text("Next")').click();

    // Continue
    await this.page.locator("#password").fill(this.walletConfig.password);
    await this.page.locator("#passwordConfirm").pressSequentially(this.walletConfig.password);
    await this.page.locator("span:has-text('Set your spending password')").click();
    await this.page.locator('button:has-text("Next")').click();
    await this.page
      .locator('.p-card-footer-compact:has-text("Up to date")')
      .waitFor({ state: "visible" });
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

  private async writeDownSeedPhraseWords(): Promise<void> {
    for (let i = 0; i < this.walletConfig.seed.length; i++) {
      await this.page
        .locator(`//div[@class='p-inputgroup' and .//span[text()='${i + 1}']]//input`)
        .fill(this.walletConfig.seed[i]);
      await this.page
        .locator(
          `//div[@class='p-autocomplete-overlay p-component']//li[text()='${this.walletConfig.seed[i]}']`
        )
        .click();
    }
  }

  private async selectNetwork(network: string): Promise<void> {
    switch (network) {
      case "preprod":
        await this.page
          .locator(
            "//div[@id='modal-network-select']//button[.//div[contains(text(), 'Pre-Production')]]"
          )
          .click();
        break;
      case "mainnet":
        await this.page
          .locator(
            "//div[@id='modal-network-select']//button[.//div[contains(text(), 'Cardano mainnet')]]"
          )
          .click();
        break;
      default:
        throw new Error(`Invalid network: ${network}`);
    }
    /* cspell: enable */
  }
}
