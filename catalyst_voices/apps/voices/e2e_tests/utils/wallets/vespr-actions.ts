import { Page } from "@playwright/test";
import { WalletActions } from "./wallet-actions";
import { WalletConfigModel } from "../../models/walletConfigModel";

export class VesprActions implements WalletActions {
  private page: Page;
  private walletConfig: WalletConfigModel;

  constructor(wallet: WalletConfigModel, page: Page) {
    this.walletConfig = wallet;
    this.page = page;
  }

  async restoreWallet(): Promise<void> {
    await this.page
      .locator("//*[@aria-label='Enable accessibility']")
      .evaluate((element: HTMLElement) => element.click());
    await this.page.locator('[role="checkbox"]').nth(0).click();
    await this.page.locator('[role="checkbox"]').nth(1).click();
    await this.page.getByRole("button", { name: "I'll do it later" }).click();
    await this.page.getByRole("button", { name: "Restore wallet" }).click();
    let seedPhrase = "";
    for (let i = 0; i < this.walletConfig.seed.length; i++) {
      seedPhrase += this.walletConfig.seed[i] + " ";
    }
    await this.page
      .locator('[data-semantics-role="text-field"]')
      .fill(seedPhrase);
    await this.page.getByRole("button", { name: "Submit" }).click();
    await this.page
      .locator(
        '[data-semantics-role="text-field"][aria-label="Enter a password"]'
      )
      .fill(this.walletConfig.password);
    await this.page.getByRole("button", { name: "Continue" }).click();
    await this.page.waitForTimeout(700);
    await this.page
      .locator(
        '[data-semantics-role="text-field"][aria-label="Enter password"]'
      )
      .fill(this.walletConfig.password);
    await this.page
      .getByLabel(
        "I understand that VESPR cannot recover this password for me."
      )
      .click();
    await this.page
      .getByLabel(
        "I understand that without this password I may lose access to my funds."
      )
      .click();
    await this.page.getByRole("button", { name: "Continue" }).click();
    await this.page.getByRole("button", { name: "Continue" }).click();
    await this.page.getByText("View your wallet").click();
    await this.switchNetwork(this.walletConfig.network);
  }

  async connectWallet(): Promise<void> {
    await this.page
    .locator("//*[@aria-label='Enable accessibility']")
    .evaluate((element: HTMLElement) => element.click());
    await this.page.locator("//flt-semantics[text()='Connect']").click();
  }

  async approveTransaction(): Promise<void> {
    throw new Error("Vespr wallet is not supported yet");
  }
  async switchNetwork(network: string): Promise<void> {
    if (network === "preprod") {
      await this.page
        .locator(
          'flt-semantics[role="button"][flt-tappable]#flt-semantic-node-119'
        )
        .click();
      await this.page.waitForTimeout(500);
      await this.page.mouse.wheel(0, 1000); // Scroll down 1000 pixels
      await this.page.getByText("Active Network").click();
      await this.page.getByText("PreProd").click();
    } else if (network === "preview") {
      await this.page
        .locator(
          'flt-semantics[role="button"][flt-tappable]#flt-semantic-node-119'
        )
        .click();
      await this.page.getByText("Active Network").click();
      await this.page.getByText("Preview").click();
    } else if (network === "mainnet") {
      await this.page
        .locator(
          'flt-semantics[role="button"][flt-tappable]#flt-semantic-node-119'
        )
        .click();
      await this.page.getByText("Active Network").click();
      await this.page.getByRole("button", { name: "Cardano Mainnet" }).click();
    } else {
      throw new Error(`Unsupported network: ${this.walletConfig.network}`);
    }
  }
}
