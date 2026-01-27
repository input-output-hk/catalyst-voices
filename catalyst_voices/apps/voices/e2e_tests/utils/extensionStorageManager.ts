/**
 * Manages browser extensions stored in S3 for e2e tests.
 *
 * This module provides:
 * - Download extensions from S3 (for CI/test runs)
 * - Upload extensions to S3 (for updating pinned versions)
 * - Manifest management to track extension versions
 */

import fs, { promises as fsPromises } from "fs";
import path from "path";
import crypto from "crypto";
import { pipeline } from "stream/promises";
import { Readable } from "stream";
import unzip from "@tomjs/unzip-crx";
import { getStorageConfig, hasAwsCredentials } from "../config/extension-storage-config";
import { BrowserExtensionName } from "../models/browserExtensionModel";
import { getBrowserExtension, browserExtensions } from "../data/browserExtensionConfigs";

interface ExtensionManifestEntry {
  name: string;
  version: string | null;
  uploadedAt: string | null;
  sha256: string | null;
}

interface ExtensionManifest {
  description: string;
  lastUpdated: string | null;
  extensions: Record<string, ExtensionManifestEntry>;
}

export class ExtensionStorageManager {
  private manifestPath: string;
  private extensionsDir: string;
  private config = getStorageConfig();

  constructor() {
    this.manifestPath = path.resolve(__dirname, "..", "config", "extension-manifest.json");
    this.extensionsDir = path.resolve(__dirname, "..", "extensions");
  }

  /**
   * Download an extension from S3.
   * Returns the path to the extracted extension, or null if not available in S3.
   */
  async downloadFromS3(extensionName: BrowserExtensionName): Promise<string | null> {
    const extensionId = getBrowserExtension(extensionName).Id;
    const manifest = await this.loadManifest();
    const entry = manifest.extensions[extensionId];

    // Check if extension is available in S3 (has been uploaded)
    if (!entry?.version || !entry?.sha256) {
      console.log(`Extension ${extensionName} not found in S3 manifest`);
      return null;
    }

    const extractPath = path.join(this.extensionsDir, extensionId);

    // Check if already downloaded and valid
    if (fs.existsSync(extractPath)) {
      const isValid = await this.validateExtraction(extractPath, entry.sha256);
      if (isValid) {
        console.log(`Extension ${extensionName} already exists and is valid`);
        return extractPath;
      }
      // Invalid - remove and re-download
      await fsPromises.rm(extractPath, { recursive: true, force: true });
    }

    // Download from S3
    const crxUrl = `${this.config.publicBaseUrl}/${extensionId}.crx`;
    const crxPath = path.join(this.extensionsDir, `${extensionId}.crx`);

    try {
      console.log(`Downloading ${extensionName} from S3: ${crxUrl}`);
      await fsPromises.mkdir(this.extensionsDir, { recursive: true });

      const res = await fetch(crxUrl);
      if (!res.ok) {
        console.log(`Failed to download from S3: ${res.status} ${res.statusText}`);
        return null;
      }

      const fileStream = fs.createWriteStream(crxPath);
      await pipeline(Readable.fromWeb(res.body as any), fileStream);

      // Verify checksum
      const downloadedHash = await this.computeFileHash(crxPath);
      if (downloadedHash !== entry.sha256) {
        console.error(`Checksum mismatch for ${extensionName}. Expected: ${entry.sha256}, Got: ${downloadedHash}`);
        await fsPromises.unlink(crxPath);
        return null;
      }

      // Extract the extension
      await fsPromises.mkdir(extractPath, { recursive: true });
      await unzip(crxPath, extractPath);

      console.log(`Successfully downloaded and extracted ${extensionName} from S3`);
      return extractPath;
    } catch (error) {
      console.error(`Error downloading ${extensionName} from S3:`, error);
      return null;
    }
  }

  /**
   * Upload an extension to S3.
   * Requires AWS credentials to be configured.
   */
  async uploadToS3(extensionName: BrowserExtensionName, crxPath: string): Promise<void> {
    if (!hasAwsCredentials()) {
      throw new Error(
        "AWS credentials not configured. Set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables."
      );
    }

    const extensionId = getBrowserExtension(extensionName).Id;

    // Compute hash
    const sha256 = await this.computeFileHash(crxPath);

    // Get version from the extension manifest.json inside the extracted folder
    const extractPath = path.join(this.extensionsDir, extensionId);
    let version = "unknown";
    const manifestJsonPath = path.join(extractPath, "manifest.json");
    if (fs.existsSync(manifestJsonPath)) {
      try {
        const manifestJson = JSON.parse(await fsPromises.readFile(manifestJsonPath, "utf-8"));
        version = manifestJson.version || "unknown";
      } catch {
        console.warn(`Could not read version from ${manifestJsonPath}`);
      }
    }

    // Upload to S3 using AWS SDK
    const { S3Client, PutObjectCommand } = await import("@aws-sdk/client-s3");
    const s3Client = new S3Client({ region: this.config.region });

    const fileContent = await fsPromises.readFile(crxPath);
    const key = `${this.config.prefix}/${extensionId}.crx`;

    console.log(`Uploading ${extensionName} v${version} to s3://${this.config.bucket}/${key}`);

    await s3Client.send(
      new PutObjectCommand({
        Bucket: this.config.bucket,
        Key: key,
        Body: fileContent,
        ContentType: "application/x-chrome-extension",
        Metadata: {
          "extension-name": extensionName,
          "extension-version": version,
          "sha256": sha256,
        },
      })
    );

    // Update manifest
    const manifest = await this.loadManifest();
    manifest.extensions[extensionId] = {
      name: extensionName,
      version,
      uploadedAt: new Date().toISOString(),
      sha256,
    };
    manifest.lastUpdated = new Date().toISOString();

    await this.saveManifest(manifest);
    console.log(`Successfully uploaded ${extensionName} v${version} to S3`);
  }

  /**
   * Upload all extensions to S3.
   * Downloads latest from Chrome Store first, then uploads to S3.
   */
  async uploadAllExtensions(): Promise<void> {
    // Import the original downloader for Chrome Store downloads
    const { ExtensionDownloader } = await import("./extensionDownloader");
    const chromeDownloader = new ExtensionDownloader();

    for (const ext of browserExtensions) {
      try {
        console.log(`\n=== Processing ${ext.Name} ===`);

        // Force download from Chrome Store (delete existing first)
        const extensionPath = path.join(this.extensionsDir, ext.Id);
        const crxPath = path.join(this.extensionsDir, `${ext.Id}.crx`);

        if (fs.existsSync(extensionPath)) {
          await fsPromises.rm(extensionPath, { recursive: true, force: true });
        }
        if (fs.existsSync(crxPath)) {
          await fsPromises.unlink(crxPath);
        }

        // Download fresh from Chrome Store
        await chromeDownloader.getExtension(ext.Name);

        // Upload to S3
        if (fs.existsSync(crxPath)) {
          await this.uploadToS3(ext.Name, crxPath);
        } else {
          console.warn(`CRX file not found for ${ext.Name}, skipping upload`);
        }
      } catch (error) {
        console.error(`Failed to process ${ext.Name}:`, error);
      }
    }

    console.log("\n=== Upload complete ===");
  }

  private async loadManifest(): Promise<ExtensionManifest> {
    try {
      const content = await fsPromises.readFile(this.manifestPath, "utf-8");
      return JSON.parse(content);
    } catch {
      // Return empty manifest if file doesn't exist
      return {
        description: "Extension manifest",
        lastUpdated: null,
        extensions: {},
      };
    }
  }

  private async saveManifest(manifest: ExtensionManifest): Promise<void> {
    await fsPromises.writeFile(this.manifestPath, JSON.stringify(manifest, null, 2) + "\n");
  }

  private async computeFileHash(filePath: string): Promise<string> {
    const hash = crypto.createHash("sha256");
    const stream = fs.createReadStream(filePath);

    return new Promise((resolve, reject) => {
      stream.on("data", (data) => hash.update(data));
      stream.on("end", () => resolve(hash.digest("hex")));
      stream.on("error", reject);
    });
  }

  private async validateExtraction(extractPath: string, expectedHash: string): Promise<boolean> {
    // For now, just check if manifest.json exists
    // A more robust validation could re-hash the CRX or check file counts
    const manifestPath = path.join(extractPath, "manifest.json");
    return fs.existsSync(manifestPath);
  }
}
