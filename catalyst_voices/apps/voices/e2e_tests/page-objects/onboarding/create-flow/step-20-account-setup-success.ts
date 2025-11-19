import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { TestModel } from "../../../models/testModel";

export class AccountSetupSuccessPanel extends OnboardingBasePage {
  openDiscoveryButton: Locator;
  reviewMyAccountButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.openDiscoveryButton = page.getByTestId("OpenDiscoveryButton");
    this.reviewMyAccountButton = page.getByTestId("ReviewMyAccountButton");
  }
  async openDiscoveryButtonClick() {
    await this.click(this.openDiscoveryButton);
  }
  async reviewMyAccountButtonClick() {
    await this.click(this.reviewMyAccountButton);
  }
}
