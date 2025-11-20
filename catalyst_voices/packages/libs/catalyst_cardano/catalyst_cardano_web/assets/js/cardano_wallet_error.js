/**
 * Matches the following errors:
 * 
 * - https://cips.cardano.org/cip/CIP-30#apierror
 * - https://cips.cardano.org/cip/CIP-30#datasignerror
 * - https://cips.cardano.org/cip/CIP-30#txsenderror
 * - https://cips.cardano.org/cip/CIP-30#txsignerror
 */
export class CardanoWalletInfoCodeError {
  constructor(code, info) {
    this.code = code;
    this.info = info;
  }

  static tryFromObject(obj) {
    if (!obj || typeof obj.code !== "number" || typeof obj.info !== "string") {
      return null;
    }
    return new CardanoWalletInfoCodeError(obj.code, obj.info);
  }

  stringify() {
    return JSON.stringify(this);
  }
}

/**
 * Matches the following errors:
 * 
 * - https://cips.cardano.org/cip/CIP-30#paginateerror
 */
export class CardanoWalletPaginateError {
  constructor(maxSize) {
    this.maxSize = maxSize;
  }

  static tryFromObject(obj) {
    if (!obj || typeof obj.maxSize !== "number") {
      return null;
    }
    return new CardanoWalletPaginateError(obj.maxSize);
  }

  stringify() {
    return JSON.stringify(this);
  }
}
