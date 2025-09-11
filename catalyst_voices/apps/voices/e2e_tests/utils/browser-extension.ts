import { Page, BrowserContext, chromium } from "@playwright/test";
import { spawn, ChildProcess } from "child_process";
import fs from "fs";
import path from "path";
import { WalletConfigModel } from "../models/walletConfigModel";
import { getBrowserExtension } from "../data/browserExtensionConfigs";
import { BrowserExtensionName } from "../models/browserExtensionModel";
import { ExtensionDownloader } from "./extensionDownloader";

export const getDynamicUrlInChrome = async (
  extensionTab: Page,
  wallet: WalletConfigModel
): Promise<string> => {
  await extensionTab.goto("chrome://extensions/");
  const extensionId = await extensionTab
    .locator("extensions-item")
    .getAttribute("id");
  return `chrome-extension://${extensionId}${
    getBrowserExtension(wallet.extension.Name).HomeUrl
  }`;
};

export const connectToBrowser = async (
  chromePath: string,
  extensionName?: BrowserExtensionName
): Promise<BrowserContext> => {
  let chromeProcess: ChildProcess;
  if (extensionName) {
    chromeProcess = await launchChrome(chromePath, extensionName);
  } else {
    chromeProcess = await launchChrome(chromePath);
  }

  await new Promise((resolve) => setTimeout(resolve, 3000));

  const browser = await chromium.connectOverCDP("http://localhost:9222");
  const browserContext = browser.contexts()[0];

  // Store the process reference for cleanup
  (browserContext as any).chromeProcess = chromeProcess;

  return browserContext;
};

export const cleanupChromeProfile = async (
  profilePath: string
): Promise<void> => {
  if (fs.existsSync(profilePath)) {
    try {
      await fs.promises.rm(profilePath, { recursive: true, force: true });
      console.log(`Cleaned up Chrome profile: ${profilePath}`);
    } catch (error) {
      console.error(`Failed to cleanup Chrome profile: ${error}`);
    }
  }
};

const launchChrome = async (
  chromePath: string,
  extensionName?: BrowserExtensionName
): Promise<ChildProcess> => {
  // Create a unique profile directory for this test run in the browser-profiles folder
  const profilesDir = path.join(process.cwd(), "browser-profiles");

  // Ensure the browser-profiles directory exists
  if (!fs.existsSync(profilesDir)) {
    fs.mkdirSync(profilesDir, { recursive: true });
  }

  const profilePath = path.join(
    profilesDir,
    `chrome-profile-${Date.now()}-${Math.random().toString(36).substring(7)}`
  );

  // Clean up any existing profile at this path (shouldn't exist, but just in case)
  await cleanupChromeProfile(profilePath);

  const chromeArgs = [
    "--remote-debugging-port=9222",
    "--no-first-run",
    "--no-default-browser-check",
    `--user-data-dir=${profilePath}`,
  ];

  if (extensionName) {
    const extensionPath = await new ExtensionDownloader().getExtension(
      extensionName
    );
    chromeArgs.push(`--disable-extensions-except=${extensionPath}`);
    chromeArgs.push(`--load-extension=${extensionPath}`);
  }

  const chromeProcess = spawn(chromePath, chromeArgs, {
    detached: false,
    stdio: "pipe",
  });

  (chromeProcess as any).profilePath = profilePath;

  chromeProcess.stdout?.on("data", (data) => {
    console.log(`Chrome stdout: ${data}`);
  });

  chromeProcess.stderr?.on("data", (data) => {
    console.log(`Chrome stderr: ${data}`);
  });

  chromeProcess.on("error", (error) => {
    console.error(`Chrome process error: ${error}`);
  });

  return chromeProcess;
};

export const closeBrowserWithExtension = async (
  browserContext: BrowserContext
) => {
  const chromeProcess = (browserContext as any).chromeProcess as ChildProcess;
  const profilePath = chromeProcess ? (chromeProcess as any).profilePath : null;

  if (chromeProcess && !chromeProcess.killed) {
    chromeProcess.kill("SIGTERM");

    // Wait for the process to terminate gracefully
    await new Promise<void>((resolve) => {
      const timeout = setTimeout(() => {
        if (!chromeProcess.killed) {
          chromeProcess.kill("SIGKILL");
        }
        resolve();
      }, 5000);

      chromeProcess.on("exit", () => {
        clearTimeout(timeout);
        resolve();
      });
    });
  }

  await browserContext.close();

  // Clean up the Chrome profile directory
  if (profilePath) {
    await cleanupChromeProfile(profilePath);
  }
};
