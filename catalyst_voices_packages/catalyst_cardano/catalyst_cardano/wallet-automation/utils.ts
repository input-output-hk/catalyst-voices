import * as fs from 'fs/promises';
import * as fsi from 'fs';
import path from 'path';
import nodeFetch from "node-fetch";
import { expect, Page } from '@playwright/test';

interface WalletCredentials {
  username: string;
  password: string;
}
const getWalletCredentials = async (walletID: string): Promise<WalletCredentials> => {
  const username = process.env[`${walletID}_USERNAME`];
  const password = process.env[`${walletID}_PASSWORD`];
  console.log(`username: ${username}, password: ${password}`);

  if (!username || !password) {
    throw new Error(`Credentials for ${walletID} not found`);
  }

  return { username, password };
};
export { getWalletCredentials };

const getSeedPhrase = async (): Promise<string[]> => {
  let  seedPhraseArray: string[];
  seedPhraseArray = process.env[`WALLET1_SEED_WORD`].split(",");
  return seedPhraseArray;
};
export { getSeedPhrase };

const downloadExtension = async (extID: string): Promise<string> => {
    const unzip = require("unzip-crx-3");
    const url = `https://clients2.google.com/service/update2/crx?response=redirect&os=win&arch=x64&os_arch=x86_64&nacl_arch=x86-64&prod=chromiumcrx&prodchannel=beta&prodversion=79.0.3945.53&lang=ru&acceptformat=crx3&x=id%3D${extID}%26installsource%3Dondemand%26uc`;
    const downloadPath = path.resolve(__dirname, 'extensions');
    await fs.mkdir(downloadPath, { recursive: true });
    const filePath = path.join(downloadPath, extID + '.crx');
    const res = await nodeFetch(url);
    await new Promise<void>((resolve, reject) => {
        console.log(`Downloading extension ${extID}`);
        const fileStream = fsi.createWriteStream(filePath);
        res?.body?.pipe(fileStream);
        res!.body!.on("error", (err) => {
          reject(err);
        });
        fileStream.on("finish", function() {
          console.log(`Extension has been downloaded to: ${filePath}`);
          resolve();
        });
      });

    // Extract the extension
    try {
        const extractPath = path.join(downloadPath, extID);
        await fs.mkdir(extractPath, { recursive: true });
        await unzip(filePath, extractPath);
        console.log("Extracted CRX file to:", extractPath);
        return extractPath;
    } catch (error) {
        console.error("Failed to unzip the CRX file:", error.message);
        throw new Error('Failed to unzip the CRX file.');
    }
  };
  export { downloadExtension };

  const typhonImportWallet = async (tab: Page): Promise<void> => {
    //switch to preprod network
    await tab.locator('button#headlessui-menu-button-1').click();
    await tab.locator('button#headlessui-menu-item-6').click();
    //import wallet
    await tab.getByRole('button', { name: 'Import' }).click();
    const WalletCredentials = await getWalletCredentials('WALLET1');
    await tab.getByPlaceholder('Wallet Name').fill(WalletCredentials.username);
    await tab.getByPlaceholder('Password', { exact: true }).fill(WalletCredentials.password);
    await tab.getByPlaceholder('Confirm Password', { exact: true }).fill(WalletCredentials.password);
    await tab.locator('input#termsAndConditions').click();
    await tab.getByRole('button', { name: 'Continue' }).click();

    // Input seed phrase
    const seedPhrase = await getSeedPhrase();
    for (let i = 0; i < seedPhrase.length; i++) {
        const ftSeedPhraseSelector = `(//input[@type='text'])[${i + 1}]`;
        await tab.locator(ftSeedPhraseSelector).fill(seedPhrase[i]);
    }

    await tab.locator('//*[@id="app"]/div/div/div[3]/div/div[2]/div/div/div/div[1]/div[1]/div[1]/span[1]').click();
    await tab.getByRole('button', { name: 'Unlock Wallet' }).click();
};

const laceImportWallet = async (tab: Page): Promise<void> => {
  await tab.getByRole('button', { name: 'Agree' }).click();
  await tab.getByRole('button', { name: 'Restore' }).click();
  await tab.getByRole('button', { name: 'Next' }).click();
  await tab.getByTestId('recovery-phrase-15').click();
  const seedPhrase = await getSeedPhrase();
    for (let i = 0; i < seedPhrase.length; i++) {
        const ftSeedPhraseSelector = `//*[@id="mnemonic-word-${i + 1}"]`;
        await tab.locator(ftSeedPhraseSelector).fill(seedPhrase[i]);
    }
  await tab.getByRole('button', { name: 'Next' }).click();
  const WalletCredentials = await getWalletCredentials('WALLET1');
  await tab.getByTestId('wallet-name-input').fill(WalletCredentials.username);
  await tab.getByTestId('wallet-password-verification-input').fill(WalletCredentials.password);
  await tab.getByTestId('wallet-password-confirmation-input').fill(WalletCredentials.password);
  await tab.getByRole('button', { name: 'Open wallet' }).click();
  //Lace is very slow at loading
  await tab.getByTestId('profile-dropdown-trigger-menu').click({timeout: 300000});
  await tab.getByTestId('header-menu').getByTestId('header-menu-network-choice-container').click();
  await tab.getByTestId('header-menu').getByTestId('network-preprod-radio-button').click();
};

const importWallet = async (tab: Page, wallet: string): Promise<void> => {
  switch (wallet) {
    case 'Typhon':
      await typhonImportWallet(tab);
      break;
    case 'Lace':
      await laceImportWallet(tab);
      break;
    default:
      throw new Error('Wallet not in use')
  }
}
export { importWallet };

const allowExtension = async (tab: Page, wallet: string): Promise<void> => {
  switch (wallet) {
    case 'Typhon':
      await tab.getByRole('button', { name: 'Allow' }).click();
      break;
    case 'Lace':
      await tab.getByTestId('connect-authorize-button').click();
      await tab.getByRole('button', { name: 'Always' }).click();
      break;
    default:
      throw new Error('Wallet not in use')
  }

}
export { allowExtension };

async function signTyphonData(signTab: Page, password: string) {
  await signTab.getByRole('button', { name: 'Sign' }).click();
  await signTab.getByPlaceholder('Password', { exact: true }).fill(password);
  await signTab.getByRole('button', { name: 'confirm' }).click();
}

async function signLaceData(signTab: Page, password: string) {
 await signTab.getByRole('button', { name: 'Confirm' }).click();
 await signTab.getByTestId('password-input').fill(password);
 await signTab.getByRole('button', { name: 'Confirm' }).click();
 await signTab.getByRole('button', { name: 'Close' }).click();
}

const signData = async (wallet: string, tab: Page, password: string): Promise<void> => {
  switch (wallet) {
    case 'Typhon':
      await signTyphonData(tab, password);
      break;
    case 'Lace':
      await signLaceData(tab, password);
      break;
    default:
      throw new Error('Wallet not in use')
  }
}
export { signData };

async function signTyphonBadPwd(signTab: Page, password: string) {
  await signTab.getByRole('button', { name: 'Sign' }).click();
  await signTab.getByPlaceholder('Password', { exact: true }).fill(password);
  await signTab.getByRole('button', { name: 'confirm' }).click();
  await expect(signTab.getByText('Wrong password')).toBeVisible();
  await signTab.locator('//*[@id="headlessui-dialog-2"]/div/div[2]/div[1]/button').click()
  await signTab.getByRole('button', { name: 'Reject' }).click();
}

async function signLaceBadPwd(signTab: Page, password: string) {
 await signTab.getByRole('button', { name: 'Confirm' }).click();
 await signTab.getByTestId('password-input').fill(password);
 await signTab.getByRole('button', { name: 'Confirm' }).click();
 await expect(signTab.getByTestId('password-input-error')).toBeVisible();
 await signTab.getByRole('button', { name: 'Cancel' }).click();
 await signTab.getByRole('button', { name: 'Cancel' }).click();
}

const signDataBadPwd = async (wallet: string, tab: Page): Promise<void> => {
  const password = 'BadPassword'
  switch (wallet) {
    case 'Typhon':
      await signTyphonBadPwd(tab, password);
      break;
    case 'Lace':
      await signLaceBadPwd(tab, password);
      break;
    default:
      throw new Error('Wallet not in use')
  }
}
export { signDataBadPwd };
