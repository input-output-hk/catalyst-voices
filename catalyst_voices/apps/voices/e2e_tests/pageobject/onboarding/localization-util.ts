import * as fs from "fs";
import * as path from "path";

// Calculate the path to your ARB file (adjust levels as needed)
const arbFilePath = path.join(
  __dirname,
  "../../../../../packages/internal/catalyst_voices_localization/lib/l10n/intl_en.arb"
);

// Load and parse the ARB file
const rawContent = fs.readFileSync(arbFilePath, "utf8");
const intlEn: Record<string, any> = JSON.parse(rawContent);

// Export the parsed data
export default intlEn;
