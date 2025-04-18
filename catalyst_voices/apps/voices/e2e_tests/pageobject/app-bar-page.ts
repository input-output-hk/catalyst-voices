import { Locator, Page } from "@playwright/test";
import intlEn from "./onboarding/localization-util";

export class AppBarPage {
  getStartedBtn: Locator;
  page: Page;

  constructor(page: Page) {
    this.page = page;
    this.getStartedBtn = page.getByRole("button", {
      name: intlEn.getStarted,
    });
  }
  async GetStartedBtnClick() {
    await this.getStartedBtn.click();
  }
}
