import { Locator, Page } from "@playwright/test";

export class RoleOverviewPanel {
  page: Page;
  rolesSummaryReviewTransactionButton: Locator;
  rolesSummaryChangeRolesButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.rolesSummaryReviewTransactionButton = page.getByTestId("RolesSummaryReviewTransaction");
    this.rolesSummaryChangeRolesButton = page.getByTestId("RolesSummaryChangeRoles");
  }
  async reviewTransactionClick() {
    await this.rolesSummaryReviewTransactionButton.click();
  }
  async changeRolesClick() {
    await this.rolesSummaryChangeRolesButton.click();
  }
}