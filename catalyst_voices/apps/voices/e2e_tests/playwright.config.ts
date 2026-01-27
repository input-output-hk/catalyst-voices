import { defineConfig, devices } from "@playwright/test";
import { configDotenv } from "dotenv";

configDotenv();

export default defineConfig({
  testDir: "./tests",
  forbidOnly: !!process.env.CI,
  retries: 2,
  workers: process.env.CI ? 1 : undefined,
  reporter: [["junit", { outputFile: "/results/voices.junit-report.xml" }], ["html"]],
  timeout: 300 * 1000,
  use: {
    baseURL: `https://app.${process.env.ENVIRONMENT}.projectcatalyst.io/`,
    trace: "on-first-retry",
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: "local-run",
      use: {
        ...devices["Desktop Chrome"],
        testIdAttribute: "flt-semantics-identifier",
        baseURL: `http://localhost:80`,
      },
    },
  ],
});
