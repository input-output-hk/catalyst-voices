import { test as setup } from '@playwright/test';
import * as fs from 'fs';
import * as path from 'path';

setup('Load wallet keys', async ({ }) => {
const txtContent = fs.readFileSync(path.resolve(__dirname,'keys.txt'), 'utf8');
txtContent.split('\n').forEach(line => {
    const [key, value] = line.split('=');
    if (key && value) {
      process.env[key.trim()] = value.trim();
    }
  });
});