import { Page } from "@playwright/test";
import { WalletConfigModel } from "../../models/walletConfigModel";
import { WalletActions } from "./wallet-actions";

export class YoroiActions implements WalletActions {
  private page: Page;
  private walletConfig: WalletConfigModel;

  constructor(wallet: WalletConfigModel, page: Page) {
    this.walletConfig = wallet;
    this.page = page;
  }

  async restoreWallet(): Promise<void> {
    /* cspell: disable */
    // Accept terms of service
    await this.page.locator("#initialPage-tosAgreement-checkbox").check();
    await this.page.locator("#initialPage-continue-button").click();

    // Accept analytics
    await this.page.locator("#startupAnalytics-accept-button").click();

    // Select location
    await this.page.locator("#somewhere-checkbox").check();
    await this.page.locator('button:has-text("Continue")').click();

    // Skip URI prompt
    await this.page
      .locator(".UriPromptForm_buttonsWrapper button.MuiButton-secondary")
      .click();

    // Start restore process
    await this.page.locator("#restoreWalletButton").click();

    // Select 15 words
    await this.page.locator("#fifteenWordsButton").click();

    // Enter seed phrase
    const seedPhrase = this.walletConfig.seed;
    for (let i = 0; i < seedPhrase.length; i++) {
      const ftSeedPhraseSelector = `#downshift-${i}-input`;
      await this.page.locator(ftSeedPhraseSelector).fill(seedPhrase[i]);
    }

    // Blur the last input to trigger validation
    await this.page.locator(`#downshift-${seedPhrase.length - 1}-input`).blur();

    // Continue
    await this.page.locator("#primaryButton").click();
    await this.page.locator("#infoDialogContinueButton").click();

    // Set wallet name and password
    await this.page
      .locator("#walletNameInput-label")
      .fill(this.walletConfig.username);
    await this.page
      .locator("#walletPasswordInput-label")
      .fill(this.walletConfig.password);
    await this.page
      .locator("#repeatPasswordInput-label")
      .fill(this.walletConfig.password);

    // Create wallet
    await this.page.locator("#primaryButton").click();

    // Go to wallet
    await this.page.locator("#dialog-gotothewallet-button").click();

    // Switch to preprod network
    await this.page.locator('xpath=//*[@id="sidebar.settings"]').click();
    await this.page.locator('button:has-text("I Understand")').click();
    await this.page.locator('button:has-text("SWITCH NETWORK")').click();
    await this.page
      .locator("#switchNetworkDialog-selectNetwork-dropdown")
      .click();
    await this.page
      .locator("#switchNetworkDialog-selectNetwork_250-menuItem")
      .click();
    await this.page.locator("#switchNetworkDialog-apply-button").click();

    // Complete location setup
    await this.page.locator("#somewhere-checkbox").click();
    await this.page.locator('button:has-text("Continue")').click();
    /* cspell: enable */
  }

  async connectWallet(): Promise<void> {
    // Click on the connected wallet button to authorize
    await this.page.locator("button:has(#connectedWalletName)").click();
  }

  async approveTransaction(): Promise<void> {
    // Enter password
    await this.page.locator("#walletPassword").fill(this.walletConfig.password);

    // Confirm transaction
    await this.page.locator("#confirmButton").click();
  }
}
