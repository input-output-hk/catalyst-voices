import { Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { SeedphraseSuccessPanel } from "./step-11-seedphrase-success";

export class PasswordInfoPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new SeedphraseSuccessPanel(this.page).goto();
    await new SeedphraseSuccessPanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    new OnboardingBasePage(this.page).nextButton.click();
  }
}
