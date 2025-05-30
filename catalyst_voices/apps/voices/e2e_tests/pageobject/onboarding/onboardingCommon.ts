import { type Locator, type Page } from "@playwright/test";

export class OnboardingCommon {
  page: Page;
  nextButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.nextButton = page.getByTestId("NextButton");
  }

  async clickNextButton() {
    await this.nextButton.click();
  }
}
