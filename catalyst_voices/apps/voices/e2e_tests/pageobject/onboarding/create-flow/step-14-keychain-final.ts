import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboardingCommon";
import { PasswordInputPanel } from "./step-13-password-input";
import intlEn from "../localization-util";

export class KeychainFinalPanel {
  page: Page;
  linkWalletAndRolesBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.linkWalletAndRolesBtn = this.page.getByRole("button", {
      name: intlEn.createKeychainLinkWalletAndRoles,
    });
  }

  async goto(password: string) {
    await new PasswordInputPanel(this.page).goto();
    await new PasswordInputPanel(this.page).fillPassword(password);
    await new PasswordInputPanel(this.page).fillConfirmPassword(password);
    await this.page.waitForTimeout(1000);

    await new OnboardingBasePage(this.page).nextButton.click();
  }

  async clickLinkWalletAndRolesBtn() {
    await this.linkWalletAndRolesBtn.click();
  }
}
