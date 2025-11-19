import { Locator, Page } from "@playwright/test";
import { BasePage } from "../base-page";
import { TestModel } from "../../models/testModel";

export class OnboardingBasePage extends BasePage {
  nextButton: Locator;
  backButton: Locator;
  testModel: TestModel;

  constructor(page: Page, testModel: TestModel) {
    super(page);
    this.testModel = testModel;
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
