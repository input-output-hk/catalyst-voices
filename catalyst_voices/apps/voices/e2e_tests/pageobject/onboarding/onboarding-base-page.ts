import { test, expect, type Locator, type Page } from "@playwright/test";

export class OnboardingBasePage {
    page: Page;
    nextBtnGroup: Locator;
    nextButton: Locator;
    setUnlockPasswordGroup: Locator;
    setUnlockPasswordBtn: Locator;
    password: string;

    constructor(page:Page) {
        this.page = page;
        this.nextBtnGroup = page.getByRole("group", { name: "NextButton-test" });
        this.nextButton = this.nextBtnGroup.locator('role=button[name="Next"]');
        this.setUnlockPasswordGroup = page.getByRole("group", {
            name: "SetUnlockPasswordButton",
        });
        this.setUnlockPasswordBtn = this.setUnlockPasswordGroup.locator("role=button");
        this.password = "bera1234";
    }
 
}