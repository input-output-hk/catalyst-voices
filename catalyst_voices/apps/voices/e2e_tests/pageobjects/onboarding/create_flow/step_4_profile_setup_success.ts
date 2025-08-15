import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { ProfileSetupPanel } from "./step_3_profile_setup";

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