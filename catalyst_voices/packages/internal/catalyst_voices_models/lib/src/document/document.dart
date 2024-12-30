import 'package:catalyst_voices_models/src/document/document_change.dart';
import 'package:catalyst_voices_models/src/document/document_schema.dart';
import 'package:catalyst_voices_models/src/optional.dart';
import 'package:equatable/equatable.dart';

// TODO(dtscalac): tests

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

  /// Applies [changes] in FIFO manner on a copy of the
  /// document and returns the copy.
  ///
  /// The original document is not affected.
  ///
  /// For performance reasons it creates a single deep copy
  /// of the document and applies all changes there iteratively.
  Document applyChanges(List<DocumentChange> changes) {
    final document = deepCopy();
    for (final change in changes) {
      document._applyChange(change);
    }
    return document;
  }

  /// Applies a [change] on this instance of the document
  /// without creating a copy.
  void _applyChange(DocumentChange change) {
    final segmentIndex =
        segments.indexWhere((e) => change.nodeId.isChildOf(e.schema.nodeId));

    if (segmentIndex < 0) {
      throw ArgumentError(
        'Cannot edit property ${change.nodeId}, '
        'it does not exist in this document',
      );
    }

    segments[segmentIndex]._applyChange(change);
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

  /// Returns a new deep copy of the document.
  ///
  /// [segments] are also recursively copied.
  /// [schema] is not copied since it is immutable.
  Document deepCopy() {
    return Document(
      schema: schema,
      segments: segments.map((e) => e.deepCopy()).toList(),
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

  /// Applies a [change] on a copy of this segment and returns the copy.
  DocumentSegment applyChange(DocumentChange change) {
    return deepCopy().._applyChange(change);
  }

  /// Applies a [change] on this instance of the segment
  /// without creating a copy.
  void _applyChange(DocumentChange change) {
    final sectionIndex =
        sections.indexWhere((e) => change.nodeId.isChildOf(e.schema.nodeId));

    if (sectionIndex < 0) {
      throw ArgumentError(
        'Cannot edit property ${change.nodeId}, '
        'it does not exist in this segment',
      );
    }

    sections[sectionIndex]._applyChange(change);
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

  /// Returns a new deep copy of the segment.
  ///
  /// [schema] is not copied since it is immutable.
  /// [sections] are also recursively copied.
  DocumentSegment deepCopy() {
    return DocumentSegment(
      schema: schema,
      sections: sections.map((e) => e.deepCopy()).toList(),
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

  /// Applies a [change] on a copy of this section and returns the copy.
  DocumentSection applyChange(DocumentChange change) {
    return deepCopy().._applyChange(change);
  }

  /// Applies a [change] on this instance of the section
  /// without creating a copy.
  void _applyChange(DocumentChange change) {
    final propertyIndex =
        properties.indexWhere((e) => e.schema.nodeId == change.nodeId);

    if (propertyIndex < 0) {
      throw ArgumentError(
        'Cannot edit property ${change.nodeId}, '
        'it does not exist in this section',
      );
    }

    properties[propertyIndex] =
        properties[propertyIndex].copyWith(value: Optional(change.value));
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

  /// Returns a new deep copy of the section.
  ///
  /// [schema] is not copied since it is immutable.
  /// [properties] are also recursively copied.
  DocumentSection deepCopy() {
    return DocumentSection(
      schema: schema,
      properties: properties.map((e) => e.deepCopy()).toList(),
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

  /// Returns a new deep copy of the property.
  ///
  /// [schema] is not copied since it is immutable.
  /// [value] is not copied since it is immutable.
  DocumentProperty deepCopy() {
    return DocumentProperty(
      schema: schema,
      value: value,
    );
  }

  @override
  List<Object?> get props => [schema, value];
}
