import { test } from "../fixtures";
import { expect } from "@playwright/test";
import { getWalletConfig } from "../data/walletConfigs";

test.describe("Onboarding - ", () => {
  test("creates keychain", async ({ restoreWallet, appBaseURL }) => {
    const browser = await restoreWallet(getWalletConfig("1"));
    const page = browser.pages()[0];
    await page.goto(appBaseURL);
    await page
      .locator("//*[@aria-label='Enable accessibility']")
      .evaluate((element: HTMLElement) => element.click());
  });
});
