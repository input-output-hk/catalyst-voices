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
    required super.isSubsection,
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
  DocumentObjectProperty createChildPropertyAt({
    required DocumentNodeId nodeId,
    String? title,
  }) {
    final updatedSchema = copyWith(
      nodeId: nodeId,
      title: title,
    );

    final updatedProperties = properties.map(
      (e) {
        final childNodeId = nodeId.child(e.id);
        return e.createChildPropertyAt(nodeId: childNodeId);
      },
    ).toList();

    return updatedSchema.buildProperty(
      properties: List.unmodifiable(updatedProperties),
    );
  }

  @override
  DocumentObjectSchema copyWith({DocumentNodeId? nodeId, String? title});

  /// Validates the property against document rules.
  DocumentValidationResult validate(List<DocumentProperty> properties) {
    // Object types don't have any validation rules currently.
    return const SuccessfulDocumentValidation();
  }

  DocumentPropertySchema?
      getPropertySchemaOfType<T extends DocumentPropertySchema>() {
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
    required super.isSubsection,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
    required this.icon,
  });

  List<DocumentSectionSchema> get sections =>
      properties.whereType<DocumentSectionSchema>().toList();

  @override
  DocumentSegmentSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentSegmentSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      properties: properties
          .map((e) => e.copyWith(nodeId: newNodeId.child(e.id)))
          .toList(),
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
    required super.isSubsection,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  @override
  DocumentSectionSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentSectionSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      isSubsection: isSubsection,
      properties: properties
          .map((e) => e.copyWith(nodeId: newNodeId.child(e.id)))
          .toList(),
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
    required super.isSubsection,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  @override
  DocumentNestedQuestionsSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentNestedQuestionsSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      isSubsection: isSubsection,
      properties: properties
          .map((e) => e.copyWith(nodeId: newNodeId.child(e.id)))
          .toList(),
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
    required super.isSubsection,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  @override
  DocumentSingleGroupedTagSelectorSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentSingleGroupedTagSelectorSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      isSubsection: isSubsection,
      properties: properties
          .map((e) => e.copyWith(nodeId: newNodeId.child(e.id)))
          .toList(),
      oneOf: oneOf,
      order: order,
    );
  }

  @override
  DocumentValidationResult validate(List<DocumentProperty> properties) {
    final groupProperty =
        properties.firstWhereOrNull((e) => e.schema is DocumentTagGroupSchema)
            as DocumentValueProperty<String>?;

    final tagProperty = properties
            .firstWhereOrNull((e) => e.schema is DocumentTagSelectionSchema)
        as DocumentValueProperty<String>?;

    return validateGroupedTagsSelection(
      GroupedTagsSelection(
        group: groupProperty?.value,
        tag: tagProperty?.value,
      ),
    );
  }

  DocumentValidationResult validateGroupedTagsSelection(
    GroupedTagsSelection? selection,
  ) {
    final group = selection?.group;
    final tag = selection?.tag;

    if (group == null || tag == null) {
      return MissingRequiredDocumentValue(invalidNodeId: nodeId);
    }

    final groups = groupedTags();
    final matchingGroup = groups.firstWhereOrNull((e) => e.group == group);
    if (matchingGroup == null) {
      final groupProperty = getPropertySchemaOfType<DocumentTagGroupSchema>();
      return DocumentEnumValueMismatch(
        invalidNodeId: groupProperty!.nodeId,
        enumValues: groups.map((e) => e.group).toList(),
      );
    }

    if (matchingGroup.tags.contains(tag)) {
      return const SuccessfulDocumentValidation();
    } else {
      final tagProperty = getPropertySchemaOfType<DocumentTagSelectionSchema>();
      return DocumentEnumValueMismatch(
        invalidNodeId: tagProperty!.nodeId,
        enumValues: matchingGroup.tags,
      );
    }
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

  List<DocumentChange> buildDocumentChanges(GroupedTagsSelection? selection) {
    final groupProperty = getPropertySchemaOfType<DocumentTagGroupSchema>()!;

    final tagProperty = getPropertySchemaOfType<DocumentTagSelectionSchema>()!;

    return [
      DocumentValueChange(
        nodeId: groupProperty.nodeId,
        value: selection?.group,
      ),
      DocumentValueChange(
        nodeId: tagProperty.nodeId,
        value: selection?.tag,
      ),
    ];
  }

  List<GroupedTags> groupedTags() {
    final oneOf = this.oneOf ?? const [];
    return GroupedTags.fromLogicalGroups(oneOf);
  }
}

final class DocumentBorderGroupSchema extends DocumentObjectSchema {
  const DocumentBorderGroupSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.properties,
    required super.oneOf,
    required super.order,
  });

  @override
  DocumentBorderGroupSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentBorderGroupSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      isSubsection: isSubsection,
      properties: properties
          .map((e) => e.copyWith(nodeId: newNodeId.child(e.id)))
          .toList(),
      oneOf: oneOf,
      order: order,
    );
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
    required super.isSubsection,
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
    super.isSubsection = false,
    super.isRequired = false,
    super.properties = const [],
    super.oneOf,
    super.order = const [],
  });

  @override
  DocumentGenericObjectSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentGenericObjectSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      isSubsection: isSubsection,
      properties: properties
          .map((e) => e.copyWith(nodeId: newNodeId.child(e.id)))
          .toList(),
      oneOf: oneOf,
      order: order,
    );
  }
}
