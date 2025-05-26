import { Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { InputSeedPhrasePanel } from "./step-10-Input-seedphrase";
import { TestModel } from "../../../models/testModel";

export class SeedphraseSuccessPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto(testModel: TestModel) {
    await new InputSeedPhrasePanel(this.page).goto(testModel);
    await new InputSeedPhrasePanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    new OnboardingCommon(this.page).nextButton.click();
  }
}
