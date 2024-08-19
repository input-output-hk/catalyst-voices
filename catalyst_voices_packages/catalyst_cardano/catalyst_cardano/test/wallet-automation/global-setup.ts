import { test } from '@playwright/test';
import * as fs from 'fs/promises';
import * as path from 'path';

const typhonId = 'KFDNIEFADAANBJODLDOHAEDPHAFOFFOH';
const laceId= 'gafhhkghbfjjkeiendhlofajokpaflmk';
const downloadPath = path.resolve(__dirname, 'extensions');
const unzip = require("unzip-crx-3");
const extId = typhonId;
test('download extensions', async ({ page }) => {
    const url = `https://clients2.google.com/service/update2/crx?response=redirect&os=win&arch=x64&os_arch=x86_64&nacl_arch=x86-64&prod=chromiumcrx&prodchannel=beta&prodversion=79.0.3945.53&lang=ru&acceptformat=crx3&x=id%3D${extId}%26installsource%3Dondemand%26uc`;
    await fs.mkdir(downloadPath, { recursive: true });

    const downloadPromise = new Promise(async (resolve) => {
        page.once('download', async (download) => {
            const originalFilePath = path.join(downloadPath, download.suggestedFilename());
            await download.saveAs(originalFilePath);
            console.log(`file has been downloaded to: ${originalFilePath}`);

            const newFilePath = path.join(downloadPath, extId);
            await fs.rename(originalFilePath, newFilePath);
            console.log(`file has been renamed to: ${newFilePath}`);

            resolve(newFilePath);
        });
    });

    try {
        await page.goto(url, {
            waitUntil: 'domcontentloaded',
            timeout: 10000
        });
    } catch (error) {
        console.log('immediate download:');
    }

    const downloadedFilePath = await downloadPromise;

    try {
        await fs.access(downloadedFilePath as string);
        console.log('file exists');
    } catch {
        console.error('file does not exist');
        throw new Error('downloaded file does not exist');
    }

    // Unzip the renamed file
    try {
        // Create a directory for the unzipped contents if it doesn't exist
        const extractPath = path.join(downloadPath, extId + "_unzipped");
        await fs.mkdir(extractPath, { recursive: true });

        // Adjust the unzip call to specify the extraction directory
        await unzip(downloadedFilePath, extractPath); // Specify where to unzip
        console.log("Successfully unzipped your CRX file to:", extractPath);
    } catch (error) {
        console.error("Failed to unzip the CRX file:", error.message);
        throw new Error('Failed to unzip the CRX file.');
    }
});