import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { WritedownSeedPhraseInfoPanel } from "./step-8-writedown-seedphrase-info";
import { TestModel } from "../../../models/testModel";

export class InputSeedPhrasePanel extends OnboardingBasePage {
  page: Page;
  uploadKeyButton: Locator;
  resetButton: Locator;
  switchToUploadButton: Locator;
  dropKeyButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.uploadKeyButton = page.getByTestId("UploadKeyButton");
    this.resetButton = page.getByTestId("ResetButton");
    this.switchToUploadButton = page.locator(
      "//flt-semantics[text()='Yes, switch to Catalyst key upload']"
    );
    this.dropKeyButton = page.locator("//flt-semantics[contains(text(),'Drop your key here')]");
  }
  async goto() {
    await new WritedownSeedPhraseInfoPanel(this.page, this.testModel).goto();
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }

  async uploadSeedPhrase(): Promise<void> {
    await this.uploadKeyButtonClick();
    await this.switchToUploadButton.click();

    const fileChooserPromise = this.page.waitForEvent("filechooser");
    await this.dropKeyButton.click();
    const fileChooser = await fileChooserPromise;
    await fileChooser.setFiles(this.testModel.accountModel.seedPhrasePath);
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
    for (let i = 0; i < this.testModel.accountModel.seedPhrase.length; i++) {
      const word = this.testModel.accountModel.seedPhrase[i];
      const button = this.page.getByRole("button", { name: word, exact: true }).first();
      await button.evaluate((el: HTMLElement) => el.click());
      await this.page.waitForTimeout(500);
    }
  }
}
