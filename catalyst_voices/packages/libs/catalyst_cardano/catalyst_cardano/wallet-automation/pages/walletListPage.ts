import { Page } from "@playwright/test";
import { BrowserExtensionName } from "../utils/extensions";

export class WalletListPage {
  readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }
  async clickEnableWallet(walletName: BrowserExtensionName): Promise<void> {
    if (walletName === BrowserExtensionName.Nufi) {
      const [walletPopup] = await Promise.all([
        this.page.context().waitForEvent("page"),
        await this.page.locator('//*[text()="Enable wallet"]').first().click(),
      ]);
      await walletPopup.locator("button:has-text('Connect')").click();
    } else {
      await this.page.locator('//*[text()="Enable wallet"]').first().click();
    }
    await this.page.waitForTimeout(2000);
  }
}
