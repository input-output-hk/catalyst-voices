/* eslint @typescript-eslint/no-explicit-any: off */

import * as cip30 from "@cardano-sdk/cip30";

export type WalletCollections = {
  [k: string]: Omit<cip30.Cip30Wallet, "enable"> & {
    enable(args: { extensions: { cip: number }[] }): Promise<cip30.WalletApi>;
    supportedExtensions: { cip: number }[];
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
    id: string;
  }[];
  txOutputs: {
    address: string;
    amount: string;
  }[];
  timeToLive: string;
  certificates: (
    | {
        type: "stake_registration";
      }
    | {
        type: "stake_deregistration";
      }
    | {
        type: "stake_delegation";
        hashType: "addr_keyhash" | "scripthash";
        hash: string;
        poolKeyhash: string;
      }
    | {
        type: "pool_registration";
      }
    | {
        type: "pool_retirement";
      }
    | {
        type: "genesis_key_delegation";
      }
    | {
        type: "move_instantaneous_rewards_cert";
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
