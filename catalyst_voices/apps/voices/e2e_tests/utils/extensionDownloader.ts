/* cspell:disable */
import unzip from "@tomjs/unzip-crx";
import fs, { promises as fsPromises } from "fs";
import os from "os";
import path from "path";
import { pipeline } from "stream/promises";
import { Readable } from "stream";
import { BrowserExtensionName } from "../models/browserExtensionModel";
import { getBrowserExtension } from "../data/browserExtensionConfigs";
import { ExtensionStorageManager } from "./extensionStorageManager";

interface PlatformInfo {
  os: string;
  arch: string;
  nacl_arch: string;
}

/**
 * Extension download source strategy.
 * - 's3': Download from S3 only (recommended for CI)
 * - 'chrome-store': Download from Chrome Web Store only (for updating S3)
 * - 'auto': Try S3 first, fall back to Chrome Store (default)
 */
export type ExtensionSource = "s3" | "chrome-store" | "auto";

export class ExtensionDownloader {
  private extensionsDir: string;
  private source: ExtensionSource;

  /**
   * Creates a new ExtensionDownloader.
   * @param source Download source strategy. If not provided, reads from
   *               EXTENSION_SOURCE environment variable, defaults to "auto".
   */
  constructor(source?: ExtensionSource) {
    this.extensionsDir = path.resolve(__dirname, "..", "extensions");
    this.source = source ?? (process.env.EXTENSION_SOURCE as ExtensionSource) ?? "auto";
  }

  /**
   * Downloads and extracts the specified browser extension.
   * @param extensionName The name of the extension to download.
   * @returns The path to the extracted extension.
   *
   * @example
   * const extensionPath = await new ExtensionDownloader().getExtension(BrowserExtensionName.Lace);
   * console.log(extensionPath);
   * Output: /path/to/extension
   *
   */
  public async getExtension(extensionName: BrowserExtensionName): Promise<string> {
    const extensionId = getBrowserExtension(extensionName).Id;
    const extensionPath = path.join(this.extensionsDir, extensionId);

    // Check if the extension has already been downloaded
    if (fs.existsSync(extensionPath)) {
      console.log(`Extension already exists at: ${extensionPath}`);
      return extensionPath;
    }

    // Try S3 first if configured
    if (this.source === "s3" || this.source === "auto") {
      const s3Path = await this.tryDownloadFromS3(extensionName);
      if (s3Path) {
        return s3Path;
      }

      if (this.source === "s3") {
        throw new Error(
          `Extension ${extensionName} not available in S3. Run 'npm run update-remote-extensions' to upload extensions.`
        );
      }
      console.log(`S3 download failed for ${extensionName}, falling back to Chrome Store`);
    }

    // Download from Chrome Store
    return this.downloadFromChromeStore(extensionName);
  }

  /**
   * Downloads extension directly from Chrome Web Store.
   * Use this when updating extensions in S3.
   */
  public async downloadFromChromeStore(extensionName: BrowserExtensionName): Promise<string> {
    const extensionId = getBrowserExtension(extensionName).Id;
    const extensionPath = path.join(this.extensionsDir, extensionId);

    // Download the extension
    if (extensionName === BrowserExtensionName.Nufi) {
      const zipPath = await this.downloadNufiExtension();
      await this.extractExtension(zipPath, extensionPath);
    } else {
      const crxPath = await this.downloadExtension(extensionName);
      await this.extractExtension(crxPath, extensionPath);
    }

    return extensionPath;
  }

  private async tryDownloadFromS3(extensionName: BrowserExtensionName): Promise<string | null> {
    try {
      const storageManager = new ExtensionStorageManager();
      return await storageManager.downloadFromS3(extensionName);
    } catch (error) {
      console.log(`S3 download not available: ${error}`);
      return null;
    }
  }

  private async downloadNufiExtension(): Promise<string> {
    const url = "https://assets.nu.fi/extension/testnet/nufi-cwe-testnet-latest.zip";
    const filePath = path.join(this.extensionsDir, "nufi-cwe-testnet-latest.zip");

    // Ensure the download directory exists
    await fsPromises.mkdir(this.extensionsDir, { recursive: true });

    // Fetch the extension
    const res = await fetch(url);
    if (!res.ok) {
      throw new Error(`Failed to download extension: ${res.statusText}`);
    }

    // Stream the response directly to a file
    const fileStream = fs.createWriteStream(filePath);
    await pipeline(Readable.fromWeb(res.body as any), fileStream);

    console.log(`Extension has been downloaded to: ${filePath}`);
    return filePath;
  }

  private async extractExtension(extensionPath: string, extractPath: string): Promise<void> {
    // Ensure the extraction directory exists
    await fsPromises.mkdir(extractPath, { recursive: true });

    // Use unzip-crx to extract the CRX file
    try {
      await unzip(extensionPath, extractPath);
      console.log(`Extension has been extracted to: ${extractPath}`);
    } catch (error) {
      console.error(`Failed to extract extension: ${(error as Error).message}`);
      throw error;
    }
  }

  private async downloadExtension(extensionName: BrowserExtensionName): Promise<string> {
    const extensionId = getBrowserExtension(extensionName).Id;
    const url = this.getCrxUrl(extensionName);

    // Ensure the download directory exists
    await fsPromises.mkdir(this.extensionsDir, { recursive: true });

    const filePath = path.join(this.extensionsDir, `${extensionId}.crx`);

    // Fetch the extension
    const res = await fetch(url);
    if (!res.ok) {
      throw new Error(`Failed to download extension: ${res.statusText}`);
    }

    // Stream the response directly to a file
    const fileStream = fs.createWriteStream(filePath);
    await pipeline(Readable.fromWeb(res.body as any), fileStream);

    console.log(`Extension has been downloaded to: ${filePath}`);
    return filePath;
  }

  private getCrxUrl(extensionName: BrowserExtensionName): string {
    const extensionId = getBrowserExtension(extensionName).Id;

    const platformInfo = this.getPlatformInfo();
    const productId = "chromecrx";
    const productChannel = "unknown";
    let productVersion = "9999.0.9999.0";

    let url = "https://clients2.google.com/service/update2/crx?response=redirect";
    url += "&os=" + platformInfo.os;
    url += "&arch=" + platformInfo.arch;
    url += "&os_arch=" + platformInfo.os_arch;
    url += "&nacl_arch=" + platformInfo.nacl_arch;
    url += "&prod=" + productId;
    url += "&prodchannel=" + productChannel;
    url += "&prodversion=" + productVersion;
    url += "&lang=en";
    url += "&acceptformat=crx3";
    url += "&x=id%3D" + extensionId + "%26installsource%3Dondemand%26uc";
    return url;
  }

  private getPlatformInfo(): PlatformInfo & { os_arch: string } {
    // Determine OS
    let osType = os.type().toLowerCase();
    let osName = "win";
    if (osType.includes("darwin")) {
      osName = "mac";
    } else if (osType.includes("linux")) {
      osName = "linux";
    } else if (osType.includes("win")) {
      osName = "win";
    } else if (osType.includes("cros")) {
      osName = "cros";
    }

    // Determine architecture
    const arch = os.arch(); // Returns 'x64', 'arm', 'ia32', etc.
    const is64Bit = arch === "x64" || arch === "arm64";
    const archName = is64Bit ? "x64" : "x86";
    const os_arch = is64Bit ? "x86_64" : "x86";
    const naclArch = is64Bit ? "x86-64" : "x86-32";

    return { os: osName, arch: archName, os_arch, nacl_arch: naclArch };
  }
}
