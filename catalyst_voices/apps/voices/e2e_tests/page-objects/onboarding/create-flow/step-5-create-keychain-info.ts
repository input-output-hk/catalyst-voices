import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { ProfileSetupSuccessPanel } from "./step-4-profile-setup-success";

export class CreateKeychainInfoPanel extends OnboardingBasePage {
  page: Page;
  createKeychainButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.createKeychainButton = page.getByTestId("CreateKeychainNowButton");
  }
  async goto() {
    await new ProfileSetupSuccessPanel(this.page).goto();
    await new ProfileSetupSuccessPanel(this.page).createKeychainClick();
  }
  async createKeychainClick() {
    await this.click(this.createKeychainButton);
  }
}
