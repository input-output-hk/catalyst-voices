import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { WalletListPanel } from "./step-15-wallet-list";

export class WalletConnectedPanel extends OnboardingBasePage {
  page: Page;
  readonly walletNameValue: Locator;
  readonly walletBalanceValue: Locator;
  readonly walletAddressValue: Locator;
  readonly walletAddressClipboardIcon: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.walletNameValue = page.getByTestId("NameOfWalletValue");
    this.walletBalanceValue = page.getByTestId("WalletBalanceValue");
    this.walletAddressValue = page.getByTestId("WalletAddressValue");
    this.walletAddressClipboardIcon = page.getByTestId(
      "WalletAddressClipboardIcon"
    );
  }

  async goto() {
    await new WalletListPanel(this.page).goto();
    await new WalletListPanel(this.page).clickConnectWallet("Lace");
  }

  async getWalletNameValue() {
    return await this.walletNameValue.innerText();
  }
  async getWalletBalanceValue() {
    return await this.walletBalanceValue.innerText();
  }
  async getWalletAddressValue() {
    await this.walletAddressClipboardIcon.click();
    const address = await this.page.evaluate(() =>
      navigator.clipboard.readText()
    );
    return address;
  }
}
