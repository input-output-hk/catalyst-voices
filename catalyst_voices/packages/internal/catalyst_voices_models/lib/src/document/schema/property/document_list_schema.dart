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
  DocumentListProperty createChildPropertyAt({
    required DocumentNodeId nodeId,
    String? title,
  }) {
    final updatedSchema = copyWith(
      nodeId: nodeId,
      title: title,
    );

    return updatedSchema.buildProperty(
      properties: List.unmodifiable(<DocumentProperty>[]),
    );
  }

  @override
  DocumentListSchema copyWith({DocumentNodeId? nodeId, String? title});

  /// Validates the property against document rules.
  DocumentValidationResult validate(List<DocumentProperty> properties) {
    final values = properties.map((e) => e.value).toList();

    return DocumentValidationResult.merge([
      DocumentValidator.validateListItemsRange(this, values),
      DocumentValidator.validateListItemsUnique(this, values),
    ]);
  }

  /// The title of the child created from [itemsSchema].
  String getChildItemTitle(int index) {
    if (itemsSchema.title.isEmpty) {
      return '';
    } else {
      return '${itemsSchema.title} #${index + 1}';
    }
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
  DocumentMultiSelectSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentMultiSelectSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.copyWith(nodeId: newNodeId),
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
  DocumentSingleLineTextEntryListSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentSingleLineTextEntryListSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.copyWith(nodeId: newNodeId),
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
  DocumentMultiLineTextEntryListMarkdownSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentMultiLineTextEntryListMarkdownSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.copyWith(nodeId: newNodeId),
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
  DocumentSingleLineHttpsUrlEntryListSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentSingleLineHttpsUrlEntryListSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.copyWith(nodeId: newNodeId),
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
  DocumentNestedQuestionsListSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentNestedQuestionsListSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.copyWith(nodeId: newNodeId),
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
  DocumentGenericListSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    final newNodeId = nodeId ?? this.nodeId;
    final newTitle = title ?? this.title;

    return DocumentGenericListSchema(
      nodeId: newNodeId,
      format: format,
      title: newTitle,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      itemsSchema: itemsSchema.copyWith(nodeId: newNodeId),
      itemsRange: itemsRange,
      uniqueItems: uniqueItems,
    );
  }
}
