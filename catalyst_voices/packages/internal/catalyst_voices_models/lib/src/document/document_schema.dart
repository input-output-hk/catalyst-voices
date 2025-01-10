import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_definitions.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_models/src/document/document_validator.dart';
import 'package:catalyst_voices_models/src/optional.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

// TODO(dtscalac): split schema property into schema list,
// schema object and schema value

/// A document schema that describes the structure of a document.
///
/// The document consists of top level [segments].
/// [segments] contain [DocumentSegmentSchema.sections]
/// and sections contain [DocumentPropertySchema]'s.
final class DocumentSchema extends Equatable implements DocumentNode {
  final String schema;
  final String title;
  final String description;
  final List<DocumentSegmentSchema> segments;
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
final class DocumentSegmentSchema extends Equatable implements DocumentNode {
  final SegmentDefinition definition;
  @override
  final DocumentNodeId nodeId;
  final String id;
  final String title;
  final String? description;
  final List<DocumentSectionSchema> sections;
  final List<DocumentNodeId> order;

  const DocumentSegmentSchema({
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
final class DocumentSectionSchema extends Equatable implements DocumentNode {
  final SectionDefinition definition;
  @override
  final DocumentNodeId nodeId;
  final String id;
  final String? title;
  final String? description;
  final List<DocumentPropertySchema> properties;
  final bool isRequired;
  final List<DocumentNodeId> order;

  const DocumentSectionSchema({
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
final class DocumentPropertySchema<T extends Object> extends Equatable
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

  /// The schema for list items.
  final DocumentPropertySchema? items;

  /// The children properties.
  final List<DocumentPropertySchema>? properties;

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

  /// The order of children properties.
  final List<DocumentNodeId> order;

  const DocumentPropertySchema({
    required this.definition,
    required this.nodeId,
    required this.id,
    required this.title,
    required this.description,
    required this.defaultValue,
    required this.guidance,
    required this.enumValues,
    required this.items,
    required this.properties,
    required this.numRange,
    required this.strLengthRange,
    required this.itemsRange,
    required this.oneOf,
    required this.isRequired,
    required this.order,
  });

  @visibleForTesting
  const DocumentPropertySchema.optional({
    required this.definition,
    required this.nodeId,
    required this.id,
    this.title,
    this.description,
    this.defaultValue,
    this.guidance,
    this.enumValues,
    this.items,
    this.properties,
    this.numRange,
    this.strLengthRange,
    this.itemsRange,
    this.oneOf,
    this.isRequired = false,
    this.order = const [],
  });

  DocumentPropertyValue<T> createListItem() {
    final schema = items! as DocumentPropertySchema<T>;
    final id = const Uuid().v4();
    final value = schema.defaultValue;

    return DocumentPropertyValue(
      schema: schema.copyWith(
        nodeId: nodeId,
        id: id,

        // TODO(dtscalac): update nodeId in items, properties, oneOf, order
      ),
      value: value,
      validationResult: validatePropertyValue(value),
    );
  }

  /// Validates the property [value] against document rules.
  DocumentValidationResult validatePropertyValue(T? value) {
    return definition.validatePropertyValue(this, value);
  }

  /// A copy of the schema with updated fields.
  DocumentPropertySchema<T> copyWith({
    BaseDocumentDefinition<T>? definition,
    DocumentNodeId? nodeId,
    String? id,
    Optional<String>? title,
    Optional<String>? description,
    Optional<T>? defaultValue,
    Optional<String>? guidance,
    Optional<List<String>>? enumValues,
    Optional<DocumentPropertySchema>? items,
    Optional<List<DocumentPropertySchema>>? properties,
    Optional<Range<int>>? numRange,
    Optional<Range<int>>? strLengthRange,
    Optional<Range<int>>? itemsRange,
    Optional<List<DocumentSchemaLogicalGroup>>? oneOf,
    bool? isRequired,
    List<DocumentNodeId>? order,
  }) {
    return DocumentPropertySchema(
      definition: definition ?? this.definition,
      nodeId: nodeId ?? this.nodeId,
      id: id ?? this.id,
      title: title.dataOr(this.title),
      description: description.dataOr(this.description),
      defaultValue: defaultValue.dataOr(this.defaultValue),
      guidance: guidance.dataOr(this.guidance),
      enumValues: enumValues.dataOr(this.enumValues),
      items: items.dataOr(this.items),
      properties: properties.dataOr(this.properties),
      numRange: numRange.dataOr(this.numRange),
      strLengthRange: strLengthRange.dataOr(this.strLengthRange),
      itemsRange: itemsRange.dataOr(this.itemsRange),
      oneOf: oneOf.dataOr(this.oneOf),
      isRequired: isRequired ?? this.isRequired,
      order: order ?? this.order,
    );
  }

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
        items,
        properties,
        numRange,
        strLengthRange,
        itemsRange,
        oneOf,
        isRequired,
        order,
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
