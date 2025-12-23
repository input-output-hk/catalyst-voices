import { test } from "../fixtures";
import { expect } from "@playwright/test";
import { walletConfigs } from "../data/walletConfigs";
import { WalletListPanel } from "../page-objects/onboarding/create-flow/step-15-wallet-list";
import { createWalletActions } from "../utils/wallets/wallet-actions-factory";
import { WalletConnectedPanel } from "../page-objects/onboarding/create-flow/step-16-wallet-connected";
import { TestModel } from "../models/testModel";
import { getAccountModel } from "../data/accountConfigs";

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
      const walletListPanel = await new WalletListPanel(page, testModel).goto();
      const walletPage = await walletListPanel.clickConnectWallet(walletConfig.extension.Name);
      await createWalletActions(walletConfig, walletPage).connectWallet();
      const walletConnectedPanel = new WalletConnectedPanel(page, testModel);

      expect(await walletConnectedPanel.getWalletNameValue()).toContain(
        walletConfig.extension.Name
      );
      expect(await walletConnectedPanel.getWalletBalanceValue()).toContain("$ADA");
      expect(await walletConnectedPanel.getWalletAddressValue()).toContain(
        walletConfig.stakeAddress
      );
    });
    //TODO: Add test for creating Catalyst Keychain in next PR
    test.skip(`Create Catalyst Keychain - ${walletConfig.extension.Name}`, async ({
      restoreWallet,
      appBaseURL,
      testModel,
    }) => {
      const page = restoreWallet.pages()[0];
      await page.goto(appBaseURL);
      await page.locator("//*[@aria-label='Enable accessibility']").evaluate((element: HTMLElement) => element.click());
    });
  });
}
