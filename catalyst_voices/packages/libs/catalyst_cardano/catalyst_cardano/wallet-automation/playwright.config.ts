import { defineConfig, devices } from "@playwright/test";
import dotenv from "dotenv";
import path from "path";

dotenv.config({ path: path.resolve(__dirname, ".env") });

export default defineConfig({
  testDir: "./tests",
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: 3,
  workers: 1,
  use: {
    baseURL: process.env.APP_URL || "http://localhost:8000",
    ignoreHTTPSErrors: true,
    screenshot: "only-on-failure",
  },
  reporter: [
    ["junit", { outputFile: "/results/cardano-wallet.junit-report.xml" }],
  ],
  timeout: 60 * 1000,
  projects: [
    {
      name: "chrome",
      use: {
        ...devices["Desktop Chrome"],
        launchOptions: {
          executablePath: "/user/bin/google-chrome",
          args: [
            "--unsafely-treat-insecure-origin-as-secure=http://test-app:80",
          ],
        },
      },
    },
  ],
});
