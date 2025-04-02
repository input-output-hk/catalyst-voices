import { Locator, Page } from "@playwright/test";
import { GetStartedPanel } from "../step-1-get-started";

export class RestoreKeychainChoicePanel {
  restoreWithSeedphraseBtn: Locator;
  page: Page;

  constructor(page: Page) {
    this.page = page;
    this.restoreWithSeedphraseBtn = page.getByRole("group", {
      name: "Restore seedphrase Restore/Upload with 12-word seed phrase",
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
