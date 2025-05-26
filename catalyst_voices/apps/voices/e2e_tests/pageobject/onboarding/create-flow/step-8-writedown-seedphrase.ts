import { Locator, Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { CatalystKeychainSuccessPanel } from "./step-7-catalyst-keychain-success";
import { TestModel } from "../../../models/testModel";

export class WriteDownSeedPhrasePanel {
  page: Page;
  checkbox: Locator;

  constructor(page: Page) {
    this.page = page;
    this.checkbox = page.getByRole("checkbox");
  }

  async goto(testModel: TestModel) {
    await new CatalystKeychainSuccessPanel(this.page).goto(testModel);
    // TODO(emiride): store seed phrase in test model
    await new CatalystKeychainSuccessPanel(this.page).clickNextButton();
  }

  async markCheckboxAs(checked: boolean) {
    if ((await this.checkbox.isChecked()) !== checked) {
      await this.checkbox.click();
    }
  }

  async clickNextButton() {
    await new OnboardingCommon(this.page).nextButton.click();
  }
}
