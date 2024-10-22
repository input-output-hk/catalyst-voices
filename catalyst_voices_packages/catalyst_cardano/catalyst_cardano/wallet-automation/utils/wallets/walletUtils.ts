import { Page } from "@playwright/test";
import { BrowserExtension, BrowserExtensionName } from "../extensions";
import { onboardTyphonWallet } from "./typhonUtils";
import { onboardLaceWallet } from "./laceUtils";

export interface WalletConfig {
  id: string;
  extension: BrowserExtension;
  seed: string[];
  username: string;
  password: string;
}

export const onboardWallet = async (page: Page, walletConfig: WalletConfig): Promise<void> => {
  switch (walletConfig.extension.Name) {
    case BrowserExtensionName.Typhon:
      await onboardTyphonWallet(page, walletConfig);
      break;
    case BrowserExtensionName.Lace:
      await onboardLaceWallet(page, walletConfig);
      break;
    default:
      throw new Error('Wallet not in use')
  }
}

export const allowExtension = async (tab: Page, wallet: string): Promise<void> => {
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