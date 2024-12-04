# Wallet Automation

Welcome to wallet automation, a testing package in Playwright that tests wallet integration for Catalyst Voices.

## Introduction

Wallet automation is a testing package in Playwright that automates the wallet creation process for the Catalyst project.
It is a part of the Catalyst Voices ecosystem.

## Getting Started

1. Clone this repository:

   ```sh
   git clone
   cd catalyst-voices
   ```

2. Install Flutter and Dart:

   ```sh
   brew install flutter
   ```

3. Bootstrap the project:

   ```sh
   melos bootstrap
   ```

4. Execute earthly command from this directory:

   ```sh
   earthly +package-app
   ```

5. Use docker compose to run the app:

   ```sh
   docker compose up
   ```

   The app should be running on `localhost:8000`.

6. You can now run tests with the following command:

   ```sh
   npx playwright test
   ```
