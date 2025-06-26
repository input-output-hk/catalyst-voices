import { AccountModel } from "./accountModel";
import { WalletConfigModel } from "./walletConfigModel";

export class TestModel {
  constructor(
    public accountModel: AccountModel,
    public walletConfig: WalletConfigModel
  ) {}
}
