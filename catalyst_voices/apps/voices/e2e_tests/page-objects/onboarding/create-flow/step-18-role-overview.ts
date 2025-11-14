import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { TestModel } from "../../../models/testModel";

export class RoleOverviewPanel extends OnboardingBasePage {
  rolesSummaryReviewTransactionButton: Locator;
  rolesSummaryChangeRolesButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.rolesSummaryReviewTransactionButton = page.getByTestId("RolesSummaryReviewTransaction");
    this.rolesSummaryChangeRolesButton = page.getByTestId("RolesSummaryChangeRoles");
  }
  async reviewTransactionClick() {
    await this.click(this.rolesSummaryReviewTransactionButton);
  }
  async changeRolesClick() {
    await this.click(this.rolesSummaryChangeRolesButton);
  }
}