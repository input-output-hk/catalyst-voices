part of 'document_property_schema.dart';

final class DocumentDropDownSingleSelectSchema extends DocumentStringSchema {
  const DocumentDropDownSingleSelectSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentDropDownSingleSelectSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentDropDownSingleSelectSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
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
    required super.isSubsection,
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
    super.isSubsection = false,
    super.isRequired = false,
    super.defaultValue,
    super.constValue,
    super.enumValues,
    super.strLengthRange,
    super.pattern,
  });

  @override
  DocumentGenericStringSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentGenericStringSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
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
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentLanguageCodeSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentLanguageCodeSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentMultiLineTextEntryMarkdownSchema extends DocumentStringSchema {
  const DocumentMultiLineTextEntryMarkdownSchema({
    required super.nodeId,
    required super.format,
    required super.contentMediaType,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentMultiLineTextEntryMarkdownSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentMultiLineTextEntryMarkdownSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
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
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  const DocumentMultiLineTextEntrySchema.optional({
    required super.nodeId,
    super.format,
    super.contentMediaType,
    super.title = '',
    super.description,
    super.placeholder,
    super.guidance,
    super.isSubsection = false,
    super.isRequired = false,
    super.defaultValue,
    super.constValue,
    super.enumValues,
    super.strLengthRange,
    super.pattern,
  });

  @override
  DocumentMultiLineTextEntrySchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentMultiLineTextEntrySchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

final class DocumentRadioButtonSelect extends DocumentStringSchema {
  const DocumentRadioButtonSelect({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.contentMediaType,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentStringSchema copyWith({DocumentNodeId? nodeId, String? title}) {
    return DocumentRadioButtonSelect(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      contentMediaType: contentMediaType,
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
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentSingleLineHttpsUrlEntrySchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentSingleLineHttpsUrlEntrySchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }

  @override
  DocumentValidationResult validate(String? value) {
    return DocumentValidationResult.merge([
      DocumentValidator.validateIfRequired(this, value),
      DocumentValidator.validateStringLength(this, value),
      DocumentValidator.validateStringPattern(this, value, DocumentPatternType.https),
      DocumentValidator.validateConstValue(this, value),
      DocumentValidator.validateEnumValues(this, value),
    ]);
  }
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
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentSingleLineTextEntrySchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentSingleLineTextEntrySchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }
}

sealed class DocumentStringSchema extends DocumentValueSchema<String> {
  final DocumentContentMediaType? contentMediaType;
  final NumRange<int>? strLengthRange;
  final RegExp? pattern;

  const DocumentStringSchema({
    required super.nodeId,
    required super.format,
    required super.title,
    required super.description,
    required super.placeholder,
    required super.guidance,
    required super.isSubsection,
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
  @mustCallSuper
  List<Object?> get props => super.props + [contentMediaType, strLengthRange, pattern];

  @override
  DocumentStringSchema copyWith({DocumentNodeId? nodeId, String? title});

  /// Normalizes a user entered [value].
  ///
  /// For the purpose of document schema validation
  /// the empty string needs to be translated to `null`.
  String? normalizeValue(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  @override
  DocumentValidationResult validate(String? value) {
    return DocumentValidationResult.merge([
      DocumentValidator.validateIfRequired(this, value),
      DocumentValidator.validateStringLength(this, value),
      DocumentValidator.validateStringPattern(this, value, DocumentPatternType.generic),
      DocumentValidator.validateConstValue(this, value),
      DocumentValidator.validateEnumValues(this, value),
    ]);
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
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentTagGroupSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentTagGroupSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }

  @override
  DocumentValidationResult validate(String? value) {
    // validated by its parent (DocumentSingleGroupedTagSelectorSchema)
    return const SuccessfulDocumentValidation();
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
    required super.isSubsection,
    required super.isRequired,
    required super.defaultValue,
    required super.constValue,
    required super.enumValues,
    required super.strLengthRange,
    required super.pattern,
  });

  @override
  DocumentTagSelectionSchema copyWith({
    DocumentNodeId? nodeId,
    String? title,
  }) {
    return DocumentTagSelectionSchema(
      nodeId: nodeId ?? this.nodeId,
      format: format,
      contentMediaType: contentMediaType,
      title: title ?? this.title,
      description: description,
      placeholder: placeholder,
      guidance: guidance,
      isSubsection: isSubsection,
      isRequired: isRequired,
      defaultValue: defaultValue,
      constValue: constValue,
      enumValues: enumValues,
      strLengthRange: strLengthRange,
      pattern: pattern,
    );
  }

  @override
  DocumentValidationResult validate(String? value) {
    // validated by its parent (DocumentSingleGroupedTagSelectorSchema)
    return const SuccessfulDocumentValidation();
  }
}
