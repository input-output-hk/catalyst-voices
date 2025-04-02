import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { UnlockPasswordInfoPanel } from "./step-6-unlock-password-info-panel";

export class UnlockPasswordInputPanel {
  page: Page;
  passwordInput: Locator;
  confirmPasswordInput: Locator;

  constructor(page: Page) {
      this.page = page;
      this.passwordInput = page
          .locator('role=group[name="Enter password"] >> role=textbox');
      this.confirmPasswordInput = page
          .locator('role=group[name="Confirm password"] >> role=textbox');
  }

  async goto() {
    await new UnlockPasswordInfoPanel(this.page).goto();
    await new UnlockPasswordInfoPanel(this.page).clickNextButton();
  }
    async fillPassword(password: string) {
        await this.passwordInput.fill(password);
    }
    async fillConfirmPassword(password: string) {
        await this.confirmPasswordInput.fill(password);
    }
  async clickNextButton() {
    await new OnboardingBasePage(this.page).nextButton.click();
  }
}
