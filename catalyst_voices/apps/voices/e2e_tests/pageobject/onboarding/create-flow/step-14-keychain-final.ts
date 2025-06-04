import { Locator, Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { PasswordInputPanel } from "./step-13-password-input";
import { TestModel } from "../../../models/testModel";

export class KeychainFinalPanel {
  page: Page;
  linkWalletAndRolesBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.linkWalletAndRolesBtn = this.page.getByTestId("");
  }

  async goto(testModel: TestModel) {
    await new PasswordInputPanel(this.page).goto(testModel);
    await new PasswordInputPanel(this.page).fillPassword(testModel.accountModel.password);
    await new PasswordInputPanel(this.page).fillConfirmPassword(testModel.accountModel.password);
    await this.page.waitForTimeout(1000);

    await new OnboardingCommon(this.page).nextButton.click();
  }

  async clickLinkWalletAndRolesBtn() {
    await this.linkWalletAndRolesBtn.click();
  }
}
