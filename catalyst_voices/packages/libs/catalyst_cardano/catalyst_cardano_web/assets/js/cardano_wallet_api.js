import { CardanoWalletInfoCodeError, CardanoWalletPaginateError } from "./cardano_wallet_error.js";

/**
 * The initial API of the CIP-30 wallet interface: https://cips.cardano.org/cip/CIP-30#initial-api.
 *
 * All the methods, properties or fields are pass-through only to the wallet delegate
 * as well the return types are pass through from the wallet delegate to the caller.
 *
 * All this class does is wrap each method, pass the parameters to the delegate,
 * catch errors and map them to a format understandable by the dart layer.
 */
export class CardanoWalletInitialApi {
  /**
   * Creates a new instance of the class.
   *
   * @param {any} delegate - The CIP-30 initial api delegate.
   */
  constructor(delegate) {
    if (!delegate) throw new Error("Missing delegate in CardanoWalletInitialApi!");
    this.delegate = delegate;
  }

  /**
   * [CIP-30] enable({ extensions: Extension[] } = {}): Promise<API>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#cardanowalletnameenable-extensions-extension----promiseapi}
   */
  async enable(...args) {
    try {
      const fullApi = await this.delegate.enable(..._normalizeArgs(args));
      return new CardanoWalletFullApi(fullApi);
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] isEnabled(): Promise<bool>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#cardanowalletnameisenabled-promisebool}
   */
  async isEnabled() {
    try {
      return await this.delegate.isEnabled();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] apiVersion: String
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#cardanowalletnameapiversion-string}
   */
  get apiVersion() {
    try {
      return this.delegate.apiVersion;
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] supportedExtensions: Extension[]
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#cardanowalletnamesupportedextensions-extension}
   */
  get supportedExtensions() {
    try {
      return this.delegate.supportedExtensions;
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] name: String
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#cardanowalletnamename-string}
   */
  get name() {
    try {
      return this.delegate.name;
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] icon: String
   *
   * @see {@link hhttps://cips.cardano.org/cip/CIP-30#cardanowalletnameicon-string}
   */
  get icon() {
    try {
      return this.delegate.icon;
    } catch (err) {
      throw _mapError(err);
    }
  }
}

/**
 * The full API of the CIP-30 wallet interface: https://cips.cardano.org/cip/CIP-30#full-api.
 *
 * All the methods, properties or fields are pass-through only to the wallet delegate
 * as well the return types are pass through from the wallet delegate to the caller.
 *
 * All this class does is wrap each method, pass the parameters to the delegate,
 * catch errors and map them to a format understandable by the dart layer.
 */
export class CardanoWalletFullApi {
  /**
   * Creates a new instance of the class.
   *
   * @param {any} delegate - The CIP-30 full api delegate.
   */
  constructor(delegate) {
    if (!delegate) throw new Error("Missing delegate in CardanoWalletFullApi!");
    this.delegate = delegate;
  }

  /**
   * [CIP-95] cip95: Governance Extension API
   *
   * @see {@link https://cips.cardano.org/cip/CIP-0095}
   */
  get cip95() {
    try {
      return new CardanoWalletCip95Api(this.delegate.cip95);
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] getExtensions(): Promise<Extension[]>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apigetextensions-promiseextension}
   */
  async getExtensions() {
    try {
      return await this.delegate.getExtensions();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] getNetworkId(): Promise<number>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apigetnetworkid-promisenumber}
   */
  async getNetworkId() {
    try {
      return await this.delegate.getNetworkId();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] getUtxos(amount: cbor<value> = undefined, paginate: Paginate = undefined): Promise<TransactionUnspentOutput[] | null>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apigetutxosamount-cborvalue--undefined-paginate-paginate--undefined-promisetransactionunspentoutput--null}
   */
  async getUtxos(...args) {
    try {
      return await this.delegate.getUtxos(..._normalizeArgs(args));
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] getBalance(): Promise<cbor<value>>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apigetbalance-promisecborvalue}
   */
  async getBalance() {
    try {
      return await this.delegate.getBalance();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] getUsedAddresses(paginate: Paginate = undefined): Promise<Address[]>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apigetusedaddressespaginate-paginate--undefined-promiseaddress}
   */
  async getUsedAddresses(...args) {
    try {
      return await this.delegate.getUsedAddresses(..._normalizeArgs(args));
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] getUnusedAddresses(): Promise<Address[]>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apigetunusedaddresses-promiseaddress}
   */
  async getUnusedAddresses() {
    try {
      return await this.delegate.getUnusedAddresses();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] getChangeAddress(): Promise<Address>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apigetchangeaddress-promiseaddress}
   */
  async getChangeAddress() {
    try {
      return await this.delegate.getChangeAddress();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] getRewardAddresses(): Promise<Address[]>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apigetrewardaddresses-promiseaddress}
   */
  async getRewardAddresses() {
    try {
      return await this.delegate.getRewardAddresses();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] signTx(tx: cbor<transaction>, partialSign: bool = false): Promise<cbor<transaction_witness_set>>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apisigntxtx-cbortransaction-partialsign-bool--false-promisecbortransaction_witness_set}
   */
  async signTx(...args) {
    try {
      return await this.delegate.signTx(..._normalizeArgs(args));
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] signData(addr: Address, payload: Bytes): Promise<DataSignature>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apisigndataaddr-address-payload-bytes-promisedatasignature}
   */
  async signData(...args) {
    try {
      return await this.delegate.signData(..._normalizeArgs(args));
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-30] submitTx(tx: cbor<transaction>): Promise<hash32>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-30#apisubmittxtx-cbortransaction-promisehash32}
   */
  async submitTx(...args) {
    try {
      return await this.delegate.submitTx(..._normalizeArgs(args));
    } catch (err) {
      throw _mapError(err);
    }
  }
}

/**
 * The Governance Extension API of the CIP-95 wallet interface: https://cips.cardano.org/cip/CIP-0095#governance-extension-api.
 *
 * All the methods, properties or fields are pass-through only to the wallet delegate
 * as well the return types are pass through from the wallet delegate to the caller.
 *
 * All this class does is wrap each method, pass the parameters to the delegate,
 * catch errors and map them to a format understandable by the dart layer.
 */
export class CardanoWalletCip95Api {
  /**
   * Creates a new instance of the class.
   *
   * @param {any} delegate - The CIP-95 governance extension api delegate.
   */
  constructor(delegate) {
    if (!delegate) throw new Error("Missing delegate in CardanoWalletCip95Api!");
    this.delegate = delegate;
  }

  /**
   * [CIP-95] getPubDRepKey(): Promise<PubDRepKey>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-0095#apicip95getpubdrepkey-promisepubdrepkey}
   */
  async getPubDRepKey() {
    try {
      return await this.delegate.getPubDRepKey();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-95] getRegisteredPubStakeKeys(): Promise<PubStakeKey[]>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-0095#apigetregisteredpubstakekeys-promisepubstakekey}
   */
  async getRegisteredPubStakeKeys() {
    try {
      return await this.delegate.getRegisteredPubStakeKeys();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-95] getUnregisteredPubStakeKeys(): Promise<PubStakeKey[]>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-0095#apicip95getunregisteredpubstakekeys-promisepubstakekey}
   */
  async getUnregisteredPubStakeKeys() {
    try {
      return await this.delegate.getUnregisteredPubStakeKeys();
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-95] signTx(tx: cbor<transaction>, partialSign: bool = false): Promise<cbor<transaction_witness_set>>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-0095#apisigntxtx-cbortransaction-partialsign-bool--false-promisecbortransaction_witness_set}
   */
  async signTx(...args) {
    try {
      return await this.delegate.signTx(..._normalizeArgs(args));
    } catch (err) {
      throw _mapError(err);
    }
  }

  /**
   * [CIP-95] signData(addr: Address | DRepID, payload: Bytes): Promise<DataSignature>
   *
   * @see {@link https://cips.cardano.org/cip/CIP-0095#apicip95signdataaddr-address--drepid-payload-bytes-promisedatasignature}
   */
  async signData(...args) {
    try {
      return await this.delegate.signData(..._normalizeArgs(args));
    } catch (err) {
      throw _mapError(err);
    }
  }
}

/**
 * Normalizes the args by replacing `null` values by `undefined`.
 *
 * CIP-30 specification makes implicit use of undefined values to detect that argument has not been passed.
 * However from the dart side the wasm is not able to represent undefined values and is translating them to nulls.
 * Therefore here we need to translate these nulls back into undefined values to be compatible with the specification.
 * 
 * See: https://api.flutter.dev/flutter/dart-js_interop/NullableUndefineableJSAnyExtension.html
 */
function _normalizeArgs(args) {
  return args.map((arg) => (arg === null ? undefined : arg));
}

/**
 * Maps an error to a format understandable by the dart layer.
 *
 * @param {any} err - The error description.
 * @returns A json representing the mapped error.
 */
function _mapError(err) {
  const infoCodeError = CardanoWalletInfoCodeError.tryFromObject(err);
  if (infoCodeError) {
    return infoCodeError.stringify();
  }

  const paginateError = CardanoWalletPaginateError.tryFromObject(err);
  if (paginateError) {
    return paginateError.stringify();
  }

  return JSON.stringify(err);
}
