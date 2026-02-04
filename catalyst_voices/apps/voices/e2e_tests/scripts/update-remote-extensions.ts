#!/usr/bin/env npx ts-node

/**
 * CLI script to update wallet extensions in S3.
 *
 * Usage:
 *   npm run update-remote-extensions           # Update all extensions
 *   npm run update-remote-extensions -- --dry-run   # Preview what would be updated
 *   npm run update-remote-extensions -- --extension Lace   # Update specific extension
 *
 * Environment variables required:
 *   - AWS_ACCESS_KEY_ID
 *   - AWS_SECRET_ACCESS_KEY
 *   - EXTENSION_S3_BUCKET (optional, defaults to 'catalyst-e2e-extensions')
 *   - EXTENSION_S3_REGION (optional, defaults to 'eu-central-1')
 */

import path from "path";
import dotenv from "dotenv";

// Load environment variables
dotenv.config({ path: path.join(__dirname, "..", ".env") });

import { ExtensionStorageManager } from "../utils/extensionStorageManager";
import { ExtensionDownloader } from "../utils/extensionDownloader";
import { browserExtensions } from "../data/browserExtensionConfigs";
import { BrowserExtensionName } from "../models/browserExtensionModel";
import { hasAwsCredentials, getStorageConfig } from "../config/extension-storage-config";
import fs from "fs";

interface CliOptions {
  dryRun: boolean;
  extension?: BrowserExtensionName;
  help: boolean;
}

function parseArgs(): CliOptions {
  const args = process.argv.slice(2);
  const options: CliOptions = {
    dryRun: false,
    extension: undefined,
    help: false,
  };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === "--dry-run" || arg === "-n") {
      options.dryRun = true;
    } else if (arg === "--extension" || arg === "-e") {
      const extName = args[++i] as BrowserExtensionName;
      if (!Object.values(BrowserExtensionName).includes(extName)) {
        console.error(`Unknown extension: ${extName}`);
        console.error(`Valid extensions: ${Object.values(BrowserExtensionName).join(", ")}`);
        process.exit(1);
      }
      options.extension = extName;
    } else if (arg === "--help" || arg === "-h") {
      options.help = true;
    }
  }

  return options;
}

function printHelp(): void {
  console.log(`
Usage: npm run update-remote-extensions [options]

Updates wallet browser extensions in S3 storage.

Options:
  -n, --dry-run           Preview what would be updated without making changes
  -e, --extension <name>  Update only the specified extension
  -h, --help              Show this help message

Examples:
  npm run update-remote-extensions
    Download latest extensions from Chrome Store and upload to S3

  npm run update-remote-extensions -- --dry-run
    Preview what would be uploaded without making changes

  npm run update-remote-extensions -- --extension Lace
    Update only the Lace extension

Available extensions:
  ${Object.values(BrowserExtensionName).filter((n) => n !== BrowserExtensionName.NoExtension).join(", ")}

Environment variables:
  AWS_ACCESS_KEY_ID       Required for S3 upload
  AWS_SECRET_ACCESS_KEY   Required for S3 upload
  EXTENSION_S3_BUCKET     S3 bucket name (default: catalyst-e2e-extensions)
  EXTENSION_S3_REGION     S3 region (default: eu-central-1)
`);
}

async function getExtensionVersion(extensionPath: string): Promise<string> {
  const manifestPath = path.join(extensionPath, "manifest.json");
  if (fs.existsSync(manifestPath)) {
    try {
      const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf-8"));
      return manifest.version || "unknown";
    } catch {
      return "unknown";
    }
  }
  return "unknown";
}

async function main(): Promise<void> {
  const options = parseArgs();

  if (options.help) {
    printHelp();
    process.exit(0);
  }

  console.log("========================================");
  console.log("  Wallet Extensions S3 Updater");
  console.log("========================================\n");

  // Check AWS credentials
  if (!options.dryRun && !hasAwsCredentials()) {
    console.error("❌ AWS credentials not configured.");
    console.error("   Set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables.");
    console.error("   Or use --dry-run to preview without uploading.\n");
    process.exit(1);
  }

  const config = getStorageConfig();
  console.log(`S3 Bucket: ${config.bucket}`);
  console.log(`S3 Region: ${config.region}`);
  console.log(`S3 Prefix: ${config.prefix}`);
  console.log(`Dry Run: ${options.dryRun ? "Yes" : "No"}\n`);

  const downloader = new ExtensionDownloader("chrome-store");
  const storageManager = new ExtensionStorageManager();

  // Filter extensions if specific one requested
  const extensionsToUpdate = options.extension
    ? browserExtensions.filter((ext) => ext.Name === options.extension)
    : browserExtensions.filter((ext) => ext.Name !== BrowserExtensionName.NoExtension);

  console.log(`Extensions to update: ${extensionsToUpdate.map((e) => e.Name).join(", ")}\n`);

  for (const ext of extensionsToUpdate) {
    console.log(`\n📦 Processing ${ext.Name}...`);
    console.log(`   Extension ID: ${ext.Id}`);

    try {
      // Clear existing extension to force fresh download
      const extensionsDir = path.resolve(__dirname, "..", "extensions");
      const extensionPath = path.join(extensionsDir, ext.Id);
      const crxPath = path.join(extensionsDir, `${ext.Id}.crx`);

      if (fs.existsSync(extensionPath)) {
        console.log(`   Removing existing extraction...`);
        fs.rmSync(extensionPath, { recursive: true, force: true });
      }
      if (fs.existsSync(crxPath)) {
        console.log(`   Removing existing CRX...`);
        fs.unlinkSync(crxPath);
      }

      // Download from Chrome Store
      console.log(`   Downloading from Chrome Store...`);
      const downloadedPath = await downloader.downloadFromChromeStore(ext.Name);

      // Get version info
      const version = await getExtensionVersion(downloadedPath);
      console.log(`   Version: ${version}`);

      if (options.dryRun) {
        console.log(`   ⏭️  [DRY RUN] Would upload to S3`);
      } else {
      // Upload to S3
      console.log(`   Uploading to S3...`);
      // Nufi uses a .zip file, not .crx
      const uploadPath = fs.existsSync(crxPath) 
        ? crxPath 
        : path.join(extensionsDir, "nufi-cwe-testnet-latest.zip");
      await storageManager.uploadToS3(ext.Name, uploadPath);
        console.log(`   ✅ Successfully uploaded ${ext.Name} v${version}`);
      }
    } catch (error) {
      console.error(`   ❌ Failed to process ${ext.Name}:`, error);
    }
  }

  console.log("\n========================================");
  console.log("  Complete!");
  console.log("========================================\n");

  if (!options.dryRun) {
    console.log("📝 Remember to commit the updated extension-manifest.json file!");
    console.log("   This tracks which extension versions are in S3.\n");
  }
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
