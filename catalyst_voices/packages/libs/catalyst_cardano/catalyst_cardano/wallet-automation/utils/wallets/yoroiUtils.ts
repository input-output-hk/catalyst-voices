import { Page } from "playwright";
import { WalletConfig } from "./walletUtils";

export const onboardYoroiWallet = async (
  page: Page,
  walletConfig: WalletConfig
): Promise<void> => {
  /* cspell: disable */
  await page.locator("#initialPage-tosAgreement-checkbox").check();
  await page.locator("#initialPage-continue-button").click();
  await page.locator("#mui-2").click();
  await page.locator("#somewhere-checkbox").check();
  await page.locator('button:has-text("Continue")').click();

  await page
    .locator(".UriPromptForm_buttonsWrapper button.MuiButton-secondary")
    .click();

  await page.locator("#restoreWalletButton").click();
  await page.locator('button:has-text("Cardano Preprod Testnet")').click();
  await page.locator("#fifteenWordsButton").click();
  const seedPhrase = walletConfig.seed;
  for (let i = 0; i < seedPhrase.length; i++) {
    const ftSeedPhraseSelector = `#downshift-${i}-input`;
    await page.locator(ftSeedPhraseSelector).fill(seedPhrase[i]);
  }
  await page.locator(`#downshift-${seedPhrase.length - 1}-input`).blur();
  await page.locator("#primaryButton").click();
  await page.locator("#infoDialogContinueButton").click();
  await page.locator("#walletNameInput-label").fill(walletConfig.username);
  await page.locator("#walletPasswordInput-label").fill(walletConfig.password);
  await page.locator("#repeatPasswordInput-label").fill(walletConfig.password);
  await page.locator("#primaryButton").click();
  await page.locator("#dialog-gotothewallet-button").click();
};
/* cspell: enable */

export const signYoroiData = async (
  signTab: Page,
  password: string,
  isCorrectPassword: boolean
): Promise<void> => {
  await signTab.locator("#walletPassword").fill(password);
  await signTab.locator("#confirmButton").click();
  if (!isCorrectPassword) {
    await signTab.locator("#cancelButton").click();
    return;
  }
};
