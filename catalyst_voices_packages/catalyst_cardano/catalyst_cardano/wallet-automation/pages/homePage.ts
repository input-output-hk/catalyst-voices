import { Page, Locator } from "playwright";

export interface UTxO {
  tx: string;
  index: number;
  amount: number;
}

export interface WalletCipData {
  balance: number;
  extensions: string;
  networkId: string;
  changeAddress: string;
  rewardAddresses: string[];
  unusedAddresses: string[];
  usedAddresses: string[];
  utxos: UTxO[];
  publicDRepKey: string;
  registeredPublicStakeKeys: string;
  unregisteredPublicStakeKeys: string[];
}

export class HomePage {

  readonly page: Page;
  readonly balanceLabel: Locator;
  readonly extensionsLabel: Locator;
  readonly networkIdLabel: Locator;
  readonly changeAddressLabel: Locator;
  readonly rewardAddressesLabel: Locator;
  readonly unusedAddressesLabel: Locator;
  readonly usedAddressesLabel: Locator;
  readonly utxosLabel: Locator;
  readonly publicDRepKeyLabel: Locator;
  readonly registeredPublicStakeKeysLabel: Locator;
  readonly unregisteredPublicStakeKeysLabel: Locator;
  readonly signDataButton: Locator;
  readonly signAndSubmitTxButton: Locator;
  readonly signAndSubmitRBACTxButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.balanceLabel = page.getByText('Balance: ');
    this.extensionsLabel = page.getByText(/^Extensions:/);
    this.networkIdLabel = page.getByText(/^Network ID:/);
    this.changeAddressLabel = page.getByText(/^Change address:/);
    this.rewardAddressesLabel = page.getByText(/^Reward addresses:/);
    this.unusedAddressesLabel = page.getByText(/^Unused addresses:/);
    this.usedAddressesLabel = page.getByText(/^Used addresses:/);
    this.utxosLabel = page.getByText(/^UTXOs:/);
    this.publicDRepKeyLabel = page.getByText(/^Public DRep Key:/);
    this.registeredPublicStakeKeysLabel = page.getByText(/^Registered Public Stake Keys:/);
    this.unregisteredPublicStakeKeysLabel = page.getByText(/^Unregistered Public Stake Keys:/);
    this.signDataButton = page.getByRole('button', { name: 'Sign data' });
    this.signAndSubmitTxButton = page.getByRole('button', { name: 'Sign & submit tx' });
    this.signAndSubmitRBACTxButton = page.getByRole('button', { name: 'Sign & submit RBAC tx' });
  }

  async getWalletCipData() {
    const walletCipData: WalletCipData = {
      balance: 0,
      extensions: '',
      networkId: '',
      changeAddress: '',
      rewardAddresses: [],
      unusedAddresses: [],
      usedAddresses: [],
      utxos: [],
      publicDRepKey: '',
      registeredPublicStakeKeys: '',
      unregisteredPublicStakeKeys: [],
    };
    if (await this.balanceLabel.isVisible()) {
      walletCipData.balance = await this.getBalance(this.balanceLabel);
    } else {
      throw new Error(`Element ${this.balanceLabel} not found`);
    }
    if (await this.extensionsLabel.isVisible()) {
      walletCipData.extensions = await this.getExtensions(this.extensionsLabel);
    } else {
      throw new Error(`Element ${this.extensionsLabel} not found`);
    }
    if (await this.networkIdLabel.isVisible()) {
      walletCipData.networkId = await this.getNetworkId(this.networkIdLabel);
    } else {
      throw new Error(`Element ${this.networkIdLabel} not found`);
    }
    if (await this.changeAddressLabel.isVisible()) {
      walletCipData.changeAddress = await this.getChangeAddress(this.changeAddressLabel);
    } else {
      throw new Error(`Element ${this.changeAddressLabel} not found`);
    }
    if (await this.rewardAddressesLabel.isVisible()) {
      walletCipData.rewardAddresses = await this.getRewardAddresses(this.rewardAddressesLabel);
    } else {
      throw new Error(`Element ${this.rewardAddressesLabel} not found`);
    }
    if (await this.unusedAddressesLabel.isVisible()) {
      walletCipData.unusedAddresses = await this.getUnusedAddresses(this.unusedAddressesLabel);
    } else {
      throw new Error(`Element ${this.unusedAddressesLabel} not found`);
    }
    if (await this.usedAddressesLabel.isVisible()) {
      walletCipData.usedAddresses = await this.getUsedAddresses(this.usedAddressesLabel);
    } else {
      throw new Error(`Element ${this.usedAddressesLabel} not found`);
    }
    if (await this.utxosLabel.isVisible()) {
      walletCipData.utxos = await this.getUTXOs(this.utxosLabel);
    } else {
      throw new Error(`Element ${this.utxosLabel} not found`);
    }
    if (await this.publicDRepKeyLabel.isVisible()) {
      walletCipData.publicDRepKey = await this.getPublicDRepKey(this.publicDRepKeyLabel);
    } else {
      throw new Error(`Element ${this.publicDRepKeyLabel} not found`);
    }
    if (await this.registeredPublicStakeKeysLabel.isVisible()) {
      walletCipData.registeredPublicStakeKeys = await this.getRegisteredPublicStakeKeys(this.registeredPublicStakeKeysLabel);
    } else {
      throw new Error(`Element ${this.registeredPublicStakeKeysLabel} not found`);
    }
    if (await this.unregisteredPublicStakeKeysLabel.isVisible()) {
      walletCipData.unregisteredPublicStakeKeys = await this.getUnregisteredPublicStakeKeys(this.unregisteredPublicStakeKeysLabel);
    } else {
      throw new Error(`Element ${this.unregisteredPublicStakeKeysLabel} not found`);
    }
    return walletCipData;
  }

  async getBalance(balanceLabel: Locator): Promise<number> {
    const balanceText = await balanceLabel.textContent();
    const match = balanceText?.match(/^Balance: Ada \(lovelaces\): (\d+)/);
    if (match && match[1]) {
      return Number(match[1]);
    } else {
      throw new Error(`Unable to extract balance from text: ${balanceText}`);
    }
  }
  

  async getExtensions(extensionsLabel: Locator): Promise<string> {
    throw new Error("Method not implemented.");
  }

  async getNetworkId(networkIdLabel: Locator): Promise<string> {
    throw new Error("Method not implemented.");
  }

  async getChangeAddress(changeAddressLabel: Locator): Promise<string> {
    throw new Error("Method not implemented.");
  }

  async getRewardAddresses(rewardAddressesLabel: Locator): Promise<string[]> {
    throw new Error("Method not implemented.");
  }

  async getUnusedAddresses(unusedAddressesLabel: Locator): Promise<string[]> {
    throw new Error("Method not implemented.");
  }

  async getUsedAddresses(usedAddressesLabel: Locator): Promise<string[]> {
    throw new Error("Method not implemented.");
  }

  async getUTXOs(utxosLabel: Locator): Promise<UTxO[]> {
    throw new Error("Method not implemented.");
  }

  async getPublicDRepKey(publicDRepKeyLabel: Locator): Promise<string> {
    throw new Error("Method not implemented.");
  }

  async getRegisteredPublicStakeKeys(registeredPublicStakeKeysLabel: Locator): Promise<string> {
    throw new Error("Method not implemented.");
  }

  async getUnregisteredPublicStakeKeys(unregisteredPublicStakeKeysLabel: Locator): Promise<string[]> {
    throw new Error("Method not implemented.");
  }
}
