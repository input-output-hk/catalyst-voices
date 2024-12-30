import 'package:catalyst_voices_models/src/document/document_definitions.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// A document schema that describes the structure of a document.
///
/// The document consists of top level [segments].
/// [segments] contain [DocumentSchemaSegment.sections]
/// and sections contain [DocumentSchemaProperty]'s.
final class DocumentSchema extends Equatable implements DocumentNode {
  final String schema;
  final String title;
  final String description;
  final List<DocumentSchemaSegment> segments;
  final List<DocumentNodeId> order;
  final String propertiesSchema;

  const DocumentSchema({
    required this.schema,
    required this.title,
    required this.description,
    required this.segments,
    required this.order,
    required this.propertiesSchema,
  });

  @override
  DocumentNodeId get nodeId => DocumentNodeId.root;

  /// Returns the [segments] sorted by the [order].
  List<DocumentSchemaSegment> get sortedSegments {
    return List.of(segments)..sortByOrder(order);
  }

  @override
  List<Object?> get props => [
        schema,
        title,
        description,
        segments,
        order,
        propertiesSchema,
      ];
}

/// A top-level grouping object of the document.
final class DocumentSchemaSegment extends Equatable implements DocumentNode {
  final BaseDocumentDefinition definition;
  @override
  final DocumentNodeId nodeId;
  final String id;
  final String title;
  final String description;
  final List<DocumentSchemaSection> sections;
  final List<DocumentNodeId> order;

  const DocumentSchemaSegment({
    required this.definition,
    required this.nodeId,
    required this.id,
    required this.title,
    required this.description,
    required this.sections,
    required this.order,
  });

  /// Returns the [sections] sorted by the [order].
  List<DocumentSchemaSection> get sortedSections {
    return List.of(sections)..sortByOrder(order);
  }

  @override
  List<Object?> get props => [
        definition,
        nodeId,
        id,
        title,
        description,
        sections,
        order,
      ];
}

/// A grouping object in a document on a section level.
final class DocumentSchemaSection extends Equatable implements DocumentNode {
  final BaseDocumentDefinition definition;
  @override
  final DocumentNodeId nodeId;
  final String id;
  final String title;
  final String description;
  final List<DocumentSchemaProperty> properties;
  final bool isRequired;
  final List<DocumentNodeId> order;

  const DocumentSchemaSection({
    required this.definition,
    required this.nodeId,
    required this.id,
    required this.title,
    required this.description,
    required this.properties,
    required this.isRequired,
    required this.order,
  });

  /// Returns the [properties] sorted by the [order].
  List<DocumentSchemaProperty> get sortedProperties {
    return List.of(properties)..sortByOrder(order);
  }

  @override
  List<Object?> get props => [
        definition,
        nodeId,
        id,
        title,
        description,
        properties,
        isRequired,
        order,
      ];
}

/// A single property (field) in a document.
final class DocumentSchemaProperty extends Equatable implements DocumentNode {
  final BaseDocumentDefinition definition;
  @override
  final DocumentNodeId nodeId;
  final String id;
  final String title;
  final String? description;
  final Object? defaultValue;
  final String? guidance;
  final List<String>? enumValues;
  final Range<int>? range;
  final Range<int>? itemsRange;

  const DocumentSchemaProperty({
    required this.definition,
    required this.nodeId,
    required this.id,
    required this.title,
    required this.description,
    required this.defaultValue,
    required this.guidance,
    required this.enumValues,
    required this.range,
    required this.itemsRange,
  });

  @override
  List<Object?> get props => [
        definition,
        nodeId,
        id,
        title,
        description,
        defaultValue,
        guidance,
        enumValues,
        range,
        itemsRange,
      ];
}
