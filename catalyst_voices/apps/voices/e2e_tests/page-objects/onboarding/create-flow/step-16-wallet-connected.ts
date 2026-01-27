import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { WalletListPanel } from "./step-15-wallet-list";
import { TestModel } from "../../../models/testModel";

export class WalletConnectedPanel extends OnboardingBasePage {
  page: Page;
  readonly walletNameValue: Locator;
  readonly walletBalanceValue: Locator;
  readonly walletAddressValue: Locator;
  readonly walletAddressClipboardIcon: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.walletNameValue = page.getByTestId("NameOfWalletValue");
    this.walletBalanceValue = page.getByTestId("WalletBalanceValue");
    this.walletAddressValue = page.getByTestId("WalletAddressValue");
    this.walletAddressClipboardIcon = page.getByTestId("WalletAddressClipboardIcon");
  }

  async goto(): Promise<WalletConnectedPanel> {
    await new WalletListPanel(this.page, this.testModel).goto();
    await new WalletListPanel(this.page, this.testModel).connectWallet();
    return this;
  }

  async getWalletNameValue() {
    return await this.walletNameValue.innerText();
  }
  async getWalletBalanceValue() {
    return await this.walletBalanceValue.innerText();
  }
  async getWalletAddressValue() {
    await this.click(this.walletAddressClipboardIcon);
    const address = await this.page.evaluate(async () => await navigator.clipboard.readText());
    return address;
  }
}
