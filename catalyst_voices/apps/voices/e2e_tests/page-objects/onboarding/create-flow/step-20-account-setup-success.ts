import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";

export class AccountSetupSuccessPanel extends OnboardingBasePage {
  openDiscoveryButton: Locator;
  reviewMyAccountButton: Locator;

  constructor(page: Page) {
    super(page);
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
