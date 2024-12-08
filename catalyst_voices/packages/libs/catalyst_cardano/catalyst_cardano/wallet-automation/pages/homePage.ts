import { Locator, Page, expect } from "@playwright/test";
import { WalletConfig } from "../utils/wallets/walletUtils";
import { Modal, ModalName } from "./modal";

export interface UTxO {
  tx: string;
  index: number;
  amount: number;
}

export interface WalletCipData {
  balance: number;
  extensions: string[];
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

  // TODO: Add keys to source app and change locators to locate based on keys
  constructor(page: Page) {
    this.page = page;
    this.balanceLabel = page.getByText(/^Balance: Ada \(lovelaces\):/);
    this.extensionsLabel = page.getByText(/^Extensions:/);
    this.networkIdLabel = page.getByText(/^Network ID:/);
    this.changeAddressLabel = page.getByText(/^Change address:/);
    this.rewardAddressesLabel = page.getByText(/^Reward addresses:/);
    this.unusedAddressesLabel = page.getByText(/^Unused addresses:/);
    this.usedAddressesLabel = page.getByText(/^Used addresses:/);
    this.utxosLabel = page.getByText(/^UTXOs:/);
    this.publicDRepKeyLabel = page.getByText(/^Public DRep Key:/);
    this.registeredPublicStakeKeysLabel = page.getByText(
      /^Registered Public Stake Keys:/
    );
    this.unregisteredPublicStakeKeysLabel = page.getByText(
      /^Unregistered Public Stake Keys:/
    );
    this.signDataButton = page.getByRole("button", { name: "Sign data" });
    this.signAndSubmitTxButton = page.getByRole("button", {
      name: "Sign & submit tx",
    });
    this.signAndSubmitRBACTxButton = page.getByRole("button", {
      name: "Sign & submit RBAC tx",
    });
  }

  async getWalletCipData() {
    const walletCipData: WalletCipData = {
      balance: 0,
      extensions: [],
      networkId: "",
      changeAddress: "",
      rewardAddresses: [],
      unusedAddresses: [],
      usedAddresses: [],
      utxos: [],
      publicDRepKey: "",
      registeredPublicStakeKeys: "",
      unregisteredPublicStakeKeys: [],
    };
    await this.balanceLabel.waitFor({ state: "visible", timeout: 10000 });
    walletCipData.balance = await this.getBalance();
    walletCipData.extensions = await this.getExtensions();
    walletCipData.networkId = await this.getNetworkId();
    walletCipData.changeAddress = await this.getChangeAddress();
    walletCipData.rewardAddresses = await this.getRewardAddresses();
    walletCipData.unusedAddresses = await this.getUnusedAddresses();
    walletCipData.usedAddresses = await this.getUsedAddresses();
    walletCipData.utxos = await this.getUTXOs();
    walletCipData.publicDRepKey = await this.getPublicDRepKey();
    walletCipData.registeredPublicStakeKeys =
      await this.getRegisteredPublicStakeKeys();
    walletCipData.unregisteredPublicStakeKeys =
      await this.getUnregisteredPublicStakeKeys();
    return walletCipData;
  }

  async assertModal(modalName: ModalName) {
    const modal = new Modal(this.page, modalName);
    await modal.assertModalIsVisible();
  }

  async getBalance(): Promise<number> {
    const isVisible = await this.balanceLabel.isVisible();
    if (!isVisible) {
      throw new Error("Balance label is not visible");
    }
    const balanceText = await this.balanceLabel.textContent();
    const match = balanceText?.match(/^Balance: Ada \(lovelaces\): (\d+)/);
    if (match && match[1]) {
      return Number(match[1]);
    } else {
      throw new Error(`Unable to extract balance from text: ${balanceText}`);
    }
  }

  async getExtensions(): Promise<string[]> {
    const isVisible = await this.extensionsLabel.isVisible();
    if (!isVisible) {
      throw new Error("Extensions label is not visible");
    }
    const extensionsText = await this.extensionsLabel.textContent();
    const match = extensionsText?.trim().match(/^Extensions:\s*(.+)$/);
    if (match && match[1]) {
      const trimmedText = match[1].trim();
      return trimmedText
        .split(",")
        .map((ext) => ext.trim())
        .filter((ext) => ext.length > 0);
    } else {
      throw new Error(
        `Unable to extract extensions from text: ${extensionsText}`
      );
    }
  }

  async getNetworkId(): Promise<string> {
    const isVisible = await this.networkIdLabel.isVisible();
    if (!isVisible) {
      throw new Error("Network ID label is not visible");
    }
    const networkIdText = await this.networkIdLabel.textContent();
    const match = networkIdText?.trim().match(/^Network ID:\s*(.+)$/);
    if (match && match[1]) {
      return match[1].trim();
    } else {
      throw new Error(
        `Unable to extract network ID from text: ${networkIdText}`
      );
    }
  }

  async getChangeAddress(): Promise<string> {
    const isVisible = await this.changeAddressLabel.isVisible();
    if (!isVisible) {
      throw new Error("Change address label is not visible");
    }
    const changeAddressText = await this.changeAddressLabel.textContent();
    const match = changeAddressText?.trim().match(/^Change address:\s*(.+)$/s);
    if (match && match[1]) {
      return match[1].trim();
    } else {
      throw new Error(
        `Unable to extract change address from text: ${changeAddressText}`
      );
    }
  }

  async getRewardAddresses(): Promise<string[]> {
    const isVisible = await this.rewardAddressesLabel.isVisible();
    if (!isVisible) {
      throw new Error("Reward addresses label is not visible");
    }
    const rewardAddressesText = await this.rewardAddressesLabel.textContent();
    const match = rewardAddressesText?.match(/^Reward addresses:\s*(.+)$/s);
    if (match && match[1]) {
      const addresses = match[1]
        .trim()
        .split("\n")
        .map((addr) => addr.trim())
        .filter((addr) => addr.length > 0);
      return addresses;
    } else {
      throw new Error(
        `Unable to extract reward addresses from text: ${rewardAddressesText}`
      );
    }
  }

  async getUnusedAddresses(): Promise<string[]> {
    const isVisible = await this.unusedAddressesLabel.isVisible();
    if (!isVisible) {
      throw new Error("Unused addresses label is not visible");
    }
    const unusedAddressesText = await this.unusedAddressesLabel.textContent();
    const match = unusedAddressesText?.match(/^Unused addresses:\s*(.+)$/s);
    if (match && match[1]) {
      const addresses = match[1]
        .trim()
        .split("\n")
        .map((addr) => addr.trim())
        .filter((addr) => addr.length > 0);
      return addresses;
    } else {
      throw new Error(
        `Unable to extract unused addresses from text: ${unusedAddressesText}`
      );
    }
  }

  async getUsedAddresses(): Promise<string[]> {
    const isVisible = await this.usedAddressesLabel.isVisible();
    if (!isVisible) {
      throw new Error("Used addresses label is not visible");
    }
    const usedAddressesText = await this.usedAddressesLabel.textContent();
    const match = usedAddressesText?.match(/^Used addresses:\s*(.+)$/s);
    if (match && match[1]) {
      const addresses = match[1]
        .trim()
        .split("\n")
        .map((addr) => addr.trim())
        .filter((addr) => addr.length > 0);
      return addresses;
    } else {
      throw new Error(
        `Unable to extract used addresses from text: ${usedAddressesText}`
      );
    }
  }

  async getUTXOs(): Promise<UTxO[]> {
    const isVisible = await this.utxosLabel.isVisible();
    if (!isVisible) {
      throw new Error("UTXOs label is not visible");
    }
    const utxosText = await this.utxosLabel.textContent();
    const match = utxosText?.match(/^UTXOs:\s*(.+)$/s);
    if (match && match[1]) {
      const utxosData = match[1].trim();
      const utxoEntries = utxosData
        .split(/\n\n+/)
        .map((entry) => entry.trim())
        .filter((entry) => entry.length > 0);
      const utxos: UTxO[] = [];
      for (const entry of utxoEntries) {
        const txMatch = entry.match(/Tx:\s*([a-fA-F0-9]+)/);
        const indexMatch = entry.match(/Index:\s*(\d+)/);
        const amountMatch = entry.match(/Amount:\s*Ada \(lovelaces\):\s*(\d+)/);
        if (txMatch && indexMatch && amountMatch) {
          utxos.push({
            tx: txMatch[1],
            index: Number(indexMatch[1]),
            amount: Number(amountMatch[1]),
          });
        } else {
          throw new Error(`Unable to parse UTXO entry: ${entry}`);
        }
      }
      return utxos;
    } else {
      throw new Error(`Unable to extract UTXOs from text: ${utxosText}`);
    }
  }

  async getPublicDRepKey(): Promise<string> {
    const isVisible = await this.publicDRepKeyLabel.isVisible();
    if (!isVisible) {
      throw new Error("Public DRep Key label is not visible");
    }
    const publicDRepKeyText = await this.publicDRepKeyLabel.textContent();
    const match = publicDRepKeyText
      ?.trim()
      .match(/^Public DRep Key:\s*([a-fA-F0-9]+)$/);
    if (match && match[1]) {
      return match[1];
    } else {
      throw new Error(
        `Unable to extract public DRep key from text: ${publicDRepKeyText}`
      );
    }
  }

  async getRegisteredPublicStakeKeys(): Promise<string> {
    const isVisible = await this.registeredPublicStakeKeysLabel.isVisible();
    if (!isVisible) {
      throw new Error("Registered Public Stake Keys label is not visible");
    }
    const stakeKeysText =
      await this.registeredPublicStakeKeysLabel.textContent();
    const match = stakeKeysText
      ?.trim()
      .match(/^Registered Public Stake Keys:\s*([a-fA-F0-9]+)$/);
    if (match && match[1]) {
      return match[1];
    } else {
      throw new Error(
        `Unable to extract registered public stake keys from text: ${stakeKeysText}`
      );
    }
  }

  async getUnregisteredPublicStakeKeys(): Promise<string[]> {
    const isVisible = await this.unregisteredPublicStakeKeysLabel.isVisible();
    if (!isVisible) {
      throw new Error("Unregistered Public Stake Keys label is not visible");
    }
    const keysText = await this.unregisteredPublicStakeKeysLabel.textContent();
    const match = keysText
      ?.trim()
      .match(/^Unregistered Public Stake Keys:\s*(.*)$/s);
    if (match) {
      const keysData = match[1].trim();
      if (keysData) {
        const keys = keysData
          .split("\n")
          .map((key) => key.trim())
          .filter((key) => key.length > 0);
        return keys;
      } else {
        return [];
      }
    } else {
      throw new Error(
        `Unable to extract unregistered public stake keys from text: ${keysText}`
      );
    }
  }

  async assertBasicWalletCipData(
    actualWalletCipData: WalletCipData,
    walletConfig: WalletConfig
  ) {
    expect(actualWalletCipData.balance).toBeGreaterThan(500000000);
    await this.assertExtensions(
      actualWalletCipData.extensions,
      walletConfig.cipBridge
    );
    expect(actualWalletCipData.networkId).not.toBeNaN();
    expect(actualWalletCipData.changeAddress).not.toBeNaN();
    expect(actualWalletCipData.rewardAddresses.length).toBeGreaterThan(0);
    expect(actualWalletCipData.unusedAddresses.length).toBeGreaterThan(0);
    expect(actualWalletCipData.usedAddresses.length).toBeGreaterThan(0);
    expect(actualWalletCipData.utxos.length).toBeGreaterThan(0);
    expect(actualWalletCipData.publicDRepKey).not.toBeNaN();
    expect(actualWalletCipData.registeredPublicStakeKeys).not.toBeNaN();
  }

  //Check if expected extensions are present in actual extensions
  async assertExtensions(
    actualExtensions: string[],
    expectedExtensions: string[]
  ) {
    for (const ext of expectedExtensions) {
      expect(actualExtensions).toContain(ext);
    }
  }
}
