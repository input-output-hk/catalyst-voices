part of 'document_property_schema.dart';

sealed class DocumentListSchema extends DocumentPropertySchema {
  final DocumentPropertySchema itemsSchema;
  final Range<int>? itemsRange;

  const DocumentListSchema({
    required super.nodeId,
    required super.format,
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

    final updatedSchema = withNodeId(childNodeId) as DocumentListSchema;
    const updatedProperties = <DocumentProperty>[];

    return DocumentListProperty(
      schema: updatedSchema,
      properties: updatedProperties,
      validationResult: updatedSchema.validate(updatedProperties),
    );
  }

  /// Validates the property against document rules.
  DocumentValidationResult validate(List<DocumentProperty> properties) {
    return DocumentValidator.validateListItems(this, properties);
  }

  @override
  @mustCallSuper
  List<Object?> get props => super.props + [itemsSchema, itemsRange];
}

final class DocumentMultiSelectSchema extends DocumentListSchema {
  const DocumentMultiSelectSchema({
    required super.nodeId,
    required super.format,
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
      format: format,
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
    required super.format,
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
      format: format,
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
    required super.format,
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
      format: format,
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
    required super.format,
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
      format: format,
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
    required super.format,
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
      format: format,
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
    required super.format,
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
      format: format,
      title: title,
      description: description,
      isRequired: isRequired,
      itemsSchema: itemsSchema.withNodeId(nodeId),
      itemsRange: itemsRange,
    );
  }
}
