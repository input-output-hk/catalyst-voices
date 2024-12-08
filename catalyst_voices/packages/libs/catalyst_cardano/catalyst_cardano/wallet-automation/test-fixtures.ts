// import { test as base, BrowserContext, chromium, Page } from '@playwright/test';
// import { HomePage } from './pages/homePage';
// import { WalletListPage } from './pages/walletListPage';


// // import { allowExtension, onboardWallet, WalletConfig } from './utils/wallets/walletUtils';

// // type MyFixtures = {
// //   enableWallet: (walletConfig: WalletConfig, browser: BrowserContext) => Promise<BrowserContext>;
// // };

// // export const test = base.extend<MyFixtures>({
// //   enableWallet: async ({ }, use) => { 
// //     const enableWalletFn = async (walletConfig: WalletConfig, browser: BrowserContext) => {
// //       const page = browser.pages()[0];
// //       await page.reload();
// //       await page.goto('/');
// //       await page.waitForTimeout(4000);
// //       const [walletPopup] = await Promise.all([
// //         browser.waitForEvent('page'),
// //         page.locator('//*[text()="Enable wallet"]').click(),
// //       ]);
// //       await walletPopup.waitForTimeout(2000);
// //       await allowExtension(walletPopup, walletConfig.extension.Name);
// //       await page.waitForTimeout(2000);
// //       return browser;
// //     };
  
// //     // Provide the function to the test
// //     await use(enableWalletFn);
// //   },
// // });