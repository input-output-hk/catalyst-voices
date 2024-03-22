export default function cleanHex(hexString: string): string {
  // Remove spaces and convert to uppercase
  const cleanedHexString = hexString.replace(/\s/gm, "").toUpperCase();

  // Check if the cleaned string is a valid hex string
  if (!/^[0-9a-fA-F]*$/.test(cleanedHexString)) {
    throw new Error("Invalid hex string");
  }

  return cleanedHexString;
}
