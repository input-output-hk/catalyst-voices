import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { UnlockPasswordInputPanel } from "./step-7-unlock-password-input-panel";

export class UnlockPasswordSuccessPanel {
  page: Page;
  jumpToDiscoveryButton: Locator;
  checkMyAccountButton: Locator;

  constructor(page: Page) {
    this.page = page;
  }

  async goto() {
    await new UnlockPasswordInputPanel(this.page).goto();
    await new UnlockPasswordInputPanel(this.page).fillPassword(
      new OnboardingBasePage(this.page).password
    );
    await new UnlockPasswordInputPanel(this.page).confirmPasswordInput.click();
    await new UnlockPasswordInputPanel(this.page).fillConfirmPassword(
      new OnboardingBasePage(this.page).password
    );
    await new UnlockPasswordInputPanel(this.page).clickNextButton();
  }
}
