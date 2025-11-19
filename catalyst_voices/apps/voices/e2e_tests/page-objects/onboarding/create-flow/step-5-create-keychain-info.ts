import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { ProfileSetupSuccessPanel } from "./step-4-profile-setup-success";
import { TestModel } from "../../../models/testModel";

export class CreateKeychainInfoPanel extends OnboardingBasePage {
  page: Page;
  createKeychainButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.createKeychainButton = page.getByTestId("CreateKeychainNowButton");
  }
  async goto() {
    await new ProfileSetupSuccessPanel(this.page, this.testModel).goto();
    await new ProfileSetupSuccessPanel(this.page, this.testModel).createKeychainClick();
  }
  async createKeychainClick() {
    await this.click(this.createKeychainButton);
  }
}
