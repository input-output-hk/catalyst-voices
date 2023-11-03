# Catalyst Voices

<!-- markdownlint-disable MD029 -->

* [Catalyst Voices](#catalyst-voices)
  * [Requirements](#requirements)
  * [Getting Started](#getting-started)
    * [Bootstrapping](#bootstrapping)
  * [Running Tests](#running-tests)
  * [Working with Translations](#working-with-translations)
    * [Adding Strings](#adding-strings)
    * [Adding Supported Locales](#adding-supported-locales)
    * [Adding Translations](#adding-translations)

## Requirements

* Flutter: 3.13.9+
* Dart: 3.1.5+
* Ruby: 2.5+
* Xcode: 14.2+
* Android Studio: Android Studio Electric Eel | 2022.1.1 +
* Android SDK: 23+
* iOS SDK: 15.0+
* [Melos](https://melos.invertase.dev)
* [Fvm](https://fvm.app/)
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

This project contains 3 flavors:

* development
* staging
* production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

*\*Catalyst Voices works on Web.
We plan to add iOS and Android later.*

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

## Working with Translations

This project relies on [flutter_localizations](https://github.com/flutter/flutter/tree/master/packages/flutter_localizations).
It follows the [official internationalization guide for Flutter][flutter-intl-guide].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:catalyst_voices/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
    <array>
        <string>en</string>
        <string>es</string>
    </array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```tree
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

<!-- cspell: words Contador Texto mostrado página -->

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

[flutter-intl-guide]: https://docs.flutter.dev/development/accessibility-and-localization/internationalization
