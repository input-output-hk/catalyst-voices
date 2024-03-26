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

export enum CertificateType {
  StakeRegistration = "stake_registration",
  StakeDeregistration = "stake_deregistration",
  StakeDelegation = "stake_delegation",
  PoolRegistration = "pool_registration",
  PoolRetirement = "pool_retirement",
  GenesisKeyDelegation = "genesis_key_delegation",
  MoveInstantaneousRewardsCert = "move_instantaneous_rewards_cert",
}

export type TxBuilderArguments = {
  txInputs: {
    hash: string;
    index: string;
  }[];
  txOutputs: {
    address: string;
    amount: string;
  }[];
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
  transactionFee: string;
  auxilliaryDataHash: string;
  validityIntervalStart: string;
  requiredSigners: {
    hash: string;
  }[];
  networkId: string;
  regAddress: string;
  regAmount: string;
  regText: string;
  regLabel: string;
  stakeCred: string;
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
