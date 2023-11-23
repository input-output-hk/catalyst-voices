# Catalyst Voices Localization

This package contains the localization files for the Catalyst Voices app.

* [Catalyst Voices Localization](#catalyst-voices-localization)
  * [Working with Translations](#working-with-translations)
  * [Creating New Locale Messages](#creating-new-locale-messages)
    * [Adding Strings](#adding-strings)
    * [Adding Translations](#adding-translations)
    * [Adding Supported Locales](#adding-supported-locales)
  * [Generating VoicesLocalizations](#generating-voiceslocalizations)

## Working with Translations

This project relies on [flutter_localizations](https://github.com/flutter/flutter/tree/master/packages/flutter_localizations).
It follows the official
[internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
guide for Flutter.

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

### Adding Strings

* To add a new localizable string, open the `intl_en.arb` file at `lib/l10n/`.

```arb
{
  "@@locale": "en",
  "loginScreenUsernameLabelText": "Username",
  "@loginScreenUsernameLabelText": {
    "description": "Text shown in the login screen for the username field"
  }
}
```

* Then add a new key/value and description

```arb
{
  "@@locale": "en",
  "loginScreenUsernameLabelText": "Username",
  "@loginScreenUsernameLabelText": {
    "description": "Text shown in the login screen for the username field"
  },
  "loginScreenPasswordLabelText": "Password",
  "@loginScreenPasswordLabelText": {
    "description": "Text shown in the login screen for the password field"
  }
}
```

### Adding Translations

* For each supported locale, add a new ARB file in `lib/l10n/`.

```tree
├── l10n
│   ├── intl_en.arb
│   ├── intl_es.arb
```

* Add the translated strings to each `.arb` file:

`intl_en.arb`

```arb
{
  "@@locale": "en",
  "loginScreenUsernameLabelText": "Username",
  "@loginScreenUsernameLabelText": {
    "description": "Text shown in the login screen for the username field"
  },
  "loginScreenPasswordLabelText": "Password",
  "@loginScreenPasswordLabelText": {
    "description": "Text shown in the login screen for the password field"
  }
}
```

`app_es.arb`

<!-- cspell: words Nombre de usuario  Contraseña -->

```arb
{
  "@@locale": "es",
  "loginScreenUsernameLabelText": "Nombre de usuario",
  "loginScreenPasswordLabelText": "Contraseña",
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at
`ios/Runner/Info.plist` to include the new locale.

```xml
    ...
    <key>CFBundleLocalizations</key>
    <array>
        <string>en</string>
        <string>es</string>
    </array>
    ...
```

## Generating VoicesLocalizations

* Run the following command in `catalyst_voices_localization` package to
generate the `VoicesLocalizations` class:

```sh
flutter gen-l10n
```

* Use the new string

```dart
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';

@override
Widget build(BuildContext context) {
  return Text(context.l10n.loginScreenPasswordLabelText);
}
```
