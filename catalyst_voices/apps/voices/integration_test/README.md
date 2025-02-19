# Catalyst Voices Integration Tests

A set of integration tests for the Catalyst Voices application.
These tests use Flutter's [integration_test](https://docs.flutter.dev/testing/integration-tests)
library, organized via a Page Object Model (POM).
The file structure is subject to change as the project evolves.

---

## Table of Contents

* [Catalyst Voices Integration Tests](#catalyst-voices-integration-tests)
  * [Table of Contents](#table-of-contents)
  * [Introduction](#introduction)
  * [Prerequisites](#prerequisites)
  * [Directory Structure](#directory-structure)
  * [Running Tests](#running-tests)
    * [Via CLI](#via-cli)
    * [Via Visual Studio Code](#via-visual-studio-code)
  * [Test Approach](#test-approach)
  * [Troubleshooting](#troubleshooting)
  * [Contributing](#contributing)

---

## Introduction

This repository contains end-to-end integration tests for the **Catalyst Voices** Flutter app.
These tests simulate user interactions (clicking buttons, filling out forms, navigation)
to ensure the app behaves as expected.

**Key highlights**:

* **Framework**: [Flutter Integration Tests](https://docs.flutter.dev/testing/integration-tests)
* **Page Object Model**: Each page/screen is represented by a dedicated class.
* **Patrol Test**: [`patrol_finders`](https://pub.dev/packages/patrol_finders) for advanced element lookups.

---

## Prerequisites

Before running the tests, ensure you have the following installed:

* **Flutter SDK**: Ensure Flutter is installed and configured correctly.
You can download it from [flutter.dev](https://flutter.dev).
* **Dart SDK**: Comes bundled with Flutter.
* **Chrome Browser**: Required for running web-based tests.
* **Visual Studio Code** (optional - any other IDE being used by other developers):
For debugging and running tests in an IDE.
* **Chromedriver** running on port **4444** `chromedriver --port=4444`

---

## Directory Structure

Below is a high-level overview of the relevant directories and files:

* `pageobject/`: Houses Page Object classes (one file per page or logical flow).
* `suites/`: Contains feature-specific test files (e.g., onboarding tests).
* `test_driver/`: Home for the custom integration_tests.dart driver file.
* `all_test.dart`: Single entry to run all tests in suites/.

---

## Running Tests

### Via CLI

**Important**: Make sure you have chromedriver running on port 4444 before running the tests:
`chromedriver --port=4444`

To run the integration tests via the command line, use the following command:

```bash
flutter drive \
  --web-header Cross-Origin-Opener-Policy=same-origin \
  --web-header Cross-Origin-Embedder-Policy=require-corp \
  --driver=test_driver/integration_tests.dart \
  --target=integration_test/all_test.dart \
  -d chrome
```

### Via Visual Studio Code

To run the tests in Visual Studio Code,
add the following configuration to your `.vscode/launch.json` file:

```json
{
  "name": "Catalyst Voices [QA][Debug]",
  "cwd": "catalyst_voices/apps/voices",
  "request": "launch",
  "type": "dart",
  "program": "lib/configs/main_qa.dart",
  "args": [
    "--dart-define",
    "SENTRY_DSN=REPLACE_WITH_SENTRY_DSN_URL",
    "--web-header",
    "Cross-Origin-Opener-Policy=same-origin",
    "--web-header",
    "Cross-Origin-Embedder-Policy=require-corp"
  ]
}
```

This configuration ensures the application runs with
the necessary web headers for cross-origin requirements.

---

## Test Approach

1. **Page Object Model (POM)**: Each screen or logical flow is represented by a dedicated class.
This class contains methods to interact with the screen elements and validate the expected behavior.
2. **Patrol Test**: We use the [`patrol_finders`](https://pub.dev/packages/patrol_finders) package
for advanced element lookups.
This package provides a more robust way to find elements on the screen.
3. **Test Suites**:
   * Tests are organized into feature-specific suites (e.g., onboarding, login, etc.).
This helps maintain a clean and organized test suite.
   * `all_test.dart` compiles and executes all suites.

---

## Troubleshooting

* **Chromedriver**: Ensure chromedriver is running on port 4444 before running the tests.
* **Web Headers**: If you encounter cross-origin issues, ensure the web headers are set correctly.
* **Other issues**: If you encounter other issues, try the following:

  * From the root of the project run `melos clean`
  * Run `just bootstrap` to ensure all dependencies are installed correctly
  * NOTE: `just bootstrap` takes a white to run, so you can first try with `melos clean` and then run:

```bash
  melos l10n && melos build_runner && melos build_runner_repository
```

---

## Contributing

1. Coding Style
   * Follow existing patterns for Page Objects and keep test methods concise.
2. Adding New Tests
   * Create or update the relevant page object if needed.
   * Write test methods in the corresponding suite (e.g., onboarding_test.dart).
   * Reference the suite in `all_test.dart` if you create a new file.
3. Pull requests
   * Ensure tests pass locally before submitting.
   * Provide clear commit messages and PR descriptions.
    Start with `test(cat-voices):` for test-related PRs.
