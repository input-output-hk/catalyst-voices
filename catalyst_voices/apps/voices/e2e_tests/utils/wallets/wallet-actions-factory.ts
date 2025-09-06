import { Page } from "@playwright/test";
import { BrowserExtensionName } from "../../models/browserExtensionModel";
import { WalletConfigModel } from "../../models/walletConfigModel";
import { WalletActions } from "./wallet-actions";
import { LaceActions } from "./lace-actions";
import { EternlActions } from "./eternl-actions";
import { YoroiActions } from "./yoroi-actions";
import { NufiActions } from "./nufi-actions";
import { VesprActions } from "./vespr-actions";

class NoExtensionActions implements WalletActions {
  async restoreWallet() {
    throw new Error(
      "You should never end up here. Please share your adventure!"
    );
  }

  async connectWallet() {
    throw new Error(
      "You should never end up here. Please share your adventure!"
    );
  }

  async approveTransaction() {
    throw new Error(
      "You should never end up here. Please share your adventure!"
    );
  }
}

type WalletActionsConstructor = new (
  wallet: WalletConfigModel,
  page: Page
) => WalletActions;

const walletActionsRegistry: Record<
  BrowserExtensionName,
  WalletActionsConstructor
> = {
  [BrowserExtensionName.Lace]: LaceActions,
  [BrowserExtensionName.Eternl]: EternlActions,
  [BrowserExtensionName.Yoroi]: YoroiActions,
  [BrowserExtensionName.Nufi]: NufiActions,
  [BrowserExtensionName.Vespr]: VesprActions,
  [BrowserExtensionName.NoExtension]: NoExtensionActions,
};

export const createWalletActions = (
  wallet: WalletConfigModel,
  page: Page
): WalletActions => {
  const WalletActionsClass = walletActionsRegistry[wallet.extension.Name];

  if (!WalletActionsClass) {
    throw new Error(
      `No wallet actions implementation found for ${wallet.extension.Name}`
    );
  }

  return new WalletActionsClass(wallet, page);
};
