import { Locator, Page } from "@playwright/test";

export class RoleSetupPanel {
  page: Page;
  proposerYesButton: Locator;
  proposerNoButton: Locator;    

  constructor(page: Page) {
    this.page = page;
    this.proposerYesButton = page.getByTestId("RoleYesButton");
    this.proposerNoButton = page.getByTestId("RoleNoButton");
  }

}