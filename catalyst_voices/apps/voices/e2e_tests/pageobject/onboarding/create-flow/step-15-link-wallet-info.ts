import { Locator, Page } from "@playwright/test";
import { KeychainFinalPanel } from "./step-14-keychain-final";
import { TestModel } from "../../../models/testModel";

export class LinkWalletInfoPanel {
  page: Page;
  chooseWalletBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.chooseWalletBtn = this.page.getByTestId("ChooseWalletBtn");
  }

  async goto(testModel: TestModel) {
    await new KeychainFinalPanel(this.page).goto(testModel);
    await new KeychainFinalPanel(this.page).clickLinkWalletAndRolesBtn();
  }

  async clickChooseWalletBtn() {
    await this.chooseWalletBtn.click();
  }
}
