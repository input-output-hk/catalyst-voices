import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { WritedownSeedPhraseInfoPanel } from "./step-8-writedown-seedphrase-info";
import { TestModel } from "../../../models/testModel";

export class InputSeedPhrasePanel extends OnboardingBasePage {
  page: Page;
  uploadKeyButton: Locator;
  resetButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.uploadKeyButton = page.getByTestId("UploadKeyButton");
    this.resetButton = page.getByTestId("ResetButton");
  }
  async goto() {
    await new WritedownSeedPhraseInfoPanel(this.page, this.testModel).goto();
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }
  async uploadKeyButtonClick() {
    await this.click(this.uploadKeyButton);
  }
  async resetButtonClick() {
    if (await this.resetButton.isVisible()) {
      await this.click(this.resetButton);
    }
  }

  async inputSeedPhraseWords() {
    for (const word of this.testModel.accountModel.seedPhrase) {
      await this.page.getByRole("button", { name: word, exact: true }).first().click();
      await this.page.waitForTimeout(100);
    }
  }
}
