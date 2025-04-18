import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./tests",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: 3,
  workers: 1,
  use: {
    ignoreHTTPSErrors: true,
    screenshot: "only-on-failure",
    trace: "on",
    video: "on",
  },

  reporter: "html",
  timeout: 120 * 1000,
  projects: [
    {
      name: "chrome",
      use: {
        ...devices["Desktop Chrome"],
        launchOptions: {
          channel: "chrome",
        },
      },
    },
  ],
});
