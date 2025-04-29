import { WalletListPanel } from "../pageobject/onboarding/create-flow/step-16-wallet-list";
import { WalletDetectionPanel } from "../pageobject/onboarding/create-flow/step-18-wallet-detection";
import { OnboardingBasePage } from "../pageobject/onboarding/onboarding-base-page";
import { UnlockPasswordSuccessPanel } from "../pageobject/onboarding/restore-flow/step-8-unlock-password-success-panel";
import { test } from "../test-fixtures";
import { walletConfigs } from "../utils/walletConfigs";
import { WalletConfig } from "../utils/wallets/walletUtils";

const walletConfig: WalletConfig = walletConfigs[3];

// do some non-happy flows (wrong seed phrase, cancel connection, no wallet, etc)

// test("Refactored restore flow demo", async ({ page }) => {
//   await page.goto("http://localhost:51709/m4/discovery");
//   await new UnlockPasswordSuccessPanel(page).goto("test1234");
// });

test(
  "Create keychain and link wallet for " + walletConfig.extension.Name,
  async ({ restoreWallet }) => {
    const browser = await restoreWallet(walletConfig);
    const page = browser.pages()[0];

    // await new WalletListPage(page).clickEnableWallet(walletConfig.extension.Name);
    await page.goto("http://localhost:55338/m4/discovery");
    await new WalletListPanel(page).goto("test1234");
    const [walletPopup] = await Promise.all([
      browser.waitForEvent("page"),
      new WalletListPanel(page).clickYoroiWallet(),
    ]);
    await walletPopup.locator("div.ConnectedWallet_wrapper").click();
    await page.waitForTimeout(2000);
    await new WalletDetectionPanel(page).clickSelectRolesBtn();
    await new OnboardingBasePage(page).nextButton.click();
    await page.locator('role=button[name="reviewRegTransaction"]').click();
    const [signPopup] = await Promise.all([
      browser.waitForEvent("page"),
      page.locator('role=button[name="SignBtn"]').click({ delay: 100 }),
    ]);
    await signPopup.locator("#walletPassword").fill(walletConfig.password);
    await signPopup.locator("#confirmButton").click();
  }
);
