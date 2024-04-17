import { Transaction } from "@emurgo/cardano-serialization-lib-asmjs";

import cleanHex from "./cleanHex";

export default function tx2json(hex: string): string {
  const tx = Transaction.from_hex(cleanHex(hex));

  return JSON.stringify(hex ? tx.to_js_value() : undefined, null, 2);
}
