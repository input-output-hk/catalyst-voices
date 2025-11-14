import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { IntroductionPanel } from "./step-2-introduction";
import { TestModel } from "../../../models/testModel";

export class ProfileSetupPanel extends OnboardingBasePage {
  page: Page;
  receiveEmailsCheckbox: Locator;
  usernameTextField: Locator;
  emailTextField: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.receiveEmailsCheckbox = page.getByTestId("ReceiveEmailsCheckbox_checkbox");
    this.usernameTextField = page.getByTestId("UsernameTextField").locator("input");
    this.emailTextField = page.getByTestId("EmailTextFieldInput").locator("input");
  }

  async receiveEmailsCheckboxClick() {
    await this.click(this.receiveEmailsCheckbox);
  }

  async enterUsername(username: string) {
    await this.usernameTextField.click();
    await this.usernameTextField.focus();
    await this.page.waitForTimeout(100);
    await this.usernameTextField.clear();
    await this.usernameTextField.pressSequentially(username);
  }
  async enterEmail(email: string) {
    await this.emailTextField.click();
    await this.emailTextField.focus();
    await this.page.waitForTimeout(100);
    await this.emailTextField.clear();
    await this.emailTextField.pressSequentially(email);
  }
  async goto() {
    await new IntroductionPanel(this.page, this.testModel).goto();
    await new IntroductionPanel(this.page, this.testModel).createYourProfileClick();
  }
}
