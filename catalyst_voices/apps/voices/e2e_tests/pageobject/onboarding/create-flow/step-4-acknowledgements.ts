import { Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { SetupBaseProfilePanel } from "./step-3-setup-base-profile";
import { TestModel } from "../../../models/testModel";

export class AcknowledgementsPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto(testModel: TestModel) {
    await new SetupBaseProfilePanel(this.page).goto();
    await new SetupBaseProfilePanel(this.page).fillUsername(
      testModel.accountModel.name
    );
    await new SetupBaseProfilePanel(this.page).fillEmail(
      testModel.accountModel.email
    );
    await new SetupBaseProfilePanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    await new OnboardingCommon(this.page).nextButton.click();
  }
}
