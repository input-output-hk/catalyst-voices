import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { TestModel } from "../../../models/testModel";
import { RoleSetupPanel } from "./step-17-role-setup";

export class RoleOverviewPanel extends OnboardingBasePage {
  rolesSummaryReviewTransactionButton: Locator;
  rolesSummaryChangeRolesButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.rolesSummaryReviewTransactionButton = page.getByTestId("RolesSummaryReviewTransaction");
    this.rolesSummaryChangeRolesButton = page.getByTestId("RolesSummaryChangeRoles");
  }

  async goto(): Promise<RoleOverviewPanel> {
    const roleSetupPanel = await new RoleSetupPanel(this.page, this.testModel).goto();
    if (this.testModel.accountModel.isProposer) {
      await roleSetupPanel.proposerYesButtonClick();
    } else {
      await roleSetupPanel.proposerNoButtonClick();
    }
    await this.nextButtonClick();
    return this;
  }
  async reviewTransactionClick() {
    await this.click(this.rolesSummaryReviewTransactionButton);
  }
  async changeRolesClick() {
    await this.click(this.rolesSummaryChangeRolesButton);
  }
}
