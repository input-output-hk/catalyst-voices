import { Page } from "@playwright/test";
import { WalletListPanel } from "./step-16-wallet-list";

export class WalletPopupSelection {
  page: Page;

  constructor(page) {
    this.page = page;
  }

  async goto(password: string) {
    await new WalletListPanel(this.page).goto(password);
    await new WalletListPanel(this.page).clickYoroiWallet();
  }
}
