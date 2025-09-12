import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { SeedPhraseSuccessPanel } from "./step-10-seedphrase-success";

export class PasswordInfoPanel extends OnboardingBasePage {
  page: Page;

  constructor(page: Page) {
    super(page);
    this.page = page;
  }
  async goto() {
    await new SeedPhraseSuccessPanel(this.page).goto();
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
}
