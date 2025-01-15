import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

// TODO(dtscalac): split schema property into schema list,
// schema object and schema value

/// A document schema that describes the structure of a document.
///
/// The document consists of top level [properties].
/// [properties] contain [DocumentSegmentSchema.sections]
/// and sections contain [DocumentPropertySchema]'s.
final class DocumentSchema extends Equatable implements DocumentNode {
  final String schema;
  final String title;
  final String description;
  final List<DocumentPropertySchema> properties;
  final List<DocumentNodeId> order;
  final String propertiesSchema;

  const DocumentSchema({
    required this.schema,
    required this.title,
    required this.description,
    required this.properties,
    required this.order,
    required this.propertiesSchema,
  });

  @override
  DocumentNodeId get nodeId => DocumentNodeId.root;

  List<DocumentSegmentSchema> get segments =>
      properties.whereType<DocumentSegmentSchema>().toList();

  @override
  List<Object?> get props => [
        schema,
        title,
        description,
        properties,
        order,
        propertiesSchema,
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

// TODO(dtscalac): convert to property schema
final class DocumentSchemaLogicalCondition extends Equatable {
  final DocumentPropertySchema schema;
  final Object? constValue;
  final List<Object>? enumValues;

  const DocumentSchemaLogicalCondition({
    required this.schema,
    required this.constValue,
    required this.enumValues,
  });

  @override
  List<Object?> get props => [
        schema,
        constValue,
        enumValues,
      ];
}

// base types

sealed class DocumentPropertySchema extends Equatable implements DocumentNode {
  @override
  final DocumentNodeId nodeId;
  final DocumentPropertyType type;
  final String title;
  final String? description;
  final bool isRequired;

  const DocumentPropertySchema({
    required this.nodeId,
    required this.type,
    required this.title,
    required this.description,
    required this.isRequired,
  });

  /// The most nested object ID in the schema.
  String get id => nodeId.lastPath;

  /// new property for the list
  DocumentProperty createProperty([DocumentNodeId? parentNodeId]);

  /// Moves the schema and it's children to a new nodeId
  DocumentPropertySchema withNodeId(DocumentNodeId nodeId);

  @override
  @mustCallSuper
  List<Object?> get props => [
        nodeId,
        type,
        title,
        description,
        isRequired,
      ];
}

sealed class DocumentListSchema extends DocumentPropertySchema {
  final DocumentPropertySchema itemsSchema;
  final Range<int>? itemsRange;

  const DocumentListSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required this.itemsSchema,
    required this.itemsRange,
  }) : super(
          type: DocumentPropertyType.list,
        );

  @override
  DocumentListProperty createProperty([DocumentNodeId? parentNodeId]) {
    parentNodeId ??= nodeId;

    final childId = const Uuid().v4();
    final childNodeId = parentNodeId.child(childId);

    return DocumentListProperty(
      schema: withNodeId(childNodeId) as DocumentListSchema,
      properties: const [],
    );
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [itemsSchema, itemsRange];
}

sealed class DocumentObjectSchema extends DocumentPropertySchema {
  final List<DocumentPropertySchema> properties;
  final List<DocumentSchemaLogicalGroup>? oneOf;
  final List<DocumentNodeId> order;

  const DocumentObjectSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required this.properties,
    required this.oneOf,
    required this.order,
  }) : super(
          type: DocumentPropertyType.object,
        );

  @override
  DocumentObjectProperty createProperty([DocumentNodeId? parentNodeId]) {
    parentNodeId ??= nodeId;

    final childId = const Uuid().v4();
    final childNodeId = parentNodeId.child(childId);

    return DocumentObjectProperty(
      schema: withNodeId(childNodeId) as DocumentObjectSchema,
      properties:
          properties.map((e) => e.createProperty(parentNodeId)).toList(),
    );
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [properties, oneOf, order];
}

sealed class DocumentValueSchema<T extends Object>
    extends DocumentPropertySchema {
  final T? defaultValue;
  final List<T>? enumValues;

  const DocumentValueSchema({
    required super.nodeId,
    required super.type,
    required super.title,
    required super.description,
    required super.isRequired,
    required this.defaultValue,
    required this.enumValues,
  });

  @override
  DocumentValueProperty<T> createProperty([DocumentNodeId? parentNodeId]) {
    parentNodeId ??= nodeId;

    final childId = const Uuid().v4();
    final value = defaultValue;

    return DocumentValueProperty(
      schema: withNodeId(parentNodeId.child(childId)) as DocumentValueSchema<T>,
      value: value,
      validationResult: validatePropertyValue(value),
    );
  }

  DocumentValueProperty<T> castProperty(
    DocumentValueProperty<Object> property,
  ) {
    assert(
      property.schema == this,
      'A property can only be cast by the schema it belongs to',
    );

    return property as DocumentValueProperty<T>;
  }

  T? castValue(Object? value) {
    return value as T?;
  }

  /// Validates the property [value] against document rules.
  DocumentValidationResult validatePropertyValue(T? value);

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [defaultValue, enumValues];
}

sealed class DocumentStringSchema extends DocumentValueSchema<String> {
  final Range<int>? strLengthRange;

  const DocumentStringSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required this.strLengthRange,
  }) : super(
          type: DocumentPropertyType.string,
        );

  @override
  DocumentValidationResult validatePropertyValue(String? value) {
    return DocumentValidator.validateString(this, value);
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [strLengthRange];
}

sealed class DocumentIntegerSchema extends DocumentValueSchema<int> {
  final Range<int>? numRange;

  const DocumentIntegerSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required this.numRange,
  }) : super(
          type: DocumentPropertyType.integer,
        );

  @override
  DocumentValidationResult validatePropertyValue(int? value) {
    return DocumentValidator.validateInteger(this, value);
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [numRange];
}

sealed class DocumentNumberSchema extends DocumentValueSchema<double> {
  final Range<double>? numRange;

  const DocumentNumberSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required this.numRange,
  }) : super(
          type: DocumentPropertyType.number,
        );

  @override
  DocumentValidationResult validatePropertyValue(double? value) {
    return DocumentValidator.validateNumber(this, value);
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [numRange];
}

sealed class DocumentBooleanSchema extends DocumentValueSchema<bool> {
  const DocumentBooleanSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.enumValues,
    required super.defaultValue,
  }) : super(
          type: DocumentPropertyType.boolean,
        );

  @override
  DocumentValidationResult validatePropertyValue(bool? value) {
    return DocumentValidator.validateBool(this, value);
  }
}

// exact types for "list"

final class DocumentMultiSelectSchema extends DocumentListSchema {
  const DocumentMultiSelectSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
  });

  @override
  DocumentMultiSelectSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentMultiSelectSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
    );
  }
}

final class DocumentSingleLineTextEntryListSchema extends DocumentListSchema {
  const DocumentSingleLineTextEntryListSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
  });

  @override
  DocumentSingleLineTextEntryListSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleLineTextEntryListSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
    );
  }
}

final class DocumentMultiLineTextEntryListMarkdownSchema
    extends DocumentListSchema {
  const DocumentMultiLineTextEntryListMarkdownSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
  });

  @override
  DocumentMultiLineTextEntryListMarkdownSchema withNodeId(
    DocumentNodeId nodeId,
  ) {
    return DocumentMultiLineTextEntryListMarkdownSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
    );
  }
}

final class DocumentSingleLineHttpsUrlEntryListSchema
    extends DocumentListSchema {
  const DocumentSingleLineHttpsUrlEntryListSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
  });

  @override
  DocumentSingleLineHttpsUrlEntryListSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleLineHttpsUrlEntryListSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
    );
  }
}

final class DocumentNestedQuestionsListSchema extends DocumentListSchema {
  const DocumentNestedQuestionsListSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
  });

  @override
  DocumentNestedQuestionsListSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentNestedQuestionsListSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
    );
  }
}

final class DocumentGenericListSchema extends DocumentListSchema {
  const DocumentGenericListSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
  });

  @override
  DocumentGenericListSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericListSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
    );
  }
}

// exact types for "object"

/// A top-level grouping object of the document.
final class DocumentSegmentSchema extends DocumentObjectSchema {
  const DocumentSegmentSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  List<DocumentSectionSchema> get sections =>
      properties.whereType<DocumentSectionSchema>().toList();

  @override
  DocumentSegmentSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSegmentSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      properties:
          properties.map((e) => e.withNodeId(nodeId.child(e.id))).toList(),
      oneOf: oneOf,
      order: order,
    );
  }
}

/// A grouping object in a document on a section level.
final class DocumentSectionSchema extends DocumentObjectSchema {
  const DocumentSectionSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  @override
  DocumentSectionSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSectionSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      properties:
          properties.map((e) => e.withNodeId(nodeId.child(e.id))).toList(),
      oneOf: oneOf,
      order: order,
    );
  }
}

final class DocumentNestedQuestionsSchema extends DocumentObjectSchema {
  const DocumentNestedQuestionsSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  @override
  DocumentNestedQuestionsSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentNestedQuestionsSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      properties:
          properties.map((e) => e.withNodeId(nodeId.child(e.id))).toList(),
      oneOf: oneOf,
      order: order,
    );
  }
}

final class DocumentSingleGroupedTagSelectorSchema
    extends DocumentObjectSchema {
  const DocumentSingleGroupedTagSelectorSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  @override
  DocumentSingleGroupedTagSelectorSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleGroupedTagSelectorSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      properties:
          properties.map((e) => e.withNodeId(nodeId.child(e.id))).toList(),
      oneOf: oneOf,
      order: order,
    );
  }

  // TODO(dtscalac): this doesn't work
  GroupedTagsSelection? groupedTagsSelection(DocumentObjectProperty property) {
    assert(
      property.schema == this,
      'Value of the property can only be accessed by '
      'the schema to which the property belongs',
    );

    final groupProperty =
        property.getPropertyWithSchemaType<DocumentTagGroupSchema>()
            as DocumentValueProperty<String>?;

    final tagProperty =
        property.getPropertyWithSchemaType<DocumentTagSelectionSchema>()
            as DocumentValueProperty<String>?;

    final group = groupProperty?.value;
    final tag = tagProperty?.value;

    if (group == null && tag == null) {
      return null;
    }

    return GroupedTagsSelection(
      group: group,
      tag: tag,
    );
  }

  List<GroupedTags> groupedTags() {
    final oneOf = this.oneOf ?? const [];
    return GroupedTags.fromLogicalGroups(oneOf);
  }
}

final class DocumentGenericObjectSchema extends DocumentObjectSchema {
  const DocumentGenericObjectSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  @override
  DocumentGenericObjectSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericObjectSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      properties:
          properties.map((e) => e.withNodeId(nodeId.child(e.id))).toList(),
      oneOf: oneOf,
      order: order,
    );
  }
}

// exact types for "string"

final class DocumentSingleLineTextEntrySchema extends DocumentStringSchema {
  const DocumentSingleLineTextEntrySchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentSingleLineTextEntrySchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleLineTextEntrySchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentSingleLineHttpsUrlEntrySchema extends DocumentStringSchema {
  const DocumentSingleLineHttpsUrlEntrySchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentSingleLineHttpsUrlEntrySchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleLineHttpsUrlEntrySchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentMultiLineTextEntrySchema extends DocumentStringSchema {
  const DocumentMultiLineTextEntrySchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentMultiLineTextEntrySchema withNodeId(DocumentNodeId nodeId) {
    return DocumentMultiLineTextEntrySchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentMultiLineTextEntryMarkdownSchema
    extends DocumentStringSchema {
  const DocumentMultiLineTextEntryMarkdownSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentMultiLineTextEntryMarkdownSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentMultiLineTextEntryMarkdownSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentDropDownSingleSelectSchema extends DocumentStringSchema {
  const DocumentDropDownSingleSelectSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentDropDownSingleSelectSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentDropDownSingleSelectSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentTagGroupSchema extends DocumentStringSchema {
  const DocumentTagGroupSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentTagGroupSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentTagGroupSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentTagSelectionSchema extends DocumentStringSchema {
  const DocumentTagSelectionSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentTagSelectionSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentTagSelectionSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentSpdxLicenseOrUrlSchema extends DocumentStringSchema {
  const DocumentSpdxLicenseOrUrlSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentSpdxLicenseOrUrlSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSpdxLicenseOrUrlSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentLanguageCodeSchema extends DocumentStringSchema {
  const DocumentLanguageCodeSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentLanguageCodeSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentLanguageCodeSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

final class DocumentGenericStringSchema extends DocumentStringSchema {
  const DocumentGenericStringSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.strLengthRange,
  });

  @override
  DocumentGenericStringSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericStringSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
    );
  }
}

// exact types for "integer"

final class DocumentTokenValueCardanoAdaSchema extends DocumentIntegerSchema {
  const DocumentTokenValueCardanoAdaSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.numRange,
  });

  @override
  DocumentTokenValueCardanoAdaSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentTokenValueCardanoAdaSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}

final class DocumentDurationInMonthsSchema extends DocumentIntegerSchema {
  const DocumentDurationInMonthsSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.numRange,
  });

  @override
  DocumentDurationInMonthsSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentDurationInMonthsSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}

final class DocumentGenericIntegerSchema extends DocumentIntegerSchema {
  const DocumentGenericIntegerSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.numRange,
  });

  @override
  DocumentGenericIntegerSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericIntegerSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}

// exact types for "number"

final class DocumentGenericNumberSchema extends DocumentNumberSchema {
  const DocumentGenericNumberSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
    required super.numRange,
  });

  @override
  DocumentGenericNumberSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericNumberSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
      numRange: numRange,
    );
  }
}

// exact types for "boolean"

final class DocumentYesNoChoiceSchema extends DocumentBooleanSchema {
  const DocumentYesNoChoiceSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
  });

  @override
  DocumentYesNoChoiceSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentYesNoChoiceSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
    );
  }
}

final class DocumentAgreementConfirmationSchema extends DocumentBooleanSchema {
  const DocumentAgreementConfirmationSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
  });

  @override
  DocumentAgreementConfirmationSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentAgreementConfirmationSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
    );
  }
}

final class DocumentGenericBooleanSchema extends DocumentBooleanSchema {
  const DocumentGenericBooleanSchema({
    required super.nodeId,
    required super.title,
    required super.description,
    required super.isRequired,
    required super.defaultValue,
    required super.enumValues,
  });

  @override
  DocumentGenericBooleanSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericBooleanSchema(
      nodeId: nodeId,
      title: title,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      enumValues: enumValues,
    );
  }
}
