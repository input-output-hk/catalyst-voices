import { Locator, Page } from "@playwright/test";
import { LinkWalletInfoPanel } from "./step-15-link-wallet-info";
import intlEn from "../localization-util";

export class WalletListPanel {
  page: Page;
  yoroiWallet: Locator;

  constructor(page: Page) {
    this.page = page;
    this.yoroiWallet = page.getByRole("button", {
      name:'yoroi',
  });
  }

  async goto(password: string) {
    await new LinkWalletInfoPanel(this.page).goto(password);
    await new LinkWalletInfoPanel(this.page).clickChooseWalletBtn();
  }

  async clickYoroiWallet() {
    await this.yoroiWallet.click();
  }
}
