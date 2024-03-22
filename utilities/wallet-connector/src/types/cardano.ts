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

export type TxBuilderArguments = {
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
