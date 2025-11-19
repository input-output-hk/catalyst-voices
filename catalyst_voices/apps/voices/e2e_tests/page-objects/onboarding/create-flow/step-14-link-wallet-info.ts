import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { KeychainFinalPanel } from "./step-13-keychain-final";
import { TestModel } from "../../../models/testModel";

export class LinkWalletInfoPanel extends OnboardingBasePage {
  page: Page;
  chooseCardanoWalletButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.chooseCardanoWalletButton = page.getByTestId(
      "ChooseCardanoWalletButton"
    );
  }
  async goto() {
    await new KeychainFinalPanel(this.page, this.testModel).goto();
    await new KeychainFinalPanel(this.page, this.testModel).linkWalletButtonClick();
  }
  async chooseCardanoWalletButtonClick() {
    await this.click(this.chooseCardanoWalletButton);
  }
}
