export default function bin2hex(bin: Uint8Array, sep = " "): string {
  return Array.from(bin, (byte) => byte.toString(16).padStart(2, "0")).join(sep);
}
