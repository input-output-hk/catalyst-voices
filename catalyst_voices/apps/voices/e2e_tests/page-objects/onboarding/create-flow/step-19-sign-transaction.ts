import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";

export class SignTransactionPanel extends OnboardingBasePage {
  signTransactionButton: Locator;
  changeRolesButton: Locator;

  constructor(page: Page) {
    super(page);
    this.signTransactionButton = page.getByTestId("SignTransactionButton");
    this.changeRolesButton = page.getByTestId(
      "TransactionReviewChangeRolesButton"
    );
  }
  async signTransactionClick() {
    await this.click(this.signTransactionButton);
  }
  async changeRolesClick() {
    await this.click(this.changeRolesButton);
  }
}
