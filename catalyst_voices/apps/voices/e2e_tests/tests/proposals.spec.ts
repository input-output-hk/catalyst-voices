import { getAccountModel } from "../data/accountConfigs";
import { getWalletConfigByName } from "../data/walletConfigs";
import { test } from "../fixtures";
import { TestModel } from "../models/testModel";
import { AccountSetupSuccessPanel } from "../page-objects/onboarding/create-flow/step-20-account-setup-success";

test.describe(`Proposals space`, () => {
  test.use({
    testModel: new TestModel(getAccountModel("DummyForTesting"), getWalletConfigByName("Lace")),
  });
  test(`Submit a proposal`, async ({ restoreWallet, appBaseURL, testModel }) => {
    const page = restoreWallet.pages()[0];
    await page.goto(appBaseURL);
    await page
      .locator("//*[@aria-label='Enable accessibility']")
      .evaluate((element: HTMLElement) => element.click());

    const accountSetupSuccessPanel = await new AccountSetupSuccessPanel(page, testModel).goto();
    await accountSetupSuccessPanel.openDiscoveryButtonClick();
  });
});
