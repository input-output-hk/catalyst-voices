# Catalyst Voices

<!-- markdownlint-disable MD029 -->

This repository contains the Catalyst Voices app and packages.

* [Catalyst Voices](#catalyst-voices)
  * [Requirements](#requirements)
  * [Getting Started](#getting-started)
    * [Bootstrapping](#bootstrapping)
    * [Packages](#packages)
    * [Flavors](#flavors)
    * [Environment variables](#environment-variables)
    * [Code Generation](#code-generation)
      * [Running Code Generation](#running-code-generation)
      * [GitHub Token / PAT Setup](#github-token--pat-setup)
      * [Security Notes](#security-notes)
  * [Running Tests](#running-tests)
  * [Common issues](#common-issues)

## Requirements

* flutter: 3.24.1+
* Dart: 3.5.0+
* Ruby: 2.5+
* Xcode: 15.0+
* Android Studio: Android Studio Electric Eel | 2022.1.1 +
* Android SDK: 23+
* iOS SDK: 15.0+
* [Melos](https://melos.invertase.dev)
* [Fastlane](https://fastlane.tools)
* Flutter & Dart plugins:
  * [Visual Studio Code](https://flutter.dev/docs/get-started/editor?tab=vscode)
  * [Android Studio / IntelliJ](https://flutter.dev/docs/get-started/editor?tab=androidstudio)
  * [Emacs](https://docs.flutter.dev/get-started/editor?tab=emacs)

❗️We recommend using **Visual Studio Code** as the **default editor** for this project.

## Getting Started

### Bootstrapping

```sh
git clone https://github.com/input-output-hk/catalyst-voices.git
cd catalyst_voices
melos bootstrap
```

### Packages

<!-- markdownlint-disable MD042 -->

| Package                                                                  | Description              | Example   |
|--------------------------------------------------------------------------|--------------------------|-----------|
| [catalyst_voices_assets](./packages/internal/catalyst_voices_assets/)    | Assets used in Catalyst Voices |[example](./packages/internal/catalyst_voices_assets/example/lib/src/main.dart)|
| [catalyst_voices_blocs](./packages/internal/catalyst_voices_blocs/)               | State management of Catalyst Voices |[example](./packages/internal/catalyst_voices_blocs/)|
| [catalyst_voices_localization](./packages/internal/catalyst_voices_localization/) | Localization files for Catalyst Voices |[example](./packages/internal/catalyst_voices_localization/)|
| [catalyst_voices_models](./packages/internal/catalyst_voices_models/)             | Models |[example](./packages/internal/catalyst_voices_models/)|
| [catalyst_voices_repositories](./packages/internal/catalyst_voices_repositories/) | Repositories |[example](./packages/internal/catalyst_voices_repositories/)|
| [catalyst_voices_services](./packages/internal/catalyst_voices_services/)         | Services |[example](./packages/internal/catalyst_voices_services/)|
| [catalyst_voices_shared](./packages/internal/catalyst_voices_shared/)             | Shared code  |[example](./packages/internal/catalyst_voices_shared/)|
| [catalyst_voices_view_models](./packages/internal/catalyst_voices_view_models/)   | ViewModels  |[example](./packages/internal/catalyst_voices_view_models/)|

### Flavors

This project contains four flavors:

* dev
* qa
* preprod
* prod

To run the desired flavor, either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
flutter run --flavor dev --target apps/voices/lib/configs/main_dev.dart

# QA
flutter run --flavor qa --target apps/voices/lib/configs/main_qa.dart

# Pre-Production
flutter run --flavor preprod --target apps/voices/lib/configs/main_preprod.dart

# Production
flutter run --flavor prod --target apps/voices/lib/configs/main_prod.dart
```

>Catalyst Voices works on the Web only.
>We plan to add support for other targets later.

### Environment variables

We use [dart defines](https://dart.dev/guides/language/language-tour#using-variables)
to manage environment variables.

For example if you need to pass `SENTRY_DSN` as environment variable,
you can use the following command:

```sh
flutter build web --target apps/voices/lib/configs/main_web.dart --dart-define SENTRY_DSN=REPLACE_WITH_SENTRY_DSN_URL
```

### Code Generation

This project utilizes automatic code generation for the following components:

* Catalyst Gateway OpenAPI
* Localization files
* Asset files
* Navigation route files

#### Running Code Generation

##### Basic Generation

To generate code, run the following command in the root directory:
`earthly ./catalyst_voices+code-generator`

##### Local Saving

To save the generated code locally, use the `--save_locally` flag:
`earthly ./catalyst_voices+code-generator --save_locally=true`

#### GitHub Token / PAT Setup

**Important** A valid `GITHUB_TOKEN`/ `PAT` is required to run the earthly target.

**Token Configuration:**

1. Locate the `.secret.template` file in the root directory
2. Create a copy of this file and name it `.secret`
3. Add your `GITHUB_TOKEN` to the `.secret` file

#### Security Notes

* The `.secret` file should be included in `.gitignore`
* Verify that git does not track the `.secret` file before committing

## Running Tests

To run all unit and widget tests use the following command:

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

## Common issues

1. Mixed dependencies from a hosted repository and local path:

```sh
Because every version of catalyst_cardano_web from path depends on catalyst_cardano_serialization
  from hosted and catalyst_voices depends on catalyst_cardano_serialization from path,
  catalyst_cardano_web from path is forbidden.
So, because catalyst_voices depends on catalyst_cardano_web from path, version solving failed.
```

Solution:

When adding a new local dependency, hosted repository (i.e. pub.dev) should be preferred over local paths.
However to make it easier to depend on local changes use `melos bootstrap` to generate `pubspec_overrides.yaml`.
This allows to publish the source code on remote repository that points to official dependency versions
but use local changes during regular development.

The issue appears if you have added a new dependency or pulled code that adds dependency and you haven't run `melos bootstrap`.

See [Melos](https://melos.invertase.dev).
