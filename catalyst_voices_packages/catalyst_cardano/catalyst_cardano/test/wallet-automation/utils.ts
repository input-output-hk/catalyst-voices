import * as fs from 'fs/promises';
import * as fsi from 'fs';
import path from 'path';
import nodeFetch from "node-fetch";

interface WalletCredentials {
  username: string;
  password: string;
}
const getWalletCredentials = async (walletID: string): Promise<WalletCredentials> => {
  const username = process.env[`${walletID}_USERNAME`];
  const password = process.env[`${walletID}_PASSWORD`];
  console.log(`username: ${username}, password: ${password}`);

  if (!username || !password) {
    throw new Error(`Credentials for ${walletID} not found`);
  }

  return { username, password };
};

export { getWalletCredentials };

const getSeedPhrase = async (): Promise<string[]> => {
  const seedPhraseArray: string[] = [];
  for (let i = 1; i <= 15; i++) {
    const word = process.env[`WALLET1_SEED_WORD_${i}`];
    if (!word) {
      throw new Error(`seed word ${i} is missing`);
    }
    seedPhraseArray.push(word);
  }
  return seedPhraseArray;
};

export { getSeedPhrase };

const downloadExtension = async (extID: string): Promise<string> => {
    const unzip = require("unzip-crx-3");
    const url = `https://clients2.google.com/service/update2/crx?response=redirect&os=win&arch=x64&os_arch=x86_64&nacl_arch=x86-64&prod=chromiumcrx&prodchannel=beta&prodversion=79.0.3945.53&lang=ru&acceptformat=crx3&x=id%3D${extID}%26installsource%3Dondemand%26uc`;
    const downloadPath = path.resolve(__dirname, 'extensions');
    await fs.mkdir(downloadPath, { recursive: true });
    const filePath = path.join(downloadPath, extID + '.crx');
    const res = await nodeFetch(url);
    await new Promise<void>((resolve, reject) => {
        console.log(`Downloading extension ${extID}`);
        const fileStream = fsi.createWriteStream(filePath);
        res?.body?.pipe(fileStream);
        res!.body!.on("error", (err) => {
          reject(err);
        });
        fileStream.on("finish", function() {
          console.log(`Extension has been downloaded to: ${filePath}`);
          resolve();
        });
      });

    // Extract the extension
    try {
        const extractPath = path.join(downloadPath, extID);
        await fs.mkdir(extractPath, { recursive: true });
        await unzip(filePath, extractPath);
        console.log("Extracted CRX file to:", extractPath);
        return extractPath;
    } catch (error) {
        console.error("Failed to unzip the CRX file:", error.message);
        throw new Error('Failed to unzip the CRX file.');
    }
  };

  export { downloadExtension };
