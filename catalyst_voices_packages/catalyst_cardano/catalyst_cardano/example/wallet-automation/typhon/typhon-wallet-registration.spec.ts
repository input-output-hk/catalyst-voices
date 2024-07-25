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

    const unlockWallet = '#app > div > div > div.flex-grow.overflow-auto > div > div.my-5.flex.justify-center.py-16 > div > div > div > div.mt-6.text-center.flex.justify-center > button';
    await clickBlankSpace(newTab);
    await newTab.waitForSelector(unlockWallet, { state: 'visible' });
    await newTab.click(unlockWallet);

    const divSelector = '//*[@id="lc"]/div[2]/div[1]/div[2]/div/div[1]/div[1]/div/div[2]/div[1]/div/span[1]';
    await newTab.waitForSelector(divSelector, { state: 'visible' });

    // use the selector to retrieve the element handle
    const elementHandle = await newTab.$(divSelector);
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
            console.log('no text content found for the specified selector:', divSelector);
        }
    } else {
        console.log('element not found for the specified XPath:', divSelector);
    }

    const voting = '//*[@id="app"]/div/div/div[3]/div/div/div[1]/div/div/div[2]/div[5]/a/div/div[2]';
    await newTab.waitForSelector(voting, { state: 'visible' });
    await newTab.click(voting);

    const regForVoting = '//*[@id="lc"]/div[2]/div[2]/div[1]/button/span';
    await newTab.waitForSelector(regForVoting, { state: 'visible' });
    await newTab.click(regForVoting)

    const continueReg = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[2]/div[2]/div/button[2]/span';
    await newTab.waitForSelector(continueReg, { state: 'visible' });
    await newTab.click(continueReg);

    const RegistrationPin = getRegistrationPin('WALLET1');
    const pinReg1 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[1]';
    await newTab.waitForSelector(pinReg1, { state: 'visible' });
    await newTab.fill(pinReg1, RegistrationPin.one);

    const pinReg2 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[2]';
    await newTab.waitForSelector(pinReg2, { state: 'visible' });
    await newTab.fill(pinReg2, RegistrationPin.two);

    const pinReg3 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[3]';
    await newTab.waitForSelector(pinReg3, { state: 'visible' });
    await newTab.fill(pinReg3, RegistrationPin.three);

    const pinReg4 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[4]';
    await newTab.waitForSelector(pinReg4, { state: 'visible' });
    await newTab.fill(pinReg4, RegistrationPin.four);

    const continuePin = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[2]/div[2]/div/button[2]/span';
    await newTab.waitForSelector(continuePin, { state: 'visible' })
    await newTab.click(continuePin);

    const pinConfirm1 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[1]';
    await newTab.waitForSelector(pinConfirm1, { state: 'visible' });
    await newTab.fill(pinConfirm1, RegistrationPin.one);

    const pinConfirm2 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[2]';
    await newTab.waitForSelector(pinConfirm2, { state: 'visible' });
    await newTab.fill(pinConfirm2, RegistrationPin.two);

    const pinConfirm3 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[3]';
    await newTab.waitForSelector(pinConfirm3, { state: 'visible' });
    await newTab.fill(pinConfirm3, RegistrationPin.three);

    const pinConfirm4 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[1]/div/div[1]/input[4]';
    await newTab.waitForSelector(pinConfirm4, { state: 'visible' });
    await newTab.fill(pinConfirm4, RegistrationPin.four);

    const continueReg2 = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[2]/div[2]/div/button[2]/div/div/div/span';
    await newTab.waitForSelector(continueReg2, { state: 'visible' });
    await newTab.click(continueReg2);

    const confirmReg = '//*[@id="lc"]/div[2]/div[2]/div[1]/div[2]/div[2]/div[2]/div/button[2]/div/div';
    await newTab.waitForSelector(confirmReg, { state: 'visible' });
    await newTab.click(confirmReg);

    const inputConfirmPassword = 'input[type="password"]';
    await newTab.waitForSelector(inputConfirmPassword, { state: 'visible' });
    await newTab.fill(inputConfirmPassword, WalletCredentials.password);

    const confirmTransactionButton = '//button[text()="confirm"]';
    await newTab.waitForSelector(confirmTransactionButton, { state: 'visible' });
    await newTab.click(confirmTransactionButton);

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

    // const logOut = '//*[@id="app"]/div/div/div[3]/div/div/div[1]/div/div/div[2]/div[11]/div[2]';
    // await newTab.waitForSelector(logOut, { state: 'visible' });
    // await newTab.click(logOut);

    // const chooseAccount = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[2]/div';
    // await newTab.waitForSelector(chooseAccount, { state: 'visible' });
    // await newTab.click(chooseAccount);

    // const removeAccount = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[2]/div[4]/button';
    // await newTab.waitForSelector(removeAccount, { state: 'visible' });
    // await newTab.click(removeAccount);

    // const confirmRemove = 'button.btn.bg-primary';
    // await newTab.waitForSelector(confirmRemove, { state: 'visible' });
    // await newTab.click(confirmRemove)

    // const addNew = '//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div[4]';
    // await newTab.waitForSelector(addNew, { state: 'visible' });
    // await newTab.click(addNew);

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