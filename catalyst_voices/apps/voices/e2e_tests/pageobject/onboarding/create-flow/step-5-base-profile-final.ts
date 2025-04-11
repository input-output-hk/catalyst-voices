import { Locator, Page } from "@playwright/test";
import { AcknowledgementsPanel } from "./step-4-acknowledgements";

export class BaseProfileFinalPanel {
  page: Page;
  createYourCatalystKeychainbtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.createYourCatalystKeychainbtn = page.getByRole("button", {
      name: "CreateKeychain-test",
    });
  }

  async goto() {
    await new AcknowledgementsPanel(this.page).goto();
    await new AcknowledgementsPanel(this.page).clickNextButton();
  }

  async clickCreateYourCatalystKeychainbtn() {
    await this.createYourCatalystKeychainbtn.click();
  }
}
