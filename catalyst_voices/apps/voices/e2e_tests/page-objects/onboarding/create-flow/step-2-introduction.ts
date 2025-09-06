import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { GetStartedPanel } from "../step-1-get-started";

export class IntroductionPanel extends OnboardingBasePage {
  page: Page;
  tosCheckbox: Locator;
  privacyPolicyCheckbox: Locator;
  drepCheckbox: Locator;
  createYourProfileButton: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.tosCheckbox = page.getByTestId("RegistrationConditionsCheckbox_checkbox");
    this.privacyPolicyCheckbox = page.getByTestId("tosAndPrivacyPolicyCheckbox_checkbox");
    this.drepCheckbox = page.getByTestId("drepApprovalContingencyCheckbox_checkbox");
    this.createYourProfileButton = page.getByTestId("createProfileInstructionsNext");
  }

  async goto() {
    await  new GetStartedPanel(this.page).goto();
    await  new GetStartedPanel(this.page).createKeychainClick();
  }
  async createYourProfileClick() {
    await this.createYourProfileButton.click();
  }
  async tosCheckboxClick() {
    await this.tosCheckbox.click();
  }
  async privacyPolicyCheckboxClick() {
    await this.privacyPolicyCheckbox.click();
  }
  async drepCheckboxClick() {
    await this.drepCheckbox.click();
  }
}