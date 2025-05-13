import { Locator, Page } from "@playwright/test";

export class WalletDetectionPanel {
    page: Page
    selectRolesBtn: Locator

    constructor(page : Page) {
        this.page = page;
        this.selectRolesBtn = page.getByRole("button", { name: "selectRolesBtn" });
    }

    async clickSelectRolesBtn() {

        await this.selectRolesBtn.click();
    }
}