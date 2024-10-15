import { defineConfig, devices } from '@playwright/test';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(__dirname, '.env') });
// if (process.env.APP_URL == undefined){
//   throw new Error("APP_URL env variable undefined");
// }

export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 1 : 1,
  use: {
    baseURL: process.env.APP_URL,
    screenshot: 'only-on-failure',
    trace: 'on-first-retry',

  },
  reporter: [['junit', { outputFile: '/results/cardano-wallet.junit-report.xml' }]],
  timeout: 60 * 1000,
  projects: [
    // {
    //   name: 'setup',
    //   testMatch: /global-setup\.ts/,
    // },
    // {
    //   name: 'chromium',
    //   use: { ...devices['Desktop Chrome'] },
    //   dependencies: ['setup']
    // },
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    },
  ]
});
