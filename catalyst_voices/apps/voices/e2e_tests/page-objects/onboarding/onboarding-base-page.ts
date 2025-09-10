import { Locator, Page } from "@playwright/test";
import { BasePage } from "../base-page";

export class OnboardingBasePage extends BasePage {
  nextButton: Locator;
  backButton: Locator;

  constructor(page: Page) {
    super(page);
    this.nextButton = page.getByTestId("NextButton");
    this.backButton = page.getByTestId("BackButton");
  }
  async nextButtonClick() {
    await this.click(this.nextButton);
  }
  async backButtonClick() {
    await this.click(this.backButton);
  }
}
