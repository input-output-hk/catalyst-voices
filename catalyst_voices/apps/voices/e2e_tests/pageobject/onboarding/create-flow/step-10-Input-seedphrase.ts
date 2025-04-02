import { Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { WriteDownSeedPhraseInfoPanel } from "./step-9-writedown-seedphrase-info";

export class InputSeedPhrasePanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new WriteDownSeedPhraseInfoPanel(this.page).goto();
    await new WriteDownSeedPhraseInfoPanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    new OnboardingBasePage(this.page).nextButton.click();
  }
}
