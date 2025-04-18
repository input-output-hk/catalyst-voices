import { Locator, Page } from "@playwright/test";
import intlEn from "../localization-util";
import { AcknowledgementsPanel } from "./step-4-acknowledgements";

export class BaseProfileFinalPanel {
  page: Page;
  createYourCatalystKeychainBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.createYourCatalystKeychainBtn = page.getByRole("button", {
      name: intlEn.accountCreationSplashTitle,
    });
  }

  async goto() {
    await new AcknowledgementsPanel(this.page).goto();
    await new AcknowledgementsPanel(this.page).clickNextButton();
  }

  async clickCreateYourCatalystKeychainBtn() {
    await this.createYourCatalystKeychainBtn.click();
  }
}
