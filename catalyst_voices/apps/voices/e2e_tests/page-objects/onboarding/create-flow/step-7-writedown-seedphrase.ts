import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { CreateKeychainSuccessPanel } from "./step-6-create-keychain-success";

export class WritedownSeedPhrasePanel extends OnboardingBasePage {
  page: Page;
  seedphraseStoredCheckbox: Locator;
  downloadSeedPhraseButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.seedphraseStoredCheckbox = page.getByTestId(
      "SeedPhraseStoredCheckbox_checkbox"
    );
    this.downloadSeedPhraseButton = page.getByTestId(
      "DownloadSeedPhraseButton"
    );
  }
  async goto() {
    await new CreateKeychainSuccessPanel(this.page).goto();
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
  async seedphraseStoredCheckboxClick() {
    await this.seedphraseStoredCheckbox.click();
  }
  async downloadSeedPhraseClick() {
    await this.downloadSeedPhraseButton.click();
  }
}
