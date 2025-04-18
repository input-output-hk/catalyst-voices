import { Locator, Page } from "@playwright/test";
import { AppBarPage } from "../app-bar-page";
import intlEn from "./localization-util";

export class GetStartedPanel {
  createNewCatalystKeychain: Locator;
  recoverCatalystKeychain: Locator;
  page: Page;

  constructor(page: Page) {
    this.page = page;
    this.createNewCatalystKeychain = page.getByRole("group", {
      name:
        intlEn.accountCreationCreate + " " + intlEn.accountCreationOnThisDevice,
    });
    this.recoverCatalystKeychain = page.getByRole("group", {
      name:
        intlEn.accountCreationRecover +
        " " +
        intlEn.accountCreationOnThisDevice,
    });
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
