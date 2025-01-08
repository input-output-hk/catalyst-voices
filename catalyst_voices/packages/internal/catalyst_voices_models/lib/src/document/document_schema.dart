import 'package:catalyst_voices_models/src/document/document_definitions.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  final String? description;
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
  final String? title;
  final String? description;
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
final class DocumentSchemaProperty<T extends Object> extends Equatable
    implements DocumentNode {
  final BaseDocumentDefinition<T> definition;
  @override
  final DocumentNodeId nodeId;
  final String id;
  final String? title;
  final String? description;
  final T? defaultValue;
  final String? guidance;
  final List<String>? enumValues;

  /// Minimum-maximum (both inclusive) numerical range.
  final Range<int>? numRange;

  /// Minimum-maximum (both inclusive) length of a string.
  final Range<int>? strLengthRange;

  /// Minimum-maximum (both inclusive) count of items.
  final Range<int>? itemsRange;

  /// Allowed combination of values this property can take.
  final List<DocumentSchemaLogicalGroup>? oneOf;

  /// Whether the property is required.
  final bool isRequired;

  const DocumentSchemaProperty({
    required this.definition,
    required this.nodeId,
    required this.id,
    required this.title,
    required this.description,
    required this.defaultValue,
    required this.guidance,
    required this.enumValues,
    required this.numRange,
    required this.strLengthRange,
    required this.itemsRange,
    required this.oneOf,
    required this.isRequired,
  });

  @visibleForTesting
  const DocumentSchemaProperty.optional({
    required this.definition,
    required this.nodeId,
    required this.id,
    this.title,
    this.description,
    this.defaultValue,
    this.guidance,
    this.enumValues,
    this.numRange,
    this.strLengthRange,
    this.itemsRange,
    this.oneOf,
    this.isRequired = false,
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
        numRange,
        strLengthRange,
        itemsRange,
        oneOf,
        isRequired,
      ];
}

final class DocumentSchemaLogicalGroup extends Equatable {
  final List<DocumentSchemaLogicalCondition> conditions;

  const DocumentSchemaLogicalGroup({
    required this.conditions,
  });

  @override
  List<Object?> get props => [
        conditions,
      ];
}

final class DocumentSchemaLogicalCondition extends Equatable {
  final BaseDocumentDefinition definition;
  final String id;
  final Object? value;
  final List<String>? enumValues;

  const DocumentSchemaLogicalCondition({
    required this.definition,
    required this.id,
    required this.value,
    required this.enumValues,
  });

  @override
  List<Object?> get props => [
        definition,
        id,
        value,
        enumValues,
      ];
}
