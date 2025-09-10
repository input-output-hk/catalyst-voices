import { Locator, Page } from "@playwright/test";
import { BasePage } from "./base-page";

export class DiscoveryPage extends BasePage {
  getStartedButton: Locator;

  constructor(page: Page) {
    super(page);
    this.getStartedButton = page.getByTestId("GetStartedButton");
  }

  async clickGetStartedButton() {
    await this.click(this.getStartedButton);
  }
}
