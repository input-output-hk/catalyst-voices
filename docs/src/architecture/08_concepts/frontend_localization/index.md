---
icon: material/translate
---

# Frontend Localization

This section documents internationalization and localization patterns in the Catalyst Voices
frontend application.

## Overview

The application uses ARB (Application Resource Bundle) files with Flutter's
`flutter_localizations` for type-safe, multi-language support.

## ARB Files

ARB files are JSON-based translation files located in:
`packages/internal/catalyst_voices_localization/lib/l10n/`

### File Structure

```json
{
  "@@locale": "en",
  "keyName": "Translation value",
  "@keyName": {
    "description": "Description for translators"
  }
}
```

### Template File

`intl_en.arb` serves as the template:

* All new strings added here first
* English is the base language
* Used to generate type-safe accessors

## Code Generation

### Configuration

`l10n.yaml`:

```yaml
arb-dir: lib/l10n
output-dir: lib/generated/
template-arb-file: intl_en.arb
output-localization-file: catalyst_voices_localizations.dart
output-class: VoicesLocalizations
preferred-supported-locales: [en]
use-deferred-loading: true
```

### Generation

```bash
flutter gen-l10n
```

Generates `VoicesLocalizations` class with type-safe accessors.

## Usage

### In Widgets

```dart
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';

Text(context.l10n.loginScreenPasswordLabelText)
```

### Locale Resolution

Flutter automatically resolves locale based on:

1. Device locale
2. User preferences
3. Supported locales

## Translation Workflow

### Adding New Strings

1. Add to `intl_en.arb`:

```json
{
  "newFeatureTitle": "New Feature",
  "@newFeatureTitle": {
    "description": "Title for new feature"
  }
}
```

1. Generate localizations:

```bash
flutter gen-l10n
```

1. Add translations to locale files (e.g., `intl_es.arb`)

2. Use in code:

```dart
Text(context.l10n.newFeatureTitle)
```

## Translation Management

### Cleaning Unused Keys

```bash
dart run manage_l10n.dart --clean
```

Removes translation keys not used in code.

### Sorting Keys

```bash
dart run manage_l10n.dart --sort
```

Sorts keys alphabetically in ARB files.

### Validation

```bash
dart run manage_l10n.dart --check
```

Validates that files are clean and sorted (useful for CI).

## Supported Locales

Locales must be configured in:

* `l10n.yaml` (Flutter)
* `ios/Runner/Info.plist` (iOS - `CFBundleLocalizations`)
* Android manifest (Android)

## Best Practices

1. **Always add to template first**: Add new strings to `intl_en.arb`
2. **Include descriptions**: Help translators understand context
3. **Use descriptive keys**: Clear, semantic key names
4. **Keep in sync**: Maintain translations across all locales
5. **Validate in CI**: Run `--check` in continuous integration
6. **Use deferred loading**: Improves initial load performance
