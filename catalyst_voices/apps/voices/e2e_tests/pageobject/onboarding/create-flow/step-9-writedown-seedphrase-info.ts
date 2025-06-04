import { Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { WriteDownSeedPhrasePanel } from "./step-8-writedown-seedphrase";
import { TestModel } from "../../../models/testModel";

export class WriteDownSeedPhraseInfoPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto(testModel: TestModel) {
    await new WriteDownSeedPhrasePanel(this.page).goto(testModel);
    await new WriteDownSeedPhrasePanel(this.page).markCheckboxAs(true);
    await new WriteDownSeedPhrasePanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    await new OnboardingCommon(this.page).nextButton.click();
  }
}
