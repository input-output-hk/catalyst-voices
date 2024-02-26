# Catalyst Voices

<!-- markdownlint-disable MD029 -->

This repository contains the Catalyst Voices app and packages.

* [Catalyst Voices](#catalyst-voices)
  * [Requirements](#requirements)
  * [Getting Started](#getting-started)
    * [Bootstrapping](#bootstrapping)
    * [Packages](#packages)
    * [Flavors](#flavors)
  * [Running Tests](#running-tests)

## Requirements

* flutter: 3.19.+
* Dart: 3.3.0+
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

| Package                           | Description              | Example   |
|-----------------------------------|--------------------------|-----------|
| [catalyst_voices_assets](./packages/catalyst_voices_assets/)        | Assets used in Catalyst Voices |[example](./packages/catalyst_voices_assets/example/lib/src/main.dart)|
| [catalyst_voices_blocs](./packages/catalyst_voices_blocs/)         | State management of Catalyst Voices |[example](./packages/catalyst_voices_blocs/)|
| [catalyst_voices_localization](./packages/catalyst_voices_localization/)  | Localization files for Catalyst Voices |[example](./packages/catalyst_voices_localization/)|
| [catalyst_voices_models](./packages/catalyst_voices_models/)        | Models |[example](./packages/catalyst_voices_models/)|
| [catalyst_voices_repositories](./packages/catalyst_voices_repositories/)  | Repositories |[example](./packages/catalyst_voices_repositories/)|
| [catalyst_voices_services](./packages/catalyst_voices_services/)      | Services |[example](./packages/catalyst_voices_services/)|
| [catalyst_voices_shared](./packages/catalyst_voices_shared/)   | Shared code  |[example](./packages/catalyst_voices_shared/)|
| [catalyst_voices_view_models](./packages/catalyst_voices_view_models/)   | ViewModels  |[example](./packages/catalyst_voices_view_models/)|

### Flavors

This project contains four flavors:

* dev
* qa
* preprod
* prod

To run the desired flavor, either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
flutter run --flavor dev --target lib/configs/main_dev.dart

# QA
flutter run --flavor qa --target lib/configs/main_qa.dart

# Pre-Production
flutter run --flavor preprod --target lib/configs/main_preprod.dart

# Production
flutter run --flavor prod --target lib/configs/main_prod.dart
```

>Catalyst Voices works on the Web only.
>We plan to add support for other targets later.

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
