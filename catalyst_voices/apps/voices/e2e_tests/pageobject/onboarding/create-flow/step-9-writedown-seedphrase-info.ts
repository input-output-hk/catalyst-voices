import { Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboardingCommon";
import { WriteDownSeedPhrasePanel } from "./step-8-writedown-seedphrase";

export class WriteDownSeedPhraseInfoPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new WriteDownSeedPhrasePanel(this.page).goto();
    await new WriteDownSeedPhrasePanel(this.page).markCheckboxAs(true);
    await new WriteDownSeedPhrasePanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    await new OnboardingBasePage(this.page).nextButton.click();
  }
}
