import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { InputPasswordPanel } from "./step-12-input-password";

export class KeychainFinalPanel extends OnboardingBasePage {
  page: Page;
  linkWalletButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.linkWalletButton = page.getByTestId("LinkWalletAndRolesButton");
  }
  async goto() {
    await new InputPasswordPanel(this.page).goto();
    await new InputPasswordPanel(this.page).inputPassword("12341234");
    await new InputPasswordPanel(this.page).confirmPassword("12341234");
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
  async linkWalletButtonClick() {
    await this.click(this.linkWalletButton);
  }
}
