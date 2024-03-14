import { fromDiag } from "cborg/lib/diagnostic";

export default function diag2hex(diagString: string): string {
  try {
    const result = fromDiag(diagString);

    return Array.from(result, byte => {
      return ("0" + byte.toString(16)).slice(-2);
    }).join(" ");
  } catch (err: unknown) {
    return String(err);
  }
}
