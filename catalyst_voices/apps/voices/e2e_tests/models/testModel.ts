import { WalletConfig } from "../utils/wallets/walletUtils";
import { AccountModel } from "./accountModel";

export class TestModel {
  constructor(
    public accountModel: AccountModel,
    public walletConfig: WalletConfig
  ) {}
}
