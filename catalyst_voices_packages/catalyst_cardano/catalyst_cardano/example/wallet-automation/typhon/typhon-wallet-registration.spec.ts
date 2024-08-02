import { test, chromium, expect, Page, BrowserContext } from '@playwright/test';
import { getWalletCredentials, getRegistrationPin } from './credentials';
import { getSeedPhrase } from './seed-phrase';
import { waitForDebugger } from 'inspector';
const path = require('path');
import fs from 'fs-extra';

// extension ID for Typhon: kfdniefadaanbjodldohaedphafoffoh

let newTab: Page
let browser: BrowserContext;

test.beforeAll(async () => {
    const extensionPath: string = path.resolve(__dirname, 'extensions/KFDNIEFADAANBJODLDOHAEDPHAFOFFOH_unzipped');
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
    const pages = browser.pages();
    newTab = pages[pages.length - 1];
    await newTab.bringToFront();

    // interact with elements on the background page
    await newTab.locator('button#headlessui-menu-button-1').click();

    await newTab.locator('button#headlessui-menu-item-6').click();

    await newTab.getByRole('button', { name: 'Import' }).click();

    // Login
    const WalletCredentials = getWalletCredentials('WALLET1');
    await newTab.getByPlaceholder('Wallet Name').fill(WalletCredentials.username);
    await newTab.getByPlaceholder('Password', { exact: true }).fill(WalletCredentials.password);
    await newTab.getByPlaceholder('Confirm Password', { exact: true }).fill(WalletCredentials.password);
    await newTab.locator('input#termsAndConditions').click();
    await newTab.getByRole('button', { name: 'Continue' }).click();

    // Input seed phrase
    const seedPhrase = getSeedPhrase();
    for (let i = 0; i < seedPhrase.length; i++) {
        const ftSeedPhraseSelector = `(//input[@type='text'])[${i + 1}]`;
        await newTab.locator(ftSeedPhraseSelector).fill(seedPhrase[i]);
    }

    await newTab.locator('//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div/div[1]/div[1]/div[1]/span[1]').click();
    await newTab.getByRole('button', { name: 'Unlock Wallet' }).click();

    await newTab.waitForTimeout(5000);
    await newTab.goto('http://localhost:8000/');
    await newTab.locator('//*[text()="Enable wallet"]').click();

    await expect.poll(async () => {
        return browser.pages().length;
    }, { timeout: 5000 }).toBe(3);

    const updatedPages = browser.pages();
    const allowTab = updatedPages[updatedPages.length - 1];
    await allowTab.bringToFront();

    await allowTab.getByRole('button', { name: 'Allow' }).click();
    await newTab.waitForTimeout(5000);
});

test('get wallet details', async () => {
    // Get and match text content
    const matchTextContent = async (selector: string, regex: RegExp) => {
        const textContent = await newTab.locator(selector).textContent({ timeout: 5000 });
        expect(textContent).not.toBeNull();

        const match = textContent!.match(regex);
        expect(match).not.toBeNull();
        return match![1].trim();
    };

    // Get wallet balance
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
});

test('Sign data', async () => {
    await newTab.getByRole('button', { name: 'Sign data' }).click();
    
    await expect.poll(async () => {
        return browser.pages().length;
    }, { timeout: 5000 }).toBe(3);

    const signPage = browser.pages();
    const signTab = signPage[signPage.length - 1];
    await signTab.bringToFront();

    const WalletCredentials = getWalletCredentials('WALLET1');
    await signTab.getByRole('button', { name: 'Sign' }).click();
    await signTab.getByPlaceholder('Password', { exact: true }).fill(WalletCredentials.password);
    await signTab.getByRole('button', { name: 'confirm' }).click();

    await expect(newTab.getByText('DataSignature')).toBeVisible();
});

test('Sign and submit tx', async () => {

    await newTab.goBack();
    await newTab.getByRole('button', { name: 'Sign & submit tx' }).click();
    
    await expect.poll(async () => {
        return browser.pages().length;
    }, { timeout: 5000 }).toBe(3);

    const signPage = browser.pages();
    const signTab = signPage[signPage.length - 1];
    await signTab.bringToFront();

    const WalletCredentials = getWalletCredentials('WALLET1');
    await signTab.getByRole('button', { name: 'Sign' }).click();
    await signTab.getByPlaceholder('Password', { exact: true }).fill(WalletCredentials.password);
    await signTab.getByRole('button', { name: 'confirm' }).click();

    await expect(newTab.getByText('Tx hash')).toBeVisible();
});

test('Sign and submit RBAC tx', async () => {

    await newTab.goBack();
    await newTab.getByRole('button', { name: 'Sign & submit RBAC tx' }).click();
    
    await expect.poll(async () => {
        return browser.pages().length;
    }, { timeout: 5000 }).toBe(3);

    const signPage = browser.pages();
    const signTab = signPage[signPage.length - 1];
    await signTab.bringToFront();

    const WalletCredentials = getWalletCredentials('WALLET1');
    await signTab.getByRole('button', { name: 'Sign' }).click();
    await signTab.getByPlaceholder('Password', { exact: true }).fill(WalletCredentials.password);
    await signTab.getByRole('button', { name: 'confirm' }).click();
    await newTab.waitForTimeout(5000);

    await expect(newTab.getByText('Tx hash')).toBeVisible();
    await newTab.waitForTimeout(5000);
});

test('Fail to Sign data with incorrect password', async () => {

    await newTab.goBack();
    await newTab.getByRole('button', { name: 'Sign data' }).click();
    
    await expect.poll(async () => {
        return browser.pages().length;
    }, { timeout: 5000 }).toBe(3);

    const signPage = browser.pages();
    const signTab = signPage[signPage.length - 1];
    await signTab.bringToFront();

    const wrongPassword = 'wrongPassword';
    await signTab.getByRole('button', { name: 'Sign' }).click();
    await signTab.getByPlaceholder('Password', { exact: true }).fill(wrongPassword);
    await signTab.getByRole('button', { name: 'confirm' }).click();

    await expect(signTab.getByText('Wrong password')).toBeVisible();
});

    // Logout 
    // const logOut = '//*[@id="app"]/div/div/div[3]/div/div/div[1]/div/div/div[2]/div[11]/div[2]';
    // await newTab.locator(logOut).click();

    // const chooseAccount = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[2]/div';
    // await newTab.locator(chooseAccount).click();

    // const removeAccount = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[2]/div[4]/button';
    // await newTab.locator(removeAccount).click();

    // await newTab.locator('button.btn.bg-primary').click();

    // const addNew = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[4]';
