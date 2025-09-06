import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { CreateKeychainInfoPanel } from "./step-5-create-keychain-info";

export class CreateKeychainSuccessPanel extends OnboardingBasePage {
  page: Page;
  openDiscoveryButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
  }
  async goto() {
    await new CreateKeychainInfoPanel(this.page).goto();
    await new CreateKeychainInfoPanel(this.page).createKeychainClick();
  }
}
