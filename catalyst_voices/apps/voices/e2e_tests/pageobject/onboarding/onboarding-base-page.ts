import { type Locator, type Page } from "@playwright/test";
import intlEn from "./localization-util";

export class OnboardingBasePage {
  page: Page;
  nextBtnGroup: Locator;
  nextButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.nextBtnGroup = page.getByRole("button", { name: "Next Button" });
    this.nextButton = page.locator('role=button[name="' + intlEn.next + '"]');
  }
}
