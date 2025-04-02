import { Locator, Page } from "@playwright/test";
import { RestoreKeychainInputPanel } from "./step-4-restore-keychain-input-panel";

export class RestoreKeychainSuccessPanel {
  page: Page;
  setUnlockPasswordBtn: Locator;

  constructor(page: Page) {
    this.page = page;
    this.setUnlockPasswordBtn = page.getByRole("group", {
      name: "SetUnlockPasswordButton",
    });
  }

  async goto() {
    await new RestoreKeychainInputPanel(this.page).goto();
    await new RestoreKeychainInputPanel(this.page).clickNextButton();
  }
  async clickSetUnlockPasswordBtn() {
    await this.page.waitForTimeout(300);
    await this.setUnlockPasswordBtn.click();
  }
}
