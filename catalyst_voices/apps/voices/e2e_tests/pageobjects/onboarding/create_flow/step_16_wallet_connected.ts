import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { WalletListPanel } from "./step_15_wallet_list";

export class WalletConnectedPanel extends OnboardingBasePage{
  page: Page;
  

  constructor(page: Page) {
    super(page);
    this.page = page;
  }

  async goto() {
    await new WalletListPanel(this.page).goto();
    await new WalletListPanel(this.page).connectLaceWallet();
  }
}