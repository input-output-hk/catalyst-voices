import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { CreateKeychainInfoPanel } from "./step_5_create_keychain_info";

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