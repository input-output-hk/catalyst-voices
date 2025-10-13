import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { InputPasswordPanel } from "./step-12-input-password";

export class KeychainFinalPanel extends OnboardingBasePage {
  page: Page;
  linkWalletButton: Locator;
  inputPasswordPanel: InputPasswordPanel;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.linkWalletButton = page.getByTestId("LinkWalletAndRolesButton");
    this.inputPasswordPanel = new InputPasswordPanel(page);
  }
  async goto() {
    await this.inputPasswordPanel.goto();
    await this.inputPasswordPanel.inputPassword("12341234");
    await this.inputPasswordPanel.confirmPassword("12341234");
    await new OnboardingBasePage(this.page).nextButtonClick();
  }
  async linkWalletButtonClick() {
    await this.click(this.linkWalletButton);
  }
}
