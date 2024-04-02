/* eslint @typescript-eslint/no-explicit-any: off */

import * as cip30 from "@cardano-sdk/cip30";

export type WalletCollections = {
  [k: string]: Omit<cip30.Cip30Wallet, "enable"> & {
    enable(args: { extensions: { cip: number; }[]; }): Promise<cip30.WalletApi>;
    supportedExtensions: { cip: number; }[];
  };
};

export type ExtensionArguments = {
  cip?: number;
};

export type ExtractedWalletApi = {
  signTx: cip30.SignTx;
  signData: cip30.SignData;
  submitTx: cip30.SubmitTx;
  info: {
    [key: string]: {
      from: string;
      raw: any;
      value: any;
    };
  };
  [key: `cip${number}`]: any;
};

export enum MetadataValueType {
  Text = "text",
  Hex = "hex",
  Int = "int",
  List = "list",
  Map = "map",
  Cbor = "cbor",
}

export enum CertificateType {
  StakeRegistration = "stake_registration",
  StakeDeregistration = "stake_deregistration",
  StakeDelegation = "stake_delegation",
  PoolRegistration = "pool_registration",
  PoolRetirement = "pool_retirement",
  GenesisKeyDelegation = "genesis_key_delegation",
  MoveInstantaneousRewardsCert = "move_instantaneous_rewards_cert",
}

export enum AuxMetadataType {
  Shelley = "shelley",
  ShelleyMA = "shelley-ma",
  AlonzoAndBeyond = "alonzo-and-beyond",
}

export type TxBuilderArguments = {
  txInputs: {
    hex: string;
  }[];
  txOutputs: {
    address: string;
    amount: string;
  }[];
  txFee: string;
  timeToLive: string;
  certificates: (
    | {
        type: CertificateType.StakeRegistration;
      }
    | {
        type: CertificateType.StakeDeregistration;
      }
    | {
        type: CertificateType.StakeDelegation;
        hashType: "addr_keyhash" | "scripthash";
        hash: string;
        poolKeyhash: string;
        network: string;
      }
    | {
        type: CertificateType.PoolRegistration;
      }
    | {
        type: CertificateType.PoolRetirement;
      }
    | {
        type: CertificateType.GenesisKeyDelegation;
      }
    | {
        type: CertificateType.MoveInstantaneousRewardsCert;
      }
  )[];
  rewardWithdrawals: {
    address: string;
    network: string;
    value: string;
  }[];
  auxilliaryDataHash: string;
  validityIntervalStart: string;
  requiredSigners: {
    address: string;
  }[];
  networkId: string;

  auxMetadata: {
    type: AuxMetadataType;
    metadata: {
      key: string;
      valueType: MetadataValueType | "";
      value: string;
    }[];
    // TODO: add support for scripts
  };
  config: {
    linearFee: {
      minFeeA: string;
      minFeeB: string;
    };
    minUtxo: string;
    poolDeposit: string;
    keyDeposit: string;
    maxValSize: number;
    maxTxSize: number;
    priceMem: number;
    priceStep: number;
    coinsPerUtxoWord: string;
  };
};
