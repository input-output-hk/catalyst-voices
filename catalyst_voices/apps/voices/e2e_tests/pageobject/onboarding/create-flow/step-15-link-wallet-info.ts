import { Locator, Page } from "@playwright/test";
import { KeychainFinalPanel } from "./step-14-keychain-final";

export  class LinkWalletInfoPanel {
    page: Page
    chooseWalletBtn: Locator

    constructor(page: Page) {
        this.page = page;
        this.chooseWalletBtn = this.page.getByRole("button", {
            name: "ChooseCardanoWalletButton",
        });
    }

    async goto() {
        await new KeychainFinalPanel(this.page).goto();
        await new KeychainFinalPanel(this.page).clickLinkWalletAndRolesBtn();
    }

    async clickChooseWalletBtn() {
        await this.chooseWalletBtn.click();
    }
}