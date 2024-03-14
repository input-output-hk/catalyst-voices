import { tokensToDiagnostic } from "cborg/lib/diagnostic";
import hex2bin from "./hex2bin";

export default function hex2diag(hexString: string): string {
  try {
    const result: string[] = [];
    for (const line of tokensToDiagnostic(hex2bin(hexString), 48)) {
      result.push(line);
    }

    return result.join("\n").replace(/#\s+/gm, "# ");
  } catch (err: unknown) {
    return String(err);
  }
}
