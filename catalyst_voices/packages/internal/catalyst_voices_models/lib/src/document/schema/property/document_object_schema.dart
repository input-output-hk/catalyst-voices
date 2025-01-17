part of 'document_property_schema.dart';

sealed class DocumentObjectSchema extends DocumentPropertySchema {
  final List<DocumentPropertySchema> properties;
  final List<DocumentSchemaLogicalGroup>? oneOf;
  final List<DocumentNodeId> order;

  const DocumentObjectSchema({
    required super.nodeId,
    required super.format,
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

    final updatedSchema = withNodeId(childNodeId) as DocumentObjectSchema;
    final updatedProperties =
        properties.map((e) => e.createProperty(parentNodeId)).toList();

    return DocumentObjectProperty(
      schema: updatedSchema,
      properties: updatedProperties,
      validationResult: updatedSchema.validate(updatedProperties),
    );
  }

  /// Validates the property against document rules.
  DocumentValidationResult validate(List<DocumentProperty> properties) {
    // TODO(dtscalac): object type validation
    return const SuccessfulDocumentValidation();
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [properties, oneOf, order];
}

/// A top-level grouping object of the document.
final class DocumentSegmentSchema extends DocumentObjectSchema {
  const DocumentSegmentSchema({
    required super.nodeId,
    required super.format,
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
      format: format,
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
    required super.format,
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
      format: format,
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
    required super.format,
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
      format: format,
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
    required super.format,
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
      format: format,
      title: title,
      description: description,
      isRequired: isRequired,
      properties:
          properties.map((e) => e.withNodeId(nodeId.child(e.id))).toList(),
      oneOf: oneOf,
      order: order,
    );
  }

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
    required super.format,
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
      format: format,
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
