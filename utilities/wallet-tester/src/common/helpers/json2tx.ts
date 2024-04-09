import { Transaction } from "@emurgo/cardano-serialization-lib-asmjs";

import bin2hex from "./bin2hex";

export default function json2tx(json: string): string {
  const tx = Transaction.from_json(json);

  return bin2hex(tx.to_bytes());
}
