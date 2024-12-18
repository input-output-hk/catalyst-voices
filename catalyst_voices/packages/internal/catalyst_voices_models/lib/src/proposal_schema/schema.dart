import 'package:catalyst_voices_models/src/proposal_schema/definitions.dart';

class Schema {
  final String schema;
  final String title;
  final String description;
  final DefinitionsObjectType type;
  final bool additionalProperties;
  final List<SchemaSegment> segments;
  final List<String> order;
  final String propertiesSchema;

  const Schema({
    required this.schema,
    required this.title,
    required this.description,
    required this.type,
    required this.additionalProperties,
    required this.segments,
    required this.order,
    required this.propertiesSchema,
  });
}

class SchemaSegment {
  final BaseDefinition ref;
  final String id;
  final String title;
  final String description;
  final List<SchemaSection> sections;

  const SchemaSegment({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.sections,
  });
}

class SchemaSection {
  final BaseDefinition ref;
  final String id;
  final String title;
  final String description;
  final List<SchemaElement> elements;
  final bool isRequired;

  const SchemaSection({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.elements,
    required this.isRequired,
  });
}

class SchemaElement {
  final BaseDefinition ref;
  final String id;
  final String title;
  final String description;
  final int? minLength;
  final int? maxLength;
  final String? defaultValue;
  final String guidance;
  final List<String> enumValues;
  final int? maxItems;
  final int? minItems;
  final int? minimum;
  final int? maximum;
  // Sample JSON values associated with a particular schema,
  // for the purpose of illustrating usage.
  final List<String> examples;

  const SchemaElement({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    this.minLength,
    this.maxLength,
    required this.defaultValue,
    required this.guidance,
    this.enumValues = const <String>[],
    this.maxItems,
    this.minItems,
    this.minimum,
    this.maximum,
    this.examples = const <String>[],
  });
}
