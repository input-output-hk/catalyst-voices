import { Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { RestoreKeychainChoicePanel } from "./step-2-base-profile-info";

export class SeedPhraseInstructionsPanel {
    page: Page

    constructor(page: Page) {
        this.page = page;
    }

    async goto() {
        await new RestoreKeychainChoicePanel(this.page).goto();
        await new RestoreKeychainChoicePanel(this.page).clickRestoreWithSeedphrase();
    }
    async clickNextButton() {
        await new OnboardingBasePage(this.page).nextButton.click();
    }
}