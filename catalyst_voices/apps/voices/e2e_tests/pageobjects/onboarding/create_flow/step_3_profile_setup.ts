import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding_base_page";
import { IntroductionPanel } from "./step_2_introduction";

export class ProfileSetupPanel extends OnboardingBasePage {
  page: Page;
  receiveEmailsCheckbox: Locator;

  constructor(page: Page) {
    super(page);
    this.page = page;
    this.receiveEmailsCheckbox = page.getByTestId("ReceiveEmailsCheckbox_checkbox");
  }

  async receiveEmailsCheckboxClick() {
    await this.receiveEmailsCheckbox.click();
  }
  async goto() {
    await new IntroductionPanel(this.page).goto();
    await new IntroductionPanel(this.page).createYourProfileClick();
  }
}