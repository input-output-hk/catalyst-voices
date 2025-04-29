import { Locator, Page } from "@playwright/test";
import { KeychainFinalPanel } from "./step-14-keychain-final";
import intlEn from "../localization-util";

export  class LinkWalletInfoPanel {
    page: Page
    chooseWalletBtn: Locator

    constructor(page: Page) {
        this.page = page;
        this.chooseWalletBtn = this.page.getByRole("button", {
            name: intlEn.chooseCardanoWallet,
        });
    }

    async goto(password: string) {
        await new KeychainFinalPanel(this.page).goto(password);
        await new KeychainFinalPanel(this.page).clickLinkWalletAndRolesBtn();
    }

    async clickChooseWalletBtn() {
        await this.chooseWalletBtn.click();
    }
}