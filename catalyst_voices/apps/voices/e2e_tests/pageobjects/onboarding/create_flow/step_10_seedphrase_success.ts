import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { InputSeedPhrasePanel } from "./step_9_input_seedphrase";

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