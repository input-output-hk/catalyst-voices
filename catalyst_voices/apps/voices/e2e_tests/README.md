# Catalyst Voices E2E Tests

End-to-end tests for the Catalyst Voices web application using Playwright.
Unlike regular Playwright setups, this project will connect to already existing browser binary via CDP
and the app will run locally.

## Scope

These tests cover browser-based end-to-end workflows for the Catalyst Voices application:

* **Cardano wallet integration testing** (Lace, Eternl, Yoroi, Nufi)
* **User authentication and account management**
* **Cross-environment testing** (dev, staging, prod)
* **Browser extension interaction**
* **Application title and basic navigation**

## Building & Setup

### Prerequisites

* **Node.js** (v18 or higher)
* **npm** package manager
* **Chrome for testing** ([Download manually](https://googlechromelabs.github.io/chrome-for-testing/))
* Ability to run the app locally (Check `catalyst_voices/README.md` for instructions)

### Installation

1. Run the app locally:

   This ensures the app will be running on port 5555.

   ```bash
   cd catalyst_voices/apps/voices && 
   flutter run --flavor preprod --web-port 5555
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
