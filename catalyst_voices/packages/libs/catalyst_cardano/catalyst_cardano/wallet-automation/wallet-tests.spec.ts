import { test, chromium, expect, BrowserContext, Page } from '@playwright/test';
import { allowExtension, downloadExtension, getWalletCredentials, importWallet, signData, signDataBadPwd} from './utils';

let browser: BrowserContext;
let extensionPath: string;
let extTab: Page;
/* cSpell:disable */
let wallets =
            [{ name: 'Typhon', id: 'kfdniefadaanbjodldohaedphafoffoh', url: 'chrome-extension://changeme/tab.html#/wallet/access/' },
            { name: 'Lace', id: 'gafhhkghbfjjkeiendhlofajokpaflmk', url: 'chrome-extension://changeme/app.html#/setup' },]
/* cSpell:enable */

wallets.forEach(({ name, id, url }) => {
    test.describe(`Testing with ${name}`,() => {
        test.skip(name === 'Typhon', 'https://github.com/input-output-hk/catalyst-voices/issues/753');
        test.afterAll(async () => {
            browser.close()
         });

        test.beforeAll(async () => {
            // Download extension and import wallet into wallet extension
            test.setTimeout(300000);
            extensionPath = await downloadExtension(id);
            browser = await chromium.launchPersistentContext('', {
                headless: false, // extensions only work in headful mode
                args: [
                    `--disable-extensions-except=${extensionPath}`,
                    `--load-extension=${extensionPath}`,
                ],
            });
            let [background] = browser.serviceWorkers();
            if (!background)
            background = await browser.waitForEvent('serviceworker');
            const extensionId = background.url().split('/')[2];
            extTab = await browser.newPage();
            const extUrl = url.replace('changeme', extensionId );
            await extTab.goto(extUrl);
            await extTab.waitForTimeout(5000);
            await importWallet(extTab,name);
            await extTab.waitForTimeout(5000);
            await extTab.goto('/')
            await extTab.locator('//*[text()="Enable wallet"]').click();

            await expect.poll(async () => {
                return browser.pages().length;
            }, { timeout: 15000 }).toBe(3);

            const updatedPages = browser.pages();
            const allowTab = updatedPages[updatedPages.length - 1];
            await allowTab.bringToFront();
            await allowExtension(allowTab,name);
            await extTab.bringToFront();
            //wait for data to load
            const textContent = await extTab.locator('#flt-semantic-node-13').textContent({ timeout: 5000 });
            expect(textContent).not.toBeNull();
        });

        // Get and match text content
        const matchTextContent = async (selector: string, regex: RegExp) => {
            const textContent = await extTab.locator(selector).textContent({ timeout: 5000 });
            expect(textContent).not.toBeNull();
            const match = textContent!.match(regex);
            expect(match).not.toBeNull();
            return match![1].trim();
        };

        test('Get wallet details for ' + name , async () => {
            await extTab.waitForTimeout(5000);
            const balanceTextContent = await matchTextContent('#flt-semantic-node-13', /Balance: Ada \(lovelaces\): (\d+)/);
            const balanceAda = (parseInt(balanceTextContent, 10) / 1_000_000).toFixed(2);
            expect(parseInt(balanceAda)).toBeGreaterThan(500);

            const cleanedExtensionInfo = await matchTextContent('#flt-semantic-node-14', /Extensions:\s*(.+)/);
            switch (name) {
            case 'Typhon':
                expect(cleanedExtensionInfo).toMatch('cip-30');
                break;
            case 'Lace':
                expect(cleanedExtensionInfo).toMatch('cip-95');
                break;
            default:
                throw new Error('Wallet not in use')
            }

            expect(matchTextContent('#flt-semantic-node-15', /Network ID: (.+)/)).not.toBeNaN();

            expect(await matchTextContent('#flt-semantic-node-17', /Reward addresses:\s*(\S+)/)).not.toBeNaN();

            expect(matchTextContent('#flt-semantic-node-19', /Used addresses:\s*(\S+)/)).not.toBeNaN();

            const utxoTextContent = await extTab.locator('#flt-semantic-node-20').textContent({ timeout: 5000 });
            expect(utxoTextContent).not.toBeNull();
            const utxoLines = utxoTextContent!.split('\n').map(line => line.trim());
            expect(utxoLines.length).toBeGreaterThanOrEqual(4);
            const tx = utxoLines[1].split(':')[1].trim();
            const index = utxoLines[2].split(':')[1].trim();
            const amount = utxoLines[3].split(':')[2].trim();
            const amountAda = (parseInt(amount, 10) / 1_000_000).toFixed(2);
            expect(tx).not.toBeUndefined();
            expect(index).not.toBeUndefined();
            expect(amount).not.toBeNaN();
            expect(parseInt(amountAda)).toBeGreaterThan(500);
         });

        async function openSignTab(buttonName: string) {
             await extTab.getByRole('button', { name: buttonName }).click();
             await expect.poll(async () => browser.pages().length, { timeout: 15000 }).toBe(3);
             const signPage = browser.pages();
             const signTab = signPage[signPage.length - 1];
             await signTab.bringToFront();
             return signTab;
         }

         test('Sign data ' + name, async () => {
            const signTab = await openSignTab('Sign data');
            const WalletCredentials = await getWalletCredentials('WALLET1');
            await signData(name, signTab, WalletCredentials.password);
            await expect(extTab.getByText('Sign Data')).toBeVisible();
            await extTab.getByRole('button', { name: 'Close' }).click();
         });

         test('Sign and submit tx ' + name, async () => {
            const signTab = await openSignTab('Sign & submit tx')
            const WalletCredentials = await getWalletCredentials('WALLET1');
            await signData(name, signTab, WalletCredentials.password);
            await expect(extTab.getByText('Tx hash')).toBeVisible();
            await extTab.getByRole('button', { name: 'Close' }).click();
         });

         test('Sign and submit RBAC tx ' + name, async () => {
            const signTab = await openSignTab('Sign & submit RBAC tx');
            const WalletCredentials = await getWalletCredentials('WALLET1');
            await signData(name, signTab, WalletCredentials.password);
            await expect(extTab.getByText('Tx hash')).toBeVisible();
            await extTab.getByRole('button', { name: 'Close' }).click();
         });

         test('Fail to Sign data with incorrect password ' + name, async () => {
            const signTab = await openSignTab('Sign data');
            await signDataBadPwd(name, signTab);
            await extTab.getByRole('button', { name: 'Close' }).click();
         });

         test('Fail to Sign & submit tx with incorrect password ' + name, async () => {
            const signTab = await openSignTab('Sign & submit tx');
            await signDataBadPwd(name, signTab);
            await extTab.getByRole('button', { name: 'Close' }).click();
         });

         test('Fail to Sign & submit RBAC tx with incorrect password ' + name, async () => {
            const signTab = await openSignTab('Sign & submit RBAC tx');
            await signDataBadPwd(name, signTab);
            await extTab.getByRole('button', { name: 'Close' }).click();
         });
    });
  });
