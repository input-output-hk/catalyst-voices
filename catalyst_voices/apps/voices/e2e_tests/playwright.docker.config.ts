import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./tests",
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: 1,
  reporter: [["junit", { outputFile: "test-results/results.xml" }], ["html"]],
  timeout: 120 * 1000,
  use: {
    baseURL: process.env.APP_URL || "http://nginx-proxy:3030",
    trace: "on-first-retry",
  },
  projects: [
    {
      name: "chromium",
      use: {
        ...devices["Desktop Chrome"],
        testIdAttribute: "flt-semantics-identifier",
      },
    },
  ],
  // No webServer section - services are already running via docker-compose
});