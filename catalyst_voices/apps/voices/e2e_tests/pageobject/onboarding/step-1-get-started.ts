import { Locator, Page } from "@playwright/test";
import { AppBarPage } from "../app-bar-page";

export class GetStartedPanel {
  createNewCatalystKeychain: Locator;
  recoverCatalystKeychain: Locator;
  page: Page;

  constructor(page: Page) {
    this.page = page;
    this.createNewCatalystKeychain = page.getByRole("group", {
      name: "Create a new Catalyst Keychain On this device",
    });
    this.recoverCatalystKeychain = page.getByRole("group", {
      name: "Recover your Catalyst Keychain On this device",
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
