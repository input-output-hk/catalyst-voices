import { Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { CatalystKeychainInfoPanel } from "./step-6-catalyst-keychain-info";

export class CatalystKeychainSuccessPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new CatalystKeychainInfoPanel(this.page).goto();
    await new CatalystKeychainInfoPanel(
      this.page
    ).clickCreateCatalystKeychainNowBtn();
  }

  async clickNextButton() {
    await new (this.page).nextButton.click();
  }
}
