/// The content type of document's string property.
enum DocumentContentMediaType {
  textPlain('text/plain'),
  markdown('text/markdown'),
  unknown('unknown');

  final String value;

  const DocumentContentMediaType(this.value);

  factory DocumentContentMediaType.fromString(String string) {
    for (final type in values) {
      if (type.value.toLowerCase() == string.toLowerCase()) {
        return type;
      }
    }

    return DocumentContentMediaType.unknown;
  }
}
