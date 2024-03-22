# Cardano Utility Wallet Connector

## Setup Project

1. Make sure you have the version of Node.js 18 or 20 on your current machine as the requirement to run Vite.
2. Install all dependencies via `npm i`.
3. Done. You can develop the project via the `npm run dev` command, and build the project by running the `npm run build` command. See more scripts in `package.json`.

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

## Tools

- **Scripting**: TypeScript 5
- **UI Framework**: React 18
- **Styling**: Tailwind CSS
- **Async State Management**: Tanstack Query
- **UI Components**: Headless UI
- **Utilities**: Lodash
- **Icons**: Material UI Icons
- **Build Tool**: Vite

## Runs with Earthly

Type command `earthly +local` to build the app with Nginx wrapped as a web server.

And run with docker:

```sh
docker run -p ...:80 -t cat-wallet-connector
```

## What it can do:
First step, the tool will scan all accessible wallets installed as browser extensions.
It executes fundamental wallet actions as outlined in [CIP30](https://cips.cardano.org/cip/CIP-30/) including:
- Retrieving wallet details
- Simultaneously signing transactions using multiple wallets
- (WIP) Simultaneously signing data with multiple wallets
- (WIP) Simultaneously submitting transactions using multiple wallets
