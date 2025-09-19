import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./tests",
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: "html",
  use: {
    baseURL: "http://localhost:3030",
    trace: "on-first-retry",
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
  ],

  webServer: {
    command:
      "flutter run -d web-server --web-port=3030 --web-hostname=localhost --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp ./lib/configs/main_qa.dart",
    url: "http://localhost:3030",
    timeout: 120 * 1000,
    reuseExistingServer: false,
  },
});
