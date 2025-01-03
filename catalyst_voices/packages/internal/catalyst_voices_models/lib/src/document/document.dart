import 'package:catalyst_voices_models/src/document/document_builder.dart';
import 'package:catalyst_voices_models/src/document/document_schema.dart';
import 'package:equatable/equatable.dart';

// TODO(dtscalac): tests

/// A class that represents the content described by a [DocumentSchema].
///
/// The document is immutable, in order to edit it make use
/// of [toBuilder] method and act on [DocumentBuilder] instance.
final class Document extends Equatable {
  final DocumentSchema schema;
  final List<DocumentSegment> segments;

  /// The default constructor for the [Document].
  const Document({
    required this.schema,
    required this.segments,
  });

  /// Creates a new [DocumentBuilder] from this document.
  DocumentBuilder toBuilder() {
    return DocumentBuilder.fromDocument(this);
  }

  @override
  List<Object?> get props => [schema, segments];
}

/// A segment that groups multiple [DocumentSection]'s.
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

  /// Creates a new [DocumentSegmentBuilder] from this segment.
  DocumentSegmentBuilder toBuilder() {
    return DocumentSegmentBuilder.fromSegment(this);
  }

  @override
  List<Object?> get props => [schema, sections];
}

/// A section that groups multiple [DocumentProperty]'s.
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

  /// Creates a new [DocumentSectionBuilder] from this section.
  DocumentSectionBuilder toBuilder() {
    return DocumentSectionBuilder.fromSection(this);
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

  /// Creates a new [DocumentPropertyBuilder] from this property.
  DocumentPropertyBuilder toBuilder() {
    return DocumentPropertyBuilder.fromProperty(this);
  }

  @override
  List<Object?> get props => [schema, value];
}
