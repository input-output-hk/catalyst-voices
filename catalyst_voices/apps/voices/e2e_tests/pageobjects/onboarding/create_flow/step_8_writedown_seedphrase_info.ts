import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { WritedownSeedPhrasePanel } from "./step_7_writedown_seedprhase";

export class WritedownSeedPhraseInfoPanel extends OnboardingBasePage {
  page: Page;

  constructor(page: Page) {
    super(page);
    this.page = page;
    
  }
  async goto() {
    await new WritedownSeedPhrasePanel(this.page).goto();
    await new WritedownSeedPhrasePanel(this.page).seedphraseStoredCheckboxClick();
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
}