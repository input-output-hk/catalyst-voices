import { Page } from "@playwright/test";
import { OnboardingCommon } from "../onboardingCommon";
import { CatalystKeychainInfoPanel } from "./step-6-catalyst-keychain-info";
import { TestModel } from "../../../models/testModel";

export class CatalystKeychainSuccessPanel {
  page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async goto(testModel: TestModel) {
    await new CatalystKeychainInfoPanel(this.page).goto(testModel);
    await new CatalystKeychainInfoPanel(
      this.page
    ).clickCreateCatalystKeychainNowBtn();
  }

  async clickNextButton() {
    await new OnboardingCommon(this.page).nextButton.click();
  }
}
