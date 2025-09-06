import { BrowserExtensionModel } from "./browserExtensionModel";

export class WalletConfigModel {
  name: string;
  extension: BrowserExtensionModel;
  network: "mainnet" | "preprod" | "preview" | "devnet";
  seed: string[];
  username: string;
  password: string;
  cipBridge: string[];
  mainAddress: string;
  stakeAddress: string;
}
