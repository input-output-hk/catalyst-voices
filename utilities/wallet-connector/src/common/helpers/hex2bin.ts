export default function hex2bin(hexString: string): Uint8Array {
  // Remove spaces and convert to uppercase
  const cleanedHexString = hexString.replace(/\s/g, '').toUpperCase();

  // Check if the cleaned string is a valid hex string
  if (!/^[0-9a-fA-F]*$/.test(cleanedHexString)) {
    throw new Error('Invalid hex string');
  }

  // Convert the hex string to a Uint8Array
  const uint8Array = Array.from(cleanedHexString.match(/.{1,2}/g) || []).map((byte) =>
    parseInt(byte, 16)
  );

  return new Uint8Array(uint8Array);
}