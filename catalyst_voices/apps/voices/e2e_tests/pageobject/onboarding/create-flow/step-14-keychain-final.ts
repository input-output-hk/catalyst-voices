import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { PasswordInputPanel } from "./step-13-password-input";

export class KeychainFinalPanel {
  page: Page;
  linkWalletAndRolesBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.linkWalletAndRolesBtn = this.page.getByRole("button", {
      name: "LinkWalletAndRoles-test",
    });
  }

  async goto() {
    await new PasswordInputPanel(this.page).goto();

    await new PasswordInputPanel(this.page).fillPassword(
      new OnboardingBasePage(this.page).password
    );

    await new PasswordInputPanel(this.page).fillConfirmPassword(
      new OnboardingBasePage(this.page).password
    );
    await this.page.waitForTimeout(1000);

    await new OnboardingBasePage(this.page).nextButton.click();
  }

  async clickLinkWalletAndRolesBtn() {
    await this.linkWalletAndRolesBtn.click();
  }
}
