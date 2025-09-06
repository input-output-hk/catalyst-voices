import { Locator, Page } from "@playwright/test";
import { DiscoveryPage } from "../discovery-page";

export class GetStartedPanel {
  page: Page;
  createKeychainButton: Locator;
  restoreKeychainButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.createKeychainButton = page.getByTestId(
      "CreateAccountType.createNewTitle"
    );
    this.restoreKeychainButton = page.getByTestId(
      "CreateAccountType.recoverTitle"
    );
  }
  async createKeychainClick() {
    await this.createKeychainButton.click();
  }
  async restoreKeychainClick() {
    await this.restoreKeychainButton.click();
  }
  async goto() {
    await new DiscoveryPage(this.page).getStartedButton.click();
  }
}
