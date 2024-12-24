import 'package:catalyst_voices_models/src/document/document_schema.dart';
import 'package:equatable/equatable.dart';

/// A class that understands the [DocumentSchema] and is able to collect
/// all required inputs to build a valid document.
///
/// The document is immutable, all edits must return
/// a new copy of the document with edited properties.
final class Document extends Equatable {
  final String schema;
  final List<DocumentSegment> segments;

  /// The default constructor for the [Document].
  const Document({
    required this.schema,
    required this.segments,
  });

  /// Creates an empty [Document] from a [schema].
  factory Document.fromSchema(DocumentSchema schema) {
    return Document(
      schema: schema.propertiesSchema,
      segments: schema.segments.map(DocumentSegment.fromSchema).toList(),
    );
  }

  @override
  List<Object?> get props => [schema, segments];
}

final class DocumentSegment extends Equatable {
  /// The schema of the document segment.
  final DocumentSchemaSegment schema;

  /// The list of sections that group the [DocumentProperty].
  final List<DocumentSection> sections;

  /// The default constructor for the [DocumentSegment].
  const DocumentSegment({
    required this.schema,
    required this.sections,
  });

  /// Creates a [DocumentSegment] from a [schema].
  factory DocumentSegment.fromSchema(DocumentSchemaSegment schema) {
    return DocumentSegment(
      schema: schema,
      sections: schema.sections.map(DocumentSection.from).toList(),
    );
  }

  @override
  List<Object?> get props => [schema, sections];
}

final class DocumentSection extends Equatable {
  /// The schema of the document section.
  final DocumentSchemaSection schema;

  /// The list of properties within this section.
  final List<DocumentProperty> properties;

  /// The default constructor for the [DocumentSection].
  const DocumentSection({
    required this.schema,
    required this.properties,
  });

  /// Creates a [DocumentSection] from a [schema].
  factory DocumentSection.from(DocumentSchemaSection schema) {
    return DocumentSection(
      schema: schema,
      properties: schema.properties.map(DocumentProperty.fromSchema).toList(),
    );
  }

  @override
  List<Object?> get props => [schema, properties];
}

final class DocumentProperty extends Equatable {
  /// The schema of the document property.
  final DocumentSchemaProperty schema;

  /// The current value this property holds.
  final Object? value;

  /// The default constructor for the [DocumentProperty].
  const DocumentProperty({
    required this.schema,
    required this.value,
  });

  /// Creates a [DocumentSection] from an [schema].
  factory DocumentProperty.fromSchema(DocumentSchemaProperty schema) {
    return DocumentProperty(
      schema: schema,
      value: null,
    );
  }

  @override
  List<Object?> get props => [schema, value];
}
