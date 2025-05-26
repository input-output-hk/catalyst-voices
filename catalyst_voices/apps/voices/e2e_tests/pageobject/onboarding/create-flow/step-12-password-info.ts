import { Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { SeedphraseSuccessPanel } from "./step-11-seedphrase-success";
import { TestModel } from "../../../models/testModel";

export class PasswordInfoPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto(testModel: TestModel) {
    await new SeedphraseSuccessPanel(this.page).goto(testModel);
    await new SeedphraseSuccessPanel(this.page).clickNextButton();
  }

  async clickNextButton() {
    new OnboardingCommon(this.page).nextButton.click();
  }
}
