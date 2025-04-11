import { Locator, Page } from "@playwright/test";
import { KaychainFinalPanel } from "./step-14-keychain-final";

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
        await new KaychainFinalPanel(this.page).goto();
        await new KaychainFinalPanel(this.page).clickLinkWalletAndRolesBtn();
    }

    async clickChooseWalletBtn() {
        await this.chooseWalletBtn.click();
    }
}