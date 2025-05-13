import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboardingCommon";
import { CatalystKeychainSuccessPanel } from "./step-7-catalyst-keychain-success";

export class WriteDownSeedPhrasePanel {
  page: Page;
  checkbox: Locator;

  constructor(page: Page) {
    this.page = page;
    this.checkbox = page.getByRole("checkbox");
  }

  async goto() {
    await new CatalystKeychainSuccessPanel(this.page).goto();
    await new CatalystKeychainSuccessPanel(this.page).clickNextButton();
  }

  async markCheckboxAs(checked: boolean) {
    if ((await this.checkbox.isChecked()) !== checked) {
      await this.checkbox.click();
    }
  }

  async clickNextButton() {
    await new OnboardingBasePage(this.page).nextButton.click();
  }
}
