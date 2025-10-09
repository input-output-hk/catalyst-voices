import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { WritedownSeedPhraseInfoPanel } from "./step-8-writedown-seedphrase-info";

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
    await this.click(this.uploadKeyButton);
  }
}
