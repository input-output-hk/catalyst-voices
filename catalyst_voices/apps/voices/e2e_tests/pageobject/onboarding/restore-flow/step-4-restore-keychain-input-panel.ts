import { Page } from "@playwright/test";
import { SeedPhraseInstructionsPanel } from "./step-3-seedphrase-instruction-panel";
import { OnboardingBasePage } from "../onboarding-base-page";

export class RestoreKeychainInputPanel {
    page: Page
    constructor(page: Page) {
        this.page = page;
    }

    async goto() {
        await new SeedPhraseInstructionsPanel(this.page).goto();
        await new SeedPhraseInstructionsPanel(this.page).clickNextButton();
    }
    async clickNextButton() {
        await new OnboardingBasePage(this.page).nextButton.click();
    }
}