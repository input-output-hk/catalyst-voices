import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { TestModel } from "../../../models/testModel";

export class RoleSetupPanel extends OnboardingBasePage {
  proposerYesButton: Locator;
  proposerNoButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.proposerYesButton = page.getByTestId("RoleYesButton");
    this.proposerNoButton = page.getByTestId("RoleNoButton");
  }
}
