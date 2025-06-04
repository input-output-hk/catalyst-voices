import { Locator, Page } from "@playwright/test";
import { GetStartedPanel } from "../step-1-get-started";
import intlEn from "../localization-util";

export class RestoreKeychainChoicePanel {
  restoreWithSeedphraseBtn: Locator;
  page: Page;
  
  constructor(page: Page) {
    this.page = page;
    this.restoreWithSeedphraseBtn = page.getByRole("group", {
      name: intlEn.recoverWithSeedPhrase12Words,
    });
  }

  async goto() {
    await new GetStartedPanel(this.page).goto();
    await new GetStartedPanel(this.page).clickRecoverCatalystKeychain();
  }

  async clickRestoreWithSeedphrase() {
    await this.restoreWithSeedphraseBtn.click();
  }
}
