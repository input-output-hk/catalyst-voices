import { Locator, Page } from "@playwright/test";
import { OnboardingBasePage } from "../onboarding-base-page";
import { SeedPhraseSuccessPanel } from "./step-10-seedphrase-success";
import { TestModel } from "../../../models/testModel";

export class PasswordInfoPanel extends OnboardingBasePage {
  page: Page;

  constructor(page: Page, testModel: TestModel) {
    super(page, testModel);
    this.page = page;
  }
  async goto() {
    await new SeedPhraseSuccessPanel(this.page, this.testModel).goto();
    await new OnboardingBasePage(this.page, this.testModel).nextButtonClick();
  }
}
