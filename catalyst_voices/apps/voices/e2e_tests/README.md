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

### Installation

1. Run the app locally:

   This ensures the app will be running on port 5555.

   ```bash
   cd catalyst_voices/apps/voices &&
   flutter run --dart-define=ENV_NAME=dev --web-port 5555 \
   --web-header "Cross-Origin-Opener-Policy=same-origin" \
   --web-header "Cross-Origin-Embedder-Policy=require-corp" \
   -d web-server --target lib/configs/main.dart
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
const accountModel = getAccountModel("DummyForTesting");
const walletConfig = getWalletConfigByName("Lace");
```

In the tests you will be able to use the `testModel` fixture to get the account and wallet config.

```ts
test("test", async ({ testModel }) => {
  const accountModel = testModel.accountModel;
  const walletConfig = testModel.walletConfig;
});
```

### Running tests in containers

1. Navigate to the e2e tests directory

   ```bash
   cd catalyst_voices/apps/voices/e2e_tests
   ```

2. Build all images

   ```bash
   earthly +all-images
   ```

3. Spin up Gateway and Voices

   ```bash
   docker compose up nginx
   ```

4. Wait until the Gateway is healthy

   ```bash
   curl --location 'http://localhost:80/api/gateway/v1/health/ready'
   ```

   This should return 204.

5. Run the tests

   ```bash
   npx playwright test
   ```

## Browser Extension Management

The e2e tests require wallet browser extensions (Lace, Eternl, Nufi, Vespr and Yoroi).
To ensure stable and reproducible tests, extensions are stored in S3 rather than
downloaded directly from Chrome Web Store on each run.

### How it works

1. **S3 Storage**: Extensions are stored in an S3 bucket as `.crx` files
2. **Version Manifest**: `config/extension-manifest.json` tracks which versions are in S3
3. **Download Strategy**: Tests download from S3 first, with Chrome Store as fallback

### Updating Extensions in S3

When wallet extensions release updates, you need to manually update the S3 versions
after verifying they work with our tests:

1. **Test new extensions locally first**:

   ```bash
   # Delete local extensions to force fresh download from Chrome Store
   rm -rf extensions/

   # Run tests against latest Chrome Store versions
   EXTENSION_SOURCE=chrome-store npm run test:local
   ```

2. **If tests pass, update S3**:

   ```bash
   # Preview what would be uploaded
   npm run update-remote-extensions:dry-run

   # Upload to S3 (requires AWS credentials)
   npm run update-remote-extensions
   ```

3. **Commit the updated manifest**:

   ```bash
   git add config/extension-manifest.json
   git commit -m "chore: update wallet extensions to latest versions"
   ```

### Updating a Single Extension

To update only a specific extension:

```bash
npm run update-remote-extensions -- --extension Lace
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `EXTENSION_S3_BUCKET` | S3 bucket name | `catalyst-e2e-extensions` |
| `EXTENSION_S3_REGION` | S3 region | `eu-central-1` |
| `EXTENSION_S3_PREFIX` | Path prefix in bucket | `wallet-extensions` |
| `EXTENSION_SOURCE` | Download strategy (`s3`, `chrome-store`, `auto`) | `auto` |
| `AWS_ACCESS_KEY_ID` | AWS key for uploads | Required for upload |
| `AWS_SECRET_ACCESS_KEY` | AWS secret for uploads | Required for upload |

### CI Configuration

In CI, extensions are downloaded from S3. The S3 bucket should be configured with
public read access (or use AWS credentials for private buckets).

For IOG infrastructure, see the workflow at:
https://github.com/input-output-hk/catalyst-storage/blob/main/.github/workflows/download-browsers.yml
