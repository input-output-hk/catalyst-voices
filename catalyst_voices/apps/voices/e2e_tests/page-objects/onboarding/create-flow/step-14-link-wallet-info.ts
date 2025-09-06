import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { KeychainFinalPanel } from "./step-13-keychain-final";

export class LinkWalletInfoPanel extends OnboardingBasePage {
  page: Page;
  chooseCardanoWalletButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.chooseCardanoWalletButton = page.getByTestId(
      "ChooseCardanoWalletButton"
    );
  }
  async goto() {
    await new KeychainFinalPanel(this.page).goto();
    await new KeychainFinalPanel(this.page).linkWalletButtonClick();
  }
  async chooseCardanoWalletButtonClick() {
    await this.chooseCardanoWalletButton.click();
  }
}
