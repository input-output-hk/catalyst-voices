import { Locator, Page } from "@playwright/test";
import { AcknowledgementsPanel } from "./step-4-acknowledgements";
import { TestModel } from "../../../models/testModel";

export class BaseProfileFinalPanel {
  page: Page;
  createYourCatalystKeychainBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.createYourCatalystKeychainBtn = page.getByTestId("");
  }

  async goto(testModel: TestModel) {
    await new AcknowledgementsPanel(this.page).goto(testModel);
    await new AcknowledgementsPanel(this.page).clickNextButton();
  }

  async clickCreateYourCatalystKeychainBtn() {
    await this.createYourCatalystKeychainBtn.click();
  }
}
