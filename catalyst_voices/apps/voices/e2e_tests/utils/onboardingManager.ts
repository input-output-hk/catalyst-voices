import { Page } from "@playwright/test";
import { AccountModel } from "./accountModel";

export class OnboardingManager {
    accountModel: AccountModel;
    readonly page: Page;

    constructor(page: Page) {
        this.page = page;
    }
    async createKeychain(accountModel: AccountModel) {
        this.accountModel = accountModel;
        await 
    }
}