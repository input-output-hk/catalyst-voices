import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_models/src/document/document_schema.dart';
import 'package:catalyst_voices_models/src/optional.dart';
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

  /// Returns a new copy of the document
  /// with updated property identified by the [nodeId].
  Document editProperty(DocumentNodeId nodeId, Object? value) {
    final segmentIndex =
        segments.indexWhere((e) => nodeId.isChildOf(e.schema.nodeId));

    if (segmentIndex < 0) {
      throw ArgumentError(
        'Cannot edit property $nodeId, it does not exist in this document',
      );
    }

    final editedSegments = List.of(segments);
    final segment = editedSegments[segmentIndex];
    editedSegments[segmentIndex] = segment.editProperty(nodeId, value);
    return copyWith(segments: editedSegments);
  }

  /// Returns a new copy with updated fields.
  Document copyWith({
    String? schema,
    List<DocumentSegment>? segments,
  }) {
    return Document(
      schema: schema ?? this.schema,
      segments: segments ?? this.segments,
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

  /// Returns a new copy of the segment
  /// with updated property identified by the [nodeId].
  DocumentSegment editProperty(DocumentNodeId nodeId, Object? value) {
    final sectionIndex =
        sections.indexWhere((e) => nodeId.isChildOf(e.schema.nodeId));

    if (sectionIndex < 0) {
      throw ArgumentError(
        'Cannot edit property $nodeId, it does not exist in this segment',
      );
    }

    final editedSections = List.of(sections);
    final section = editedSections[sectionIndex];
    editedSections[sectionIndex] = section.editProperty(nodeId, value);
    return copyWith(sections: editedSections);
  }

  /// Returns a new copy with updated fields.
  DocumentSegment copyWith({
    DocumentSchemaSegment? schema,
    List<DocumentSection>? sections,
  }) {
    return DocumentSegment(
      schema: schema ?? this.schema,
      sections: sections ?? this.sections,
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

  /// Returns a new copy of the section
  /// with updated property identified by the [nodeId].
  DocumentSection editProperty(DocumentNodeId nodeId, Object? value) {
    final propertyIndex =
        properties.indexWhere((e) => e.schema.nodeId == nodeId);

    if (propertyIndex < 0) {
      throw ArgumentError(
        'Cannot edit property $nodeId, it does not exist in this section',
      );
    }

    final editedProperties = List.of(properties);
    final property = editedProperties[propertyIndex];
    editedProperties[propertyIndex] = property.copyWith(value: Optional(value));
    return copyWith(properties: editedProperties);
  }

  /// Returns a new copy with updated fields.
  DocumentSection copyWith({
    DocumentSchemaSection? schema,
    List<DocumentProperty>? properties,
  }) {
    return DocumentSection(
      schema: schema ?? this.schema,
      properties: properties ?? this.properties,
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

  /// Returns a new copy with updated fields.
  DocumentProperty copyWith({
    DocumentSchemaProperty? schema,
    Optional<Object?>? value,
  }) {
    return DocumentProperty(
      schema: schema ?? this.schema,
      value: value.dataOr(this.value),
    );
  }

  @override
  List<Object?> get props => [schema, value];
}
