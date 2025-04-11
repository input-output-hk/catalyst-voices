import { Locator, Page } from "@playwright/test";
import { GetStartedPanel } from "../step-1-get-started";

export class BaseProfileInfoPanel {
  page: Page;
  ceateYourBaseProfilebtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.ceateYourBaseProfilebtn = page.getByRole("button", {
      name: "CreateBaseProfileNext-test",
    });
  }

  async goto() {
    await new GetStartedPanel(this.page).goto();
    await new GetStartedPanel(this.page).clickCreateNewCatalystKeychain();
  }
    
  async clickCreateBaseProfileBtn() {
    await this.ceateYourBaseProfilebtn.click();
  }
}
