part of 'document_property_schema.dart';

sealed class DocumentListSchema extends DocumentPropertySchema {
  final DocumentPropertySchema itemsSchema;
  final Range<int>? itemsRange;
  final bool uniqueItems;

  const DocumentListSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required this.itemsSchema,
    required this.itemsRange,
    required this.uniqueItems,
  }) : super(
          type: DocumentPropertyType.list,
        );

  /// A method that builds typed properties.
  ///
  /// Helps to create properties which generic type
  /// is synced with the schema's generic type.
  DocumentListProperty buildProperty({
    required List<DocumentProperty> properties,
  }) {
    return DocumentListProperty(
      schema: this,
      properties: properties,
      validationResult: validate(properties),
    );
  }

  @override
  DocumentListProperty createChildPropertyAt([DocumentNodeId? parentNodeId]) {
    parentNodeId ??= nodeId;

    final childId = const Uuid().v4();
    final childNodeId = parentNodeId.child(childId);

    final updatedSchema = withNodeId(childNodeId) as DocumentListSchema;
    const updatedProperties = <DocumentProperty>[];

    return updatedSchema.buildProperty(
      properties: List.unmodifiable(updatedProperties),
    );
  }

  /// Validates the property against document rules.
  DocumentValidationResult validate(List<DocumentProperty> properties) {
    final values = properties.map((e) => e.value).toList();

    return DocumentValidationResult.merge([
      DocumentValidator.validateListItemsRange(this, values),
      DocumentValidator.validateListItemsUnique(this, values),
    ]);
  }

  @override
  @mustCallSuper
  List<Object?> get props =>
      super.props + [itemsSchema, itemsRange, uniqueItems];
}

final class DocumentMultiSelectSchema extends DocumentListSchema {
  const DocumentMultiSelectSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
    required super.uniqueItems,
  });

  @override
  DocumentMultiSelectSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentMultiSelectSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
      uniqueItems: uniqueItems,
    );
  }
}

final class DocumentSingleLineTextEntryListSchema extends DocumentListSchema {
  const DocumentSingleLineTextEntryListSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
    required super.uniqueItems,
  });

  @override
  DocumentSingleLineTextEntryListSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleLineTextEntryListSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
      uniqueItems: uniqueItems,
    );
  }
}

final class DocumentMultiLineTextEntryListMarkdownSchema
    extends DocumentListSchema {
  const DocumentMultiLineTextEntryListMarkdownSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
    required super.uniqueItems,
  });

  @override
  DocumentMultiLineTextEntryListMarkdownSchema withNodeId(
    DocumentNodeId nodeId,
  ) {
    return DocumentMultiLineTextEntryListMarkdownSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
      uniqueItems: uniqueItems,
    );
  }
}

final class DocumentSingleLineHttpsUrlEntryListSchema
    extends DocumentListSchema {
  const DocumentSingleLineHttpsUrlEntryListSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
    required super.uniqueItems,
  });

  @override
  DocumentSingleLineHttpsUrlEntryListSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleLineHttpsUrlEntryListSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
      uniqueItems: uniqueItems,
    );
  }
}

final class DocumentNestedQuestionsListSchema extends DocumentListSchema {
  const DocumentNestedQuestionsListSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
    required super.uniqueItems,
  });

  @override
  DocumentNestedQuestionsListSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentNestedQuestionsListSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
      uniqueItems: uniqueItems,
    );
  }
}

final class DocumentGenericListSchema extends DocumentListSchema {
  const DocumentGenericListSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.itemsSchema,
    required super.itemsRange,
    required super.uniqueItems,
  });

  const DocumentGenericListSchema.optional({
    required super.nodeId,
    super.format,
    super.title = '',
    super.description,
    super.placeholder,
    super.guidance,
    super.isSubsection = false,
    super.isRequired = false,
    super.itemsSchema =
        const DocumentGenericStringSchema.optional(nodeId: DocumentNodeId.root),
    super.itemsRange,
    super.uniqueItems = false,
  });

  @override
  DocumentGenericListSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericListSchema(
      nodeId: nodeId,
      format: format,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
      uniqueItems: uniqueItems,
    );
  }
}
