import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";

export class AccountSetupSuccessPanel extends OnboardingBasePage{
  page: Page;
  openDiscoveryButton: Locator;
  reviewMyAccountButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.openDiscoveryButton = page.getByTestId("OpenDiscoveryButton");
    this.reviewMyAccountButton = page.getByTestId("ReviewMyAccountButton");
  }
  async openDiscoveryButtonClick() {
    await this.openDiscoveryButton.click();
  }
  async reviewMyAccountButtonClick() {
    await this.reviewMyAccountButton.click();
  }
}