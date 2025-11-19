import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { WritedownSeedPhrasePanel } from "./step-7-writedown-seedphrase";
import { TestModel } from "../../../models/testModel";

export class WritedownSeedPhraseInfoPanel extends OnboardingBasePage {
  page: Page;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
  }
  async goto() {
    await new WritedownSeedPhrasePanel(this.page, this.testModel).goto();
    this.testModel.accountModel.seedPhrase = await new WritedownSeedPhrasePanel(this.page, this.testModel).getSeedPhraseWords();
    await new WritedownSeedPhrasePanel(this.page, this.testModel).seedphraseStoredCheckboxClick();
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }
}
