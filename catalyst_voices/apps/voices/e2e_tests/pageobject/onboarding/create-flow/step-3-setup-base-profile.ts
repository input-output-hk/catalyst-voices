import { Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { BaseProfileInfoPanel } from "./step-2-base-profile-info";

export class SetupBaseProfilePanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new BaseProfileInfoPanel(this.page).goto();
    await new BaseProfileInfoPanel(this.page).clickCreateBaseProfileBtn();
  }

  async clickNextButton() {
    await new OnboardingBasePage(this.page).nextButton.click();
  }
}
