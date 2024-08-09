import { test } from '@playwright/test';
import * as fs from 'fs/promises';
import * as path from 'path';

const typhonId = 'KFDNIEFADAANBJODLDOHAEDPHAFOFFOH';
const url = `https://clients2.google.com/service/update2/crx?response=redirect&os=win&arch=x64&os_arch=x86_64&nacl_arch=x86-64&prod=chromiumcrx&prodchannel=beta&prodversion=79.0.3945.53&lang=ru&acceptformat=crx3&x=id%3D${typhonId}%26installsource%3Dondemand%26uc`;
const downloadPath = path.resolve(__dirname, 'typhon/extensions');
const unzip = require("unzip-crx-3");

test('downloadFile test', async ({ page }) => {
    await fs.mkdir(downloadPath, { recursive: true });

    const downloadPromise = new Promise(async (resolve) => {
        page.once('download', async (download) => {
            const originalFilePath = path.join(downloadPath, download.suggestedFilename());
            await download.saveAs(originalFilePath);
            console.log(`file has been downloaded to: ${originalFilePath}`);

            // new code: rename the downloaded file
            const newFilePath = path.join(downloadPath, typhonId);
            await fs.rename(originalFilePath, newFilePath);
            console.log(`file has been renamed to: ${newFilePath}`);

            resolve(newFilePath); // resolve the promise with the new file path
        });
    });

    try {
        await page.goto(url, {
            waitUntil: 'domcontentloaded',
            timeout: 10000
        });
    } catch (error) {
        console.log('navigation caused an exception, likely due to immediate download:', 'directDownload');
    }

    // wait for the download and rename to complete
    const downloadedFilePath = await downloadPromise;

    // verify the file exists
    try {
        await fs.access(downloadedFilePath as string); // type assertion to string
        console.log('file verification succeeded, file exists.');
    } catch {
        console.error('file verification failed, file does not exist.');
        throw new Error('downloaded file does not exist.');
    }

    // Assuming the rest of your setup remains the same...

    // Unzip the renamed file
    try {
        // Create a directory for the unzipped contents if it doesn't exist
        const extractPath = path.join(downloadPath, typhonId + "_unzipped");
        await fs.mkdir(extractPath, { recursive: true });

        // Adjust the unzip call to specify the extraction directory
        await unzip(downloadedFilePath, extractPath); // Specify where to unzip
        console.log("Successfully unzipped your CRX file to:", extractPath);
    } catch (error) {
        console.error("Failed to unzip the CRX file:", error.message);
        throw new Error('Failed to unzip the CRX file.');
    }
});