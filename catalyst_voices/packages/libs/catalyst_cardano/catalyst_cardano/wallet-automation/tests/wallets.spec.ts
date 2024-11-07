import { HomePage } from '../pages/homePage';
import { test } from '../test-fixtures';
import { walletConfigs } from '../utils/walletConfigs';
import { signWalletPopup } from '../utils/wallets/walletUtils';
import { ModalName } from '../pages/modal';
import { BrowserContext, expect } from '@playwright/test';

walletConfigs.forEach(( walletConfig ) => {
    let browser: BrowserContext;
    test.describe(`Testing with ${walletConfig.extension.Name}`, () => {
        test.skip(walletConfig.extension.Name === 'Typhon', 'https://github.com/input-output-hk/catalyst-voices/issues/753');
        test.beforeAll(async ({ enableWallet }) => {
            browser = await enableWallet(walletConfig);
        });
        test.afterAll(async () => {
            await browser.close();
        });
        test('Get wallet details for ' + walletConfig.extension.Name, async () => {
            const page = browser.pages()[0];
            const homePage = new HomePage(page);
            const walletCipData = await homePage.getWalletCipData();
            await homePage.assertBasicWalletCipData(walletCipData, walletConfig.extension.Name);
        });
        test('Sign data with ' + walletConfig.extension.Name, async () => {
            const page = browser.pages()[0];
            const homePage = new HomePage(page);
            const [walletPopup] = await Promise.all([
                browser.waitForEvent('page'),
                homePage.signDataButton.click()
              ]);
            await signWalletPopup(walletPopup, walletConfig);
            await homePage.assertModal(ModalName.SignData);
        });

        test('Sign and submit tx with ' + walletConfig.extension.Name, async () => {
            const page = browser.pages()[0];
            const homePage = new HomePage(page);
            const [walletPopup] = await Promise.all([
                browser.waitForEvent('page'),
                homePage.signAndSubmitTxButton.click()
              ]);
            await signWalletPopup(walletPopup, walletConfig);
            await homePage.assertModal(ModalName.SignAndSubmitTx);
        });

        test('Sign and submit RBAC tx with ' + walletConfig.extension.Name, async () => {
            const page = browser.pages()[0];
            const homePage = new HomePage(page);
            const [walletPopup] = await Promise.all([
                browser.waitForEvent('page'),
                homePage.signAndSubmitRBACTxButton.click()
              ]);
            await signWalletPopup(walletPopup, walletConfig);
            await homePage.assertModal(ModalName.SignAndSubmitRBACTx);
        });

        test('Fail to Sign data with incorrect password ' + walletConfig.extension.Name, async () => {
            const page = browser.pages()[0];
            const homePage = new HomePage(page);
            const [walletPopup] = await Promise.all([
                browser.waitForEvent('page'),
                homePage.signDataButton.click()
              ]);
            const walletConfigClone = structuredClone(walletConfig);
            walletConfigClone.password = 'BadPassword';
            await signWalletPopup(walletPopup, walletConfigClone, false);
            await expect(walletPopup.getByTestId('password-input-error')).toBeVisible();
        });

        test('Fail to Sign & submit tx with incorrect password' + walletConfig.extension.Name, async () => {
            const page = browser.pages()[0];
            const homePage = new HomePage(page);
            const [walletPopup] = await Promise.all([
                browser.waitForEvent('page'),
                homePage.signAndSubmitTxButton.click()
              ]);
            const walletConfigClone = structuredClone(walletConfig);
            walletConfigClone.password = 'BadPassword';
            await signWalletPopup(walletPopup, walletConfigClone, false);
            await expect(walletPopup.getByTestId('password-input-error')).toBeVisible();
        });

        test('Fail to Sign & submit RBAC tx with incorrect password' + walletConfig.extension.Name, async () => {
            const page = browser.pages()[0];
            const homePage = new HomePage(page);
            const [walletPopup] = await Promise.all([
                browser.waitForEvent('page'),
                homePage.signAndSubmitRBACTxButton.click()
              ]);
            const walletConfigClone = structuredClone(walletConfig);
            walletConfigClone.password = 'BadPassword';
            await signWalletPopup(walletPopup, walletConfigClone, false);
            await expect(walletPopup.getByTestId('password-input-error')).toBeVisible();
        });
    });
})
