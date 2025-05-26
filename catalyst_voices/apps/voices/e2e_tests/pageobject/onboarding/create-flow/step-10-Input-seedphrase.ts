import { Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { WriteDownSeedPhraseInfoPanel } from "./step-9-writedown-seedphrase-info";
import { TestModel } from "../../../models/testModel";

export class InputSeedPhrasePanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto(testModel: TestModel) {
    await new WriteDownSeedPhraseInfoPanel(this.page).goto(testModel);
    await new WriteDownSeedPhraseInfoPanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    new OnboardingCommon(this.page).nextButton.click();
  }
}
