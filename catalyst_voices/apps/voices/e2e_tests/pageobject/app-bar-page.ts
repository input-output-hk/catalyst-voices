import { Locator, Page } from "@playwright/test";

export class AppBarPage {
  getStartedBtn: Locator;
  page: Page;

  constructor(page: Page) {
    this.page = page;
    this.getStartedBtn = this.page.getByTestId("GetStartedBtn");
  }
  async GetStartedBtnClick() {
    await this.getStartedBtn.click();
  }
}
