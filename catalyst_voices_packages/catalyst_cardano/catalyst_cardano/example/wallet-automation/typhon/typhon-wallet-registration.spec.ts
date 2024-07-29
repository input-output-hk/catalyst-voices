import { test, chromium, expect, Page } from '@playwright/test';
import { getWalletCredentials, getRegistrationPin } from './credentials';
import { getSeedPhrase } from './seed-phrase';
import { waitForDebugger } from 'inspector';
const path = require('path');
import fs from 'fs-extra';

// extension ID for Typhon: kfdniefadaanbjodldohaedphafoffoh

let newTab: Page

test.beforeAll(async () => {
    const extensionPath: string = path.resolve(__dirname, 'extensions/KFDNIEFADAANBJODLDOHAEDPHAFOFFOH_unzipped');
    const browser = await chromium.launchPersistentContext('', {
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

    async function clickBlankSpace(newTab) {
        const blankSpace = '#app > div > div > div.flex-grow.overflow-auto > div > div.my-5.flex.justify-center.py-16 > div > div > div > div:nth-child(1) > div.flex.justify-between.items-start > div.flex-initial.flex.flex-col.mr-2 > span.text-primary.font-medium.text-xl';
        await newTab.waitForSelector(blankSpace, { state: 'visible' });
        await newTab.click(blankSpace);
    }

    // Input seed phrase
    const seedPhrase = getSeedPhrase();
    for (let i = 0; i < seedPhrase.length; i++) {
        const ftSeedPhraseSelector = `(//input[@type='text'])[${i + 1}]`;
        await newTab.locator(ftSeedPhraseSelector).fill(seedPhrase[i]);
    }

    await clickBlankSpace(newTab);
    await newTab.getByRole('button', { name: 'Unlock Wallet' }).click();
    
    try {
        await newTab.waitForSelector('//*[@id="lc"]/div[2]/div[2]/div[2]/div[1]/div[2]', { timeout: 5000 });
        const textContent = await newTab.$eval('//*[@id="lc"]/div[2]/div[2]/div[2]/div[1]/div[2]', el => el.textContent);

        if (textContent) {
            console.log("registered for voting successfully!");
        } else {
            console.log('text content not found');
        }
    } catch (error) {
        console.error('an error occurred:', error.toString());
        console.log('an error occurred');
    }

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
    await newTab.waitForTimeout(10000);
});


test('get wallet balance', async ({ }) => {
    const elementHandle = await newTab.waitForSelector('#flt-semantic-node-13', { timeout: 5000 });

    if (elementHandle) {
        // Retrieve the text content of the element
        const textContent = await elementHandle.textContent();

        if (textContent !== null) {
            // Extract the balance from the text content
            const match = textContent.match(/Balance: Ada \(lovelaces\): (\d+)/);
            if (match && match[1]) {
                const balance = ((parseInt(match[1], 10))/1_000_000).toFixed(2);
                console.log('ADA (lovelaces):', balance);

                if (parseInt(balance) < 500) {
                    console.log('not eligible for voting ☹️');
                } else {
                    console.log('eligible for voting ☺');
                }
            } else {
                console.log('balance not found in text content:', textContent);
            }
        } else {
            console.log('no text content found for the specified selector:', elementHandle);
        }
    } else {
        console.log('element not found for the specified selector');
    }
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
