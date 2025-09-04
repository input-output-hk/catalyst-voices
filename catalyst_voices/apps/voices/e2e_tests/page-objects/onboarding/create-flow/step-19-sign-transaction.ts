import { Locator, Page } from "@playwright/test";

export class SignTransactionPanel {
  page: Page;
  signTransactionButton: Locator;
  changeRolesButton: Locator;
  
  constructor(page: Page) {
    this.page = page;
    this.signTransactionButton = page.getByTestId("SignTransactionButton");
    this.changeRolesButton = page.getByTestId("TransactionReviewChangeRolesButton");
  }
  async signTransactionClick() {
    await this.signTransactionButton.click();
  }
  async changeRolesClick() {
    await this.changeRolesButton.click();
  }
}