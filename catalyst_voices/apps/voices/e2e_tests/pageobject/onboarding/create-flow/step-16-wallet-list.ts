import { Locator, Page } from "@playwright/test";
import { LinkWalletInfoPanel } from "./step-15-link-wallet-info";

export class WalletListPanel {
  page: Page;
  yoroiWallet: Locator;

  constructor(page: Page) {
    this.page = page;
    this.yoroiWallet = page.locator(
      'role=group[name="Wallets"] >> role=button'
    );
  }

  async goto() {
    await new LinkWalletInfoPanel(this.page).goto();
    await new LinkWalletInfoPanel(this.page).clickChooseWalletBtn();
  }

  async clickYoroiWallet() {
    await this.yoroiWallet.click();
  }
}
