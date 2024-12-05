import { BrowserContext, test } from "@playwright/test";
import { HomePage } from "../pages/homePage";
import { ModalName } from "../pages/modal";
import { WalletListPage } from "../pages/walletListPage";
import { enableWallet, restoreWallet } from "../setup";
import { walletConfigs } from "../utils/walletConfigs";
import { signWalletPopup } from "../utils/wallets/walletUtils";

let browser: BrowserContext;
walletConfigs.forEach((walletConfig) => {
  test.describe(`Testing with ${walletConfig.extension.Name}`, () => {
    test.skip(
      walletConfig.extension.Name === "Typhon",
      "https://github.com/input-output-hk/catalyst-voices/issues/753"
    );
    test.skip(
      walletConfig.extension.Name === "Lace",
      "https://github.com/input-output-hk/catalyst-voices/issues/1190"
    );
    test.beforeAll(async () => {
      browser = await restoreWallet(walletConfig);
      await enableWallet(walletConfig, browser);
    });

    test("Get wallet details for " + walletConfig.extension.Name, async () => {
      const page = browser.pages()[0];
      await page.reload();
      await new WalletListPage(page).clickEnableWallet(
        walletConfig.extension.Name
      );
      const homePage = new HomePage(page);
      const walletCipData = await homePage.getWalletCipData();
      await homePage.assertBasicWalletCipData(walletCipData, walletConfig);
    });

    test("Sign data with " + walletConfig.extension.Name, async () => {
      const page = browser.pages()[0];
      await page.reload();
      await new WalletListPage(page).clickEnableWallet(
        walletConfig.extension.Name
      );
      const homePage = new HomePage(page);
      const [walletPopup] = await Promise.all([
        browser.waitForEvent("page"),
        homePage.signDataButton.click(),
      ]);
      await signWalletPopup(walletPopup, walletConfig);
      await homePage.assertModal(ModalName.SignData);
    });

    test("Sign and submit tx with " + walletConfig.extension.Name, async () => {
      const page = browser.pages()[0];
      await page.waitForTimeout(2000);
      await page.reload();
      await new WalletListPage(page).clickEnableWallet(
        walletConfig.extension.Name
      );
      const homePage = new HomePage(page);
      const [walletPopup] = await Promise.all([
        browser.waitForEvent("page"),
        homePage.signAndSubmitTxButton.click(),
      ]);
      await signWalletPopup(walletPopup, walletConfig);
      await homePage.assertModal(ModalName.SignAndSubmitTx);
    });

    test(
      "Sign and submit RBAC tx with " + walletConfig.extension.Name,
      async () => {
        const page = browser.pages()[0];
        await page.waitForTimeout(2000);
        await page.reload();
        await new WalletListPage(page).clickEnableWallet(
          walletConfig.extension.Name
        );
        const homePage = new HomePage(page);
        const [walletPopup] = await Promise.all([
          browser.waitForEvent("page"),
          homePage.signAndSubmitRBACTxButton.click(),
        ]);
        await signWalletPopup(walletPopup, walletConfig);
        await homePage.assertModal(ModalName.SignAndSubmitRBACTx);
      }
    );

    test(
      "Fail to Sign data with incorrect password " +
        walletConfig.extension.Name,
      async () => {
        const page = browser.pages()[0];
        await page.waitForTimeout(2000);
        await page.reload();
        await new WalletListPage(page).clickEnableWallet(
          walletConfig.extension.Name
        );
        const homePage = new HomePage(page);
        const [walletPopup] = await Promise.all([
          browser.waitForEvent("page"),
          homePage.signDataButton.click(),
        ]);
        const walletConfigClone = structuredClone(walletConfig);
        walletConfigClone.password = "BadPassword";
        await signWalletPopup(walletPopup, walletConfigClone, false);
        await homePage.assertModal(ModalName.SignDataUserDeclined);
      }
    );

    test(
      "Fail to Sign & submit tx with incorrect password" +
        walletConfig.extension.Name,
      async () => {
        const page = browser.pages()[0];
        await page.waitForTimeout(2000);
        await page.reload();
        await new WalletListPage(page).clickEnableWallet(
          walletConfig.extension.Name
        );
        const homePage = new HomePage(page);
        const [walletPopup] = await Promise.all([
          browser.waitForEvent("page"),
          homePage.signAndSubmitTxButton.click(),
        ]);
        const walletConfigClone = structuredClone(walletConfig);
        walletConfigClone.password = "BadPassword";
        await signWalletPopup(walletPopup, walletConfigClone, false);
        await homePage.assertModal(ModalName.SignTxUserDeclined);
      }
    );

    test(
      "Fail to Sign & submit RBAC tx with incorrect password" +
        walletConfig.extension.Name,
      async () => {
        const page = browser.pages()[0];
        await page.waitForTimeout(2000);
        await page.reload();
        await new WalletListPage(page).clickEnableWallet(
          walletConfig.extension.Name
        );
        const homePage = new HomePage(page);
        const [walletPopup] = await Promise.all([
          browser.waitForEvent("page"),
          homePage.signAndSubmitRBACTxButton.click(),
        ]);
        const walletConfigClone = structuredClone(walletConfig);
        walletConfigClone.password = "BadPassword";
        await signWalletPopup(walletPopup, walletConfigClone, false);
        await homePage.assertModal(ModalName.SignRBACTxUserDeclined);
      }
    );
  });
});
