# Catalyst Voices E2E Tests

End-to-end tests for the Catalyst Voices web application using Playwright, with a focus on Cardano wallet integration testing.

## Scope

These tests cover browser-based end-to-end workflows for the Catalyst Voices application:

* **Cardano wallet integration testing** (Lace, Eternl, Yoroi, Nufi)
* **User authentication and account management**
* **Cross-environment testing** (dev, staging, prod)
* **Browser extension interaction**
* **Application title and basic navigation**

**Not covered:**

* Unit tests (see `/test` directory)
* Flutter integration tests (see `/integration_test` directory)
* API backend tests (see `/catalyst-gateway/tests`)

## Building & Setup

### Prerequisites

* **Node.js** (v18 or higher)
* **npm** package manager
* **Chromium browser** (installed via Playwright)

### Installation

1. Navigate to the e2e tests directory:

```bash
cd catalyst_voices/apps/voices/e2e_tests
```

1. Install dependencies:

```bash
npm install
```

1. Install Playwright browsers:

```bash
npx playwright install chromium
```

## Configuration

### Environment Variables

Set the environment variable for the target environment:

```bash
export ENVIRONMENT=dev  # Options: dev, preprod, prod
```

Alternatively, you can create a `.env` file in the e2e_tests directory:

```bash
ENVIRONMENT=dev
```

The application URL is dynamically constructed as:

```text
https://app.${ENVIRONMENT}.projectcatalyst.io/
```

### Test Data Structure

Test data is organized using TypeScript models:

* **`/models/`** - Data structure definitions
* **`/data/`** - Pre-configured test data
  * `accountConfigs.ts` - User accounts with credentials
  * `walletConfigs.ts` - Wallet seed phrases and settings
  * `browserExtensionConfigs.ts` - Browser extension configurations

### Playwright Configuration

Key settings in `playwright.config.ts`:

* **Test directory**: `./tests`
* **Parallel execution**: Enabled locally, sequential in CI
* **Retries**: 2 retries in CI, none locally
* **Browser**: Chromium only (focused testing)
* **Reporter**: HTML reports

## Running

### Environment Setup

Set the target environment:

```bash
export ENVIRONMENT=dev     # For development
export ENVIRONMENT=staging # For staging  
export ENVIRONMENT=prod    # For production
```

### Basic Test Execution

Run all tests:

```bash
npx playwright test
```

Run tests in headed mode (visible browser):

```bash
npx playwright test --headed
```

Run specific test file:

```bash
npx playwright test tests/example.spec.ts
```

### Debug Mode

Debug tests with Playwright Inspector:

```bash
npx playwright test --debug
```

### CI/CD Mode

For continuous integration:

```bash
CI=true npx playwright test
```

This enables:

* Sequential test execution
* Automatic retries on failure
* Trace collection for debugging

### Test Reports

View HTML test report:

```bash
npx playwright show-report
```

Test artifacts are generated in:

* `/test-results/` - Screenshots, videos, traces
* `/playwright-report/` - HTML test reports
* `/blob-report/` - CI-compatible reports

## Miscellaneous

### Project Structure

```text
e2e_tests/
├── data/                    # Test data configurations
│   ├── accountConfigs.ts    # User account test data
│   ├── walletConfigs.ts     # Wallet configurations
│   └── browserExtensionConfigs.ts # Extension configs
├── models/                  # TypeScript data models
│   ├── accountModel.ts      # Account structure
│   ├── walletConfigModel.ts # Wallet configuration
│   ├── browserExtensionModel.ts # Extension structure
│   └── testModel.ts         # Combined test model
├── tests/                   # Test specifications
│   └── example.spec.ts      # Basic application test
├── playwright.config.ts     # Main configuration
├── package.json            # Dependencies and scripts
└── .env                    # Environment variables
```

### Wallet Testing Approach

* **Seed Phrases**: Pre-configured test wallets with known seeds
* **Extension Management**: Automated browser extension loading
* **Multi-Wallet**: Tests can switch between different wallet providers

### Security Considerations

* **Test Wallets Only**: Never use real funds or mainnet seeds
* **Environment Isolation**: Each environment uses separate configurations
* **Credential Management**: Test credentials are safely stored in code

### Best Practices

* Use the provided data models for consistent test data
* Leverage helper functions: `getAccountModel()`, `getWalletConfig()`
* Keep wallet-specific tests isolated and independent
* Follow the existing TypeScript patterns for new tests

### Contributing

1. Follow existing TypeScript patterns in `/models` and `/data`
1. Add new wallet configurations to appropriate config files
1. Keep test data organized and well-documented
1. Update this README when adding new configuration options

### Related Documentation

* [Playwright Documentation](https://playwright.dev/)
* [Flutter Integration Tests](../integration_test/README.md)
* [Catalyst Voices Development](../../../README.md)
