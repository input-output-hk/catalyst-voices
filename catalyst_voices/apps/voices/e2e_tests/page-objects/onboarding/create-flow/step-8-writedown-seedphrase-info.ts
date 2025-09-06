import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { WritedownSeedPhrasePanel } from "./step-7-writedown-seedphrase";

export class WritedownSeedPhraseInfoPanel extends OnboardingBasePage {
  page: Page;

  constructor(page: Page) {
    super(page);
    this.page = page;
  }
  async goto() {
    await new WritedownSeedPhrasePanel(this.page).goto();
    await new WritedownSeedPhrasePanel(
      this.page
    ).seedphraseStoredCheckboxClick();
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
}
