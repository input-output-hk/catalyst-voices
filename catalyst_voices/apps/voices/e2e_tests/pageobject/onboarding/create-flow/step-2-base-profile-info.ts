import { Locator, Page } from "@playwright/test";
import { GetStartedPanel } from "../step-1-get-started";

export class BaseProfileInfoPanel {
  page: Page;
  createYourBaseProfileBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.createYourBaseProfileBtn = page.getByTestId('CreateBaseProfileNextButton');
  }

  async goto() {
    await new GetStartedPanel(this.page).goto();
    await new GetStartedPanel(this.page).clickCreateNewCatalystKeychain();
  }

  async clickCreateBaseProfileBtn() {
    await this.createYourBaseProfileBtn.click();
  }
}
