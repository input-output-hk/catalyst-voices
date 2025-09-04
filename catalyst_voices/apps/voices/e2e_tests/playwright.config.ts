import { defineConfig, devices } from "@playwright/test";
import { configDotenv } from "dotenv";

configDotenv();

export default defineConfig({
  testDir: "./tests",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: "html",
  timeout: 120 * 1000,
  use: {
    baseURL: `https://app.${process.env.ENVIRONMENT}.projectcatalyst.io/`,
    trace: "on-first-retry",
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: "chromium",
      use: {
        ...devices["Desktop Chrome"],
        testIdAttribute: "flt-semantics-identifier",
      },
    },
  ],
});
