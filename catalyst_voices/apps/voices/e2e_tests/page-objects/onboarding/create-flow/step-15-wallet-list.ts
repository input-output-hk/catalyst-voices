import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { LinkWalletInfoPanel } from "./step-14-link-wallet-info";
import { TestModel } from "../../../models/testModel";
import { createWalletActions } from "../../../utils/wallets/wallet-actions-factory";

export class WalletListPanel extends OnboardingBasePage {
  page: Page;
  walletButton: (name: string) => Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.walletButton = (name: string) => page.getByTestId(`${name.toLowerCase()}-wallet`);
  }
  async goto() {
    await new LinkWalletInfoPanel(this.page, this.testModel).goto();
    await new LinkWalletInfoPanel(this.page, this.testModel).chooseCardanoWalletButtonClick();
    return this;
  }
  async connectWallet(): Promise<void> {
    const pagePromise = this.page.context().waitForEvent("page");
    await this.click(this.walletButton(this.testModel.walletConfig.name));
    const page = await pagePromise;
    await createWalletActions(this.testModel.walletConfig, page).connectWallet();
  }
}
