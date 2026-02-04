import { test } from "../fixtures";
import { expect } from "@playwright/test";
import { walletConfigs } from "../data/walletConfigs";
import { WalletListPanel } from "../page-objects/onboarding/create-flow/step-15-wallet-list";
import { createWalletActions } from "../utils/wallets/wallet-actions-factory";
import { WalletConnectedPanel } from "../page-objects/onboarding/create-flow/step-16-wallet-connected";
import { TestModel } from "../models/testModel";
import { getAccountModel } from "../data/accountConfigs";
import { AccountSetupSuccessPanel } from "../page-objects/onboarding/create-flow/step-20-account-setup-success";

for (const walletConfig of walletConfigs) {
  test.describe(`Onboarding ${walletConfig.extension.Name}`, () => {
    test.use({
      testModel: new TestModel(getAccountModel("DummyForTesting"), walletConfig),
    });
    test(`Connect wallet - ${walletConfig.extension.Name}`, async ({
      restoreWallet,
      appBaseURL,
      testModel,
    }) => {
      const page = restoreWallet.pages()[0];
      await page.goto(appBaseURL);
      await page
        .locator("//*[@aria-label='Enable accessibility']")
        .evaluate((element: HTMLElement) => element.click());
      const walletConnectedPanel = await new WalletConnectedPanel(page, testModel).goto();

      expect(await walletConnectedPanel.getWalletNameValue()).toContain(
        walletConfig.extension.Name
      );
      expect(await walletConnectedPanel.getWalletBalanceValue()).toContain("$ADA");
      expect(await walletConnectedPanel.getWalletAddressValue()).toContain(
        walletConfig.stakeAddress
      );
    });
    
    test(`Create Catalyst Keychain - ${walletConfig.extension.Name}`, async ({
      restoreWallet,
      appBaseURL,
      testModel,
    }) => {
      const page = restoreWallet.pages()[0];
      await page.goto(appBaseURL);
      await page
        .locator("//*[@aria-label='Enable accessibility']")
        .evaluate((element: HTMLElement) => element.click());
      const accountSetupSuccessPanel = await new AccountSetupSuccessPanel(page, testModel).goto();
    });
  });
}
