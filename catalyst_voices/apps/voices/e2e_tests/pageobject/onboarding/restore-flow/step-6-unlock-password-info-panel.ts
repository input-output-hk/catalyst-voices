import { Page } from "@playwright/test";
import { RestoreKeychainSuccessPanel } from "./step-5-restore-keychain-success-panel";
import { OnboardingBasePage } from "../onboardingCommon";

export class UnlockPasswordInfoPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new RestoreKeychainSuccessPanel(this.page).goto();
    await new RestoreKeychainSuccessPanel(
      this.page
    ).clickSetUnlockPasswordBtn();
  }
  async clickNextButton() {
    await new OnboardingBasePage(this.page).nextButton.click();
  }
}
