import { test } from "../fixtures";
import { expect } from "@playwright/test";
import {
  getOneOfEachExtensions,
  getWalletConfigByExtensionName,
} from "../data/walletConfigs";
import { WalletListPanel } from "../page-objects/onboarding/create-flow/step-15-wallet-list";
import { createWalletActions } from "../utils/wallets/wallet-actions-factory";
import { WalletConnectedPanel } from "../page-objects/onboarding/create-flow/step-16-wallet-connected";
import { TestModel } from "../models/testModel";
import { getAccountModel } from "../data/accountConfigs";
import { BrowserExtensionName } from "../models/browserExtensionModel";

for (const walletConfig of [
  getWalletConfigByExtensionName(BrowserExtensionName.Lace),
]) {
  test.describe(`Onboarding ${walletConfig.extension.Name}`, () => {
    test.use({
      testModel: new TestModel(
        getAccountModel("DummyForTesting"),
        walletConfig
      ),
    });
    test(`Connect wallet - ${walletConfig.extension.Name}`, async ({
      restoreWallet,
      appBaseURL,
    }) => {
      const page = restoreWallet.pages()[0];
      await page.goto(appBaseURL);
      await page
        .locator("//*[@aria-label='Enable accessibility']")
        .evaluate((element: HTMLElement) => element.click());
      const walletListPanel = await new WalletListPanel(page).goto();
      const walletPage = await walletListPanel.clickConnectWallet(
        walletConfig.extension.Name
      );
      await createWalletActions(walletConfig, walletPage).connectWallet();
      const walletConnectedPanel = new WalletConnectedPanel(page);

      expect(await walletConnectedPanel.getWalletNameValue()).toContain(
        walletConfig.extension.Name
      );
      expect(await walletConnectedPanel.getWalletBalanceValue()).toContain("₳");
      expect(await walletConnectedPanel.getWalletAddressValue()).toContain(
        walletConfig.stakeAddress
      );
    });
  });
}
