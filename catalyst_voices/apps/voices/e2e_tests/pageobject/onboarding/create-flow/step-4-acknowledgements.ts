import { Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboardingCommon";
import { SetupBaseProfilePanel } from "./step-3-setup-base-profile";

export class AcknowledgementsPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new SetupBaseProfilePanel(this.page).goto();
    await new SetupBaseProfilePanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    await new OnboardingBasePage(this.page).nextButton.click();
  }
}
