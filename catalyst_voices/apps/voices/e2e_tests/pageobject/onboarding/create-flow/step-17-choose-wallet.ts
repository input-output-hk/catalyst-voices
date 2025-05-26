import { Page } from "@playwright/test";
import { WalletListPanel } from "./step-16-wallet-list";
import { TestModel } from "../../../models/testModel";

export class WalletPopupSelection {
  page: Page;

  constructor(page) {
    this.page = page;
  }

  async goto(testModel: TestModel) {
    await new WalletListPanel(this.page).goto(testModel);
    await new WalletListPanel(this.page).clickWallet(
      testModel.walletConfig.extension.Name.toLowerCase()
    );
  }
}
