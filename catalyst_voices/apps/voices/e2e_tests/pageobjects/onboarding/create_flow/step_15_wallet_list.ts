import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { LinkWalletInfoPanel } from "./step_14_link_wallet_info";

export class WalletListPanel extends OnboardingBasePage {
  page: Page;
  laceWalletButton: Locator;
  
  constructor(page: Page) {
    super(page);
    this.page = page;
    this.laceWalletButton = page.getByLabel("Lace");
  }
  async goto() {
    await new LinkWalletInfoPanel(this.page).goto();
    await new LinkWalletInfoPanel(this.page).chooseCardanoWalletButtonClick();  
  }
  async connectLaceWallet() {
   await this.laceWalletButton.click();
  }
}