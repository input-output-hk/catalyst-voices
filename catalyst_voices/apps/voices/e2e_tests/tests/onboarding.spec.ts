import { AccountModel } from "../models/accountModel";
import { TestModel } from "../models/testModel";
import { accountModels } from "../testData/accountConfigs";
import { WalletListPanel } from "../pageobject/onboarding/create-flow/step-16-wallet-list";
import { WalletDetectionPanel } from "../pageobject/onboarding/create-flow/step-18-wallet-detection";
import { OnboardingCommon } from "../pageobject/onboarding/onboardingCommon";
import { test } from "../test-fixtures";
import { walletConfigs } from "../testData/walletConfigs";
import { WalletConfig } from "../utils/wallets/walletUtils";

const walletConfig: WalletConfig = walletConfigs[3];
const accountModel: AccountModel = accountModels[0];

test(
  "Create keychain and link wallet for " + walletConfig.extension.Name,
  async ({ restoreWallet }) => {
    const browser = await restoreWallet(walletConfig);
    const page = browser.pages()[0];

    const testModel = new TestModel(accountModel, walletConfig);

    await page.goto("http://localhost:49367/discovery");
    await new WalletListPanel(page).goto(testModel);
    const [walletPopup] = await Promise.all([
      browser.waitForEvent("page"),
      new WalletListPanel(page).clickWallet(
        walletConfig.extension.Name.toLowerCase()
      ),
    ]);

    await walletPopup.locator("div.ConnectedWallet_wrapper").click();
    await page.waitForTimeout(2000);
    await new WalletDetectionPanel(page).clickSelectRolesBtn();
    await new OnboardingCommon(page).nextButton.click();
    await page.locator('role=button[name="reviewRegTransaction"]').click();
    const [signPopup] = await Promise.all([
      browser.waitForEvent("page"),
      page.locator('role=button[name="SignBtn"]').click({ delay: 100 }),
    ]);
    await signPopup.locator("#walletPassword").fill(walletConfig.password);
    await signPopup.locator("#confirmButton").click();
  }
);
