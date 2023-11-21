# Catalyst Voices Localization

This package contains the localization files for the Catalyst Voices app.

* [Catalyst Voices Localization](#catalyst-voices-localization)
  * [Working with Translations](#working-with-translations)
  * [Creating New Locale Messages](#creating-new-locale-messages)
  * [Generating VoicesLocalizations](#generating-voiceslocalizations)
    * [Adding Strings](#adding-strings)
    * [Adding Supported Locales](#adding-supported-locales)
    * [Adding Translations](#adding-translations)

## Working with Translations

This project relies on [flutter_localizations](https://github.com/flutter/flutter/tree/master/packages/flutter_localizations).
It follows the
[official internationalization guide for Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization).

## Creating New Locale Messages

To add new strings for localization, modify `intl_en.arb`,
which this project uses as its template.

New entries must adhere to the format below:

```arb
  "dartGetterVariableName": "english translation of the message",
  "@dartGetterVariableName": {
    "description": "description for use by the localizations delegate."
  },
```

Here, `dartGetterVariableName` represents the Dart method/property name utilized in your localizations delegate.

Once you've updated `intl_en.arb` with the new message, regenerate the `VoicesLocalizations` delegate to enable
immediate use of the English message in your application code through the localizations delegate,
bypassing the need to wait for translation completion.

## Generating VoicesLocalizations

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

```shell
flutter gen-l10n
```
