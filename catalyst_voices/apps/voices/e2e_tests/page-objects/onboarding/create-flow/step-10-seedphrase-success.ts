import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { InputSeedPhrasePanel } from "./step-9-input-seedphrase";
import { TestModel } from "../../../models/testModel";

export class SeedPhraseSuccessPanel extends OnboardingBasePage {
  page: Page;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
  }
  async goto() {
    await new InputSeedPhrasePanel(this.page, this.testModel).goto();
    await new InputSeedPhrasePanel(this.page, this.testModel).resetButtonClick();
    await new InputSeedPhrasePanel(this.page, this.testModel).inputSeedPhraseWords();
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }
}
