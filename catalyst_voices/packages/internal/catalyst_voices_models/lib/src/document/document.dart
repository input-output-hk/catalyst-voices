import 'package:catalyst_voices_models/src/document/document_node_id.dart';
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
  factory Document.from(DocumentSchema schema) {
    return Document(
      schema: schema.propertiesSchema,
      segments: schema.segments.map(DocumentSegment.from).toList(),
    );
  }

  @override
  List<Object?> get props => [schema, segments];
}

final class DocumentSegment extends Equatable {
  /// The identifier of the segment within a [DocumentSegment].
  ///
  /// Since segments are top-level their ids cannot be repeated.
  final String id;

  /// The identifier of the object within a whole [Document].
  final DocumentNodeId nodeId;

  /// The list of sections that group the [DocumentElement].
  final List<DocumentSection> sections;

  /// The default constructor for the [DocumentSegment].
  const DocumentSegment({
    required this.id,
    required this.nodeId,
    required this.sections,
  });

  /// Creates a [DocumentSegment] from a [segment].
  factory DocumentSegment.from(DocumentSchemaSegment segment) {
    return DocumentSegment(
      id: segment.id,
      nodeId: segment.nodeId,
      sections: segment.sections.map(DocumentSection.from).toList(),
    );
  }

  @override
  List<Object?> get props => [id, nodeId, sections];
}

final class DocumentSection extends Equatable {
  /// The identifier of the section within a [DocumentSegment].
  ///
  /// Might be repeated in other segments.
  final String id;

  /// The identifier of the object within a whole [Document].
  final DocumentNodeId nodeId;

  /// The list of elements within this section.
  final List<DocumentElement> elements;

  /// The default constructor for the [DocumentSection].
  const DocumentSection({
    required this.id,
    required this.nodeId,
    required this.elements,
  });

  /// Creates a [DocumentSection] from a [section].
  factory DocumentSection.from(DocumentSchemaSection section) {
    return DocumentSection(
      id: section.id,
      nodeId: section.nodeId,
      elements: section.elements.map(DocumentElement.from).toList(),
    );
  }

  @override
  List<Object?> get props => [id, nodeId, elements];
}

final class DocumentElement extends Equatable {
  /// The identifier of the element within a [DocumentSection].
  ///
  /// Might be repeated in other sections.
  final String id;

  /// The identifier of the object within a whole [Document].
  final DocumentNodeId nodeId;

  /// The current value this element holds.
  final Object? value;

  /// The default constructor for the [DocumentElement].
  const DocumentElement({
    required this.id,
    required this.nodeId,
    required this.value,
  });

  /// Creates a [DocumentSection] from an [element].
  factory DocumentElement.from(DocumentSchemaElement element) {
    return DocumentElement(
      id: element.id,
      nodeId: element.nodeId,
      value: null,
    );
  }

  @override
  List<Object?> get props => [id, nodeId, value];
}
