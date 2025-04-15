import { Locator, Page } from "@playwright/test";
import intlEn from "../localization-util";
import { GetStartedPanel } from "../step-1-get-started";

export class BaseProfileInfoPanel {
  page: Page;
  createYourBaseProfileBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.createYourBaseProfileBtn = page.getByRole("button", {
      name: intlEn.createBaseProfileInstructionsNext,
    });
  }

  async goto() {
    await new GetStartedPanel(this.page).goto();
    await new GetStartedPanel(this.page).clickCreateNewCatalystKeychain();
  }

  async clickCreateBaseProfileBtn() {
    await this.createYourBaseProfileBtn.click();
  }
}
