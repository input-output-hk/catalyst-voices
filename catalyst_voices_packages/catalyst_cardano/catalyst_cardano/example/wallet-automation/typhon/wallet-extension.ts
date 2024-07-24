const { chromium } = require('playwright');
import path from 'path';

export async function setupBrowserContext() {
    const extensionPath: string = path.resolve(__dirname, 'extensions/KFDNIEFADAANBJODLDOHAEDPHAFOFFOH_unzipped');
    const userDataDir = path.resolve(__dirname, 'usrdatadir');

    const browserContext = await chromium.launchPersistentContext(userDataDir, {
        headless: false,
        args: [
        `--disable-extensions-except=${extensionPath}`,
        `--load-extension=${extensionPath}`
        ]
    });
    const page = await browserContext.newPage();
    await page.waitForTimeout(1000); // adjust the timeout as needed

    await page.bringToFront();

    const newPage = await browserContext.newPage();

    await newPage.goto('http://localhost:8000/');

    return { browserContext, page, newPage };

}