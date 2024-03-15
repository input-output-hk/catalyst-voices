import { fromDiag } from "cborg/lib/diagnostic";

export default function diag2hex(diagString: string): string {
  try {
    const result = fromDiag(diagString);

    return Array.from(result, (byte) => byte.toString(16).padStart(2, "0")).join(" ");
  } catch (err: unknown) {
    return String(err);
  }
}
