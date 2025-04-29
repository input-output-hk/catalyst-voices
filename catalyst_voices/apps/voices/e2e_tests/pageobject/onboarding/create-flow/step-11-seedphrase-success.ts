import { Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboardingCommon";
import { InputSeedPhrasePanel } from "./step-10-Input-seedphrase";

export class SeedphraseSuccessPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new InputSeedPhrasePanel(this.page).goto();
    await new InputSeedPhrasePanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    new OnboardingBasePage(this.page).nextButton.click();
  }
}
