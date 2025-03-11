import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// The content type of document's string property.
enum DocumentContentMediaType {
  textPlain('text/plain'),
  markdown('text/markdown'),
  unknown('unknown');

  final String value;

  const DocumentContentMediaType(this.value);

  factory DocumentContentMediaType.fromString(String string) {
    for (final type in values) {
      if (type.value.equalsIgnoreCase(string)) {
        return type;
      }
    }

    return DocumentContentMediaType.unknown;
  }
}
