import { Page } from "@playwright/test";
import { WalletListPanel } from "./step-16-wallet-list";

export class WalletPopupSelection {
    page: Page

    constructor(page) {
        this.page = page;
    }

    async goto() { 
        await new WalletListPanel(this.page).goto();
        await new WalletListPanel(this.page).clickYoroiWallet();
    }
    async clickWalletPopup() { 
        const [walletPopup] = await Promise.all([
          browser.waitForEvent("page"),
          new WalletListPanel(page).clickYoroiWallet(),
        ]);
    }
}