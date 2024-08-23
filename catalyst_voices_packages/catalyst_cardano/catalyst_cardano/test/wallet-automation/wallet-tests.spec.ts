import { test, chromium, expect, BrowserContext, Page } from '@playwright/test';
import { allowExtension, downloadExtension, importWallet} from './utils';

let browser: BrowserContext;
let extensionPath: string;

[
 { name: 'Typhon', id: 'kfdniefadaanbjodldohaedphafoffoh' },
 { name: 'Lace', id: 'gafhhkghbfjjkeiendhlofajokpaflmk' },
  ].forEach(({ name, id }) => {
    test.describe(`Testing with ${name}`,() => {

        test.beforeAll(async () => {
            extensionPath = await downloadExtension(id);
        });

        test.beforeEach(async () => {
            browser = await chromium.launchPersistentContext('', {
                headless: false, // extensions only work in headful mode
                args: [
                    `--disable-extensions-except=${extensionPath}`,
                    `--load-extension=${extensionPath}`,
                ],
            });

            await expect.poll(async () => {
                return browser.pages().length;
            }, { timeout: 5000 }).toBe(2);
            const extTab = browser.pages()[1];
            await extTab.bringToFront();
            await importWallet(extTab,name);
            //TODO switch wait for wait on load page
            await extTab.waitForTimeout(5000);
            await extTab.goto('/')
            await extTab.locator('//*[text()="Enable wallet"]').click();

            await expect.poll(async () => {
                return browser.pages().length;
            }, { timeout: 5000 }).toBe(3);

            const updatedPages = browser.pages();
            const allowTab = updatedPages[updatedPages.length - 1];
            await allowTab.bringToFront();
            await allowExtension(allowTab,name);
            await extTab.bringToFront();
            //wait for data to load
            const textContent = await extTab.locator('#flt-semantic-node-13').textContent({ timeout: 5000 });
            expect(textContent).not.toBeNull();

        });


        test('get wallet details' + name , async () => {

            /* // Get wallet balance
             const balanceTextContent = await matchTextContent('#flt-semantic-node-13', /Balance: Ada \(lovelaces\): (\d+)/);
             const balanceAda = (parseInt(balanceTextContent, 10) / 1_000_000).toFixed(2);
             expect(parseInt(balanceAda)).toBeGreaterThan(500);

             // Get extension info
             const cleanedExtensionInfo = await matchTextContent('#flt-semantic-node-14', /Extensions:\s*(.+)/);
             expect(cleanedExtensionInfo).toMatch('cip-30');

             // Get network ID
             expect(matchTextContent('#flt-semantic-node-15', /Network ID: (.+)/)).not.toBeNaN();

             // Get reward addresses
             expect(await matchTextContent('#flt-semantic-node-17', /Reward addresses:\s*(\S+)/)).not.toBeNaN();

             // Get used addresses
             expect(matchTextContent('#flt-semantic-node-19', /Used addresses:\s*(\S+)/)).not.toBeNaN();

             // Get UTXOs info
             const utxoTextContent = await newTab.locator('#flt-semantic-node-20').textContent({ timeout: 5000 });
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
             await newTab.waitForTimeout(5000);
         */});

         /*async function openSignTab(buttonName: string) {
             await newTab.getByRole('button', { name: buttonName }).click();
             await expect.poll(async () => browser.pages().length, { timeout: 5000 }).toBe(3);
             const signPage = browser.pages();
             const signTab = signPage[signPage.length - 1];
             await signTab.bringToFront();
             return signTab;
         }*/

         async function signData(signTab: Page, password: string) {
             await signTab.getByRole('button', { name: 'Sign' }).click();
             await signTab.getByPlaceholder('Password', { exact: true }).fill(password);
             await signTab.getByRole('button', { name: 'confirm' }).click();
         }

         test('Sign data' + name, async () => {/*
             const signTab = await openSignTab('Sign data');
             const WalletCredentials = await getWalletCredentials('WALLET1');
             await signData(signTab, WalletCredentials.password);
             await expect(newTab.getByText('DataSignature')).toBeVisible();
         */});


         test('Sign and submit tx' + name, async () => {
             /*const signTab = await openSignTab('Sign & submit tx')
             const WalletCredentials = await getWalletCredentials('WALLET1');
             await signData(signTab, WalletCredentials.password);
             await expect(newTab.getByText('Tx hash')).toBeVisible();*/
         });

         /*
         test('Sign and submit RBAC tx', async () => {
             const signTab = await openSignTab('Sign & submit RBAC tx');
             const WalletCredentials = await getWalletCredentials('WALLET1');
             await signData(signTab, WalletCredentials.password);
             await expect(newTab.getByText('Tx hash')).toBeVisible();
         });

         test('Fail to Sign data with incorrect password', async () => {
             const signTab = await openSignTab('Sign data');
             const wrongPassword = 'wrongPassword';
             await signData(signTab, wrongPassword);
             await expect(signTab.getByText('Wrong password')).toBeVisible();
         });

         test('Fail to Sign & submit tx with incorrect password', async () => {
             const signTab = await openSignTab('Sign & submit tx');
             const wrongPassword = 'wrongPassword';
             await signData(signTab, wrongPassword);
             await expect(signTab.getByText('Wrong password')).toBeVisible();
         });

         test('Fail to Sign & submit RBAC tx with incorrect password', async () => {
             const signTab = await openSignTab('Sign & submit RBAC tx');
             const wrongPassword = 'wrongPassword';
             await signData(signTab, wrongPassword);
             await expect(signTab.getByText('Wrong password')).toBeVisible();
         });

         test('Empty wallet', async ({ page }) => {
             await page.goto('http://localhost:8000/', { waitUntil: 'load' });
             await expect(page.getByText('There are no active wallet extensions')).toBeVisible();
         });*/


    });
  });
