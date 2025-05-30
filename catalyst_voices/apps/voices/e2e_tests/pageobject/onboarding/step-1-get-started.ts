import { Locator, Page } from "@playwright/test";
import { AppBarPage } from "../app-bar-page";

export class GetStartedPanel {
  createNewCatalystKeychain: Locator;
  recoverCatalystKeychain: Locator;
  page: Page;

  constructor(page: Page) {
    this.page = page;
    this.createNewCatalystKeychain = page.getByTestId("CreateAccountType.createNew");
    this.recoverCatalystKeychain = page.getByTestId("CreateAccountType.recover");
  }

  async goto() {
    await new AppBarPage(this.page).GetStartedBtnClick();
  }

  async clickCreateNewCatalystKeychain() {
    await this.createNewCatalystKeychain.click();
  }

  async clickRecoverCatalystKeychain() {
    await this.recoverCatalystKeychain.click();
  }
}
