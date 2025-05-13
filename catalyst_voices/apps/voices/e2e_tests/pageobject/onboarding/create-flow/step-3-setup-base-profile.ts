import { Locator, Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { BaseProfileInfoPanel } from "./step-2-base-profile-info";

export class SetupBaseProfilePanel {
  page: Page;
  usernameInput: Locator;
  emailInput: Locator;
  onboardingCommon: OnboardingCommon;

  constructor(page: Page) {
    this.page = page;
    this.usernameInput = page
      .getByTestId("DisplayNameTextField")
      .locator("input");
    this.emailInput = page.getByTestId("EmailTextField").locator("input");
    this.onboardingCommon = new OnboardingCommon(this.page);
  }

  async goto() {
    await new BaseProfileInfoPanel(this.page).goto();
    await new BaseProfileInfoPanel(this.page).clickCreateBaseProfileBtn();
  }

  async fillUsername(username: string) {
    await this.usernameInput.fill(username);
  }

  async fillEmail(email: string) {
    await this.emailInput.fill(email);
  }

  async clickNextButton() {
    await this.onboardingCommon.clickNextButton();
  }
}
