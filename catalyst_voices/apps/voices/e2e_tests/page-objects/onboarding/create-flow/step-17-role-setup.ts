import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { TestModel } from "../../../models/testModel";
import { WalletConnectedPanel } from "./step-16-wallet-connected";

export class RoleSetupPanel extends OnboardingBasePage {
  proposerYesButton: Locator;
  proposerNoButton: Locator;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.proposerYesButton = page.getByTestId("RoleYesButton");
    this.proposerNoButton = page.getByTestId("RoleNoButton");
  }

  async goto(): Promise<RoleSetupPanel> {
    await new WalletConnectedPanel(this.page, this.testModel).goto();
    await this.nextButtonClick();
    return this;
  }
  async proposerYesButtonClick() {
    await this.click(this.proposerYesButton);
  }
  async proposerNoButtonClick() {
    await this.click(this.proposerNoButton);
  }
}
