import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { PasswordInfoPanel } from "./step-11-password-info";
import { TestModel } from "../../../models/testModel";

export class InputPasswordPanel extends OnboardingBasePage {
  page: Page;
  passwordInput: Locator;
  passwordConfirmInput: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.passwordInput = page.getByTestId("PasswordInputField").locator("input");
    this.passwordConfirmInput = page.getByTestId("PasswordConfirmInputField").locator("input");
  }
  async goto() {
    await new PasswordInfoPanel(this.page, this.testModel).goto();
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }
  async inputPassword(password: string) {
    await this.click(this.passwordInput);
    await this.page.waitForTimeout(100);
    await this.passwordInput.pressSequentially(password);
  }
  async confirmPassword(password: string) {
    await this.click(this.passwordConfirmInput);
    await this.page.waitForTimeout(100);
    await this.passwordConfirmInput.pressSequentially(password);
  }
}
