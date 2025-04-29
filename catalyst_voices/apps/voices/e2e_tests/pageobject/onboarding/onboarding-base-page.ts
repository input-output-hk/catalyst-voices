import { type Locator, type Page } from "@playwright/test";

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
