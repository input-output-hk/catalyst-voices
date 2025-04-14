import { Locator, Page } from "@playwright/test";
import { BaseProfileFinalPanel } from "./step-5-base-profile-final";

export class CatalystKeychainInfoPanel {
  page: Page;
  createCatalystKeychainNowBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.createCatalystKeychainNowBtn = page.getByRole("button", {
      name: "CreateKeychainNow-test",
    });
  }

  async goto() {
    await new BaseProfileFinalPanel(this.page).goto();
    await new BaseProfileFinalPanel(
      this.page
    ).clickCreateYourCatalystKeychainBtn();
  }

  async clickCreateCatalystKeychainNowBtn() {
    await this.createCatalystKeychainNowBtn.click();
  }
}
