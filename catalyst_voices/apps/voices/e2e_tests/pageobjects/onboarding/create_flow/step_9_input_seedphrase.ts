import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { WritedownSeedPhraseInfoPanel } from "./step_8_writedown_seedphrase_info";

export class InputSeedPhrasePanel extends OnboardingBasePage {
  page: Page;
  uploadKeyButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.uploadKeyButton = page.getByTestId("UploadKeyButton");
  }
  async goto() {
    await new WritedownSeedPhraseInfoPanel(this.page).goto();
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
  async uploadKeyButtonClick() {
    await this.uploadKeyButton.click();
  }
}