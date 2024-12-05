import { Locator, Page } from '@playwright/test';
import { BrowserExtensionName } from '../utils/extensions';


export class WalletListPage {
  readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }
  async clickEnableWallet(walletName: BrowserExtensionName): Promise<void> {
    const enableButton = (walletName: BrowserExtensionName) => this.page.locator(
      `flt-semantics:has(flt-semantics-img[aria-label*="Name: ${walletName.toLowerCase()}"]) ` +
      `flt-semantics[role="button"]:has-text("Enable wallet")`
    );
    await enableButton(walletName).click();
  }
}