import fs from 'fs';
import path from 'path';

const txtContent = fs.readFileSync(path.resolve(__dirname,'typhon-wallet-storage.txt'), 'utf8');;

// parse the contents and set them to process.env
txtContent.split('\n').forEach(line => {
  const [key, value] = line.split('=');
  if (key && value) {
    process.env[key.trim()] = value.trim();
  }
});

interface WalletCredentials {
  username: string;
  password: string;
}
const getWalletCredentials = (walletID: string): WalletCredentials => {
  const username = process.env[`${walletID}_USERNAME`];
  const password = process.env[`${walletID}_PASSWORD`];
  console.log(`username: ${username}, password: ${password}`);

  if (!username || !password) {
    throw new Error(`Credentials for ${walletID} not found`);
  }

  return { username, password };
};

interface RegistrationPin {
  one: string;
  two: string;
  three: string;
  four: string;
}
const getRegistrationPin = (walletID: string): RegistrationPin => {
  const one = process.env[`${walletID}_PIN1`];
  const two = process.env[`${walletID}_PIN2`];
  const three = process.env[`${walletID}_PIN3`];
  const four = process.env[`${walletID}_PIN4`];

if (!one || !two || !three || !four) {
  throw new Error(`PIN for ${walletID} not found`);
}

return { one, two, three, four };
};

export { getWalletCredentials, getRegistrationPin };