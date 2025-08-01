import { BrowserExtensionModel } from "./browserExtensionModel";

export class WalletConfigModel {
  id: string;
  extension: BrowserExtensionModel;
  seed: string[];
  username: string;
  password: string;
  cipBridge: string[];
}
