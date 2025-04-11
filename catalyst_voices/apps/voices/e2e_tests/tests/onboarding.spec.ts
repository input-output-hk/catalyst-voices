import { WalletListPanel } from "../pageobject/onboarding/create-flow/step-16-wallet-list";
import { WalletDetectionPanel } from "../pageobject/onboarding/create-flow/step-18-wallet-detection";
import { OnboardingBasePage } from "../pageobject/onboarding/onboarding-base-page";
import { UnlockPasswordSuccessPanel } from "../pageobject/onboarding/restore-flow/step-8-unlock-password-success-panel";
import { test } from "../test-fixtures";
import { walletConfigs } from "../utils/walletConfigs";
import { WalletConfig } from "../utils/wallets/walletUtils";

const walletConfig: WalletConfig = walletConfigs[3];

// do some non-happy flows (wrong seed phrase, cancel connection, no wallet, etc)
test(
  "Create keychain and link wallet for " + walletConfig.extension.Name,
  async ({ restoreWallet }) => {
    const browser = await restoreWallet(walletConfig);
    const page = browser.pages()[0];

    // await new WalletListPage(page).clickEnableWallet(walletConfig.extension.Name);
    await page.goto("http://localhost:56499/m4/discovery");
    await new WalletListPanel(page).goto();
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

test("Refactored restore flow demo", async ({ page }) => {
  await new UnlockPasswordSuccessPanel(page).goto();
});
test("Refactored create flow demo", async ({ page }) => {
  await new WalletListPanel(page).goto();
});

// test("Restore flow demo", async ({ page }) => {
//   const nextBtnGroup = page.getByRole("group", { name: "NextButton-test" });
//   const nextButton = nextBtnGroup.locator('role=button[name="Next"]');
//   const setUnlockPasswordGroup = page.getByRole("group", {
//     name: "SetUnlockPasswordButton",
//   });
//   const setUnlockPasswordBtn = setUnlockPasswordGroup.locator("role=button");
//   const password = "bera1234";

//   await page.getByRole("button", { name: "GetStartedButton-test" }).click();
//   await page
//     .getByRole("group", {
//       name: "Recover your Catalyst Keychain On this device",
//     })
//     .click();
//   await page
//     .getByRole("group", {
//       name: "Restore seedphrase Restore/Upload with 12-word seed phrase",
//     })
//     .click();
//   await nextButton.click();
//   await nextButton.click();

//   //Wait for the set unlock password button to be enabled
//   const setUnlockPasswordBtnIsDisabled =
//     await setUnlockPasswordBtn.getAttribute("aria-disabled");
//   if (setUnlockPasswordBtnIsDisabled === "true") {
//     await setUnlockPasswordBtn.waitFor({
//       state: "visible",
//       timeout: 5000,
//     });
//   }
//   await setUnlockPasswordBtn.click();
//   await nextButton.click();

//   await page
//     .locator('role=group[name="Enter password"] >> role=textbox')
//     .fill(password);
//   await page
//     .locator('role=group[name="Confirm password"] >> role=textbox')
//     .click();
//   await page
//     .locator('role=group[name="Confirm password"] >> role=textbox')
//     .fill(password);

//   //Wait for the next button to be enabled
//   const nextBtnIsDisabled = await nextButton.getAttribute("aria-disabled");
//   if (nextBtnIsDisabled === "true") {
//     await nextButton.waitFor({
//       state: "visible",
//       timeout: 5000,
//     });
//   }
//   await nextButton.click();
//   await page.locator('role=button[name="Go to account"]').click();
//   await page.locator('role=button[name="RemoveKeychainButton"]').click();
//   await page.getByLabel("VoicesTextField Enter phrase").fill("Remove Keychain");
//   await page.waitForTimeout(200);
//   await page
//     .getByRole("button", { name: "DeleteKeychainContinueButton" })
//     .click();
//   await page.getByRole("button", { name: "closebtn-test" }).click();
// });

// test("Create flow demo", async ({ page }) => {
//   const nextBtnGroup = page.getByRole("group", { name: "NextButton-test" });
//   const nextButton = nextBtnGroup.locator('role=button[name="Next"]');
//   const checkbox = page.getByRole("checkbox");
//   const setUnlockPasswordGroup = page.getByRole("group", {
//     name: "SetUnlockPasswordButton",
//   });
//   const setUnlockPasswordBtn = setUnlockPasswordGroup.locator("role=button");
//   const password = "bera1234";

//   await page.getByRole("button", { name: "GetStartedButton-test" }).click();
//   await page
//     .getByRole("group", {
//       name: "Create a new Catalyst Keychain On this device",
//     })
//     .click();
//   await page
//     .getByRole("button", {
//       name: "CreateBaseProfileNext-test",
//     })
//     .click();
//   await nextButton.click();
//   await nextButton.click();
//   await page.getByRole("button", { name: "CreateKeychain-test" }).click();
//   await page.getByRole("button", { name: "CreateKeychainNow-test" }).click();
//   await nextButton.click();
//   const checkboxIsChecked = await checkbox.getAttribute("aria-checked");
//   if (checkboxIsChecked === "false") {
//     await checkbox.click();
//   }
//   await nextButton.click();
//   await nextButton.click();
//   await nextButton.click();
//   await nextButton.click();
//   await nextButton.click();

//   await page
//     .locator('role=group[name="Enter password"] >> role=textbox')
//     .fill(password);
//   await page.waitForTimeout(1200);
//   await page
//     .locator('role=group[name="Confirm password"] >> role=textbox')
//     .click();
//   await page
//     .locator('role=group[name="Confirm password"] >> role=textbox')
//     .fill(password);
//   await nextButton.click();
//   await page.getByRole("button", { name: "LinkWalletAndRoles-test" }).click();
//   await page.getByRole("button", { name: "closebtn-test" }).click();
// });
