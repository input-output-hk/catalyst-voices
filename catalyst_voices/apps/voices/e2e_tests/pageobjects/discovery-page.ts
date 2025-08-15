import { Locator, Page } from "@playwright/test";

export class DiscoveryPage {
  page: Page;
  getStartedButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.getStartedButton = page.getByTestId("GetStartedButton");
  }
}
