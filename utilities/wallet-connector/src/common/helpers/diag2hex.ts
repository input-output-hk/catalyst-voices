import { fromDiag } from "cborg/lib/diagnostic";
import bin2hex from "./bin2hex";

export default function diag2hex(diagString: string): string {
  try {
    return bin2hex(fromDiag(diagString));
  } catch (err: unknown) {
    return String(err);
  }
}
