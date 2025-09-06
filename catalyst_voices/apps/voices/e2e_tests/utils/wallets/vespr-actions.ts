import { Page } from "@playwright/test";
import { WalletActions } from "./wallet-actions";
import { WalletConfigModel } from "../../models/walletConfigModel";

export class VesprActions implements WalletActions {
  private page: Page;
  private walletConfig: WalletConfigModel;

  constructor(wallet: WalletConfigModel, page: Page) {
    this.walletConfig = wallet;
    this.page = page;
  }

  async restoreWallet(): Promise<void> {
    throw new Error("Vespr wallet is not supported yet");
  }

  async connectWallet(): Promise<void> {
    throw new Error("Vespr wallet is not supported yet");
  }

  async approveTransaction(): Promise<void> {
    throw new Error("Vespr wallet is not supported yet");
  }
}
