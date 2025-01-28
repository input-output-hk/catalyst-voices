part of 'document_property_schema.dart';

sealed class DocumentStringSchema extends DocumentValueSchema<String> {
  final DocumentContentMediaType? contentMediaType;
  final Range<int>? strLengthRange;
  final RegExp? pattern;

  const DocumentStringSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required this.contentMediaType,
    required this.strLengthRange,
    required this.pattern,
  }) : super(
          type: DocumentPropertyType.string,
        );

  @override
  DocumentValidationResult validate(String? value) {
    return DocumentValidationResult.merge([
      DocumentValidator.validateIfRequired(this, value),
      DocumentValidator.validateStringLength(this, value),
      DocumentValidator.validateStringPattern(this, value),
      DocumentValidator.validateConstValue(this, value),
      DocumentValidator.validateEnumValues(this, value),
    ]);
  }

  @override
  @mustCallSuper
  List<Object?> get props =>
      super.props + [contentMediaType, strLengthRange, pattern];
}

final class DocumentSingleLineTextEntrySchema extends DocumentStringSchema {
  const DocumentSingleLineTextEntrySchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentSingleLineTextEntrySchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleLineTextEntrySchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentSingleLineHttpsUrlEntrySchema extends DocumentStringSchema {
  const DocumentSingleLineHttpsUrlEntrySchema({
    required super.nodeId,
    required super.title,
    required super.format,
    required super.contentMediaType,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentSingleLineHttpsUrlEntrySchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSingleLineHttpsUrlEntrySchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentMultiLineTextEntrySchema extends DocumentStringSchema {
  const DocumentMultiLineTextEntrySchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentMultiLineTextEntrySchema withNodeId(DocumentNodeId nodeId) {
    return DocumentMultiLineTextEntrySchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentMultiLineTextEntryMarkdownSchema
    extends DocumentStringSchema {
  const DocumentMultiLineTextEntryMarkdownSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentMultiLineTextEntryMarkdownSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentMultiLineTextEntryMarkdownSchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentDropDownSingleSelectSchema extends DocumentStringSchema {
  const DocumentDropDownSingleSelectSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentDropDownSingleSelectSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentDropDownSingleSelectSchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentTagGroupSchema extends DocumentStringSchema {
  const DocumentTagGroupSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentTagGroupSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentTagGroupSchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentTagSelectionSchema extends DocumentStringSchema {
  const DocumentTagSelectionSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentTagSelectionSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentTagSelectionSchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentSpdxLicenseOrUrlSchema extends DocumentStringSchema {
  const DocumentSpdxLicenseOrUrlSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentSpdxLicenseOrUrlSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentSpdxLicenseOrUrlSchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentLanguageCodeSchema extends DocumentStringSchema {
  const DocumentLanguageCodeSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentLanguageCodeSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentLanguageCodeSchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentGenericStringSchema extends DocumentStringSchema {
  const DocumentGenericStringSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  const DocumentGenericStringSchema.optional({
    required super.nodeId,
    super.format,
    super.contentMediaType,
    super.title = '',
    super.description,
    super.placeholder,
    super.guidance,
    super.isRequired = false,
    super.defaultValue,
    super.constValue,
    super.enumValues,
    super.strLengthRange,
    super.pattern,
  });

  @override
  DocumentGenericStringSchema withNodeId(DocumentNodeId nodeId) {
    return DocumentGenericStringSchema(
      nodeId: nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}
