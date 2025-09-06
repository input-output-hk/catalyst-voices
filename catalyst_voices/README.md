# Catalyst Voices

<!-- markdownlint-disable MD029 -->

This repository contains the Catalyst Voices app and packages.

* [Catalyst Voices](#catalyst-voices)
  * [Requirements](#requirements)
  * [Getting Started](#getting-started)
    * [Bootstrapping](#bootstrapping)
    * [Packages](#packages)
    * [Environment Type vs Flavor](#environment-type-vs-flavor)
    * [Environment types](#environment-types)
    * [Flavor types](#flavor-types)
    * [Environment variables](#environment-variables)
      * [Environment config](#environment-config)
    * [Code Generation](#code-generation)
      * [Running Code Generation](#running-code-generation)
        * [Basic Generation](#basic-generation)
        * [Local Saving](#local-saving)
      * [GitHub Token / PAT Setup](#github-token--pat-setup)
      * [Security Notes](#security-notes)
  * [Running Tests](#running-tests)
  * [Common issues](#common-issues)

## Requirements

* flutter: 3.32.8+
* Dart: 3.8.0+
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
just bootstrap
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

### Environment Type vs Flavor

Environment is used to define the environment type is used on Web target.
Flavor is used to define the environment type that is used on other targets (mobile, desktop).

So when you are running the app on the Web target, be sure to use `ENV_NAME` dart define to define
the environment type.
In other cases, use `flavor` to define the environment type.

### Environment types

This project contains four env types:

* dev
* preprod
* prod
* relative

To run the desired environment, either use the launch configuration in VSCode/Android Studio
or use the following commands:

```sh
# Development
cd apps/voices
flutter run --target lib/configs/main_dev.dart -d chrome --web-header \
"Cross-Origin-Opener-Policy=same-origin" --web-header "Cross-Origin-Embedder-Policy=require-corp"

# Pre-Production
cd apps/voices
flutter run --target lib/configs/main_preprod.dart -d chrome --web-header \
"Cross-Origin-Opener-Policy=same-origin" --web-header "Cross-Origin-Embedder-Policy=require-corp"

# Production
cd apps/voices
flutter run --target lib/configs/main_prod.dart -d chrome --web-header \
"Cross-Origin-Opener-Policy=same-origin" --web-header "Cross-Origin-Embedder-Policy=require-corp"

# Or
flutter run --target lib/configs/main.dart --dart-define=ENV_NAME=prod -d chrome --web-header \
"Cross-Origin-Opener-Policy=same-origin" --web-header "Cross-Origin-Embedder-Policy=require-corp"
```

> Catalyst Voices works on the Web only.
> We plan to add support for other targets later.

### Flavor types

You should use flavor types instead of environment variables when running the app on mobile
or desktop targets.

This project contains 3 flavor types:

* dev
* preprod
* prod

To run the desired environment, either use the launch configuration in VSCode/Android Studio
or use the following commands:

```sh
# Development
cd apps/voices
flutter run --target lib/configs/main_dev.dart

# Pre-Production
cd apps/voices
flutter run --target lib/configs/main_preprod.dart

# Production
cd apps/voices
flutter run --target lib/configs/main_prod.dart

# Or
cd apps/voices
flutter run --flavor prod --target lib/configs/main.dart
```

### Environment variables

We use [dart defines](https://dart.dev/guides/language/language-tour#using-variables) as
flavor run parameter for Web, and `flavor` for mobile and desktop targets.

All of env variable are optional and you can define only what you want, where you want.

Priority looks as follow:

1. `dart-define` vars
2. `flavor` var

If none of above is defined app will fallback to **relative** type for web or **dev** in other cases.

Using following command below will resolve in **relative** env type for web  and **dev** for mobile
and desktop because **ENV_NAME** nor **flavor** is defined.

```sh
flutter build web --target apps/voices/lib/configs/main_web.dart
```

#### Environment config

Configuration is downloaded dynamically from **gateway** backend where **gateway** base url depends
on used env type.

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
