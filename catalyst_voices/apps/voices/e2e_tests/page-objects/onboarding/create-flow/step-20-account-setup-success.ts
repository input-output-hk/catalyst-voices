import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { TestModel } from "../../../models/testModel";
import { SignTransactionPanel } from "./step-19-sign-transaction";

export class AccountSetupSuccessPanel extends OnboardingBasePage {
  openDiscoveryButton: Locator;
  reviewMyAccountButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.openDiscoveryButton = page.getByTestId("OpenDiscoveryButton");
    this.reviewMyAccountButton = page.getByTestId("ReviewMyAccountButton");
  }

  async goto(): Promise<AccountSetupSuccessPanel> {
    const signTransactionPanel = await new SignTransactionPanel(this.page, this.testModel).goto();
    await signTransactionPanel.signTransaction();
    return this;
  }
  async openDiscoveryButtonClick() {
    await this.click(this.openDiscoveryButton);
  }
  async reviewMyAccountButtonClick() {
    await this.click(this.reviewMyAccountButton);
  }
}
