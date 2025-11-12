import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { InputPasswordPanel } from "./step-12-input-password";
import { TestModel } from "../../../models/testModel";

export class KeychainFinalPanel extends OnboardingBasePage {
  page: Page;
  linkWalletButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.linkWalletButton = page.getByTestId("LinkWalletAndRolesButton");
  }
  async goto() {
    await new InputPasswordPanel(this.page, this.testModel).goto();
    await new InputPasswordPanel(this.page, this.testModel).inputPassword(this.testModel.accountModel.password);
    await new InputPasswordPanel(this.page, this.testModel).confirmPassword(this.testModel.accountModel.password);
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }
  async linkWalletButtonClick() {
    await this.click(this.linkWalletButton);
  }
}
