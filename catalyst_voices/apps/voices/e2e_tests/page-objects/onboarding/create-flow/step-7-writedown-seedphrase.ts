import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { CreateKeychainSuccessPanel } from "./step-6-create-keychain-success";
import { TestModel } from "../../../models/testModel";

export class WritedownSeedPhrasePanel extends OnboardingBasePage {
  page: Page;
  seedphraseStoredCheckbox: Locator;
  downloadSeedPhraseButton: Locator;
  exportKeyButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.seedphraseStoredCheckbox = page.getByTestId("SeedPhraseStoredCheckbox_checkbox");
    this.downloadSeedPhraseButton = page.getByTestId("DownloadSeedPhraseButton");
    this.exportKeyButton = page.locator("//flt-semantics[text()='Export Key']");
  }
  async goto() {
    await new CreateKeychainSuccessPanel(this.page, this.testModel).goto();
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }
  async seedphraseStoredCheckboxClick() {
    await this.click(this.seedphraseStoredCheckbox);
  }

  async downloadSeedPhrase(): Promise<string> {
    await this.downloadSeedPhraseClick();
    const downloadPromise = this.page.waitForEvent("download");
    await this.exportKeyButton.click();
    const download = await downloadPromise;
    const path = await download.path();
    return path;
  }
  async downloadSeedPhraseClick() {
    await this.click(this.downloadSeedPhraseButton);
  }
  async getSeedPhraseWords(): Promise<string[]> {
    const seedPhraseWords: string[] = [];
    for (let i = 0; i < 12; i++) {
      const word = await this.page.getByTestId(`SeedPhraseWords_word_${i}`).textContent();
      if (word) {
        seedPhraseWords.push(word.split("\n")[1]);
      }
    }
    return seedPhraseWords;
  }
}
