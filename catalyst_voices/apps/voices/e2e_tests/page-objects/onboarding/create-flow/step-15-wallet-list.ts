import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { LinkWalletInfoPanel } from "./step-14-link-wallet-info";

export class WalletListPanel extends OnboardingBasePage {
  page: Page;
  walletButton: (name: string) => Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.walletButton = (name: string) =>
      page.getByTestId(`${name.toLowerCase()}-wallet`);
  }
  async goto() {
    await new LinkWalletInfoPanel(this.page).goto();
    await new LinkWalletInfoPanel(this.page).chooseCardanoWalletButtonClick();
    return this;
  }
  async clickConnectWallet(name: string): Promise<Page> {
    const pagePromise = this.page.context().waitForEvent("page");
    await this.walletButton(name).click();
    return await pagePromise;
  }
}
