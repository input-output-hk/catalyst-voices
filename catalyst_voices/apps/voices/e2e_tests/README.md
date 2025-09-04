# Catalyst Voices E2E Tests

End-to-end tests for the Catalyst Voices web application using Playwright.
Unlike regular Playwright setups, this project will connect to already existing browser binary via CDP
and the app will run locally.

## Scope

These tests cover browser-based end-to-end workflows for the Catalyst Voices application:

* **Cardano wallet integration testing** (Lace, Eternl, Yoroi, Nufi)
* **User authentication and account management**
* **Cross-environment testing** (dev, preprod, prod)
* **Browser extension interaction**
* **Application title and basic navigation**

## Building & Setup

### Prerequisites

* **Node.js** (v18 or higher)
* **npm** package manager
* **Chrome for testing** ([Download manually](https://googlechromelabs.github.io/chrome-for-testing/)
   or download using [puppeteer](https://pptr.dev/browsers-api))
* Ability to run the app locally (Check `catalyst_voices/README.md` for instructions)
* Check `catalyst_voices/apps/voices/e2e_tests/.env.example` for the environment variables
   (for testing on localhost, use `localhost:5555`)

### Installation

1. Run the app locally:

   This ensures the app will be running on port 5555.

   ```bash
   cd catalyst_voices/apps/voices && 
   flutter run --dart-define=ENV_NAME=preprod --web-port 5555
   --web-header "Cross-Origin-Opener-Policy=same-origin"
   --web-header "Cross-Origin-Embedder-Policy=require-corp"
   -d web-server lib/configs/main.dart
   ```

2. In new terminal, navigate to the e2e tests directory:

   ```bash
   cd catalyst_voices/apps/voices/e2e_tests
   ```

3. Install dependencies:

   ```bash
   npm install
   ```

4. Run the e2e tests:

   ```bash
   npx playwright test
   ```

### Account and Wallet data

For our testing effort we use predefined wallet and account data.
It's located in the `catalyst_voices/apps/voices/e2e_tests/data/accountConfigs.ts` and
`catalyst_voices/apps/voices/e2e_tests/data/walletConfigs.ts` files.

These files have some helper methods to more easily get the account that you need.
Most of the time you will want to use the `getAccountModel` and `getWalletConfigByName` functions.

example:

```ts
const accountModel = getAccountModel('DummyForTesting');
const walletConfig = getWalletConfigByName('Lace');
```

In the tests you will be able to use the `testModel` fixture to get the account and wallet config.

```ts
test('test', async ({ testModel }) => {
  const accountModel = testModel.accountModel;
  const walletConfig = testModel.walletConfig;
});
```
