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

  /// The list of sections that group the [DocumentElement].
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

  /// The list of elements within this section.
  final List<DocumentElement> elements;

  /// The default constructor for the [DocumentSection].
  const DocumentSection({
    required this.schema,
    required this.elements,
  });

  /// Creates a [DocumentSection] from a [schema].
  factory DocumentSection.from(DocumentSchemaSection schema) {
    return DocumentSection(
      schema: schema,
      elements: schema.elements.map(DocumentElement.fromSchema).toList(),
    );
  }

  @override
  List<Object?> get props => [schema, elements];
}

final class DocumentElement extends Equatable {
  /// The schema of the document element.
  final DocumentSchemaElement schema;

  /// The current value this element holds.
  final Object? value;

  /// The default constructor for the [DocumentElement].
  const DocumentElement({
    required this.schema,
    required this.value,
  });

  /// Creates a [DocumentSection] from an [schema].
  factory DocumentElement.fromSchema(DocumentSchemaElement schema) {
    return DocumentElement(
      schema: schema,
      value: null,
    );
  }

  @override
  List<Object?> get props => [schema, value];
}
