import 'package:collection/collection.dart';

enum DocumentContentMediaType {
  textPlain('text/plain'),
  markdown('text/markdown'),
  unknown('unknown');

  final String schemaValue;

  const DocumentContentMediaType(this.schemaValue);

  static DocumentContentMediaType fromString(String value) {
    final lowerCase = value.toLowerCase();

    return DocumentContentMediaType.values.firstWhereOrNull(
          (e) => e.schemaValue.toLowerCase() == lowerCase,
        ) ??
        DocumentContentMediaType.unknown;
  }
}
