import 'package:catalyst_voices_models/src/document_builder/document_definitions.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

class DocumentSchema {
  final String schema;
  final String title;
  final String description;
  final List<DocumentSchemaSegment> segments;
  final List<String> order;
  final String propertiesSchema;

  const DocumentSchema({
    required this.schema,
    required this.title,
    required this.description,
    required this.segments,
    required this.order,
    required this.propertiesSchema,
  });
}

class DocumentSchemaSegment {
  final BaseDocumentDefinition ref;
  final String id;
  final String title;
  final String description;
  final List<DocumentSchemaSection> sections;

  const DocumentSchemaSegment({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.sections,
  });
}

class DocumentSchemaSection {
  final BaseDocumentDefinition ref;
  final String id;
  final String title;
  final String description;
  final List<DocumentSchemaElement> elements;
  final bool isRequired;

  const DocumentSchemaSection({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.elements,
    required this.isRequired,
  });
}

class DocumentSchemaElement {
  final BaseDocumentDefinition ref;
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

  const DocumentSchemaElement({
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
