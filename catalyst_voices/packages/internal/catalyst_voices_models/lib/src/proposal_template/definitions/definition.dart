abstract class Definition {
  final String type;
  final String? format;
  final String? contentMediaType;
  final String? pattern;

  const Definition({
    required this.type,
    this.format,
    this.contentMediaType,
    this.pattern,
  });
}
