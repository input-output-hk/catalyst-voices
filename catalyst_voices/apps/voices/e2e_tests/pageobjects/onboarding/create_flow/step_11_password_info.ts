import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { SeedPhraseSuccessPanel } from "./step_10_seedphrase_success";

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