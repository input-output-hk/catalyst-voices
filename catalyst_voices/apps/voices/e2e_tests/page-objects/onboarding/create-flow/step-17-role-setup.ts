import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";

export class RoleSetupPanel extends OnboardingBasePage {
  proposerYesButton: Locator;
  proposerNoButton: Locator;

  constructor(page: Page) {
    super(page);
    this.proposerYesButton = page.getByTestId("RoleYesButton");
    this.proposerNoButton = page.getByTestId("RoleNoButton");
  }
}
