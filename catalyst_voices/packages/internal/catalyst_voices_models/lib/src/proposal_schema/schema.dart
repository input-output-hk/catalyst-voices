import 'package:catalyst_voices_models/src/proposal_schema/definitions.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

class Schema {
  final String schema;
  final String title;
  final String description;
  final List<SchemaSegment> segments;
  final List<String> order;
  final String propertiesSchema;

  const Schema({
    required this.schema,
    required this.title,
    required this.description,
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
  final Range<int>? range;
  final Range<int>? itemsRange;

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
    required this.range,
    required this.itemsRange,
  });
}
