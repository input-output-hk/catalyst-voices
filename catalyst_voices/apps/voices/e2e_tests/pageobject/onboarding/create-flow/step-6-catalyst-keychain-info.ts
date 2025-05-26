import { Locator, Page } from "@playwright/test";
import { BaseProfileFinalPanel } from "./step-5-base-profile-final";
import { TestModel } from "../../../models/testModel";

export class CatalystKeychainInfoPanel {
  page: Page;
  createKeychainButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.createKeychainButton = page.getByTestId("CreateKeychainButton");
  }

  async goto(testModel: TestModel) {
    await new BaseProfileFinalPanel(this.page).goto(testModel);
    await new BaseProfileFinalPanel(
      this.page
    ).clickCreateYourCatalystKeychainBtn();
  }

  async clickCreateCatalystKeychainNowBtn() {
    await this.createKeychainButton.click();
  }
}
