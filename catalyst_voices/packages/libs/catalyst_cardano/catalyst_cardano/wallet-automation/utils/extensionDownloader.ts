/* cspell:disable */
import unzip from "@tomjs/unzip-crx";
import fs, { promises as fsPromises } from "fs";
import nodeFetch from "node-fetch";
import * as os from "os";
import path from "path";
import { pipeline } from "stream/promises";
import { BrowserExtensionName, getBrowserExtension } from "./extensions";

interface PlatformInfo {
  os: string;
  arch: string;
  nacl_arch: string;
}

export class ExtensionDownloader {
  private extensionsDir: string;

  constructor() {
    this.extensionsDir = path.resolve(__dirname, "..", "extensions");
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
  public async getExtension(
    extensionName: BrowserExtensionName
  ): Promise<string> {
    const extensionId = getBrowserExtension(extensionName).Id;
    const extensionPath = path.join(this.extensionsDir, extensionId);

    // Check if the extension has already been downloaded
    if (fs.existsSync(extensionPath)) {
      console.log(`Extension already exists at: ${extensionPath}`);
      return extensionPath;
    }

    // Download the extension
    if (extensionName === BrowserExtensionName.Nufi) {
      const zipPath = await this.downloadNufiExtension();
      await this.extractExtension(zipPath, extensionPath);
    } else {
      const crxPath = await this.downloadExtension(extensionName);
      await this.extractExtension(crxPath, extensionPath);
    }
    // Extract the extension

    return extensionPath;
  }

  private async downloadNufiExtension(): Promise<string> {
    const url =
      "https://assets.nu.fi/extension/testnet/nufi-cwe-testnet-latest.zip";
    const filePath = path.join(
      this.extensionsDir,
      "nufi-cwe-testnet-latest.zip"
    );

    // Ensure the download directory exists
    await fsPromises.mkdir(this.extensionsDir, { recursive: true });

    // Fetch the extension
    const res = await nodeFetch(url);
    if (!res.ok) {
      throw new Error(`Failed to download extension: ${res.statusText}`);
    }

    // Stream the response directly to a file
    const fileStream = fs.createWriteStream(filePath);
    await pipeline(res.body, fileStream);

    console.log(`Extension has been downloaded to: ${filePath}`);
    return filePath;
  }

  private async extractExtension(
    extensionPath: string,
    extractPath: string
  ): Promise<void> {
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

  private async downloadExtension(
    extensionName: BrowserExtensionName
  ): Promise<string> {
    const extensionId = getBrowserExtension(extensionName).Id;
    const url = this.getCrxUrl(extensionName);

    // Ensure the download directory exists
    await fsPromises.mkdir(this.extensionsDir, { recursive: true });

    const filePath = path.join(this.extensionsDir, `${extensionId}.crx`);

    // Fetch the extension
    const res = await nodeFetch(url);
    if (!res.ok) {
      throw new Error(`Failed to download extension: ${res.statusText}`);
    }

    // Stream the response directly to a file
    const fileStream = fs.createWriteStream(filePath);
    await pipeline(res.body, fileStream);

    console.log(`Extension has been downloaded to: ${filePath}`);
    return filePath;
  }

  private getCrxUrl(extensionName: BrowserExtensionName): string {
    const extensionId = getBrowserExtension(extensionName).Id;

    const platformInfo = this.getPlatformInfo();
    const productId = "chromecrx";
    const productChannel = "unknown";
    let productVersion = "9999.0.9999.0";

    let url =
      "https://clients2.google.com/service/update2/crx?response=redirect";
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
