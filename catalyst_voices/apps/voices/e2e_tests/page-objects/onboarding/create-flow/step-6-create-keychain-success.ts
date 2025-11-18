import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { CreateKeychainInfoPanel } from "./step-5-create-keychain-info";
import { TestModel } from "../../../models/testModel";

export class CreateKeychainSuccessPanel extends OnboardingBasePage {
  page: Page;
  openDiscoveryButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
  }
  async goto() {
    await new CreateKeychainInfoPanel(this.page, this.testModel).goto();
    await new CreateKeychainInfoPanel(this.page, this.testModel).createKeychainClick();
  }
}
