import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { ProfileSetupPanel } from "./step-3-profile-setup";
import { TestModel } from "../../../models/testModel";

export class ProfileSetupSuccessPanel extends OnboardingBasePage {
  page: Page;
  createKeychainButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.createKeychainButton = page.getByTestId("CreateKeychainButton");
  }
  async goto() {
    await new ProfileSetupPanel(this.page, this.testModel).goto();
    await new ProfileSetupPanel(this.page, this.testModel).enterUsername(this.testModel.accountModel.name);
    await new ProfileSetupPanel(this.page, this.testModel).enterEmail(this.testModel.accountModel.email);
    await new ProfileSetupPanel(this.page, this.testModel).receiveEmailsCheckboxClick();
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }
  async createKeychainClick() {
    await this.click(this.createKeychainButton);
  }
}
