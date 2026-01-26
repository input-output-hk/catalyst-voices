import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { TestModel } from "../../../models/testModel";
import { RoleOverviewPanel } from "./step-18-role-overview";
import { createWalletActions } from "../../../utils/wallets/wallet-actions-factory";

export class SignTransactionPanel extends OnboardingBasePage {
  signTransactionButton: Locator;
  changeRolesButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.signTransactionButton = page.getByTestId("SignTransactionButton");
    this.changeRolesButton = page.getByTestId("TransactionReviewChangeRolesButton");
  }

  async goto(): Promise<SignTransactionPanel> {
    const roleOverviewPanel = await new RoleOverviewPanel(this.page, this.testModel).goto();
    await roleOverviewPanel.reviewTransactionClick();
    await this.page.waitForTimeout(1000);
    return this;
  }
  async signTransaction() {
    const pagePromise = this.page.context().waitForEvent("page");
    await this.click(this.signTransactionButton);
    const page = await pagePromise;
    await createWalletActions(this.testModel.walletConfig, page).approveTransaction();
    return page;
  }
  async changeRolesClick() {
    await this.click(this.changeRolesButton);
  }
}
