import { Locator, Page } from "@playwright/test";
import { LinkWalletInfoPanel } from "./step-15-link-wallet-info";
import { TestModel } from "../../../models/testModel";

export class WalletListPanel {
  page: Page;
  yoroiWallet: Locator;
  laceWallet: Locator;
  eternlWallet: Locator;
  nufiWallet: Locator;

  constructor(page: Page) {
    this.page = page;
    this.yoroiWallet = page.getByRole("button", {
      name: "yoroi",
    });
    this.laceWallet = page.getByRole("button", {
      name: "lace",
    });
    this.eternlWallet = page.getByRole("button", {
      name: "eternl",
    });
    this.nufiWallet = page.getByRole("button", {
      name: "nufi",
    });
  }

  async goto(testModel: TestModel) {
    await new LinkWalletInfoPanel(this.page).goto(testModel);
    await new LinkWalletInfoPanel(this.page).clickChooseWalletBtn();
  }

  async clickWallet(walletName: string) {
    switch (walletName) {
      case "yoroi":
        await this.yoroiWallet.click();
        break;
      case "lace":
        await this.laceWallet.click();
        break;
      case "eternl":
        await this.eternlWallet.click();
        break;
      case "nufi":
        await this.nufiWallet.click();
        break;
      default:
        throw new Error(`Wallet ${walletName} not found`);
    }
  }
}
