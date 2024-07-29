import { test, chromium, expect } from '@playwright/test';
import { getWalletCredentials, getRegistrationPin } from './credentials';
import { getSeedPhrase } from './seed-phrase';
import { waitForDebugger } from 'inspector';
const path = require('path');
import fs from 'fs-extra';

// extension ID for Typhon: kfdniefadaanbjodldohaedphafoffoh

test('import wallet', async ({ }) => {
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
    const newTab = pages[pages.length - 1];
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

    const elementHandle = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[1]/div[2]/div/div[1]/div[1]/div/div[2]/div[1]/div/span[1]');
    if (elementHandle) {
        // retrieve the text content of the element
        const textContent = await elementHandle.textContent();
        if (textContent !== null) {
            // remove any formatting that might interfere with parseFloat
            const cleanedText = textContent.replace(/,/g, '').trim();
            const floatValue = parseFloat(cleanedText);
            console.log('ADA:', floatValue)
            if (!isNaN(floatValue)) {
                if (floatValue < 500) {
                    console.log('not eligible for voting ☹️');
                } else {
                    console.log('eligible for voting ☺');
                }
            } else {
                console.log('text content is not a valid float:', textContent);
            }
        } else {
            console.log('no text content found for the specified selector:', elementHandle);
        }
    } else {
        console.log('element not found for the specified XPath:', elementHandle);
    }

    // Voting Registration
    // await newTab.getByText('Voting').click();
    // await newTab.getByRole('button', { name: 'Register for voting' }).click();
    // await newTab.getByRole('button', { name: 'Continue' }).click();

    // const RegistrationPin = getRegistrationPin('WALLET1');
    // const pinReg1 = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[1]');
    // await pinReg1.fill(RegistrationPin.one);

    // const pinReg2 = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[2]');
    // await pinReg2.fill(RegistrationPin.two);

    // const pinReg3 = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[3]');
    // await pinReg3.fill(RegistrationPin.one);

    // const pinReg4 = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[4]');
    // await pinReg4.fill(RegistrationPin.one);
    // await newTab.getByRole('button', { name: 'Continue' }).click();

    // Confirm password change
    // const pinConfirm1 = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[1]');
    // await pinConfirm1.fill(RegistrationPin.one);

    // const pinConfirm2 = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[2]');
    // await pinConfirm2.fill(RegistrationPin.two);

    // const pinConfirm3 = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[3]');
    // await pinConfirm3.fill(RegistrationPin.one);

    // const pinConfirm4 = newTab.locator('xpath=//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[4]');
    // await pinConfirm4.fill(RegistrationPin.one);
    // await newTab.getByRole('button', { name: 'Continue' }).click();

    // await newTab.getByRole('button', { name: 'confirm' }).click();
    // await newTab.getByPlaceholder('Password', { exact: true }).fill(WalletCredentials.password);
    // await newTab.getByRole('button', { name: 'confirm' }).click();

    // try {
    //     await newTab.waitForSelector('//*[@id="lc"]/div[2]/div[2]/div[2]/div[1]/div[2]', { timeout: 5000 });
    //     const textContent = await newTab.$eval('//*[@id="lc"]/div[2]/div[2]/div[2]/div[1]/div[2]', el => el.textContent);

    //     if (textContent) {
    //         console.log("registered for voting successfully!");
    //     } else {
    //         console.log('text content not found');
    //     }
    // } catch (error) {
    //     console.error('an error occurred:', error.toString());
    //     console.log('an error occurred');
    // }

    // Logout 
    // const logOut = '//*[@id="app"]/div/div/div[3]/div/div/div[1]/div/div/div[2]/div[11]/div[2]';
    // await newTab.locator(logOut).click();

    // const chooseAccount = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[2]/div';
    // await newTab.locator(chooseAccount).click();

    // const removeAccount = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[2]/div[4]/button';
    // await newTab.locator(removeAccount).click();

    // await newTab.locator('button.btn.bg-primary').click();

    // const addNew = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[4]';
    // await newTab.locator(addNew).click();

    await newTab.goto('http://localhost:8000/');

    await newTab.locator('//*[text()="Enable wallet"]').click();

    await expect.poll(async () => {
        return browser.pages().length;
    }, { timeout: 5000 }).toBe(3);

    const updatedPages = browser.pages();
    const allowTab = updatedPages[updatedPages.length - 1];
    await allowTab.bringToFront();

    await allowTab.getByRole('button', { name: 'Allow' }).click();
});