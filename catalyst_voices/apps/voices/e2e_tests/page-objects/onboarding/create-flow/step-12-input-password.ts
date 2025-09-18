import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { PasswordInfoPanel } from "./step-11-password-info";

export class InputPasswordPanel extends OnboardingBasePage {
  page: Page;
  passwordInput: Locator;
  passwordConfirmInput: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.passwordInput = page.locator(
      "input[type='password'][aria-label='Enter password']"
    );
    this.passwordConfirmInput = page.locator(
      "input[type='password'][aria-label='Confirm password']"
    );
  }
  async goto() {
    await new PasswordInfoPanel(this.page).goto();
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
  async inputPassword(password: string) {
    await this.click(this.passwordInput);
    await this.passwordInput.fill(password);
  }
  async confirmPassword(password: string) {
    await this.click(this.passwordConfirmInput);
    await this.passwordConfirmInput.fill(password);
  }
}
