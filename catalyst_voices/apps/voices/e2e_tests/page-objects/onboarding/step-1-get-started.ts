import { Locator, Page } from "@playwright/test";
import { DiscoveryPage } from "../discovery-page";
import { BasePage } from "../base-page";

export class GetStartedPanel extends BasePage {
  createKeychainButton: Locator;
  restoreKeychainButton: Locator;

  constructor(page: Page) {
    super(page);
    this.createKeychainButton = page.getByTestId(
      "CreateAccountType.createNewTitle"
    );
    this.restoreKeychainButton = page.getByTestId(
      "CreateAccountType.recoverTitle"
    );
  }
  async createKeychainClick() {
    await this.click(this.createKeychainButton);
  }
  async restoreKeychainClick() {
    await this.click(this.restoreKeychainButton);
  }
  async goto() {
    const discoveryPage = new DiscoveryPage(this.page);
    await discoveryPage.clickGetStartedButton();
  }
}
