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

    const restoreButton = this.page.locator("//flt-semantics[text()='Restore wallet']");
    await restoreButton.evaluate((el: HTMLElement) => el.click());

    await this.page.locator("(//flt-semantics[@role='checkbox'])[1]").click();
    await this.page.locator("(//flt-semantics[@role='checkbox'])[2]").click();
    await this.page.locator("//flt-semantics[@role='button' and text()='Continue']").click();
    await this.page
      .locator("//textarea[@aria-label='Seed Phrase']")
      .fill(this.walletConfig.seed.join(" "));
    await this.page.locator("//flt-semantics[@role='button' and text()='Submit']").click();
    await this.page
      .locator("//input[@aria-label='Enter a password']")
      .pressSequentially(this.walletConfig.password);
    await this.page.locator("//flt-semantics[@role='button' and text()='Continue']").click();
    await this.page.locator("//span[text()='Confirm your password']").waitFor({ state: "visible" });
    await this.page.waitForTimeout(1000);
    await this.page.locator("//input[@aria-label='Enter password']").focus();
    await this.page
      .locator("//input[@aria-label='Enter password']")
      .pressSequentially(this.walletConfig.password, { delay: 100 });
    await this.page.locator("(//flt-semantics[@role='checkbox'])[1]").click();
    await this.page.locator("(//flt-semantics[@role='checkbox'])[2]").click();
    await this.page.locator("//flt-semantics[@role='button' and text()='Continue']").click();
    await this.page.locator("//flt-semantics[@role='button' and text()='Continue']").click();
    await this.page
      .locator("//flt-semantics[@role='button' and text()='View your wallet']")
      .click();
    await this.page.locator("(//flt-semantics[@role='button'])[9]").click();
    const networkButton = this.page.locator(
      "//flt-semantics[@role='button' and contains(text(), 'Active Network')]"
    );
    await networkButton.evaluate((el: HTMLElement) => el.click());
    const preprodButton = this.page.locator(
      "//flt-semantics[@role='button' and contains(text(), 'PreProd')]"
    );
    await preprodButton.evaluate((el: HTMLElement) => el.click());
  }

  async connectWallet(): Promise<void> {
    await this.page
      .locator("//*[@aria-label='Enable accessibility']")
      .evaluate((element: HTMLElement) => element.click());
    await this.page.locator("//flt-semantics[@role='button' and text()='Connect']").click();
  }

  async approveTransaction(): Promise<void> {
    throw new Error("Vespr wallet is not supported yet");
  }
}
