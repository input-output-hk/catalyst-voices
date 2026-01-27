---
    title: 0024 Internationalization Architecture
    adr:
        author: Catalyst Engineering Team
        created: 15-Jan-2024
        status: accepted
    tags:
        - flutter
        - internationalization
        - localization
        - frontend
---

## Context

The Catalyst Voices frontend application must support multiple languages and locales to serve a global user base.
We need a solution that:

* Supports multiple languages
* Provides type-safe access to translations
* Enables easy addition of new translations
* Maintains translation quality and consistency
* Works across all Flutter platforms

We evaluated several approaches:

* Hard-coded strings (not scalable)
* JSON-based translation files (no type safety)
* ARB files with code generation (Flutter's recommended approach)

## Decision

We use **ARB (Application Resource Bundle) files** with Flutter's `flutter_localizations` package and code generation.
This provides:

1. **ARB Files**: Translation files in ARB format (JSON-based)
2. **Code Generation**: Automatic generation of type-safe `VoicesLocalizations` class
3. **Deferred Loading**: Translations loaded on-demand for better performance
4. **Template File**: `intl_en.arb` serves as the template for all translations

## Implementation Details

### ARB File Structure

ARB files are located in `packages/internal/catalyst_voices_localization/lib/l10n/`:

```json
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

### Configuration

`l10n.yaml` configuration:

```yaml
arb-dir: lib/l10n
output-dir: lib/generated/
template-arb-file: intl_en.arb
output-localization-file: catalyst_voices_localizations.dart
output-class: VoicesLocalizations
preferred-supported-locales:
  - en
use-deferred-loading: true
use-escaping: false
relax-syntax: true
```

### Usage in Code

```dart
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';

@override
Widget build(BuildContext context) {
  return Text(context.l10n.loginScreenPasswordLabelText);
}
```

### Adding New Translations

1. **Add to template file** (`intl_en.arb`):

```json
{
  "newFeatureTitle": "New Feature",
  "@newFeatureTitle": {
    "description": "Title for the new feature screen"
  }
}
```

1. **Generate localizations**:

```bash
flutter gen-l10n
```

1. **Add translations** to locale-specific ARB files (e.g., `intl_es.arb`)

2. **Use in code**:

```dart
Text(context.l10n.newFeatureTitle)
```

### Translation Management

The project includes a `manage_l10n.dart` script for:

* **Cleaning**: Remove unused translation keys
* **Sorting**: Sort keys alphabetically
* **Checking**: Verify files are clean and sorted

```bash
dart run manage_l10n.dart --clean
dart run manage_l10n.dart --sort
dart run manage_l10n.dart --check
```

### Supported Locales

Locales are configured in:

* `l10n.yaml` for Flutter
* `ios/Runner/Info.plist` for iOS (`CFBundleLocalizations`)
* Android manifest for Android

## Alternatives Considered

### Hard-coded Strings

* **Pros**: Simple, no setup
* **Cons**: Not scalable, no type safety, difficult to maintain
* **Rejected**: Not suitable for multi-language support

### JSON Translation Files

* **Pros**: Simple format
* **Cons**: No type safety, manual loading, error-prone
* **Rejected**: ARB provides better tooling and type safety

### Third-party Packages (e.g., easy_localization)

* **Pros**: Additional features
* **Cons**: External dependency, less standard
* **Rejected**: Flutter's built-in solution is sufficient and standard

## Consequences

### Positive

* Type-safe access to translations
* Automatic code generation
* Standard Flutter approach
* Easy to add new translations
* Deferred loading improves performance
* Tooling support for management

### Negative

* Code generation step required
* ARB file format learning curve
* Need to regenerate after adding translations

### Best Practices

* Always add new strings to `intl_en.arb` first
* Include descriptions for all translation keys
* Use descriptive key names
* Run `manage_l10n.dart --check` in CI
* Keep translations in sync across locales
* Use deferred loading for better performance
