import { defineConfig, devices } from '@playwright/test';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(__dirname, '.env') });

export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 1,
  workers: process.env.CI ? 1 : 1,
  use: {
    baseURL: process.env.APP_URL || 'http://localhost:8000',
    screenshot: 'only-on-failure',
    trace: 'on',
    video: 'on',

  },
  reporter: [
    ['html', { open: 'never', outputFolder: '/results' }],
    ['junit', { outputFile: '/results/cardano-wallet.junit-report.xml' }]],
  timeout: 120 * 1000,
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ]
});
