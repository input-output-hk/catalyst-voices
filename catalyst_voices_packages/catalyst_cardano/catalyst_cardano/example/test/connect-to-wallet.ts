import { chromium, Browser, Page } from '@playwright/test';

async function connectToTyphonWallet() {
    const browser: Browser = await chromium.launch({ headless: false }); 
    const page: Page = await browser.newPage();

    try {
        await page.goto('http://localhost:8000'); 

        await page.context().addCookies([
            {
                name: 'typhon_wallet',
                value: 'addr1qxjyu608n2n5644z2d0g5jtjvlahcwlptws9wp2h7szytcfgxuuwq4mpzcwdwcuee0ecg88eae437ctn3uk70vfvh3pq2nsftr', 
                domain: 'chrome-extension://kfdniefadaanbjodldohaedphafoffoh/tab.html#/wallet', 
                path: '/'
            }
        ]);

        await page.click('selector-for-connect-wallet-button'); 

        const walletConnected = await page.evaluate(() => {
            return document.querySelector('selector-for-connection-status')?.textContent === 'Connected';
        });

        console.log(`Wallet connected: ${walletConnected}`);

    } catch (error) {
        console.error('Error connecting to Typhon wallet:', error);
    } finally {
        await browser.close();
    }
}

connectToTyphonWallet();
