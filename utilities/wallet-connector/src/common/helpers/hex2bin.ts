import cleanHex from "./cleanHex";

export default function hex2bin(hexString: string): Uint8Array {
  const cleanedHexString = cleanHex(hexString);

  const uint8Array = Array.from(cleanedHexString.match(/.{1,2}/g) || []).map((byte) =>
    parseInt(byte, 16)
  );

  return new Uint8Array(uint8Array);
}