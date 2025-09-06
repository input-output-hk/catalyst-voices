import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { InputSeedPhrasePanel } from "./step-9-input-seedphrase";

export class SeedPhraseSuccessPanel extends OnboardingBasePage {
  page: Page;

  constructor(page: Page) {
    super(page);
    this.page = page;
  }
  async goto() {
    await new InputSeedPhrasePanel(this.page).goto();
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
}
