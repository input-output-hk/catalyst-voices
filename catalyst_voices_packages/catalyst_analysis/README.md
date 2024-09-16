# 🧐 Catalyst Analysis

This package provides lint rules for Dart and Flutter which are used at [Catalyst @ IOG](https://github.com/input-output-hk).
For more information,
see the [complete list of options](/catalyst_voices_packages/packages/catalyst_analysis/lib/analysis_options.1.0.0.yaml).

> This package was heavily inspired by [lint](https://pub.dev/packages/lints)
> and real-life experience building products with Dart and Flutter.

* [🧐 Catalyst Analysis](#-catalyst-analysis)
  * [Usage](#usage)
  * [Suppressing Lints](#suppressing-lints)
    * [Line Level](#line-level)
    * [File Level](#file-level)
    * [Project Level](#project-level)
  * [Evolving the lint sets](#evolving-the-lint-sets)

## Usage

To use the lints, add as a dev dependency in your `pubspec.yaml`:

```yaml
dev_dependencies:
  catalyst_analysis: any # or the latest version on Pub
```

Then, add an include in `analysis_options.yaml`:

```yaml
include: package:catalyst_analysis/analysis_options.yaml
```

This will ensure you always use the latest version of the lints.
If you wish to restrict the lint version, specify a version of `catalyst_analysis` in pubspec.yaml instead:

```yaml
catalyst_analysis: ^1.0.0
```

## Suppressing Lints

There may be cases where specific lint rules are undesirable.
Lint rules can be suppressed at the line, file, or project level.

### Line Level

To suppress a specific lint rule for a specific line of code, use an `ignore` comment directly above the line:

```dart
// ignore: public_member_api_docs
class A {}
```

### File Level

To suppress a specific lint rule of a specific file, use an `ignore_for_file` comment at the top of the file:

```dart
// ignore_for_file: public_member_api_docs

class A {}

class B {}
```

### Project Level

To suppress a specific lint rule for an entire project, modify `analysis_options.yaml`:

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  errors:
    public_member_api_docs: ignore
```

## Evolving the lint sets

As the Dart language and its ecosystem evolve, it is important to keep lint sets current.
Regularly updating them to reflect the best practices for writing Dart code.
To accomplish this, we have an informal process in place:

* Individuals can submit an [issue](https://github.com/input-output-hk/catalyst-voices/issues)
to discuss potential changes to the lint sets (such as adding or removing a lint).
Feedback is welcome from all Dart/Flutter users.

* Catalyst Engineering team meets periodically to review suggestions and make decisions on what to change.

* Once the updates are made, a new version of the package is published.
