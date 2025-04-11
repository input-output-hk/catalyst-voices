import { Locator, Page } from "@playwright/test";

export class AppBarPage {
  getStartedBtn: Locator;
  page: Page;
  
  constructor(page: Page) {
    this.page = page;
    this.getStartedBtn = page.getByRole("button", {
      name: "GetStartedButton-test",
    });
  }
  async GetStartedBtnClick() {
    await this.getStartedBtn.click();
  }
}
