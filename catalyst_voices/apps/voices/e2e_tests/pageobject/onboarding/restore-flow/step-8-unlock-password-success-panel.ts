import { Locator, Page } from "@playwright/test";
import { UnlockPasswordInputPanel } from "./step-7-unlock-password-input-panel";

export class UnlockPasswordSuccessPanel {
  page: Page;
  jumpToDiscoveryButton: Locator;
  checkMyAccountButton: Locator;

  constructor(page: Page) {
    this.page = page;
  }

  async goto(password: string) {
    await new UnlockPasswordInputPanel(this.page).goto();
    await new UnlockPasswordInputPanel(this.page).fillPassword(password);
    await new UnlockPasswordInputPanel(this.page).confirmPasswordInput.click();
    await new UnlockPasswordInputPanel(this.page).fillConfirmPassword(password);
    await new UnlockPasswordInputPanel(this.page).clickNextButton();
  }
}
