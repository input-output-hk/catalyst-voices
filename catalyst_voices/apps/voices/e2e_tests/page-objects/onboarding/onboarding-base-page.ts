import { Locator, Page } from "@playwright/test";

export class OnboardingBasePage {
  page: Page;
  nextButton: Locator;
  backButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.nextButton = page.getByTestId("NextButton");
    this.backButton = page.getByTestId("BackButton");
  }
  async nextButtonClick() {
    await this.nextButton.click();
  }
  async backButtonClick() {
    await this.backButton.click();
  }
}
