import { Locator, Page } from "@playwright/test";
import { PasswordInfoPanel } from "./step-12-password-info";

export class PasswordInputPanel {
  page: Page;
  passwordInput: Locator;
  confirmPasswordInput: Locator;

  constructor(page: Page) {
    this.page = page;
    this.passwordInput = page.locator(
      'role=group[name="Enter password"] >> role=textbox'
    );
    this.confirmPasswordInput = page.locator(
      'role=group[name="Confirm password"] >> role=textbox'
    );
  }

  async goto() {
    await new PasswordInfoPanel(this.page).goto();
    await new PasswordInfoPanel(this.page).clickNextButton();
  }

  async fillPassword(password: string) {
    await this.passwordInput.click();
    await this.page.waitForTimeout(1000);

    await this.passwordInput.fill(password);
  }

  async fillConfirmPassword(password: string) {
    await this.confirmPasswordInput.click();
    await this.page.waitForTimeout(1000);

    await this.confirmPasswordInput.fill(password);
  }
}
