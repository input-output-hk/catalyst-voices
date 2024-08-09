import fs from 'fs';
import path from 'path';

// Read the contents of the .txt fileon-wallet-storage.txt'), 'utf8');
const txtContent = fs.readFileSync(path.resolve(__dirname,'typhon-wallet-storage.txt'), 'utf8');

// Parse the contents and set them to process.env
txtContent.split('\n').forEach(line => {
  const [key, value] = line.split('=');
  if (key && value) {
    process.env[key.trim()] = value.trim();
  }
});

interface SeedPhrase {

  seedPhrase: string[]; 
}

// function to get the seed phrase from environment variables
const getSeedPhrase = (): string[] => {
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
