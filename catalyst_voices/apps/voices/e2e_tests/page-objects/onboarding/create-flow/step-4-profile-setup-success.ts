import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { ProfileSetupPanel } from "./step-3-profile-setup";

export class ProfileSetupSuccessPanel extends OnboardingBasePage {
  page: Page;
  createKeychainButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.createKeychainButton = page.getByTestId("CreateKeychainButton");
  }
  async goto() {
    await new ProfileSetupPanel(this.page).goto();
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
  async createKeychainClick() {
    await this.createKeychainButton.click();
  }
}
