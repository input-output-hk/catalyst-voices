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
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required this.properties,
    required this.oneOf,
    required this.order,
  }) : super(
          type: DocumentPropertyType.object,
        );

  /// A method that builds typed properties.
  ///
  /// Helps to create properties which generic type
  /// is synced with the schema's generic type.
  DocumentObjectProperty buildProperty({
    required List<DocumentProperty> properties,
  }) {
    return DocumentObjectProperty(
      schema: this,
      properties: properties,
      validationResult: validate(properties),
    );
  }

  @override
  DocumentObjectProperty createChildPropertyAt([DocumentNodeId? parentNodeId]) {
    parentNodeId ??= nodeId;

    final childId = const Uuid().v4();
    final childNodeId = parentNodeId.child(childId);

    final updatedSchema = withNodeId(childNodeId) as DocumentObjectSchema;
    final updatedProperties =
        properties.map((e) => e.createChildPropertyAt(parentNodeId)).toList();

    return updatedSchema.buildProperty(
      properties: List.unmodifiable(updatedProperties),
    );
  }

  /// Validates the property against document rules.
  DocumentValidationResult validate(List<DocumentProperty> properties) {
    // TODO(dtscalac): object type validation
    return const SuccessfulDocumentValidation();
  }

  DocumentPropertySchema?
      getPropertyWithSchemaType<T extends DocumentPropertySchema>() {
    return properties.firstWhereOrNull((e) => e is T);
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [properties, oneOf, order];
}

/// A top-level grouping object of the document.
final class DocumentSegmentSchema extends DocumentObjectSchema {
  final String? icon;

  const DocumentSegmentSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
    required this.icon,
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
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      properties:
          properties.map((e) => e.withNodeId(nodeId.child(e.id))).toList(),
      oneOf: oneOf,
      order: order,
      icon: icon,
    );
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [icon];
}

/// A grouping object in a document on a section level.
final class DocumentSectionSchema extends DocumentObjectSchema {
  const DocumentSectionSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
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
      placeholder: placeholder,
      guidance: guidance,
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
    required super.placeholder,
    required super.guidance,
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
      placeholder: placeholder,
      guidance: guidance,
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
    required super.placeholder,
    required super.guidance,
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
      placeholder: placeholder,
      guidance: guidance,
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

  List<DocumentChange> buildDocumentChanges(GroupedTagsSelection selection) {
    final groupProperty = getPropertyWithSchemaType<DocumentTagGroupSchema>()!;

    final tagProperty =
        getPropertyWithSchemaType<DocumentTagSelectionSchema>()!;

    return [
      DocumentValueChange(
        nodeId: groupProperty.nodeId,
        value: selection.group,
      ),
      DocumentValueChange(
        nodeId: tagProperty.nodeId,
        value: selection.tag,
      ),
    ];
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
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  const DocumentGenericObjectSchema.optional({
    required super.nodeId,
    super.format,
    super.title = '',
    super.description,
    super.placeholder,
    super.guidance,
    super.isRequired = false,
    super.properties = const [],
    super.oneOf,
    super.order = const [],
  });

  @override
  DocumentGenericObjectSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericObjectSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      properties:
          properties.map((e) => e.withNodeId(nodeId.child(e.id))).toList(),
      oneOf: oneOf,
      order: order,
    );
  }
}
