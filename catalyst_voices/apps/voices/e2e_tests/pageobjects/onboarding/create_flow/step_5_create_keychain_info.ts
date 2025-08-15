import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { ProfileSetupSuccessPanel } from "./step_4_profile_setup_success";

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
    await this.createKeychainButton.click();
  }
}