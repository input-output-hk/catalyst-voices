sealed class Definitions {
  const Definitions();

  static Definitions select(Map<String, dynamic> json) {
    final ref = json[r'$ref'] as String;
    final definition = ref.split('/').last;
    return switch (definition) {
      'segment' => SegmentDefinition.fromJson(json),
      'section' => SectionDefiniton.fromJson(json),
      'singleLineTextEntry' => SingleLineTextEntry.fromJson(json),
      'singleLineHttpsURLEntry' => SingleLineHttpsURLEntry.fromJson(json),
      'multiLineTextEntry' => MultiLineTextEntry.fromJson(json),
      _ => throw Exception('Unknown link: $definition'),
    };
  }
}

class SegmentDefinition extends Definitions {
  final bool additionalProperties;

  const SegmentDefinition({
    required this.additionalProperties,
  });

  factory SegmentDefinition.fromJson(Map<String, dynamic> json) =>
      SegmentDefinition(
        additionalProperties: json['additionalProperties'] as bool,
      );
}

class SectionDefiniton extends Definitions {
  final bool additionalProperties;

  const SectionDefiniton({
    required this.additionalProperties,
  });

  factory SectionDefiniton.fromJson(Map<String, dynamic> json) =>
      SectionDefiniton(
        additionalProperties: json['additionalProperties'] as bool,
      );
}

class SingleLineTextEntry extends Definitions {
  final String contentMediaType;
  final String pattern;

  const SingleLineTextEntry({
    required this.contentMediaType,
    required this.pattern,
  });

  factory SingleLineTextEntry.fromJson(Map<String, dynamic> json) =>
      SingleLineTextEntry(
        contentMediaType: json['contentMediaType'] as String,
        pattern: json['pattern'] as String,
      );
}

class SingleLineHttpsURLEntry extends Definitions {
  final String type;
  final String format;
  final String pattern;

  const SingleLineHttpsURLEntry({
    required this.type,
    required this.format,
    required this.pattern,
  });

  factory SingleLineHttpsURLEntry.fromJson(Map<String, dynamic> json) =>
      SingleLineHttpsURLEntry(
        type: json['type'] as String,
        format: json['format'] as String,
        pattern: json['pattern'] as String,
      );
}

class MultiLineTextEntry extends Definitions {
  final String contentMediaType;
  final String pattern;

  const MultiLineTextEntry({
    required this.contentMediaType,
    required this.pattern,
  });

  factory MultiLineTextEntry.fromJson(Map<String, dynamic> json) =>
      MultiLineTextEntry(
        contentMediaType: json['contentMediaType'] as String,
        pattern: json['pattern'] as String,
      );
}
