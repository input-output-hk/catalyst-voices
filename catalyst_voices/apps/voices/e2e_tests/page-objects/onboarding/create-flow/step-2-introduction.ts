import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { GetStartedPanel } from "../step-1-get-started";
import { TestModel } from "../../../models/testModel";

export class IntroductionPanel extends OnboardingBasePage {
  page: Page;
  tosCheckbox: Locator;
  privacyPolicyCheckbox: Locator;
  drepCheckbox: Locator;
  createYourProfileButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
    this.tosCheckbox = page.getByTestId("RegistrationConditionsCheckbox_checkbox");
    this.privacyPolicyCheckbox = page.getByTestId("tosAndPrivacyPolicyCheckbox_checkbox");
    this.drepCheckbox = page.getByTestId("drepApprovalContingencyCheckbox_checkbox");
    this.createYourProfileButton = page.getByTestId("createProfileInstructionsNext");
  }

  async goto() {
    await new GetStartedPanel(this.page).goto();
    await new GetStartedPanel(this.page).createKeychainClick();
  }
  async createYourProfileClick() {
    await this.click(this.createYourProfileButton);
  }
  async tosCheckboxClick() {
    await this.click(this.tosCheckbox);
  }
  async privacyPolicyCheckboxClick() {
    await this.click(this.privacyPolicyCheckbox);
  }
  async drepCheckboxClick() {
    await this.click(this.drepCheckbox);
  }
}
